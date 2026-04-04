import unittest

from server.src.utils.recommender import ProductDecisions, Recommender


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


if __name__ == "__main__":
    unittest.main()
