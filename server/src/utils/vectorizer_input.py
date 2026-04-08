import hashlib
from typing import Optional


def normalize_identifier_name(name: Optional[str]) -> str:
    if not name:
        return ""
    return name.lower()


def build_vectorizer_input(identifier: dict) -> str:
    name = identifier.get("name")
    return f"name: {name}" if name not in (None, "") else ""


def calculate_vectorizer_input_hash(vectorizer_input: str) -> str:
    return hashlib.sha256(vectorizer_input.encode("utf-8")).hexdigest()
