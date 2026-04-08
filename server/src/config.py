import os
from dotenv import load_dotenv

load_dotenv()


def _parse_bool_env(name: str, default: bool) -> bool:
    value = os.getenv(name)
    if value is None:
        return default

    normalized = value.strip().lower()
    if normalized in {"1", "true", "yes", "on"}:
        return True
    if normalized in {"0", "false", "no", "off"}:
        return False

    raise ValueError(f"{name} must be a boolean value")


class Settings:
    def __init__(self):
        self.db_source_url = os.getenv('DB_SOURCE_URL')

        self.vectorizer_api_url = os.getenv('VECTORIZER_API_URL')
        self.vectorizer_model = os.getenv('VECTORIZER_MODEL')
        self.duplicate_distance_threshold = float(os.getenv('DUPLICATE_DISTANCE_THRESHOLD', '0.15'))

        self.llm_provider = os.getenv('LLM_PROVIDER', 'ollama').strip().lower()
        self.llm_api_url = os.getenv('LLM_API_URL')
        self.llm_model = os.getenv('LLM_MODEL')
        self.llm_api_key = os.getenv('LLM_API_KEY')
        self.llm_regroup_batch_size = max(1, int(os.getenv('LLM_REGROUP_BATCH_SIZE', '1')))
        self.llm_filter_batch_size = max(1, int(os.getenv('LLM_FILTER_BATCH_SIZE', '1')))
        self.llm_regroup_think = _parse_bool_env('LLM_REGROUP_THINK', True)
        self.llm_filter_think = _parse_bool_env('LLM_FILTER_THINK', True)
        self.llm_recommend_think = _parse_bool_env('LLM_RECOMMEND_THINK', True)

        if not self.db_source_url:
            raise ValueError("DB_SOURCE_URL environment variable is required")
        if not self.vectorizer_api_url:
            raise ValueError("VECTORIZER_API_URL environment variable is required")
        if self.llm_provider not in {'ollama', 'gemini'}:
            raise ValueError("LLM_PROVIDER must be one of: ollama, gemini")
        if not self.llm_api_url:
            raise ValueError("LLM_API_URL environment variable is required")


settings = Settings()
