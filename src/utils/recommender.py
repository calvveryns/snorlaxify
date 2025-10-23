import json
import logging
import requests

logger = logging.getLogger(__name__)


class Recommender:
    def __init__(self, api_url: str, model: str):
        self.api_url = api_url
        self.model = model

    def recommend_duplicates(self, pairs_json: str) -> str:
        try:
            pairs = json.loads(pairs_json)
            if not pairs:
                return "Нет похожих элементов для анализа."

            prompt = (
                "Ты аналитик по дубликатам товаров. Получен список пар товаров с "
                "косинусным расстоянием между их векторами:\n"
                f"{json.dumps(pairs, indent=2)}\n\n"
                "Для каждой пары:\n"
                "1. Оцени вероятность дубликата: high / medium / low\n"
                "2. Предложи, какое название товара оставить (короче и более информативное).\n"
                "Выведи результат строго в формате JSON, список объектов с полями: "
                "title_one, title_two, distance, duplicate_likelihood, suggested_name."
            )

            payload = {
                "model": self.model,
                "messages": [{
                    "role": "user",
                    "content": prompt
                }],
                "think": True,
                "stream": False
            }

            response = requests.post(f"{self.api_url}", json=payload)
            response.raise_for_status()
            data = response.json()

            if "completion" in data:
                return data["completion"].strip()
            elif "message" in data and "content" in data["message"]:
                return data["message"]["content"].strip()
            elif "choices" in data and len(data["choices"]) > 0:
                choice = data["choices"][0]
                if "message" in choice and "content" in choice["message"]:
                    return choice["message"]["content"].strip()
            else:
                logger.error(f"Не удалось получить текст ответа от Ollama: {data}")
                return "Ошибка при анализе дубликатов"


        except json.JSONDecodeError as e:
            logger.error(f"Ошибка при разборе JSON: {e}")
            return "Некорректный JSON"
        except requests.RequestException as e:
            logger.error(f"Ошибка запроса к Ollama: {e}")
            return "Ошибка при работе с Ollama API"
        except Exception as e:
            logger.error(f"Ошибка при обработке дубликатов: {e}")
            return "Ошибка при анализе дубликатов"
