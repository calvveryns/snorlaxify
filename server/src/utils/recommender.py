from __future__ import annotations

import json
import logging
import requests
from pydantic import BaseModel, ValidationError
from typing import Literal, Optional

logger = logging.getLogger(__name__)


class ProductPair(BaseModel):
    title_one: str
    title_two: str
    distance: float
    duplicate_likelihood: Literal["high", "medium", "low"]
    suggested_name: Optional[str]


class ProductPairs(BaseModel):
    results: list[ProductPair]


class Recommender:
    def __init__(self, api_url: str, model: str):
        self.api_url = api_url
        self.model = model

    def recommend_duplicates(self, pairs_json: str) -> ProductPairs | str:
        try:
            pairs = json.loads(pairs_json)
            if not pairs:
                return "No elements for analysis"

            prompt = (
                "Ты аналитик по поиску дубликатов товарных карточек.\n\n"
                "Получен список пар товаров с косинусным расстоянием между их векторами:\n"
                f"{json.dumps(pairs, indent=2)}\n\n"
                "Для каждой пары:\n"
                "1. Оцени вероятность того, что товары являются дубликатами — одно из значений: "
                "\"high\", \"medium\" или \"low\".\n"
                "   - high — почти идентичные товары;\n"
                "   - medium — схожие, но отличающиеся модели или версии;\n"
                "   - low — разные товары.\n"
                "2. Если вероятность medium или high, предложи одно короткое и информативное название, "
                "которое стоит оставить. Если low — верни null.\n\n"
            )

            payload = {
                "model": self.model,
                "messages": [{
                    "role": "user",
                    "content": prompt
                }],
                "think": False,
                "reasoning": False,
                "stream": False,
                "format": ProductPairs.model_json_schema(),
                "options": {
                    "temperature": 0.2,
                    "top_p": 0.8,
                    "repeat_penalty": 1.2
                }
            }

            response = requests.post(self.api_url, json=payload)
            response.raise_for_status()
            data = response.json()

            content = None
            if "message" in data and "content" in data["message"]:
                content = data["message"]["content"]
            elif "completion" in data:
                content = data["completion"]
            elif "choices" in data and len(data["choices"]) > 0:
                choice = data["choices"][0]
                if "message" in choice and "content" in choice["message"]:
                    content = choice["message"]["content"]

            if not content:
                logger.error(f"Failed to extract content from response: {data}")
                return "Error while analyzing duplicates!"

            try:
                validated = ProductPairs.model_validate_json(content)
                return validated.model_dump_json()
            except ValidationError as ve:
                logger.error(f"Validation error: {ve}")
                return "The model response does not match the expected format!"

        except json.JSONDecodeError as e:
            logger.error(f"Parsing error: {e}")
            return "Invalid JSON!"
        except requests.RequestException as e:
            logger.error(f"Ollama API request error: {e}")
            return "Error while communicating with the Ollama API!"
        except Exception as e:
            logger.error(f"Error while processing duplicates: {e}")
            return "Error while analyzing duplicates!"
