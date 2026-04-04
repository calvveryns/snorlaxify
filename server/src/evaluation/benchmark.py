from __future__ import annotations

import json
import math
import os
import sys
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Iterable, Optional, Protocol
from urllib.parse import urlsplit, urlunsplit

from server.src.databases import SourceDatabase
from server.src.utils.dedup_metrics import (
    build_gold_pair_set_from_labeled_dataset,
    build_pair_set_from_groups,
    calculate_deduplication_quality_metrics,
    calculate_pair_metrics_on_labeled_dataset,
)
from server.src.utils.vectorizer_input import build_vectorizer_input


class VectorizerLike(Protocol):
    def vectorize(self, text: str) -> list[float]:
        ...


class RecommenderLike(Protocol):
    def recommend_duplicates(self, groups_json: str) -> dict[str, Any]:
        ...


@dataclass(frozen=True)
class BenchmarkEvaluationResult:
    dataset_path: str
    items_total: int
    labeled_pairs_total: int
    candidate_groups_total: int
    predicted_duplicate_groups_total: int
    metrics: dict[str, Any]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


def _parse_timestamp(value: Optional[str]) -> Optional[datetime]:
    if not value:
        return None
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def _coalesce_name(name_payload: Any) -> Optional[str]:
    if isinstance(name_payload, dict):
        return name_payload.get("en") or name_payload.get("ru")
    if isinstance(name_payload, str):
        return name_payload
    return None


def _build_identifier_from_item(item: dict[str, Any]) -> dict[str, Any]:
    return {
        "item_id": item["id"],
        "name": _coalesce_name(item.get("name")),
        "path": item.get("path"),
        "type_id": item.get("typeId"),
        "type_identifier": item.get("typeIdentifier"),
        "updated_at": _parse_timestamp(item.get("updatedAt")),
    }


def _cosine_distance(vector_one: list[float], vector_two: list[float]) -> float:
    dot_product = sum(left * right for left, right in zip(vector_one, vector_two))
    left_norm = math.sqrt(sum(value * value for value in vector_one))
    right_norm = math.sqrt(sum(value * value for value in vector_two))

    if left_norm == 0.0 or right_norm == 0.0:
        return 1.0

    cosine_similarity = dot_product / (left_norm * right_norm)
    cosine_similarity = max(-1.0, min(1.0, cosine_similarity))
    return 1.0 - cosine_similarity


def _build_candidate_groups(
    identifiers: list[dict[str, Any]],
    embeddings_by_item_id: dict[int, list[float]],
    distance_threshold: float,
    top_k: int,
) -> list[dict[str, Any]]:
    rows: list[tuple[int, int, str]] = []
    neighbour_rows: dict[int, list[tuple[int, int, str, float]]] = {}

    ordered_identifiers = [identifier for identifier in identifiers if identifier.get("name")]
    vector_ids_by_item_id = {
        identifier["item_id"]: index
        for index, identifier in enumerate(ordered_identifiers, start=1)
    }

    for identifier in ordered_identifiers:
        item_id = identifier["item_id"]
        vector_id = vector_ids_by_item_id[item_id]
        title = identifier["name"]
        rows.append((vector_id, item_id, title))

    for base_identifier in ordered_identifiers:
        base_item_id = base_identifier["item_id"]
        base_vector = embeddings_by_item_id[base_item_id]
        base_vector_id = vector_ids_by_item_id[base_item_id]
        neighbours: list[tuple[int, int, str, float]] = []

        for other_identifier in ordered_identifiers:
            other_item_id = other_identifier["item_id"]
            if other_item_id == base_item_id:
                continue

            distance = _cosine_distance(base_vector, embeddings_by_item_id[other_item_id])
            if distance >= distance_threshold:
                continue

            neighbours.append(
                (
                    vector_ids_by_item_id[other_item_id],
                    other_item_id,
                    other_identifier["name"],
                    distance,
                )
            )

        neighbour_rows[base_vector_id] = sorted(neighbours, key=lambda row: (row[3], row[0]))[:top_k]

    return SourceDatabase._build_groups_from_neighbors(rows, neighbour_rows)


def load_benchmark_dataset(dataset_path: str | os.PathLike[str]) -> dict[str, Any]:
    path = Path(dataset_path)
    return json.loads(path.read_text(encoding="utf-8"))


