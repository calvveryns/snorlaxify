import unittest
from unittest.mock import Mock, patch

from server.src.utils.vectorizer import Vectorizer


class VectorizerTests(unittest.TestCase):
    @patch("server.src.utils.vectorizer.requests.post")
    def test_uses_prompt_for_legacy_ollama_embeddings_endpoint(self, mock_post):
        response = Mock()
        response.raise_for_status.return_value = None
        response.json.return_value = {"embedding": [0.1, 0.2]}
        mock_post.return_value = response

        vectorizer = Vectorizer("http://localhost:11434/api/embeddings", "embeddinggemma:latest")

        result = vectorizer.vectorize("Минеральная вода")

        self.assertEqual(result, [0.1, 0.2])
        mock_post.assert_called_once_with(
            "http://localhost:11434/api/embeddings",
            json={"model": "embeddinggemma:latest", "prompt": "Минеральная вода"},
        )

    @patch("server.src.utils.vectorizer.requests.post")
    def test_uses_input_for_embed_endpoint(self, mock_post):
        response = Mock()
        response.raise_for_status.return_value = None
        response.json.return_value = {"embeddings": [[0.3, 0.4]]}
        mock_post.return_value = response

        vectorizer = Vectorizer("http://localhost:11434/api/embed", "embeddinggemma:latest")

        result = vectorizer.vectorize("Минеральная вода")

        self.assertEqual(result, [0.3, 0.4])
        mock_post.assert_called_once_with(
            "http://localhost:11434/api/embed",
            json={"model": "embeddinggemma:latest", "input": "Минеральная вода"},
        )

    @patch("server.src.utils.vectorizer.requests.post")
    def test_rejects_empty_embedding_response(self, mock_post):
        response = Mock()
        response.raise_for_status.return_value = None
        response.json.return_value = {"embedding": []}
        mock_post.return_value = response

        vectorizer = Vectorizer("http://localhost:11434/api/embeddings", "embeddinggemma:latest")

        with self.assertRaisesRegex(RuntimeError, "Embedding response is empty or invalid"):
            vectorizer.vectorize("Минеральная вода")


if __name__ == "__main__":
    unittest.main()
