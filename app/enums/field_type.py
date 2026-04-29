from enum import Enum


class FieldType(str, Enum):
    TEXT = "TEXT"
    NUMBER = "NUMBER"
    DATE = "DATE"
    PHONE = "PHONE"
    TEXTAREA = "TEXTAREA"
    DROPDOWN = "DROPDOWN"