def adapt_service_url_for_local_run(url: str) -> str:
    parts = urlsplit(url)
    if parts.hostname != "host.docker.internal":
        return url

    netloc = "localhost"
    if parts.port is not None:
        netloc = f"{netloc}:{parts.port}"
    if parts.username:
        auth = parts.username
        if parts.password:
            auth = f"{auth}:{parts.password}"
        netloc = f"{auth}@{netloc}"

    adapted_url = urlunsplit((parts.scheme, netloc, parts.path, parts.query, parts.fragment))
    print(
        f"Benchmark runner: using local fallback URL {adapted_url} instead of {url}",
        file=sys.stderr,
    )
    return adapted_url


def evaluate_benchmark_dataset(
    dataset: dict[str, Any],
    *,
    dataset_path: str = "<in-memory>",
    vectorizer: Optional[VectorizerLike] = None,
    recommender: Optional[RecommenderLike] = None,
    distance_threshold: Optional[float] = None,
    top_k: Optional[int] = None,
    vectorizer_api_url: Optional[str] = None,
    vectorizer_model: Optional[str] = None,
    llm_provider: Optional[str] = None,
    llm_api_url: Optional[str] = None,
    llm_model: Optional[str] = None,
    llm_api_key: Optional[str] = None,
) -> BenchmarkEvaluationResult:
    if vectorizer is None or recommender is None or distance_threshold is None:
        from server.src.config import settings
        from server.src.utils.recommender import Recommender
        from server.src.utils.vectorizer import Vectorizer

        resolved_vectorizer_api_url = adapt_service_url_for_local_run(
            vectorizer_api_url or settings.vectorizer_api_url
        )
        resolved_llm_api_url = adapt_service_url_for_local_run(
            llm_api_url or settings.llm_api_url
        )
        resolved_vectorizer_model = vectorizer_model or settings.vectorizer_model
        resolved_llm_provider = llm_provider or settings.llm_provider
        resolved_llm_model = llm_model or settings.llm_model
        resolved_llm_api_key = llm_api_key or settings.llm_api_key

        vectorizer = vectorizer or Vectorizer(resolved_vectorizer_api_url, resolved_vectorizer_model)
        recommender = recommender or Recommender(
            resolved_llm_api_url,
            resolved_llm_model,
            provider=resolved_llm_provider,
            api_key=resolved_llm_api_key,
        )
        distance_threshold = distance_threshold if distance_threshold is not None else settings.duplicate_distance_threshold

    items = dataset.get("items") or []
    labeled_pairs = dataset.get("labeled_pairs") or []
    top_k = top_k if top_k is not None else max(1, int(os.getenv("DUPLICATE_GROUP_TOP_K", "10")))

    identifiers = [
        identifier
        for identifier in (_build_identifier_from_item(item) for item in items)
        if identifier.get("name")
    ]

    embeddings_by_item_id: dict[int, list[float]] = {}
    for identifier in identifiers:
        vectorizer_input = build_vectorizer_input(identifier)
        embeddings_by_item_id[identifier["item_id"]] = vectorizer.vectorize(vectorizer_input)

    candidate_groups = _build_candidate_groups(
        identifiers=identifiers,
        embeddings_by_item_id=embeddings_by_item_id,
        distance_threshold=distance_threshold,
        top_k=top_k,
    )
    candidate_pairs = build_pair_set_from_groups(candidate_groups)

    recommendation_payload = recommender.recommend_duplicates(
        json.dumps(candidate_groups, ensure_ascii=False)
    )
    predicted_groups = [
        group
        for group in recommendation_payload.get("results", [])
        if group.get("duplicate_likelihood") == "high"
    ]
    predicted_pairs = build_pair_set_from_groups(predicted_groups)
    gold_pairs = build_gold_pair_set_from_labeled_dataset(labeled_pairs)

    quality_report = calculate_deduplication_quality_metrics(
        candidate_pairs=candidate_pairs,
        predicted_duplicate_pairs=predicted_pairs,
        gold_duplicate_pairs=gold_pairs,
    )
    pair_report = calculate_pair_metrics_on_labeled_dataset(
        predicted_duplicate_pairs=predicted_pairs,
        labeled_pairs=labeled_pairs,
    )

    return BenchmarkEvaluationResult(
        dataset_path=dataset_path,
        items_total=len(items),
        labeled_pairs_total=len(labeled_pairs),
        candidate_groups_total=len(candidate_groups),
        predicted_duplicate_groups_total=len(predicted_groups),
        metrics={
            **pair_report.to_dict(),
            **quality_report.to_dict(),
        },
    )
