from typing import Any

from app.core.case_utils import camelize_keys


def success_response(data: Any = None, message: str = "Success") -> dict:
    return camelize_keys({"success": True, "data": data, "message": message})


def error_response(message: str = "Error", data: Any = None) -> dict:
    return camelize_keys({"success": False, "data": data, "message": message})
