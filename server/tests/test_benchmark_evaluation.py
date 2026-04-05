import unittest

from server.src.evaluation.benchmark import adapt_service_url_for_local_run, evaluate_benchmark_dataset


class FakeVectorizer:
    def __init__(self, vectors):
        self.vectors = vectors

    def vectorize(self, text: str) -> list[float]:
        return self.vectors[text]


class FakeGroupFilter:
    def __init__(self, response):
        self.response = response
        self.calls = []

    def filter_duplicate_groups(self, groups_json: str, *, batch_size: int = 1) -> dict:
        self.calls.append({"groups_json": groups_json, "batch_size": batch_size})
        return self.response


class FakeGroupRegrouper:
    def __init__(self, response):
        self.response = response
        self.calls = []

    def regroup_duplicate_groups(self, groups_json: str, *, batch_size: int = 1) -> dict:
        self.calls.append({"groups_json": groups_json, "batch_size": batch_size})
        return self.response


class BenchmarkEvaluationTests(unittest.TestCase):
    def test_adapt_service_url_for_local_run_rewrites_docker_hostname(self):
        self.assertEqual(
            adapt_service_url_for_local_run("http://host.docker.internal:11434/api/embed"),
            "http://localhost:11434/api/embed",
        )

    def test_evaluate_benchmark_dataset_counts_candidate_stage_metrics(self):
        dataset = {
            "items": [
                {
                    "id": 1,
                    "identifier": "item-1",
                    "path": "1",
                    "name": {"ru": "Арматура №10х6000-А500С"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 2,
                    "identifier": "item-2",
                    "path": "2",
                    "name": {"ru": "Арматура №10х6000-А500С "},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 3,
                    "identifier": "item-3",
                    "path": "3",
                    "name": {"ru": "Sprite 0.5"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
            ],
            "labeled_pairs": [
                {"item_one_id": 1, "item_two_id": 2, "is_duplicate": True},
                {"item_one_id": 1, "item_two_id": 3, "is_duplicate": False},
                {"item_one_id": 2, "item_two_id": 3, "is_duplicate": False},
            ],
        }

        vectorizer = FakeVectorizer(
            {
                "name: Арматура №10х6000-А500С": [1.0, 0.0],
                "name: Арматура №10х6000-А500С ": [0.99, 0.01],
                "name: Sprite 0.5": [0.0, 1.0],
            }
        )

        result = evaluate_benchmark_dataset(
            dataset,
            vectorizer=vectorizer,
            distance_threshold=0.05,
            top_k=5,
        )

        self.assertEqual(result.dataset_path, "<in-memory>")
        self.assertEqual(result.precision, 1.0)
        self.assertEqual(result.recall, 1.0)
        self.assertEqual(result.f1, 1.0)
        self.assertEqual(result.candidate_precision, 1.0)
        self.assertEqual(result.regroup_precision, 1.0)
        self.assertEqual(result.final_precision, 1.0)
        self.assertFalse(result.llm_regroup_enabled)
        self.assertFalse(result.llm_filter_enabled)

    def test_evaluate_benchmark_dataset_counts_metrics_after_llm_filter(self):
        dataset = {
            "items": [
                {
                    "id": 1,
                    "identifier": "item-1",
                    "path": "1",
                    "name": {"ru": "Borjomi 0.5"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 2,
                    "identifier": "item-2",
                    "path": "2",
                    "name": {"ru": "Borjomi 500ml"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 3,
                    "identifier": "item-3",
                    "path": "3",
                    "name": {"ru": "Sprite 0.5"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
            ],
            "labeled_pairs": [
                {"item_one_id": 1, "item_two_id": 2, "is_duplicate": True},
                {"item_one_id": 1, "item_two_id": 3, "is_duplicate": False},
                {"item_one_id": 2, "item_two_id": 3, "is_duplicate": False},
            ],
        }

        vectorizer = FakeVectorizer(
            {
                "name: Borjomi 0.5": [1.0, 0.0],
                "name: Borjomi 500ml": [0.99, 0.01],
                "name: Sprite 0.5": [0.98, 0.02],
            }
        )
        group_filter = FakeGroupFilter(
            {
                "results": [
                    {
                        "anchor_item_id": 1,
                        "items": [
                            {"item_id": 1, "title": "Borjomi 0.5", "distance": 0.0, "is_anchor": True},
                            {"item_id": 2, "title": "Borjomi 500ml", "distance": 0.01, "is_anchor": False},
                        ],
                    }
                ]
            }
        )

        result = evaluate_benchmark_dataset(
            dataset,
            vectorizer=vectorizer,
            group_filter=group_filter,
            distance_threshold=0.05,
            top_k=5,
            use_llm_filter=True,
            llm_filter_batch_size=3,
        )

        self.assertEqual(result.candidate_precision, 1 / 3)
        self.assertEqual(result.candidate_recall, 1.0)
        self.assertEqual(result.final_precision, 1.0)
        self.assertEqual(result.final_recall, 1.0)
        self.assertEqual(result.precision, 1.0)
        self.assertEqual(result.regroup_precision, 1 / 3)
        self.assertEqual(result.regroup_recall, 1.0)
        self.assertFalse(result.llm_regroup_enabled)
        self.assertTrue(result.llm_filter_enabled)
        self.assertEqual(group_filter.calls[0]["batch_size"], 3)

    def test_evaluate_benchmark_dataset_counts_metrics_after_llm_regroup_and_filter(self):
        dataset = {
            "items": [
                {
                    "id": 1004,
                    "identifier": "item-1004",
                    "path": "1004",
                    "name": {"ru": "Спрайт 500ml"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 1005,
                    "identifier": "item-1005",
                    "path": "1005",
                    "name": {"ru": "Спрайт 0.5л"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 1006,
                    "identifier": "item-1006",
                    "path": "1006",
                    "name": {"ru": "Sprite 500 ml"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 1007,
                    "identifier": "item-1007",
                    "path": "1007",
                    "name": {"ru": "Кока-Кола 1л"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 1008,
                    "identifier": "item-1008",
                    "path": "1008",
                    "name": {"ru": "Coca Cola 1 л"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 1009,
                    "identifier": "item-1009",
                    "path": "1009",
                    "name": {"ru": "Кола 0.5л"},
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
            ],
            "labeled_pairs": [
                {"item_one_id": 1004, "item_two_id": 1005, "is_duplicate": True},
                {"item_one_id": 1004, "item_two_id": 1006, "is_duplicate": True},
                {"item_one_id": 1005, "item_two_id": 1006, "is_duplicate": True},
                {"item_one_id": 1007, "item_two_id": 1008, "is_duplicate": True},
                {"item_one_id": 1004, "item_two_id": 1007, "is_duplicate": False},
                {"item_one_id": 1004, "item_two_id": 1008, "is_duplicate": False},
                {"item_one_id": 1005, "item_two_id": 1007, "is_duplicate": False},
                {"item_one_id": 1005, "item_two_id": 1008, "is_duplicate": False},
                {"item_one_id": 1006, "item_two_id": 1007, "is_duplicate": False},
                {"item_one_id": 1006, "item_two_id": 1008, "is_duplicate": False},
                {"item_one_id": 1005, "item_two_id": 1009, "is_duplicate": False},
            ],
        }

        vectorizer = FakeVectorizer(
            {
                "name: Спрайт 500ml": [1.0, 0.0],
                "name: Спрайт 0.5л": [0.99, 0.01],
                "name: Sprite 500 ml": [0.98, 0.02],
                "name: Кока-Кола 1л": [0.97, 0.03],
                "name: Coca Cola 1 л": [0.96, 0.04],
                "name: Кола 0.5л": [0.95, 0.05],
            }
        )
        group_regrouper = FakeGroupRegrouper(
            {
                "results": [
                    {
                        "anchor_item_id": 1005,
                        "items": [
                            {"item_id": 1005, "title": "Спрайт 0.5л", "distance": 0.0, "is_anchor": True},
                            {"item_id": 1004, "title": "Спрайт 500ml", "distance": 0.1662, "is_anchor": False},
                            {"item_id": 1006, "title": "Sprite 500 ml", "distance": 0.2976, "is_anchor": False},
                        ],
                    },
                    {
                        "anchor_item_id": 1007,
                        "items": [
                            {"item_id": 1007, "title": "Кока-Кола 1л", "distance": 0.0, "is_anchor": True},
                            {"item_id": 1008, "title": "Coca Cola 1 л", "distance": 0.5969, "is_anchor": False},
                        ],
                    },
                ]
            }
        )
        group_filter = FakeGroupFilter(
            {
                "results": [
                    {
                        "anchor_item_id": 1005,
                        "items": [
                            {"item_id": 1005, "title": "Спрайт 0.5л", "distance": 0.0, "is_anchor": True},
                            {"item_id": 1004, "title": "Спрайт 500ml", "distance": 0.1662, "is_anchor": False},
                            {"item_id": 1006, "title": "Sprite 500 ml", "distance": 0.2976, "is_anchor": False},
                        ],
                    },
                    {
                        "anchor_item_id": 1007,
                        "items": [
                            {"item_id": 1007, "title": "Кока-Кола 1л", "distance": 0.0, "is_anchor": True},
                            {"item_id": 1008, "title": "Coca Cola 1 л", "distance": 0.5969, "is_anchor": False},
                        ],
                    },
                ]
            }
        )

        result = evaluate_benchmark_dataset(
            dataset,
            vectorizer=vectorizer,
            group_regrouper=group_regrouper,
            group_filter=group_filter,
            distance_threshold=0.4,
            top_k=10,
            use_llm_regroup=True,
            llm_regroup_batch_size=2,
            use_llm_filter=True,
            llm_filter_batch_size=2,
        )

        self.assertEqual(result.candidate_precision, 4 / 15)
        self.assertEqual(result.candidate_recall, 1.0)
        self.assertEqual(result.regroup_precision, 1.0)
        self.assertEqual(result.regroup_recall, 1.0)
        self.assertEqual(result.final_precision, 1.0)
        self.assertEqual(result.final_recall, 1.0)
        self.assertTrue(result.llm_regroup_enabled)
        self.assertTrue(result.llm_filter_enabled)
        self.assertEqual(group_regrouper.calls[0]["batch_size"], 2)
        self.assertEqual(group_filter.calls[0]["batch_size"], 2)


if __name__ == "__main__":
    unittest.main()
