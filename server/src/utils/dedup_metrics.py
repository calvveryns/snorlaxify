from __future__ import annotations

from dataclasses import asdict, dataclass
from itertools import combinations
from typing import Iterable


PairKey = tuple[int, int]


@dataclass(frozen=True)
class LabeledPair:
    item_one_id: int
    item_two_id: int
    is_duplicate: bool

    def normalized_key(self) -> PairKey:
        return normalize_pair(self.item_one_id, self.item_two_id)


def _safe_divide(numerator: int, denominator: int) -> float:
    if denominator == 0:
        return 0.0
    return numerator / denominator


def normalize_pair(item_one_id: int, item_two_id: int) -> PairKey:
    if item_one_id == item_two_id:
        raise ValueError("Pair items must be different")

    return tuple(sorted((item_one_id, item_two_id)))


def build_pair_set_from_pairs(pairs: Iterable[dict]) -> set[PairKey]:
    normalized_pairs: set[PairKey] = set()

    for pair in pairs:
        if "item_one_id" not in pair or "item_two_id" not in pair:
            raise KeyError("Pair payload must contain item_one_id and item_two_id")

        normalized_pairs.add(normalize_pair(pair["item_one_id"], pair["item_two_id"]))

    return normalized_pairs


def build_pair_set_from_groups(groups: Iterable[dict]) -> set[PairKey]:
    normalized_pairs: set[PairKey] = set()

    for group in groups:
        items = group.get("items") or []
        item_ids = [item["item_id"] for item in items if item.get("item_id") is not None]

        for item_one_id, item_two_id in combinations(item_ids, 2):
            normalized_pairs.add(normalize_pair(item_one_id, item_two_id))

    return normalized_pairs


def build_gold_pair_set_from_labeled_dataset(labeled_pairs: Iterable[dict | LabeledPair]) -> set[PairKey]:
    gold_pairs: set[PairKey] = set()

    for labeled_pair in labeled_pairs:
        if isinstance(labeled_pair, LabeledPair):
            normalized_pair = labeled_pair
        else:
            if not {"item_one_id", "item_two_id", "is_duplicate"} <= set(labeled_pair):
                raise KeyError("Labeled pair payload must contain item_one_id, item_two_id and is_duplicate")
            normalized_pair = LabeledPair(
                item_one_id=labeled_pair["item_one_id"],
                item_two_id=labeled_pair["item_two_id"],
                is_duplicate=bool(labeled_pair["is_duplicate"]),
            )

        if normalized_pair.is_duplicate:
            gold_pairs.add(normalized_pair.normalized_key())

    return gold_pairs


@dataclass(frozen=True)
class PairQualityMetrics:
    true_positives: int
    false_positives: int
    false_negatives: int
    precision: float
    recall: float
    f1: float

    @classmethod
    def from_sets(cls, predicted_pairs: set[PairKey], gold_pairs: set[PairKey]) -> "PairQualityMetrics":
        true_positives = len(predicted_pairs & gold_pairs)
        false_positives = len(predicted_pairs - gold_pairs)
        false_negatives = len(gold_pairs - predicted_pairs)

        precision = _safe_divide(true_positives, true_positives + false_positives)
        recall = _safe_divide(true_positives, true_positives + false_negatives)
        f1 = _safe_divide(2 * precision * recall, precision + recall) if precision or recall else 0.0

        return cls(
            true_positives=true_positives,
            false_positives=false_positives,
            false_negatives=false_negatives,
            precision=precision,
            recall=recall,
            f1=f1,
        )

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass(frozen=True)
class DeduplicationQualityReport:
    candidate_stage: PairQualityMetrics
    final_stage: PairQualityMetrics
    false_merge_rate: float
    coverage: float

    def to_dict(self) -> dict:
        return {
            "candidate_stage": self.candidate_stage.to_dict(),
            "final_stage": self.final_stage.to_dict(),
            "false_merge_rate": self.false_merge_rate,
            "coverage": self.coverage,
        }


@dataclass(frozen=True)
class PairDatasetQualityReport:
    pair_precision: float
    pair_recall: float
    pair_f1: float
    true_positives: int
    false_positives: int
    false_negatives: int
    labeled_pairs_total: int
    positive_pairs_total: int

    def to_dict(self) -> dict:
        return asdict(self)


def calculate_deduplication_quality_metrics(
    candidate_pairs: set[PairKey],
    predicted_duplicate_pairs: set[PairKey],
    gold_duplicate_pairs: set[PairKey],
) -> DeduplicationQualityReport:
    candidate_stage = PairQualityMetrics.from_sets(candidate_pairs, gold_duplicate_pairs)
    final_stage = PairQualityMetrics.from_sets(predicted_duplicate_pairs, gold_duplicate_pairs)

    predicted_merges = len(predicted_duplicate_pairs)
    false_merge_rate = _safe_divide(final_stage.false_positives, predicted_merges)
    coverage = _safe_divide(final_stage.true_positives, len(gold_duplicate_pairs))

    return DeduplicationQualityReport(
        candidate_stage=candidate_stage,
        final_stage=final_stage,
        false_merge_rate=false_merge_rate,
        coverage=coverage,
    )


def calculate_pair_metrics_on_labeled_dataset(
    predicted_duplicate_pairs: set[PairKey],
    labeled_pairs: Iterable[dict | LabeledPair],
) -> PairDatasetQualityReport:
    labeled_pairs = list(labeled_pairs)
    gold_duplicate_pairs = build_gold_pair_set_from_labeled_dataset(labeled_pairs)
    quality_metrics = PairQualityMetrics.from_sets(predicted_duplicate_pairs, gold_duplicate_pairs)

    return PairDatasetQualityReport(
        pair_precision=quality_metrics.precision,
        pair_recall=quality_metrics.recall,
        pair_f1=quality_metrics.f1,
        true_positives=quality_metrics.true_positives,
        false_positives=quality_metrics.false_positives,
        false_negatives=quality_metrics.false_negatives,
        labeled_pairs_total=len(labeled_pairs),
        positive_pairs_total=len(gold_duplicate_pairs),
    )
