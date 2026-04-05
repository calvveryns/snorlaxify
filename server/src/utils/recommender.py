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


class FilteredDuplicateGroupDecision(BaseModel):
    model_config = ConfigDict(extra="forbid")
    anchor_item_id: int
    duplicate_item_ids: list[int]


class FilteredDuplicateGroupDecisions(BaseModel):
    results: list[FilteredDuplicateGroupDecision]


class RegroupedDuplicateGroupDecision(BaseModel):
    model_config = ConfigDict(extra="forbid")
    anchor_item_id: int
    item_ids: list[int]


class RegroupedDuplicateGroupDecisions(BaseModel):
    results: list[RegroupedDuplicateGroupDecision]


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
        regroup_think: bool = True,
        filter_think: bool = True,
        recommend_think: bool = True,
    ):
        self.api_url = api_url
        self.model = model
        self.provider = provider.strip().lower()
        self.api_key = api_key
        self.regroup_think = regroup_think
        self.filter_think = filter_think
        self.recommend_think = recommend_think

        if self.provider not in {"ollama", "gemini"}:
            raise ValueError(f"Unsupported LLM provider: {self.provider}")

    def filter_duplicate_groups(self, groups_json: str, *, batch_size: int = 1) -> dict[str, Any]:
        try:
            groups = json.loads(groups_json)
            if not groups:
                return {
                    "results": [],
                    "message": "No elements for analysis",
                }

            filtered_groups: list[dict[str, Any]] = []
            for index, batch in enumerate(self._chunk_payload(groups, batch_size=batch_size), start=1):
                decisions = self._request_filter_batch(index, batch)
                if not decisions:
                    filtered_groups.extend(batch)
                    continue
                filtered_groups.extend(self._merge_filtered_groups(batch, decisions))

            return {"results": filtered_groups}

        except json.JSONDecodeError as e:
            logger.error("Parsing error: %s", e)
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
            logger.error("Error while filtering duplicate groups: %s", e)
            return {
                "results": [],
                "message": "Error while filtering duplicates!",
            }

    def regroup_duplicate_groups(self, groups_json: str, *, batch_size: int = 1) -> dict[str, Any]:
        try:
            groups = json.loads(groups_json)
            if not groups:
                return {
                    "results": [],
                    "message": "No elements for analysis",
                }

            regrouped_groups: list[dict[str, Any]] = []
            for index, batch in enumerate(self._chunk_payload(groups, batch_size=batch_size), start=1):
                decisions = self._request_regroup_batch(index, batch)
                if not decisions:
                    regrouped_groups.extend(batch)
                    continue
                regrouped_groups.extend(self._merge_regrouped_groups(batch, decisions))

            return {"results": regrouped_groups}

        except json.JSONDecodeError as e:
            logger.error("Parsing error: %s", e)
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
            logger.error("Error while regrouping duplicate groups: %s", e)
            return {
                "results": [],
                "message": "Error while regrouping duplicates!",
            }

    def recommend_duplicates(self, groups_json: str, *, batch_size: int = 1) -> dict[str, Any]:
        try:
            groups = json.loads(groups_json)
            if not groups:
                return {
                    "results": [],
                    "message": "No elements for analysis",
                }

            results: list[dict[str, Any]] = []
            for index, batch in enumerate(self._chunk_payload(groups, batch_size=batch_size), start=1):
                decisions = self._request_recommendation_batch(index, batch)
                if not decisions:
                    continue
                results.extend(self._merge_batch_results(batch, decisions))

            return {"results": results}

        except json.JSONDecodeError as e:
            logger.error("Parsing error: %s", e)
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
            logger.error("Error while processing duplicates: %s", e)
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
    def _chunk_payload(payload: list[dict], batch_size: int) -> list[list[dict]]:
        batch_size = max(1, batch_size)
        return [payload[i:i + batch_size] for i in range(0, len(payload), batch_size)]

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

    @staticmethod
    def _fallback_filter_decisions(batch: list[dict]) -> FilteredDuplicateGroupDecisions:
        return FilteredDuplicateGroupDecisions.model_validate(
            {
                "results": [
                    {
                        "anchor_item_id": group["anchor_item_id"],
                        "duplicate_item_ids": [
                            item["item_id"]
                            for item in group.get("items", [])
                            if not item.get("is_anchor")
                        ],
                    }
                    for group in batch
                    if any(not item.get("is_anchor") for item in group.get("items", []))
                ]
            }
        )

    def _request_filter_batch(
        self,
        batch_index: int,
        batch: list[dict],
    ) -> Optional[FilteredDuplicateGroupDecisions]:
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
            "Проверь группы товаров на смысловые дубликаты.\n"
            "В каждой группе есть основной товар с is_anchor=true.\n"
            "Верни только те группы, где есть реальные дубликаты anchor-товара.\n"
            "Если внутри группы только часть записей является дублями, верни только id этих дублей в duplicate_item_ids.\n"
            "Если в группе нет дублей, не возвращай эту группу.\n"
            "Нельзя добавлять новые id или менять anchor_item_id.\n"
            "Ответ верни строго в JSON-формате {\"results\": [...]}.\n"
            "Для каждой возвращенной группы разрешены только поля anchor_item_id и duplicate_item_ids.\n\n"
            f"{json.dumps(compact_batch, ensure_ascii=False)}"
        )

        try:
            content = self._request_llm(
                batch_index=batch_index,
                batch_size=len(batch),
                prompt=prompt,
                response_schema=FilteredDuplicateGroupDecisions,
                think=self.filter_think,
            )
            validated = FilteredDuplicateGroupDecisions.model_validate_json(content)
            if not self._matches_filter_input(batch, validated):
                logger.error("LLM returned invalid filter payload for batch %s", batch_index)
                return self._fallback_filter_decisions(batch)
            return validated
        except ValidationError as ve:
            logger.error("Validation error for filter batch %s: %s", batch_index, ve)
            return self._fallback_filter_decisions(batch)
        except ValueError as ve:
            logger.error("Error for filter batch %s: %s", batch_index, ve)
            return self._fallback_filter_decisions(batch)

    def _request_regroup_batch(
        self,
        batch_index: int,
        batch: list[dict],
    ) -> Optional[RegroupedDuplicateGroupDecisions]:
        compact_batch = [
            {
                "source_anchor_item_id": group["anchor_item_id"],
                "items": [
                    {
                        "item_id": item["item_id"],
                        "title": item["title"],
                        "distance": item["distance"],
                        "is_anchor": item["is_anchor"],
                    }
                    for item in group["items"]
                ],
            }
            for group in batch
        ]

        prompt = (
            "Разбей каждую входную группу товаров на смысловые подгруппы дубликатов.\n"
            "Во входной группе могут смешиваться несколько разных товаров.\n"
            "Нужно выделить отдельные группы, где внутри группы все записи описывают один и тот же товар.\n"
            "Если внутри исходной группы есть две или больше независимых группы дублей, верни их все отдельно.\n"
            "Если запись ни с кем не образует дубликатную группу, не возвращай ее.\n"
            "anchor_item_id должен быть одним из item_ids своей подгруппы.\n"
            "item_ids должны содержать все записи подгруппы, включая anchor_item_id.\n"
            "Нельзя добавлять новые item_ids, которых нет во входной группе.\n"
            "Одна запись не должна попадать в несколько подгрупп одновременно.\n"
            "Ответ верни строго в JSON-формате {\"results\": [...]}.\n"
            "Для каждой подгруппы разрешены только поля anchor_item_id и item_ids.\n\n"
            f"{json.dumps(compact_batch, ensure_ascii=False)}"
        )

        try:
            content = self._request_llm(
                batch_index=batch_index,
                batch_size=len(batch),
                prompt=prompt,
                response_schema=RegroupedDuplicateGroupDecisions,
                think=self.regroup_think,
            )
            validated = RegroupedDuplicateGroupDecisions.model_validate_json(content)
            if not self._matches_regroup_input(batch, validated):
                logger.error("LLM returned invalid regroup payload for batch %s", batch_index)
                return None
            return validated
        except ValidationError as ve:
            logger.error("Validation error for regroup batch %s: %s", batch_index, ve)
            return None
        except ValueError as ve:
            logger.error("Error for regroup batch %s: %s", batch_index, ve)
            return None

    def _request_recommendation_batch(
        self,
        batch_index: int,
        batch: list[dict],
    ) -> Optional[GroupDecisions]:
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
            "Для каждой группы дублей предложи нормализованное название товара.\n"
            "Во всех группах первый элемент с is_anchor=true является основной записью.\n"
            "Если можно дать единое корректное название для всей группы дублей, верни его в suggested_name.\n"
            "Если группа действительно состоит из дублей, но ты не уверен в нормализованном названии, верни suggested_name = null.\n"
            "Верни JSON только для переданных групп, строго в том же порядке.\n"
            "Для каждой группы верни только одно поле: suggested_name.\n"
            "Не возвращай id, item_id, anchor_item_id, duplicate_item_ids, title, comments или любые другие поля.\n\n"
            f"{json.dumps(compact_batch, ensure_ascii=False)}"
        )

        try:
            content = self._request_llm(
                batch_index=batch_index,
                batch_size=len(batch),
                prompt=prompt,
                response_schema=GroupDecisions,
                think=self.recommend_think,
            )
            validated = GroupDecisions.model_validate_json(content)
            if len(validated.results) != len(batch):
                logger.error(
                    "LLM returned unexpected number of recommendation results for batch %s: expected=%s actual=%s",
                    batch_index,
                    len(batch),
                    len(validated.results),
                )
                return self._fallback_group_decisions(batch)
            return validated
        except ValidationError as ve:
            logger.error("Validation error for recommendation batch %s: %s", batch_index, ve)
            return self._fallback_group_decisions(batch)
        except ValueError as ve:
            logger.error("Error for recommendation batch %s: %s", batch_index, ve)
            return self._fallback_group_decisions(batch)

    def _request_llm(
        self,
        *,
        batch_index: int,
        batch_size: int,
        prompt: str,
        response_schema: type[BaseModel],
        think: bool,
    ) -> str:
        payload = self._build_payload(prompt, response_schema, think=think)
        request_url = self._build_request_url()
        request_headers = self._build_request_headers()

        logger.info(
            "LLM request batch=%s size=%s provider=%s url=%s payload=%s",
            batch_index,
            batch_size,
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
            raise ValueError("Failed to extract content from LLM response")

        return content

    def _build_payload(
        self,
        prompt: str,
        response_schema: type[BaseModel],
        *,
        think: bool,
    ) -> dict[str, Any]:
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
                "content": prompt,
            }],
            "think": think,
            "reasoning": False,
            "stream": False,
            "format": self._build_response_format(response_schema),
            "options": {
                "temperature": 0.1,
                "top_p": 0.8,
                "repeat_penalty": 1.1,
            },
        }

    @staticmethod
    def _build_response_format(response_schema: type[BaseModel]) -> dict[str, Any]:
        if response_schema is GroupDecisions:
            return {
                "type": "object",
                "properties": {
                    "results": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "suggested_name": {
                                    "type": ["string", "null"],
                                }
                            },
                            "required": ["suggested_name"],
                            "additionalProperties": False,
                        },
                    }
                },
                "required": ["results"],
                "additionalProperties": False,
            }

        if response_schema is FilteredDuplicateGroupDecisions:
            return {
                "type": "object",
                "properties": {
                    "results": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "anchor_item_id": {"type": "integer"},
                                "duplicate_item_ids": {
                                    "type": "array",
                                    "items": {"type": "integer"},
                                },
                            },
                            "required": ["anchor_item_id", "duplicate_item_ids"],
                            "additionalProperties": False,
                        },
                    }
                },
                "required": ["results"],
                "additionalProperties": False,
            }

        if response_schema is RegroupedDuplicateGroupDecisions:
            return {
                "type": "object",
                "properties": {
                    "results": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "anchor_item_id": {"type": "integer"},
                                "item_ids": {
                                    "type": "array",
                                    "items": {"type": "integer"},
                                },
                            },
                            "required": ["anchor_item_id", "item_ids"],
                            "additionalProperties": False,
                        },
                    }
                },
                "required": ["results"],
                "additionalProperties": False,
            }

        return response_schema.model_json_schema()

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
    def _matches_filter_input(
        input_groups: list[dict],
        output_groups: FilteredDuplicateGroupDecisions,
    ) -> bool:
        input_groups_by_anchor = {
            group["anchor_item_id"]: {
                item["item_id"]
                for item in group.get("items", [])
                if not item.get("is_anchor")
            }
            for group in input_groups
        }

        seen_anchors: set[int] = set()
        for group in output_groups.results:
            if group.anchor_item_id in seen_anchors:
                return False
            if group.anchor_item_id not in input_groups_by_anchor:
                return False
            if not group.duplicate_item_ids:
                return False

            allowed_duplicate_ids = input_groups_by_anchor[group.anchor_item_id]
            actual_duplicate_ids = set(group.duplicate_item_ids)
            if len(actual_duplicate_ids) != len(group.duplicate_item_ids):
                return False
            if not actual_duplicate_ids.issubset(allowed_duplicate_ids):
                return False

            seen_anchors.add(group.anchor_item_id)

        return True

    @staticmethod
    def _matches_regroup_input(
        input_groups: list[dict],
        output_groups: RegroupedDuplicateGroupDecisions,
    ) -> bool:
        available_item_ids: set[int] = set()
        for group in input_groups:
            for item in group.get("items", []):
                available_item_ids.add(item["item_id"])

        used_item_ids: set[int] = set()
        for group in output_groups.results:
            actual_item_ids = set(group.item_ids)
            if len(actual_item_ids) != len(group.item_ids):
                return False
            if len(actual_item_ids) < 2:
                return False
            if group.anchor_item_id not in actual_item_ids:
                return False
            if not actual_item_ids.issubset(available_item_ids):
                return False
            if used_item_ids & actual_item_ids:
                return False
            used_item_ids.update(actual_item_ids)

        return True

    @staticmethod
    def _merge_filtered_groups(
        batch: list[dict],
        decisions: FilteredDuplicateGroupDecisions,
    ) -> list[dict[str, Any]]:
        decisions_by_anchor = {
            decision.anchor_item_id: set(decision.duplicate_item_ids)
            for decision in decisions.results
        }
        merged: list[dict[str, Any]] = []

        for group in batch:
            selected_duplicate_ids = decisions_by_anchor.get(group["anchor_item_id"])
            if not selected_duplicate_ids:
                continue

            filtered_items = [
                item
                for item in group.get("items", [])
                if item.get("is_anchor") or item.get("item_id") in selected_duplicate_ids
            ]
            if len(filtered_items) < 2:
                continue

            merged.append(
                {
                    **group,
                    "items": filtered_items,
                }
            )

        return merged

    @staticmethod
    def _merge_regrouped_groups(
        batch: list[dict],
        decisions: RegroupedDuplicateGroupDecisions,
    ) -> list[dict[str, Any]]:
        item_payloads: dict[int, dict[str, Any]] = {}
        for source_group in batch:
            for item in source_group.get("items", []):
                item_payloads[item["item_id"]] = dict(item)

        merged: list[dict[str, Any]] = []
        for decision in decisions.results:
            subgroup_items: list[dict[str, Any]] = []
            for item_id in decision.item_ids:
                item_payload = dict(item_payloads[item_id])
                item_payload["is_anchor"] = item_id == decision.anchor_item_id
                if item_id == decision.anchor_item_id:
                    item_payload["distance"] = 0.0
                subgroup_items.append(item_payload)

            subgroup_items.sort(
                key=lambda item: (
                    not item.get("is_anchor"),
                    float(item.get("distance", 0.0)),
                    int(item["item_id"]),
                )
            )
            merged.append(
                {
                    "anchor_item_id": decision.anchor_item_id,
                    "items": subgroup_items,
                }
            )

        return merged

    @staticmethod
    def _merge_batch_results(batch: list[dict], decisions: GroupDecisions) -> list[dict]:
        merged = []
        for group, decision in zip(batch, decisions.results):
            merged.append(
                {
                    **group,
                    "duplicate_likelihood": "high",
                    "suggested_name": decision.suggested_name,
                }
            )
        return merged
