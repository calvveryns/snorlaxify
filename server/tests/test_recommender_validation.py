import unittest

from server.src.utils.recommender import GroupDecisions, ProductDecisions, Recommender


class RecommenderValidationTests(unittest.TestCase):
    def setUp(self):
        self.recommender = Recommender("http://example.test", "fake-model")
        self.input_pairs = [
            {
                "item_one_id": 1,
                "item_two_id": 2,
                "title_one": "A",
                "title_two": "B",
                "distance": 0.01,
            },
            {
                "item_one_id": 3,
                "item_two_id": 4,
                "title_one": "C",
                "title_two": "D",
                "distance": 0.02,
            },
        ]

    def test_accepts_exact_input_pairs(self):
        output_pairs = ProductDecisions.model_validate(
            {
                "results": [
                    {
                        "item_one_id": 1,
                        "item_two_id": 2,
                        "suggested_name": "A",
                    },
                    {
                        "item_one_id": 3,
                        "item_two_id": 4,
                        "suggested_name": None,
                    },
                ]
            }
        )

        self.assertTrue(self.recommender._matches_input_pairs(self.input_pairs, output_pairs))

    def test_rejects_pairs_missing_from_input(self):
        output_pairs = ProductDecisions.model_validate(
            {
                "results": [
                    {
                        "item_one_id": 1,
                        "item_two_id": 2,
                        "suggested_name": "A",
                    },
                    {
                        "item_one_id": 2,
                        "item_two_id": 1,
                        "suggested_name": "A",
                    },
                ]
            }
        )

        self.assertFalse(self.recommender._matches_input_pairs(self.input_pairs, output_pairs))

    def test_group_decision_accepts_only_suggested_name(self):
        output_groups = GroupDecisions.model_validate(
            {
                "results": [
                    {
                        "suggested_name": "A",
                    }
                ]
            }
        )

        self.assertEqual(output_groups.results[0].suggested_name, "A")

    def test_group_decision_rejects_unexpected_ids(self):
        with self.assertRaises(Exception):
            GroupDecisions.model_validate(
                {
                    "results": [
                        {
                            "anchor_item_id": 1,
                            "duplicate_item_ids": [2, 3],
                            "suggested_name": "A",
                        }
                    ]
                }
            )

    def test_merge_batch_results_uses_response_order(self):
        batch = [
            {
                "anchor_item_id": 1,
                "items": [
                    {"item_id": 1, "title": "A", "distance": 0.0, "is_anchor": True},
                    {"item_id": 2, "title": "B", "distance": 0.01, "is_anchor": False},
                ],
            },
            {
                "anchor_item_id": 3,
                "items": [
                    {"item_id": 3, "title": "C", "distance": 0.0, "is_anchor": True},
                    {"item_id": 4, "title": "D", "distance": 0.02, "is_anchor": False},
                ],
            },
        ]
        decisions = GroupDecisions.model_validate(
            {
                "results": [
                    {"suggested_name": "Normalized A"},
                    {"suggested_name": None},
                ]
            }
        )

        merged = self.recommender._merge_batch_results(batch, decisions)

        self.assertEqual(merged[0]["suggested_name"], "Normalized A")
        self.assertEqual(merged[0]["duplicate_likelihood"], "high")
        self.assertIsNone(merged[1]["suggested_name"])
        self.assertEqual(merged[1]["duplicate_likelihood"], "low")

    def test_fallback_group_decisions_uses_anchor_title(self):
        batch = [
            {
                "anchor_item_id": 1,
                "items": [
                    {"item_id": 2, "title": "B", "distance": 0.01, "is_anchor": False},
                    {"item_id": 1, "title": "Anchor A", "distance": 0.0, "is_anchor": True},
                ],
            },
            {
                "anchor_item_id": 3,
                "items": [],
            },
        ]

        decisions = self.recommender._fallback_group_decisions(batch)

        self.assertEqual(decisions.results[0].suggested_name, "Anchor A")
        self.assertIsNone(decisions.results[1].suggested_name)


if __name__ == "__main__":
    unittest.main()
