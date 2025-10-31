import requests
import logging

logger = logging.getLogger(__name__)


class Vectorizer:
    def __init__(self, api_url: str, model: str):
        self.api_url = api_url
        self.model = model

    def vectorize(self, text: str) -> list:
        payload = {
            "model": self.model,
            "input": text
        }

        try:
            response = requests.post(self.api_url, json=payload)
            response.raise_for_status()
            data = response.json()

            if "embedding" in data:
                return data["embedding"]
            elif "embeddings" in data and isinstance(data["embeddings"], list) and len(data["embeddings"]) > 0:
                return data["embeddings"][0]
            elif "data" in data and isinstance(data["data"], list) and "embedding" in data["data"][0]:
                return data["data"][0]["embedding"]
            else:
                raise RuntimeError(f"No embedding found in response: {data}")
        except Exception as e:
            logger.error(f"Failed to vectorize text '{text}': {e}")
            raise RuntimeError(f"Failed to vectorize text: {e}")
