import unittest

from server.src.evaluation.benchmark import adapt_service_url_for_local_run, evaluate_benchmark_dataset


class FakeVectorizer:
    def __init__(self, vectors):
        self.vectors = vectors

    def vectorize(self, text: str) -> list[float]:
        return self.vectors[text]


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


if __name__ == "__main__":
    unittest.main()
