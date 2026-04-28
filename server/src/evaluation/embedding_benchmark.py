from __future__ import annotations

import json
import math
import os
import platform
import subprocess
import time
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Callable, Optional, Protocol

from server.src.evaluation.benchmark import adapt_service_url_for_local_run
from server.src.utils.dedup_metrics import build_gold_pair_set_from_labeled_dataset
from server.src.utils.vectorizer_input import build_vectorizer_input


class VectorizerLike(Protocol):
    def vectorize(self, text: str) -> list[float]:
        ...


@dataclass(frozen=True)
class MemoryUsage:
    process_name: Optional[str]
    pids: list[int]
    ram_bytes: Optional[int]
    vram_bytes: Optional[int]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(frozen=True)
class EmbeddingBenchmarkResult:
    dataset_path: str
    items_total: int
    items_vectorized: int
    positive_pairs_total: int
    evaluable_items_with_known_duplicate: int
    embedding_calls_total: int
    embedding_dimension: Optional[int]
    avg_positive_pair_cosine_similarity: Optional[float]
    avg_embedding_latency_ms: Optional[float]
    nearest_neighbor_duplicate_rate: Optional[float]
    nearest_neighbor_duplicate_hits: int
    memory_usage: Optional[MemoryUsage]

    def to_dict(self) -> dict[str, Any]:
        payload = asdict(self)
        if self.memory_usage is not None:
            payload["memory_usage"] = self.memory_usage.to_dict()
        return payload


MemoryProbe = Callable[[Optional[str], Optional[int]], Optional[MemoryUsage]]


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


def load_benchmark_dataset(dataset_path: str | os.PathLike[str]) -> dict[str, Any]:
    path = Path(dataset_path)
    return json.loads(path.read_text(encoding="utf-8"))


def _cosine_similarity(vector_one: list[float], vector_two: list[float]) -> float:
    dot_product = sum(left * right for left, right in zip(vector_one, vector_two))
    left_norm = math.sqrt(sum(value * value for value in vector_one))
    right_norm = math.sqrt(sum(value * value for value in vector_two))

    if left_norm == 0.0 or right_norm == 0.0:
        return 0.0

    cosine_similarity = dot_product / (left_norm * right_norm)
    return max(-1.0, min(1.0, cosine_similarity))


def _build_duplicate_map(gold_pairs: set[tuple[int, int]]) -> dict[int, set[int]]:
    duplicate_map: dict[int, set[int]] = {}
    for item_one_id, item_two_id in gold_pairs:
        duplicate_map.setdefault(item_one_id, set()).add(item_two_id)
        duplicate_map.setdefault(item_two_id, set()).add(item_one_id)
    return duplicate_map


def _infer_model_process_name(vectorizer_api_url: Optional[str]) -> Optional[str]:
    if not vectorizer_api_url:
        return None
    normalized_url = vectorizer_api_url.lower()
    if "11434" in normalized_url or "/api/embed" in normalized_url or "/api/embeddings" in normalized_url:
        return "ollama"
    return None


def _run_command(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, capture_output=True, text=True, check=True)


def _get_pids_by_name(process_name: str) -> list[int]:
    system = platform.system().lower()
    if system == "windows":
        command = [
            "powershell",
            "-NoProfile",
            "-Command",
            f'Get-Process -Name "{process_name}" | Select-Object -ExpandProperty Id',
        ]
        result = _run_command(command)
        return [
            int(line.strip())
            for line in result.stdout.splitlines()
            if line.strip().isdigit()
        ]

    result = _run_command(["pgrep", "-x", process_name])
    return [int(line.strip()) for line in result.stdout.splitlines() if line.strip().isdigit()]


def _get_ram_bytes_for_pids(pids: list[int]) -> Optional[int]:
    if not pids:
        return None

    system = platform.system().lower()
    if system == "windows":
        pid_list = ",".join(str(pid) for pid in pids)
        command = [
            "powershell",
            "-NoProfile",
            "-Command",
            f"Get-Process -Id {pid_list} | Measure-Object -Property WorkingSet64 -Sum | Select-Object -ExpandProperty Sum",
        ]
        result = _run_command(command)
        output = result.stdout.strip()
        return int(output) if output.isdigit() else None

    pid_csv = ",".join(str(pid) for pid in pids)
    result = _run_command(["ps", "-o", "rss=", "-p", pid_csv])
    rss_kb = sum(int(line.strip()) for line in result.stdout.splitlines() if line.strip().isdigit())
    return rss_kb * 1024


def _get_vram_bytes_for_pids(pids: list[int]) -> Optional[int]:
    if not pids:
        return None

    try:
        result = _run_command(
            [
                "nvidia-smi",
                "--query-compute-apps=pid,used_gpu_memory",
                "--format=csv,noheader,nounits",
            ]
        )
    except Exception:
        return None

    total_mib = 0
    matched = False
    tracked_pids = set(pids)
    for raw_line in result.stdout.splitlines():
        parts = [part.strip() for part in raw_line.split(",")]
        if len(parts) != 2:
            continue
        pid_raw, memory_raw = parts
        if not pid_raw.isdigit() or not memory_raw.isdigit():
            continue
        pid = int(pid_raw)
        if pid not in tracked_pids:
            continue
        matched = True
        total_mib += int(memory_raw)

    if not matched:
        return None
    return total_mib * 1024 * 1024


