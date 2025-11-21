import json
import logging
import threading
import time
from tqdm import tqdm
from tqdm.contrib.logging import logging_redirect_tqdm
from server.src.config import settings
from server.src.databases import SourceDatabase
from server.src.utils.vectorizer import Vectorizer
from server.src.utils.recommender import Recommender

logger = logging.getLogger(__name__)


class PipelineController:
    def __init__(self):
        self._pause_event = threading.Event()

    def pause(self):
        self._pause_event.set()

    def resume(self):
        self._pause_event.clear()

    def wait_if_paused(self):
        while self._pause_event.is_set():
            time.sleep(0.1)


_pipeline_controllers: dict[str, PipelineController] = {}
_controllers_lock = threading.Lock()


def get_pipeline_controller(task_id: str) -> PipelineController:
    with _controllers_lock:
        if task_id not in _pipeline_controllers:
            _pipeline_controllers[task_id] = PipelineController()
        return _pipeline_controllers[task_id]


def remove_pipeline_controller(task_id: str):
    with _controllers_lock:
        _pipeline_controllers.pop(task_id, None)


def pipeline(task_id: str, source_db: SourceDatabase, start_from_step: int = 0):
    vectorizer = Vectorizer(settings.vectorizer_api_url, settings.vectorizer_model)
    recommender = Recommender(api_url=settings.llm_api_url, model=settings.llm_model)
    controller = get_pipeline_controller(task_id)

    steps = [
        "Setting up source database",
        "Vectorizing identifiers",
        "Committing changes",
        "Finding close pairs",
        "Requesting recommendations"
    ]

    logger.info(f"Pipeline started for task {task_id} from step {start_from_step}")

    try:
        with logging_redirect_tqdm():
            with tqdm(total=len(steps), desc="Pipeline progress", unit="step", ncols=100,
                      initial=start_from_step) as pbar:

                # Setting up source database
                if start_from_step <= 0:
                    controller.wait_if_paused()
                    pbar.set_postfix_str(steps[0])
                    source_db.setup_vector_extension()
                    source_db.create_vector_table()
                    source_db.update_pipeline_task_status(task_id, "running", current_step=0)
                    pbar.update(1)
                    start_from_step = 1

                # Vectorizing identifiers
                if start_from_step <= 1:
                    controller.wait_if_paused()
                    pbar.set_postfix_str(steps[1])
                    identifiers = source_db.get_identifiers()
                    for identifier in tqdm(
                            identifiers, desc="Vectorizing identifiers", unit="item", leave=False
                    ):
                        controller.wait_if_paused()
                        try:
                            vector = vectorizer.vectorize(identifier)
                            source_db.insert_or_update_vector(identifier, vector)
                        except Exception as e:
                            logger.error(f"Error processing identifier {identifier}: {e}")
                    source_db.update_pipeline_task_status(task_id, "running", current_step=1)
                    pbar.update(1)
                    start_from_step = 2

                # Committing changes
                if start_from_step <= 2:
                    controller.wait_if_paused()
                    pbar.set_postfix_str(steps[2])
                    source_db.update_pipeline_task_status(task_id, "running", current_step=2)
                    pbar.update(1)
                    start_from_step = 3

                # Finding close pairs
                if start_from_step <= 3:
                    controller.wait_if_paused()
                    pbar.set_postfix_str(steps[3])
                    results = source_db.get_close_pairs()
                    results_json = json.dumps(results, indent=2)
                    source_db.update_pipeline_task_status(task_id, "running", current_step=3)
                    pbar.update(1)
                    start_from_step = 4

                # Requesting recommendations
                if start_from_step <= 4:
                    controller.wait_if_paused()
                    pbar.set_postfix_str(steps[4])
                    recommendations = recommender.recommend_duplicates(results_json)
                    source_db.save_pipeline_result(task_id, recommendations)
                    source_db.update_pipeline_task_status(task_id, "running", current_step=4)
                    pbar.update(1)

        logger.info(f"Pipeline completed successfully for task {task_id}")
        source_db.update_pipeline_task_status(task_id, "completed", current_step=len(steps))
        return recommendations

    except Exception as e:
        logger.error(f"Pipeline error for task {task_id}: {e}")
        source_db.update_pipeline_task_status(task_id, "failed", error=str(e))
        remove_pipeline_controller(task_id)
        raise
