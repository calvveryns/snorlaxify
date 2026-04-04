import unittest

from server.src.utils.dedup_metrics import (
    build_pair_set_from_groups,
    build_gold_pair_set_from_labeled_dataset,
    build_pair_set_from_pairs,
    calculate_pair_metrics_on_labeled_dataset,
    calculate_deduplication_quality_metrics,
    LabeledPair,
    normalize_pair,
)


class DeduplicationMetricsTests(unittest.TestCase):
    def test_normalize_pair_orders_item_ids(self):
        self.assertEqual(normalize_pair(20, 10), (10, 20))

    def test_normalize_pair_rejects_same_item(self):
        with self.assertRaises(ValueError):
            normalize_pair(10, 10)

    def test_build_pair_set_from_pairs_deduplicates_reversed_pairs(self):
        pair_set = build_pair_set_from_pairs(
            [
                {"item_one_id": 1, "item_two_id": 2},
                {"item_one_id": 2, "item_two_id": 1},
                {"item_one_id": 3, "item_two_id": 4},
            ]
        )

        self.assertEqual(pair_set, {(1, 2), (3, 4)})

    def test_build_pair_set_from_groups_builds_clique_pairs(self):
        pair_set = build_pair_set_from_groups(
            [
                {
                    "anchor_item_id": 1,
                    "items": [
                        {"item_id": 1},
                        {"item_id": 2},
                        {"item_id": 3},
                    ],
                }
            ]
        )

        self.assertEqual(pair_set, {(1, 2), (1, 3), (2, 3)})

    def test_build_gold_pair_set_from_labeled_dataset_keeps_only_duplicates(self):
        gold_pairs = build_gold_pair_set_from_labeled_dataset(
            [
                {"item_one_id": 1, "item_two_id": 2, "is_duplicate": True},
                {"item_one_id": 2, "item_two_id": 3, "is_duplicate": False},
                LabeledPair(item_one_id=4, item_two_id=5, is_duplicate=True),
            ]
        )

        self.assertEqual(gold_pairs, {(1, 2), (4, 5)})

    def test_calculate_deduplication_quality_metrics_returns_candidate_and_final_scores(self):
        gold_pairs = {(1, 2), (1, 3), (4, 5)}
        candidate_pairs = {(1, 2), (1, 3), (1, 4), (4, 5)}
        predicted_pairs = {(1, 2), (1, 4)}

        report = calculate_deduplication_quality_metrics(
            candidate_pairs=candidate_pairs,
            predicted_duplicate_pairs=predicted_pairs,
            gold_duplicate_pairs=gold_pairs,
        )

        self.assertEqual(report.candidate_stage.true_positives, 3)
        self.assertEqual(report.candidate_stage.false_positives, 1)
        self.assertEqual(report.candidate_stage.false_negatives, 0)
        self.assertAlmostEqual(report.candidate_stage.precision, 0.75)
        self.assertAlmostEqual(report.candidate_stage.recall, 1.0)
        self.assertAlmostEqual(report.candidate_stage.f1, 0.8571428571)

        self.assertEqual(report.final_stage.true_positives, 1)
        self.assertEqual(report.final_stage.false_positives, 1)
        self.assertEqual(report.final_stage.false_negatives, 2)
        self.assertAlmostEqual(report.final_stage.precision, 0.5)
        self.assertAlmostEqual(report.final_stage.recall, 1 / 3)
        self.assertAlmostEqual(report.false_merge_rate, 0.5)
        self.assertAlmostEqual(report.coverage, 1 / 3)

    def test_calculate_deduplication_quality_metrics_handles_empty_predictions(self):
        report = calculate_deduplication_quality_metrics(
            candidate_pairs=set(),
            predicted_duplicate_pairs=set(),
            gold_duplicate_pairs={(1, 2)},
        )

        self.assertEqual(report.final_stage.true_positives, 0)
        self.assertEqual(report.final_stage.false_positives, 0)
        self.assertEqual(report.final_stage.false_negatives, 1)
        self.assertEqual(report.final_stage.precision, 0.0)
        self.assertEqual(report.false_merge_rate, 0.0)
        self.assertEqual(report.coverage, 0.0)

    def test_calculate_pair_metrics_on_labeled_dataset_returns_pair_quality_fields(self):
        report = calculate_pair_metrics_on_labeled_dataset(
            predicted_duplicate_pairs={(1, 2), (3, 4)},
            labeled_pairs=[
                {"item_one_id": 1, "item_two_id": 2, "is_duplicate": True},
                {"item_one_id": 3, "item_two_id": 4, "is_duplicate": False},
                {"item_one_id": 5, "item_two_id": 6, "is_duplicate": True},
            ],
        )

        self.assertAlmostEqual(report.pair_precision, 0.5)
        self.assertAlmostEqual(report.pair_recall, 0.5)
        self.assertAlmostEqual(report.pair_f1, 0.5)
        self.assertEqual(report.true_positives, 1)
        self.assertEqual(report.false_positives, 1)
        self.assertEqual(report.false_negatives, 1)
        self.assertEqual(report.labeled_pairs_total, 3)
        self.assertEqual(report.positive_pairs_total, 2)


if __name__ == "__main__":
    unittest.main()