def probe_model_memory_usage(
    process_name: Optional[str] = None,
    process_pid: Optional[int] = None,
) -> Optional[MemoryUsage]:
    if process_pid is not None:
        pids = [process_pid]
    elif process_name:
        try:
            pids = _get_pids_by_name(process_name)
        except Exception:
            return None
    else:
        return None

    if not pids:
        return MemoryUsage(
            process_name=process_name,
            pids=[],
            ram_bytes=None,
            vram_bytes=None,
        )

    try:
        ram_bytes = _get_ram_bytes_for_pids(pids)
    except Exception:
        ram_bytes = None

    vram_bytes = _get_vram_bytes_for_pids(pids)

    return MemoryUsage(
        process_name=process_name,
        pids=pids,
        ram_bytes=ram_bytes,
        vram_bytes=vram_bytes,
    )


def evaluate_embedding_benchmark_dataset(
    dataset: dict[str, Any],
    *,
    dataset_path: str = "<in-memory>",
    vectorizer: Optional[VectorizerLike] = None,
    vectorizer_api_url: Optional[str] = None,
    vectorizer_model: Optional[str] = None,
    model_process_name: Optional[str] = None,
    model_process_pid: Optional[int] = None,
    memory_probe: Optional[MemoryProbe] = None,
) -> EmbeddingBenchmarkResult:
    if vectorizer is None:
        from server.src.utils.vectorizer import Vectorizer

        resolved_vectorizer_api_url = adapt_service_url_for_local_run(
            vectorizer_api_url or os.getenv("VECTORIZER_API_URL", "")
        )
        resolved_vectorizer_model = vectorizer_model or os.getenv("VECTORIZER_MODEL", "")

        if not resolved_vectorizer_api_url:
            raise ValueError("vectorizer_api_url is required when vectorizer is not provided")
        if not resolved_vectorizer_model:
            raise ValueError("vectorizer_model is required when vectorizer is not provided")

        vectorizer = Vectorizer(resolved_vectorizer_api_url, resolved_vectorizer_model)
        if model_process_name is None:
            model_process_name = _infer_model_process_name(resolved_vectorizer_api_url)

    items = dataset.get("items") or []
    labeled_pairs = dataset.get("labeled_pairs") or []
    gold_pairs = build_gold_pair_set_from_labeled_dataset(labeled_pairs)
    duplicate_map = _build_duplicate_map(gold_pairs)

    identifiers = [
        identifier
        for identifier in (_build_identifier_from_item(item) for item in items)
        if identifier.get("name")
    ]

    embeddings_by_item_id: dict[int, list[float]] = {}
    latencies_ms: list[float] = []
    embedding_dimension: Optional[int] = None

    for identifier in identifiers:
        vectorizer_input = build_vectorizer_input(identifier)
        started_at = time.perf_counter()
        embedding = vectorizer.vectorize(vectorizer_input)
        elapsed_ms = (time.perf_counter() - started_at) * 1000
        latencies_ms.append(elapsed_ms)
        embeddings_by_item_id[identifier["item_id"]] = embedding
        if embedding_dimension is None:
            embedding_dimension = len(embedding)

    positive_pair_similarities: list[float] = []
    for item_one_id, item_two_id in sorted(gold_pairs):
        vector_one = embeddings_by_item_id.get(item_one_id)
        vector_two = embeddings_by_item_id.get(item_two_id)
        if vector_one is None or vector_two is None:
            continue
        positive_pair_similarities.append(_cosine_similarity(vector_one, vector_two))

    nearest_neighbor_hits = 0
    evaluable_items = 0
    ordered_item_ids = sorted(embeddings_by_item_id)
    for item_id in ordered_item_ids:
        true_duplicates = duplicate_map.get(item_id)
        if not true_duplicates:
            continue

        vector = embeddings_by_item_id[item_id]
        best_neighbor_id: Optional[int] = None
        best_similarity: Optional[float] = None

        for other_item_id in ordered_item_ids:
            if other_item_id == item_id:
                continue
            similarity = _cosine_similarity(vector, embeddings_by_item_id[other_item_id])
            if best_similarity is None or similarity > best_similarity or (
                similarity == best_similarity and best_neighbor_id is not None and other_item_id < best_neighbor_id
            ):
                best_similarity = similarity
                best_neighbor_id = other_item_id

        evaluable_items += 1
        if best_neighbor_id in true_duplicates:
            nearest_neighbor_hits += 1

    if memory_probe is None:
        memory_probe = probe_model_memory_usage
    memory_usage = memory_probe(model_process_name, model_process_pid)

    return EmbeddingBenchmarkResult(
        dataset_path=dataset_path,
        items_total=len(items),
        items_vectorized=len(identifiers),
        positive_pairs_total=len(gold_pairs),
        evaluable_items_with_known_duplicate=evaluable_items,
        embedding_calls_total=len(latencies_ms),
        embedding_dimension=embedding_dimension,
        avg_positive_pair_cosine_similarity=(
            sum(positive_pair_similarities) / len(positive_pair_similarities)
            if positive_pair_similarities
            else None
        ),
        avg_embedding_latency_ms=(sum(latencies_ms) / len(latencies_ms) if latencies_ms else None),
        nearest_neighbor_duplicate_rate=(
            nearest_neighbor_hits / evaluable_items if evaluable_items else None
        ),
        nearest_neighbor_duplicate_hits=nearest_neighbor_hits,
        memory_usage=memory_usage,
    )
