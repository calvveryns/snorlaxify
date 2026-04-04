import unittest
from unittest.mock import Mock, patch

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

    def test_gemini_request_uses_generate_content_shape(self):
        recommender = Recommender(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
            "gemini-2.5-flash",
            provider="gemini",
            api_key="secret-key",
        )

        payload = recommender._build_payload("hello")
        request_url = recommender._build_request_url()

        self.assertEqual(payload["contents"][0]["parts"][0]["text"], "hello")
        self.assertEqual(payload["generationConfig"]["responseMimeType"], "application/json")
        self.assertNotIn("model", payload)
        self.assertIn("key=secret-key", request_url)

    def test_extract_content_supports_gemini_candidates(self):
        recommender = Recommender("http://example.test", "gemini-2.5-flash", provider="gemini")

        content = recommender._extract_content(
            {
                "candidates": [
                    {
                        "content": {
                            "parts": [
                                {"text": "{\"results\":["},
                                {"text": "{\"suggested_name\":null}"},
                                {"text": "]}"},
                            ]
                        }
                    }
                ]
            }
        )

        self.assertEqual(content, "{\"results\":[{\"suggested_name\":null}]}")

    @patch("server.src.utils.recommender.requests.post")
    def test_request_batch_parses_gemini_json_response(self, mock_post: Mock):
        recommender = Recommender("http://example.test", "gemini-2.5-flash", provider="gemini")
        mock_response = Mock()
        mock_response.status_code = 200
        mock_response.text = "{\"ok\":true}"
        mock_response.json.return_value = {
            "candidates": [
                {
                    "content": {
                        "parts": [
                            {"text": "{\"results\":[{\"suggested_name\":\"Normalized A\"}]}"}
                        ]
                    }
                }
            ]
        }
        mock_post.return_value = mock_response

        batch = [
            {
                "anchor_item_id": 1,
                "items": [
                    {"item_id": 1, "title": "A", "distance": 0.0, "is_anchor": True},
                    {"item_id": 2, "title": "B", "distance": 0.01, "is_anchor": False},
                ],
            }
        ]

        decisions = recommender._request_batch(1, batch)

        self.assertEqual(decisions.results[0].suggested_name, "Normalized A")


if __name__ == "__main__":
    unittest.main()
