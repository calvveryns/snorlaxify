import unittest
from datetime import datetime, timezone

from server.src.processes.pipeline import (
    build_vectorizer_input,
    calculate_vectorizer_input_hash,
    should_vectorize_identifier,
)


class VectorizationCacheTests(unittest.TestCase):
    def make_identifier(self, **overrides):
        base = {
            "item_id": 1,
            "name": "Borjomi 0.5",
            "path": None,
            "type_id": None,
            "type_identifier": None,
            "updated_at": datetime(2026, 4, 1, tzinfo=timezone.utc),
            "stored_vector_input_hash": None,
            "vector_model": None,
            "vector_source_updated_at": None,
        }
        base.update(overrides)
        return base

    def test_requires_vectorization_when_cache_missing(self):
        identifier = self.make_identifier()

        self.assertTrue(should_vectorize_identifier(identifier, "test-model"))

    def test_skips_vectorization_when_hash_and_model_match(self):
        identifier = self.make_identifier()
        cached_hash = calculate_vectorizer_input_hash(build_vectorizer_input(identifier))
        identifier.update(
            {
                "stored_vector_input_hash": cached_hash,
                "vector_model": "test-model",
                "vector_source_updated_at": identifier["updated_at"],
            }
        )

        self.assertFalse(should_vectorize_identifier(identifier, "test-model"))

    def test_requires_vectorization_when_source_is_newer_than_cached_vector(self):
        identifier = self.make_identifier(
            vector_source_updated_at=datetime(2026, 3, 31, tzinfo=timezone.utc)
        )
        cached_hash = calculate_vectorizer_input_hash(build_vectorizer_input(identifier))
        identifier.update(
            {
                "stored_vector_input_hash": cached_hash,
                "vector_model": "test-model",
            }
        )

        self.assertTrue(should_vectorize_identifier(identifier, "test-model"))

    def test_requires_vectorization_when_vector_input_changes(self):
        identifier = self.make_identifier(
            stored_vector_input_hash=calculate_vectorizer_input_hash("name: stale"),
            vector_model="test-model",
            vector_source_updated_at=datetime(2026, 4, 1, tzinfo=timezone.utc),
        )

        self.assertTrue(should_vectorize_identifier(identifier, "test-model"))


if __name__ == "__main__":
    unittest.main()
