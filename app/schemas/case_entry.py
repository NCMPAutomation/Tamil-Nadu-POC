from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field

from app.enums.case_status import CaseStatus
from app.schemas.case_type import CaseTypeOut
from app.schemas.common import ORMModel
from app.schemas.form_field import FormFieldOut


class DynamicCaseCreateRequest(BaseModel):
    case_type_id: int
    created_by: str
    status: CaseStatus = CaseStatus.SUBMITTED
    data: dict[str, Any] = Field(default_factory=dict)


class CategoryCaseCreateRequest(BaseModel):
    created_by: str
    status: CaseStatus = CaseStatus.SUBMITTED
    data: dict[str, Any] = Field(default_factory=dict)


class CaseFieldValueOut(ORMModel):
    field_id: int
    field_name: str
    label: str
    value: str


class CaseEntryOut(ORMModel):
    id: int
    case_type_id: int
    status: CaseStatus
    created_by: str
    created_at: datetime
    values: list[CaseFieldValueOut]


class FormSchemaOut(BaseModel):
    case_type: CaseTypeOut
    fields: list[FormFieldOut]


class CaseHistoryResponseOut(BaseModel):
    records: list[CaseEntryOut]
    form_endpoint: str
    submit_endpoint: str
