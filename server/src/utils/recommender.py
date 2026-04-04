from __future__ import annotations

import json
import logging
from typing import Literal, Optional

import requests
from pydantic import BaseModel, ValidationError

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
    anchor_item_id: int
    duplicate_item_ids: list[int]
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
    def __init__(self, api_url: str, model: str):
        self.api_url = api_url
        self.model = model

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
            logger.error(f"Ollama API request error: {e}")
            return {
                "results": [],
                "message": "Error while communicating with the Ollama API!",
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

    def _request_batch(self, batch_index: int, batch: list[dict]) -> Optional[GroupDecisions]:
        compact_batch = [
            {
                "anchor_item_id": group["anchor_item_id"],
                "items": [
                    {
                        "item_id": item["item_id"],
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
            "Верни JSON только для переданных групп. Не пропускай группы и не добавляй новые.\n"
            "duplicate_item_ids должны содержать все item_id элементов группы, кроме anchor_item_id, и в том же порядке.\n\n"
            f"{json.dumps(compact_batch, ensure_ascii=False)}"
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
            "format": GroupDecisions.model_json_schema(),
            "options": {
                "temperature": 0.1,
                "top_p": 0.8,
                "repeat_penalty": 1.1
            }
        }

        logger.info(
            "LLM request batch=%s size=%s url=%s payload=%s",
            batch_index,
            len(batch),
            self.api_url,
            json.dumps(payload, ensure_ascii=False),
        )
        response = requests.post(self.api_url, json=payload)
        response.raise_for_status()
        logger.info(
            "LLM raw response batch=%s status=%s body=%s",
            batch_index,
            response.status_code,
            response.text,
        )
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

        logger.info("LLM parsed content batch=%s: %s", batch_index, content)

        if not content:
            logger.error("Failed to extract content from response for batch %s: %s", batch_index, data)
            return None

        try:
            validated = GroupDecisions.model_validate_json(content)
            if not self._matches_input_groups(batch, validated):
                logger.error("LLM returned groups that do not match the candidate input for batch %s", batch_index)
                return None
            return validated
        except ValidationError as ve:
            logger.error("Validation error for batch %s: %s", batch_index, ve)
            return None

    def _matches_input_pairs(self, input_pairs: list[dict], output_pairs: ProductDecisions) -> bool:
        expected_keys = {self._pair_key(pair) for pair in input_pairs}
        actual_keys = {self._pair_key(pair.model_dump(mode="json")) for pair in output_pairs.results}
        return len(output_pairs.results) == len(input_pairs) and actual_keys == expected_keys

    def _matches_input_groups(self, input_groups: list[dict], output_groups: GroupDecisions) -> bool:
        expected_keys = {self._group_key(group) for group in input_groups}
        actual_keys = {
            (group.anchor_item_id, tuple(group.duplicate_item_ids))
            for group in output_groups.results
        }
        return len(output_groups.results) == len(input_groups) and actual_keys == expected_keys

    @staticmethod
    def _merge_batch_results(batch: list[dict], decisions: GroupDecisions) -> list[dict]:
        decisions_map = {
            (decision.anchor_item_id, tuple(decision.duplicate_item_ids)): decision
            for decision in decisions.results
        }
        merged = []
        for group in batch:
            decision = decisions_map.get(
                (
                    group["anchor_item_id"],
                    tuple(
                        item["item_id"]
                        for item in group["items"]
                        if not item.get("is_anchor")
                    ),
                )
            )
            suggested_name = decision.suggested_name if decision else None
            merged.append(
                {
                    **group,
                    "duplicate_likelihood": "high" if suggested_name else "low",
                    "suggested_name": suggested_name,
                }
            )
        return merged
