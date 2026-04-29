import re
from typing import Any


_NON_ALNUM_PATTERN = re.compile(r"[^A-Za-z0-9]+")
_CAMEL_SPLIT_PATTERN = re.compile(r"(?<!^)(?=[A-Z])")


def to_camel_case(value: str) -> str:
    """Convert snake_case / kebab-case / spaced keys to camelCase."""
    normalized = _NON_ALNUM_PATTERN.sub("_", value).strip("_")
    if not normalized:
        return value

    parts = [part for part in normalized.split("_") if part]
    if len(parts) == 1:
        # Handles PascalCase keys by splitting internal capitals.
        chunks = _CAMEL_SPLIT_PATTERN.split(parts[0])
        return chunks[0].lower() + "".join(chunk.capitalize() for chunk in chunks[1:])

    return parts[0].lower() + "".join(part.capitalize() for part in parts[1:])


def camelize_keys(data: Any) -> Any:
    """Recursively convert dictionary keys to camelCase."""
    if isinstance(data, dict):
        return {to_camel_case(str(key)): camelize_keys(value) for key, value in data.items()}
    if isinstance(data, list):
        return [camelize_keys(item) for item in data]
    if isinstance(data, tuple):
        return tuple(camelize_keys(item) for item in data)
    return data
