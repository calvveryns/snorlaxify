import logging
import uuid
import threading
from typing import Any, Dict, List, Optional
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel

from server.src.config import settings
from server.src.databases import SourceDatabase
from server.src.processes.pipeline import pipeline, get_pipeline_controller, remove_pipeline_controller
from server.src.utils.recommender import ProductPairs, ResolveRequest

logger = logging.getLogger(__name__)

router = APIRouter()

_pipeline_threads: Dict[str, threading.Thread] = {}
_threads_lock = threading.Lock()
_tables_initialized = False
_tables_lock = threading.Lock()


def get_source_db() -> SourceDatabase:
    global _tables_initialized
    source_db = SourceDatabase(settings.db_source_url)
    if not _tables_initialized:
        with _tables_lock:
            if not _tables_initialized:
                source_db.create_pipeline_tables()
                _tables_initialized = True
    return source_db


class PipelineResponse(BaseModel):
    status: str
    message: str
    task_id: str


class PipelineStatus(BaseModel):
    count: int
    tasks: List[Dict[str, Any]]


class TaskStatus(BaseModel):
    task_id: str
    status: str
    started_at: Optional[str]
    completed_at: Optional[str]
    paused_at: Optional[str]
    recommendations: Optional[Any]
    current_step: Optional[int]
    total_steps: Optional[int]
    error: Optional[str]


class PipelineResultResponse(BaseModel):
    task_id: str
    status: str
    recommendations: ProductPairs


class ResolveResultResponse(PipelineResponse):
    resolved_count: int


def run_pipeline_task(task_id: str, start_from_step: int = 0):
    source_db = SourceDatabase(settings.db_source_url)
    try:
        logger.info(f"Starting pipeline execution for task {task_id} from step {start_from_step}")
        recommendations = pipeline(task_id, source_db, start_from_step)
        logger.info(f"Pipeline execution completed for task {task_id}")
        return recommendations
    except Exception as e:
        logger.error(f"Pipeline execution failed for task {task_id}: {e}")
    finally:
        with _threads_lock:
            _pipeline_threads.pop(task_id, None)
        remove_pipeline_controller(task_id)


def _get_normalized_recommendations(source_db: SourceDatabase, task_id: str) -> Dict[str, Any]:
    return source_db.get_pipeline_final_result(task_id) or {"results": []}


@router.post("/pipeline/start", response_model=PipelineResponse)
async def run_pipeline(source_db: SourceDatabase = Depends(get_source_db)):
    task_id = str(uuid.uuid4())
    source_db.create_pipeline_task(task_id, total_steps=5)

    thread = threading.Thread(target=run_pipeline_task, args=(task_id, 0), daemon=True)
    thread.start()

    with _threads_lock:
        _pipeline_threads[task_id] = thread

    return PipelineResponse(
        status="started",
        message="Pipeline execution started in background",
        task_id=task_id
    )


@router.get("/pipeline/status", response_model=PipelineStatus)
async def get_pipeline_status(source_db: SourceDatabase = Depends(get_source_db)):
    all_tasks = source_db.get_all_pipeline_tasks()
    running_count = sum(1 for task in all_tasks if task["status"] == "running")

    tasks = []
    for task in all_tasks:
        recommendations = _get_normalized_recommendations(source_db, task["task_id"])
        tasks.append({
            "uuid": task["task_id"],
            "task_id": task["task_id"],
            "status": task["status"],
            "started_at": task["started_at"],
            "completed_at": task["completed_at"],
            "paused_at": task["paused_at"],
            "recommendations": recommendations,
            "current_step": task["current_step"],
            "total_steps": task["total_steps"]
        })

    return PipelineStatus(
        count=running_count,
        tasks=tasks
    )


@router.get("/pipeline/{task_id}/status", response_model=TaskStatus)
async def get_task_status(task_id: str, source_db: SourceDatabase = Depends(get_source_db)):
    task = source_db.get_pipeline_task(task_id)
    if not task:
        raise HTTPException(
            status_code=404,
            detail=f"Task {task_id} not found"
        )

    recommendations = _get_normalized_recommendations(source_db, task_id)

    return TaskStatus(
        task_id=task_id,
        status=task["status"],
        started_at=task["started_at"],
        completed_at=task["completed_at"],
        paused_at=task["paused_at"],
        recommendations=recommendations,
        current_step=task["current_step"],
        total_steps=task["total_steps"],
        error=task["error"]
    )


