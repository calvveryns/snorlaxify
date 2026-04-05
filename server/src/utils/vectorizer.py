import logging
from typing import Any

import requests

logger = logging.getLogger(__name__)


class Vectorizer:
    def __init__(self, api_url: str, model: str):
        self.api_url = api_url
        self.model = model

    @staticmethod
    def _extract_embedding(data: dict[str, Any]) -> list:
        embedding = None
        if "embedding" in data:
            embedding = data["embedding"]
        elif "embeddings" in data and isinstance(data["embeddings"], list) and data["embeddings"]:
            embedding = data["embeddings"][0]
        elif "data" in data and isinstance(data["data"], list) and data["data"] and "embedding" in data["data"][0]:
            embedding = data["data"][0]["embedding"]

        if embedding is None:
            raise RuntimeError(f"No embedding found in response: {data}")
        if not isinstance(embedding, list) or not embedding:
            raise RuntimeError(f"Embedding response is empty or invalid: {data}")

        return embedding

    def vectorize(self, text: str) -> list:
        payload = {"model": self.model}
        if self.api_url.endswith("/api/embeddings"):
            payload["prompt"] = text
        else:
            payload["input"] = text

        try:
            response = requests.post(self.api_url, json=payload)
            response.raise_for_status()
            data = response.json()
            return self._extract_embedding(data)
        except Exception as e:
            logger.error(f"Failed to vectorize text '{text}': {e}")
            raise RuntimeError(f"Failed to vectorize text: {e}")
