import hashlib
from typing import Optional


def normalize_identifier_name(name: Optional[str]) -> str:
    if not name:
        return ""
    return name.lower()


def build_vectorizer_input(identifier: dict) -> str:
    name = identifier.get("name")
    normalized_name = normalize_identifier_name(name)
    fields = [("name", name)]
    if normalized_name and normalized_name != name:
        fields.append(("normalized_name", normalized_name))
    return "\n".join(f"{label}: {value}" for label, value in fields if value not in (None, ""))


def calculate_vectorizer_input_hash(vectorizer_input: str) -> str:
    return hashlib.sha256(vectorizer_input.encode("utf-8")).hexdigest()
