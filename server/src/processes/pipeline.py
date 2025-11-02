import json
import logging
from tqdm import tqdm
from tqdm.contrib.logging import logging_redirect_tqdm
from server.src.config import settings
from server.src.databases import SourceDatabase
from server.src.utils.vectorizer import Vectorizer
from server.src.utils.recommender import Recommender

logger = logging.getLogger(__name__)


def pipeline():
    vectorizer = Vectorizer(settings.vectorizer_api_url, settings.vectorizer_model)
    source_db = SourceDatabase(settings.db_source_url)
    recommender = Recommender(api_url=settings.llm_api_url, model=settings.llm_model)

    steps = [
        "Setting up source database",
        "Vectorizing identifiers",
        "Committing changes",
        "Finding close pairs",
        "Requesting recommendations"
    ]

    logger.info("Pipeline started")

    try:
        with logging_redirect_tqdm():
            with tqdm(total=len(steps), desc="Pipeline progress", unit="step", ncols=100) as pbar:
                pbar.set_postfix_str(steps[0])
                source_db.setup_vector_extension()
                source_db.create_vector_table()
                pbar.update(1)

                pbar.set_postfix_str(steps[1])
                identifiers = source_db.get_identifiers()
                for identifier in tqdm(
                        identifiers, desc="Vectorizing identifiers", unit="item", leave=False
                ):
                    try:
                        vector = vectorizer.vectorize(identifier)
                        source_db.insert_or_update_vector(identifier, vector)
                    except Exception as e:
                        logger.error(f"Error processing identifier {identifier}: {e}")
                pbar.update(1)

                pbar.set_postfix_str(steps[2])
                source_db.commit_all_changes()
                pbar.update(1)

                pbar.set_postfix_str(steps[3])
                results = source_db.get_close_pairs()
                results_json = json.dumps(results, indent=2)
                pbar.update(1)

                pbar.set_postfix_str(steps[4])
                recommendations = recommender.recommend_duplicates(results_json)
                pbar.update(1)

        logger.info("Pipeline completed successfully")

    except Exception as e:
        logger.error(f"Pipeline error: {e}")
        raise
