from __future__ import annotations

import json
import logging
from typing import Any, Literal, Optional
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

import requests
from pydantic import BaseModel, ConfigDict, ValidationError

logger = logging.getLogger(__name__)


class CandidatePair(BaseModel):
    item_one_id: int
    item_two_id: int
    title_one: str
    title_two: str
    distance: float


class ProductPair(CandidatePair):
    duplicate_likelihood: Literal["high", "low"]
    suggested_name: Optional[str]


class ProductPairs(BaseModel):
    results: list[ProductPair]


class ProductDecision(BaseModel):
    item_one_id: int
    item_two_id: int
    suggested_name: Optional[str]


class ProductDecisions(BaseModel):
    results: list[ProductDecision]


class CandidateGroupItem(BaseModel):
    item_id: int
    title: str
    distance: float
    is_anchor: bool


class CandidateGroup(BaseModel):
    anchor_item_id: int
    items: list[CandidateGroupItem]


class ProductGroup(CandidateGroup):
    duplicate_likelihood: Literal["high", "low"]
    suggested_name: Optional[str]


class ProductGroups(BaseModel):
    results: list[ProductGroup]


class GroupDecision(BaseModel):
    model_config = ConfigDict(extra="forbid")
    suggested_name: Optional[str]


class GroupDecisions(BaseModel):
    results: list[GroupDecision]


class ResolveGroupItem(BaseModel):
    item_id: int
    title: str


class ResolveGroup(BaseModel):
    anchor_item_id: int
    items: list[ResolveGroupItem]
    action: Literal["merge", "ignore"]
    suggested_name: Optional[str] = None


class ResolvePair(BaseModel):
    item_one_id: int
    item_two_id: int
    title_one: str
    title_two: str
    action: Literal["merge", "ignore"]
    suggested_name: Optional[str] = None


class ResolveRequest(BaseModel):
    groups: list[ResolveGroup] = []
    pairs: list[ResolvePair] = []


