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

            if not isinstance(pairs, list):
                logger.error(f"pairs_json must be a list, got: {type(pairs)}")
                return "Invalid JSON! Expected a list of pairs."

            BATCH_SIZE = 50
            all_results: list[ProductPair] = []

            for i in range(0, len(pairs), BATCH_SIZE):
                batch = pairs[i:i + BATCH_SIZE]

                prompt = (
                    "Ты аналитик по поиску дубликатов товарных карточек.\n\n"
                    "Получен список пар товаров с косинусным расстоянием между их векторами:\n"
                    f"{json.dumps(batch, indent=2, ensure_ascii=False)}\n\n"
                    "ВАЖНО: Проанализируй ТОЛЬКО те пары, которые указаны выше. "
                    "НЕ добавляй свои примеры или другие товары!\n\n"
                    "Для каждой пары из списка выше:\n"
                    "1. Оцени вероятность того, что товары являются дубликатами — одно из значений: "
                    "\"high\", \"medium\" или \"low\".\n"
                    "   - high — почти идентичные товары (например, \"Минеральная вода\" и \"Мин.вода\");\n"
                    "   - medium — схожие, но отличающиеся модели или версии;\n"
                    "   - low — разные товары.\n"
                    "2. Если вероятность medium или high, предложи одно короткое и информативное название, "
                    "которое стоит оставить. Если low — верни null.\n\n"
                    "Верни результат ТОЛЬКО для тех пар, которые были в исходном списке. "
                    "Количество результатов должно быть равно количеству входных пар.\n"
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
                    validated_batch = ProductPairs.model_validate_json(content)

                    seen_keys = {(r.title_one, r.title_two) for r in all_results}
                    for r in validated_batch.results:
                        key = (r.title_one, r.title_two)
                        if key not in seen_keys:
                            all_results.append(r)
                            seen_keys.add(key)

                except ValidationError as ve:
                    logger.error(f"Validation error: {ve}")
                    return "The model response does not match the expected format!"

            final = ProductPairs(results=all_results)
            return final.model_dump_json()

        except json.JSONDecodeError as e:
            logger.error(f"Parsing error: {e}")
            return "Invalid JSON!"
        except requests.RequestException as e:
            logger.error(f"Ollama API request error: {e}")
            return "Error while communicating with the Ollama API!"
        except Exception as e:
            logger.error(f"Error while processing duplicates: {e}")
            return "Error while analyzing duplicates!"
