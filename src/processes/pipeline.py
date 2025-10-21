import logging
from src.config import settings
from src.databases import SourceDatabase, TargetDatabase
from src.utils.vectorizer import Vectorizer

logger = logging.getLogger(__name__)


def pipeline():
    vectorizer = Vectorizer(settings.vectorizer_api_url, settings.vectorizer_model)
    source_db = SourceDatabase(settings.db_source_url)
    target_db = TargetDatabase(settings.db_target_url)

    try:
        target_db.setup_vector_extension()
        target_db.create_vector_table()

        identifiers = source_db.get_identifiers()

        for identifier in identifiers:
            try:
                vector = vectorizer.vectorize(identifier)
                target_db.insert_or_update_vector(identifier, vector)

            except Exception as e:
                logger.error(f"Error processing identifier {identifier}: {e}")

        target_db.commit_all_changes()

    except Exception as e:
        logger.error(f"Pipeline error: {e}")
        raise