class Recommender:
    def __init__(
        self,
        api_url: str,
        model: str,
        *,
        provider: str = "ollama",
        api_key: Optional[str] = None,
    ):
        self.api_url = api_url
        self.model = model
        self.provider = provider.strip().lower()
        self.api_key = api_key

        if self.provider not in {"ollama", "gemini"}:
            raise ValueError(f"Unsupported LLM provider: {self.provider}")

    def recommend_duplicates(self, groups_json: str) -> dict:
        try:
            groups = json.loads(groups_json)
            if not groups:
                return {
                    "results": [],
                    "message": "No elements for analysis",
                }

            results: list[dict] = []
            for index, batch in enumerate(self._chunk_pairs(groups, batch_size=1), start=1):
                decisions = self._request_batch(index, batch)
                if not decisions:
                    continue
                results.extend(self._merge_batch_results(batch, decisions))

            return {"results": results}

        except json.JSONDecodeError as e:
            logger.error(f"Parsing error: {e}")
            return {
                "results": [],
                "message": "Invalid JSON!",
            }
        except requests.RequestException as e:
            logger.error("LLM API request error for provider %s: %s", self.provider, e)
            return {
                "results": [],
                "message": "Error while communicating with the LLM API!",
            }
        except Exception as e:
            logger.error(f"Error while processing duplicates: {e}")
            return {
                "results": [],
                "message": "Error while analyzing duplicates!",
            }

    @staticmethod
    def _pair_key(payload: dict) -> tuple[int, int]:
        return (
            payload["item_one_id"],
            payload["item_two_id"],
        )

    @staticmethod
    def _group_key(payload: dict) -> tuple[int, tuple[int, ...]]:
        return (
            payload["anchor_item_id"],
            tuple(
                item["item_id"]
                for item in payload["items"]
                if not item.get("is_anchor")
            ),
        )

    @staticmethod
    def _chunk_pairs(pairs: list[dict], batch_size: int) -> list[list[dict]]:
        return [pairs[i:i + batch_size] for i in range(0, len(pairs), batch_size)]

    @staticmethod
    def _fallback_group_decisions(batch: list[dict]) -> GroupDecisions:
        return GroupDecisions.model_validate(
            {
                "results": [
                    {
                        "suggested_name": next(
                            (item.get("title") for item in group["items"] if item.get("is_anchor")),
                            group["items"][0].get("title") if group.get("items") else None,
                        ),
                    }
                    for group in batch
                ]
            }
        )

    def _request_batch(self, batch_index: int, batch: list[dict]) -> Optional[GroupDecisions]:
        compact_batch = [
            {
                "items": [
                    {
                        "title": item["title"],
                        "is_anchor": item["is_anchor"],
                    }
                    for item in group["items"]
                ],
            }
            for group in batch
        ]
        prompt = (
            "Определи, являются ли группы товаров дублями по смыслу.\n"
            "Во всех группах первый элемент с is_anchor=true является основной записью.\n"
            "Если все элементы группы описывают один и тот же товар с разницей только в написании, верни suggested_name с нормализованным названием.\n"
            "Если внутри группы есть товары с разным смыслом, верни suggested_name = null.\n"
            "Верни JSON только для переданных групп, строго в том же порядке.\n"
            "Для каждой группы верни только одно поле: suggested_name.\n"
            "Не возвращай id, item_id, anchor_item_id, duplicate_item_ids, title, comments или любые другие поля.\n\n"
            f"{json.dumps(compact_batch, ensure_ascii=False)}"
        )

        payload = self._build_payload(prompt)
        request_url = self._build_request_url()
        request_headers = self._build_request_headers()

        logger.info(
            "LLM request batch=%s size=%s provider=%s url=%s payload=%s",
            batch_index,
            len(batch),
            self.provider,
            request_url,
            json.dumps(payload, ensure_ascii=False),
        )
        response = requests.post(request_url, json=payload, headers=request_headers)
        response.raise_for_status()
        logger.info(
            "LLM raw response batch=%s status=%s body=%s",
            batch_index,
            response.status_code,
            response.text,
        )
        data = response.json()

        content = self._extract_content(data)

        logger.info("LLM parsed content batch=%s: %s", batch_index, content)

        if not content:
            logger.error("Failed to extract content from response for batch %s: %s", batch_index, data)
            return None

        try:
            validated = GroupDecisions.model_validate_json(content)
            if len(validated.results) != len(batch):
                logger.error(
                    "LLM returned unexpected number of results for batch %s: expected=%s actual=%s",
                    batch_index,
                    len(batch),
                    len(validated.results),
                )
                return self._fallback_group_decisions(batch)
            return validated
        except ValidationError as ve:
            logger.error("Validation error for batch %s: %s", batch_index, ve)
            return None

    def _build_payload(self, prompt: str) -> dict[str, Any]:
        if self.provider == "gemini":
            return {
                "contents": [
                    {
                        "role": "user",
                        "parts": [{"text": prompt}],
                    }
                ],
                "generationConfig": {
                    "temperature": 0.1,
                    "topP": 0.8,
                    "responseMimeType": "application/json",
                },
            }

        return {
            "model": self.model,
            "messages": [{
                "role": "user",
                "content": prompt
            }],
            "think": False,
            "reasoning": False,
            "stream": False,
            "format": GroupDecisions.model_json_schema(),
            "options": {
                "temperature": 0.1,
                "top_p": 0.8,
                "repeat_penalty": 1.1
            }
        }

    def _build_request_headers(self) -> dict[str, str]:
        if self.provider == "gemini":
            return {"Content-Type": "application/json"}
        return {}

    def _build_request_url(self) -> str:
        if self.provider != "gemini" or not self.api_key:
            return self.api_url

        parts = urlsplit(self.api_url)
        query = dict(parse_qsl(parts.query, keep_blank_values=True))
        if "key" in query:
            return self.api_url

        query["key"] = self.api_key
        return urlunsplit(parts._replace(query=urlencode(query)))

    def _extract_content(self, data: dict[str, Any]) -> Optional[str]:
        if self.provider == "gemini":
            candidates = data.get("candidates")
            if not isinstance(candidates, list) or not candidates:
                return None

            content = candidates[0].get("content") or {}
            parts = content.get("parts")
            if not isinstance(parts, list):
                return None

            text_parts = [
                part.get("text")
                for part in parts
                if isinstance(part, dict) and isinstance(part.get("text"), str)
            ]
            if text_parts:
                return "".join(text_parts)
            return None

        if "message" in data and "content" in data["message"]:
            return data["message"]["content"]
        if "completion" in data:
            return data["completion"]
        if "choices" in data and len(data["choices"]) > 0:
            choice = data["choices"][0]
            if "message" in choice and "content" in choice["message"]:
                return choice["message"]["content"]
        return None

    def _matches_input_pairs(self, input_pairs: list[dict], output_pairs: ProductDecisions) -> bool:
        expected_keys = {self._pair_key(pair) for pair in input_pairs}
        actual_keys = {self._pair_key(pair.model_dump(mode="json")) for pair in output_pairs.results}
        return len(output_pairs.results) == len(input_pairs) and actual_keys == expected_keys

    @staticmethod
    def _merge_batch_results(batch: list[dict], decisions: GroupDecisions) -> list[dict]:
        merged = []
        for group, decision in zip(batch, decisions.results):
            suggested_name = decision.suggested_name
            merged.append(
                {
                    **group,
                    "duplicate_likelihood": "high" if suggested_name else "low",
                    "suggested_name": suggested_name,
                }
            )
        return merged
