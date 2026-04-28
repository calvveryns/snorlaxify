import unittest

from server.src.evaluation.embedding_benchmark import (
    MemoryUsage,
    evaluate_embedding_benchmark_dataset,
)


class FakeVectorizer:
    def __init__(self, vectors):
        self.vectors = vectors
        self.calls = []

    def vectorize(self, text: str) -> list[float]:
        self.calls.append(text)
        return self.vectors[text]


class EmbeddingBenchmarkTests(unittest.TestCase):
    def test_embedding_benchmark_calculates_similarity_latency_and_nn_rate(self):
        dataset = {
            "items": [
                {
                    "id": 1,
                    "name": {"ru": "Coca Cola 1L"},
                    "path": "1",
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 2,
                    "name": {"ru": "Кока-Кола 1 л"},
                    "path": "2",
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 3,
                    "name": {"ru": "Sprite 0.5"},
                    "path": "3",
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 4,
                    "name": {"ru": "Спрайт 500 мл"},
                    "path": "4",
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
            ],
            "labeled_pairs": [
                {"item_one_id": 1, "item_two_id": 2, "is_duplicate": True},
                {"item_one_id": 3, "item_two_id": 4, "is_duplicate": True},
                {"item_one_id": 1, "item_two_id": 3, "is_duplicate": False},
                {"item_one_id": 1, "item_two_id": 4, "is_duplicate": False},
                {"item_one_id": 2, "item_two_id": 3, "is_duplicate": False},
                {"item_one_id": 2, "item_two_id": 4, "is_duplicate": False},
            ],
        }

        vectorizer = FakeVectorizer(
            {
                "name: Coca Cola 1L": [1.0, 0.0],
                "name: Кока-Кола 1 л": [0.99, 0.01],
                "name: Sprite 0.5": [0.0, 1.0],
                "name: Спрайт 500 мл": [0.01, 0.99],
            }
        )

        def fake_memory_probe(process_name, process_pid):
            self.assertEqual(process_name, "ollama")
            self.assertIsNone(process_pid)
            return MemoryUsage(
                process_name="ollama",
                pids=[1234],
                ram_bytes=512 * 1024 * 1024,
                vram_bytes=1024 * 1024 * 1024,
            )

        result = evaluate_embedding_benchmark_dataset(
            dataset,
            vectorizer=vectorizer,
            model_process_name="ollama",
            memory_probe=fake_memory_probe,
        )

        self.assertEqual(result.items_total, 4)
        self.assertEqual(result.items_vectorized, 4)
        self.assertEqual(result.positive_pairs_total, 2)
        self.assertEqual(result.embedding_calls_total, 4)
        self.assertEqual(result.embedding_dimension, 2)
        self.assertEqual(result.evaluable_items_with_known_duplicate, 4)
        self.assertEqual(result.nearest_neighbor_duplicate_hits, 4)
        self.assertAlmostEqual(result.nearest_neighbor_duplicate_rate, 1.0)
        self.assertGreaterEqual(result.avg_embedding_latency_ms, 0.0)
        self.assertAlmostEqual(result.avg_positive_pair_cosine_similarity, 0.9999489887)
        self.assertEqual(result.memory_usage.ram_bytes, 512 * 1024 * 1024)
        self.assertEqual(result.memory_usage.vram_bytes, 1024 * 1024 * 1024)

    def test_embedding_benchmark_handles_missing_duplicate_labels_for_items(self):
        dataset = {
            "items": [
                {
                    "id": 1,
                    "name": {"ru": "A"},
                    "path": "1",
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
                {
                    "id": 2,
                    "name": {"ru": "B"},
                    "path": "2",
                    "typeId": 7,
                    "typeIdentifier": "Product",
                    "updatedAt": "2026-04-01T10:00:00+00:00",
                },
            ],
            "labeled_pairs": [
                {"item_one_id": 1, "item_two_id": 2, "is_duplicate": False},
            ],
        }

        vectorizer = FakeVectorizer(
            {
                "name: A": [1.0, 0.0],
                "name: B": [0.0, 1.0],
            }
        )

        result = evaluate_embedding_benchmark_dataset(
            dataset,
            vectorizer=vectorizer,
            memory_probe=lambda *_: None,
        )

        self.assertEqual(result.positive_pairs_total, 0)
        self.assertIsNone(result.avg_positive_pair_cosine_similarity)
        self.assertEqual(result.evaluable_items_with_known_duplicate, 0)
        self.assertIsNone(result.nearest_neighbor_duplicate_rate)
        self.assertIsNone(result.memory_usage)


if __name__ == "__main__":
    unittest.main()
