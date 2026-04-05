from __future__ import annotations

import json
import logging
import math
import os
import sys
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Optional, Protocol
from urllib.parse import urlsplit, urlunsplit

from server.src.databases import SourceDatabase
from server.src.utils.dedup_metrics import (
    PairQualityMetrics,
    build_gold_pair_set_from_labeled_dataset,
    build_pair_set_from_groups,
)
from server.src.utils.vectorizer_input import build_vectorizer_input

logger = logging.getLogger(__name__)


class VectorizerLike(Protocol):
    def vectorize(self, text: str) -> list[float]:
        ...


@dataclass(frozen=True)
class BenchmarkEvaluationResult:
    dataset_path: str
    precision: float
    recall: float
    f1: float

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
        logger.debug(
            "Candidate search for item_id=%s title=%r vector_dim=%s threshold=%s top_k=%s",
            base_item_id,
            base_identifier["name"],
            len(base_vector),
            distance_threshold,
            top_k,
        )
        neighbours: list[tuple[int, int, str, float]] = []
        considered_distances: list[tuple[int, float]] = []

        for other_identifier in ordered_identifiers:
            other_item_id = other_identifier["item_id"]
            if other_item_id == base_item_id:
                continue

            distance = _cosine_distance(base_vector, embeddings_by_item_id[other_item_id])
            considered_distances.append((other_item_id, distance))
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

        considered_distances.sort(key=lambda item: (item[1], item[0]))
        logger.debug(
            "Nearest neighbours for item_id=%s: %s",
            base_item_id,
            [
                {"item_id": item_id, "distance": round(distance, 6)}
                for item_id, distance in considered_distances[: min(5, len(considered_distances))]
            ],
        )
        neighbour_rows[base_vector_id] = sorted(neighbours, key=lambda row: (row[3], row[0]))[:top_k]
        logger.debug(
            "Accepted neighbours for item_id=%s under threshold=%s: %s",
            base_item_id,
            distance_threshold,
            [
                {"item_id": row[1], "distance": round(row[3], 6), "title": row[2]}
                for row in neighbour_rows[base_vector_id]
            ],
        )

    candidate_groups = SourceDatabase._build_groups_from_neighbors(rows, neighbour_rows)
    logger.info("Candidate generation built %s groups", len(candidate_groups))
    logger.debug("Candidate groups payload: %s", json.dumps(candidate_groups, ensure_ascii=False, indent=2))
    return candidate_groups


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
    distance_threshold: Optional[float] = None,
    top_k: Optional[int] = None,
    vectorizer_api_url: Optional[str] = None,
    vectorizer_model: Optional[str] = None,
) -> BenchmarkEvaluationResult:
    if vectorizer is None or distance_threshold is None:
        from server.src.config import settings
        from server.src.utils.vectorizer import Vectorizer

        resolved_vectorizer_api_url = adapt_service_url_for_local_run(
            vectorizer_api_url or settings.vectorizer_api_url
        )
        resolved_vectorizer_model = vectorizer_model or settings.vectorizer_model
        logger.info(
            "Benchmark config: dataset=%s vectorizer_url=%s vectorizer_model=%s distance_threshold=%s",
            dataset_path,
            resolved_vectorizer_api_url,
            resolved_vectorizer_model,
            distance_threshold if distance_threshold is not None else settings.duplicate_distance_threshold,
        )

        vectorizer = vectorizer or Vectorizer(resolved_vectorizer_api_url, resolved_vectorizer_model)
        distance_threshold = (
            distance_threshold if distance_threshold is not None else settings.duplicate_distance_threshold
        )

    items = dataset.get("items") or []
    labeled_pairs = dataset.get("labeled_pairs") or []
    top_k = top_k if top_k is not None else max(1, int(os.getenv("DUPLICATE_GROUP_TOP_K", "10")))
    logger.info(
        "Loaded benchmark dataset %s: items=%s labeled_pairs=%s top_k=%s",
        dataset_path,
        len(items),
        len(labeled_pairs),
        top_k,
    )

    identifiers = [
        identifier
        for identifier in (_build_identifier_from_item(item) for item in items)
        if identifier.get("name")
    ]
    logger.info("Prepared %s identifiers with non-empty names", len(identifiers))

    embeddings_by_item_id: dict[int, list[float]] = {}
    for identifier in identifiers:
        vectorizer_input = build_vectorizer_input(identifier)
        logger.debug(
            "Vectorizing item_id=%s title=%r input=%r",
            identifier["item_id"],
            identifier["name"],
            vectorizer_input,
        )
        embedding = vectorizer.vectorize(vectorizer_input)
        embeddings_by_item_id[identifier["item_id"]] = embedding
        logger.debug(
            "Vectorized item_id=%s vector_dim=%s first_values=%s",
            identifier["item_id"],
            len(embedding),
            [round(float(value), 6) for value in embedding[: min(5, len(embedding))]],
        )

    candidate_groups = _build_candidate_groups(
        identifiers=identifiers,
        embeddings_by_item_id=embeddings_by_item_id,
        distance_threshold=distance_threshold,
        top_k=top_k,
    )
    candidate_pairs = build_pair_set_from_groups(candidate_groups)
    gold_pairs = build_gold_pair_set_from_labeled_dataset(labeled_pairs)
    logger.info(
        "Candidate-only benchmark produced candidate_pairs=%s gold_pairs=%s",
        len(candidate_pairs),
        len(gold_pairs),
    )

    item_titles = {identifier["item_id"]: identifier["name"] for identifier in identifiers}
    gold_pair_diagnostics = []
    for item_one_id, item_two_id in sorted(gold_pairs):
        vector_one = embeddings_by_item_id.get(item_one_id)
        vector_two = embeddings_by_item_id.get(item_two_id)
        distance = None
        if vector_one is not None and vector_two is not None:
            distance = _cosine_distance(vector_one, vector_two)
        gold_pair_diagnostics.append(
            {
                "pair": [item_one_id, item_two_id],
                "title_one": item_titles.get(item_one_id),
                "title_two": item_titles.get(item_two_id),
                "distance": round(distance, 6) if distance is not None else None,
                "is_candidate": (item_one_id, item_two_id) in candidate_pairs,
            }
        )
    logger.info("Gold pair diagnostics count=%s", len(gold_pair_diagnostics))
    logger.debug("Gold pair diagnostics: %s", json.dumps(gold_pair_diagnostics, ensure_ascii=False, indent=2))

    metrics = PairQualityMetrics.from_sets(candidate_pairs, gold_pairs)
    logger.info(
        "Metrics summary: precision=%.4f recall=%.4f f1=%.4f",
        metrics.precision,
        metrics.recall,
        metrics.f1,
    )

    return BenchmarkEvaluationResult(
        dataset_path=dataset_path,
        precision=metrics.precision,
        recall=metrics.recall,
        f1=metrics.f1,
    )
