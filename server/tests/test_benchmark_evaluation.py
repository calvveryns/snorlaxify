import unittest

from server.src.evaluation.benchmark import adapt_service_url_for_local_run, evaluate_benchmark_dataset


class FakeVectorizer:
    def __init__(self, vectors):
        self.vectors = vectors

    def vectorize(self, text: str) -> list[float]:
        return self.vectors[text]


class FakeRecommender:
    def recommend_duplicates(self, groups_json: str) -> dict:
        import json

        groups = json.loads(groups_json)
        results = []
        for group in groups:
            titles = [item["title"] for item in group["items"]]
            is_duplicate = any("Арматура №10х6000-А500С" in title for title in titles) and any(
                "Арматура №10х6000-А500С " in title for title in titles
            )
            results.append(
                {
                    **group,
                    "duplicate_likelihood": "high" if is_duplicate else "low",
                    "suggested_name": "Арматура №10х6000-А500С" if is_duplicate else None,
                }
            )
        return {"results": results}


class BenchmarkEvaluationTests(unittest.TestCase):
    def test_adapt_service_url_for_local_run_rewrites_docker_hostname(self):
        self.assertEqual(
            adapt_service_url_for_local_run("http://host.docker.internal:11434/api/embed"),
            "http://localhost:11434/api/embed",
        )

    def test_evaluate_benchmark_dataset_runs_pipeline_and_counts_metrics(self):
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
                "name: Арматура №10х6000-А500С\nnormalized_name: арматура №10х6000-а500с": [1.0, 0.0],
                "name: Арматура №10х6000-А500С \nnormalized_name: арматура №10х6000-а500с ": [0.99, 0.01],
                "name: Sprite 0.5\nnormalized_name: sprite 0.5": [0.0, 1.0],
            }
        )
        recommender = FakeRecommender()

        result = evaluate_benchmark_dataset(
            dataset,
            vectorizer=vectorizer,
            recommender=recommender,
            distance_threshold=0.05,
            top_k=5,
        )

        self.assertEqual(result.items_total, 3)
        self.assertEqual(result.labeled_pairs_total, 3)
        self.assertEqual(result.candidate_groups_total, 1)
        self.assertEqual(result.predicted_duplicate_groups_total, 1)
        self.assertEqual(result.metrics["pair_precision"], 1.0)
        self.assertEqual(result.metrics["pair_recall"], 1.0)
        self.assertEqual(result.metrics["pair_f1"], 1.0)
        self.assertEqual(result.metrics["false_merge_rate"], 0.0)
        self.assertEqual(result.metrics["coverage"], 1.0)


if __name__ == "__main__":
    unittest.main()
