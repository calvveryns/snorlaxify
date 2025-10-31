import json
from tqdm import tqdm
import logging
from src.config import settings
from src.databases import SourceDatabase, TargetDatabase
from src.utils.vectorizer import Vectorizer
from src.utils.recommender import Recommender

logger = logging.getLogger(__name__)

def pipeline():
    vectorizer = Vectorizer(settings.vectorizer_api_url, settings.vectorizer_model)
    source_db = SourceDatabase(settings.db_source_url)
    target_db = TargetDatabase(settings.db_target_url)
    recommender = Recommender(api_url=settings.llm_api_url, model=settings.llm_model)

    try:
        target_db.setup_vector_extension()
        target_db.create_vector_table()

        identifiers = source_db.get_identifiers()

        for identifier in tqdm(identifiers, desc="Vectorizing identifiers", unit="item"):
            try:
                vector = vectorizer.vectorize(identifier)
                target_db.insert_or_update_vector(identifier, vector)
            except Exception as e:
                logger.error(f"Error processing identifier {identifier}: {e}")

        target_db.commit_all_changes()

        results = target_db.get_close_pairs()
        results_json = json.dumps(results, indent=2)
        print("Пары похожих элементов (JSON):")
        print(results_json)

        recommendations = recommender.recommend_duplicates(results_json)
        print("\nРекомендации LLM по дубликатам:")
        print(recommendations)

    except Exception as e:
        logger.error(f"Pipeline error: {e}")
        raise