@router.get("/pipeline/{task_id}/result", response_model=PipelineResultResponse)
async def get_task_result(task_id: str, source_db: SourceDatabase = Depends(get_source_db)):
    task = source_db.get_pipeline_task(task_id)
    if not task:
        raise HTTPException(
            status_code=404,
            detail=f"Task {task_id} not found"
        )

    recommendations = _get_normalized_recommendations(source_db, task_id)

    return PipelineResultResponse(
        task_id=task_id,
        status=task["status"],
        recommendations=ProductPairs.model_validate(recommendations),
    )


@router.post("/pipeline/{task_id}/pause", response_model=PipelineResponse)
async def pause_pipeline(task_id: str, source_db: SourceDatabase = Depends(get_source_db)):
    task = source_db.get_pipeline_task(task_id)
    if not task:
        raise HTTPException(
            status_code=404,
            detail=f"Task {task_id} not found"
        )

    if task["status"] != "running":
        raise HTTPException(
            status_code=400,
            detail=f"Task {task_id} is not running. Current status: {task['status']}"
        )

    controller = get_pipeline_controller(task_id)
    controller.pause()

    source_db.pause_pipeline_task(task_id)

    return PipelineResponse(
        status="paused",
        message=f"Pipeline task {task_id} has been paused",
        task_id=task_id
    )


@router.post("/pipeline/{task_id}/resume", response_model=PipelineResponse)
async def resume_pipeline(task_id: str, source_db: SourceDatabase = Depends(get_source_db)):
    task = source_db.get_pipeline_task(task_id)
    if not task:
        raise HTTPException(
            status_code=404,
            detail=f"Task {task_id} not found"
        )

    if task["status"] != "paused":
        raise HTTPException(
            status_code=400,
            detail=f"Task {task_id} is not paused. Current status: {task['status']}"
        )

    controller = get_pipeline_controller(task_id)
    controller.resume()

    with _threads_lock:
        thread = _pipeline_threads.get(task_id)
        if not thread or not thread.is_alive():
            current_step = task.get("current_step", 0)
            resume_from_step = max(0, current_step + 1) if current_step is not None else 0
            thread = threading.Thread(
                target=run_pipeline_task,
                args=(task_id, resume_from_step),
                daemon=True
            )
            thread.start()
            _pipeline_threads[task_id] = thread

    source_db.resume_pipeline_task(task_id)

    return PipelineResponse(
        status="resumed",
        message=f"Pipeline task {task_id} has been resumed",
        task_id=task_id
    )


@router.delete("/pipeline/{task_id}", response_model=PipelineResponse)
async def delete_pipeline(task_id: str, source_db: SourceDatabase = Depends(get_source_db)):
    with _threads_lock:
        thread = _pipeline_threads.pop(task_id, None)
        if thread and thread.is_alive():
            controller = get_pipeline_controller(task_id)
            controller.pause()
            thread.join(timeout=5)

    remove_pipeline_controller(task_id)

    source_db.delete_pipeline_task(task_id)

    return PipelineResponse(
        status="deleted",
        message=f"Pipeline task {task_id} and its results have been deleted",
        task_id=task_id
    )


@router.post("/pipeline/{task_id}/resolve", response_model=ResolveResultResponse)
async def resolve_duplicates(
    task_id: str,
    request: ResolveRequest,
    source_db: SourceDatabase = Depends(get_source_db)
):
    task = source_db.get_pipeline_task(task_id)
    if not task:
        raise HTTPException(
            status_code=404,
            detail=f"Task {task_id} not found"
        )

    if task["status"] != "completed":
        raise HTTPException(
            status_code=400,
            detail=f"Task {task_id} is not completed. Current status: {task['status']}"
        )

    recommendations = _get_normalized_recommendations(source_db, task_id)
    if not recommendations.get("results"):
        raise HTTPException(
            status_code=404,
            detail=f"No recommendations found for task {task_id}"
        )

    resolved_count = source_db.resolve_pipeline_result(
        [pair.model_dump(mode="json") for pair in request.pairs]
    )

    return ResolveResultResponse(
        status="resolved",
        message=f"Resolved {resolved_count} selected duplicate pairs for task {task_id}",
        task_id=task_id,
        resolved_count=resolved_count,
    )
