import logging
import uuid
from datetime import datetime
from typing import Any, Dict, List, Optional
from fastapi import APIRouter, BackgroundTasks, HTTPException
from pydantic import BaseModel

from server.src.processes.pipeline import pipeline

logger = logging.getLogger(__name__)

router = APIRouter()

pipeline_tasks: Dict[str, Dict] = {}


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
    started_at: str
    completed_at: Optional[str]
    recommendations: Optional[str]


def run_pipeline_task(task_id: str):
    try:
        pipeline_tasks[task_id]["status"] = "running"
        logger.info(f"Starting pipeline execution for task {task_id}")
        recommendations = pipeline()
        pipeline_tasks[task_id]["status"] = "completed"
        pipeline_tasks[task_id]["recommendations"] = recommendations
        pipeline_tasks[task_id]["completed_at"] = datetime.now().isoformat()
        logger.info(f"Pipeline execution completed for task {task_id}")
    except Exception as e:
        logger.error(f"Pipeline execution failed for task {task_id}: {e}")
        pipeline_tasks[task_id]["status"] = "failed"
        pipeline_tasks[task_id]["error"] = str(e)
        pipeline_tasks[task_id]["completed_at"] = datetime.now().isoformat()


@router.post("/pipeline/start", response_model=PipelineResponse)
async def run_pipeline(background_tasks: BackgroundTasks):
    task_id = str(uuid.uuid4())
    pipeline_tasks[task_id] = {
        "status": "pending",
        "started_at": datetime.now().isoformat(),
        "completed_at": None,
        "error": None,
        "recommendations": None
    }

    background_tasks.add_task(run_pipeline_task, task_id)

    return PipelineResponse(
        status="started",
        message=f"Pipeline execution started in background",
        task_id=task_id
    )


@router.get("/pipeline/status", response_model=PipelineStatus)
async def get_pipeline_status():
    count = sum(1 for task in pipeline_tasks.values() if task["status"] == "running")

    tasks = [
        {
            "uuid": task_id,
            "status": task_info["status"],
            "started_at": task_info["started_at"],
            "completed_at": task_info.get("completed_at"),
            "recommendations": task_info.get("recommendations")
        }
        for task_id, task_info in pipeline_tasks.items()
    ]

    return PipelineStatus(
        count=count,
        tasks=tasks
    )


@router.get("/pipeline/{task_id}/status", response_model=TaskStatus)
async def get_task_status(task_id: str):
    if task_id not in pipeline_tasks:
        raise HTTPException(
            status_code=404,
            detail=f"Task {task_id} not found"
        )

    task_info = pipeline_tasks[task_id]
    return TaskStatus(
        task_id=task_id,
        status=task_info["status"],
        started_at=task_info["started_at"],
        completed_at=task_info.get("completed_at"),
        recommendations=task_info.get("recommendations")
    )
