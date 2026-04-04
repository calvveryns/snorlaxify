import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    def __init__(self):
        self.db_source_url = os.getenv('DB_SOURCE_URL')

        self.vectorizer_api_url = os.getenv('VECTORIZER_API_URL')
        self.vectorizer_model = os.getenv('VECTORIZER_MODEL')
        self.duplicate_distance_threshold = float(os.getenv('DUPLICATE_DISTANCE_THRESHOLD', '0.35'))

        self.llm_api_url = os.getenv('LLM_API_URL')
        self.llm_model = os.getenv('LLM_MODEL')

        if not self.db_source_url:
            raise ValueError("DB_SOURCE_URL environment variable is required")
        if not self.vectorizer_api_url:
            raise ValueError("VECTORIZER_API_URL environment variable is required")
        if not self.llm_api_url:
            raise ValueError("LLM_API_URL environment variable is required")


settings = Settings()
