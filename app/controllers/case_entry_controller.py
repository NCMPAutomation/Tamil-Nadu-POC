from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db_session
from app.core.response import success_response
from app.repositories.case_entry_repo import CaseEntryRepository
from app.repositories.case_type_repo import CaseTypeRepository
from app.repositories.form_field_repo import FormFieldRepository
from app.schemas.case_entry import DynamicCaseCreateRequest
from app.services.case_entry_service import CaseEntryService

router = APIRouter(prefix="/cases", tags=["Cases"])


def _case_to_payload(case):
    return {
        "id": case.id,
        "case_type_id": case.case_type_id,
        "status": case.status,
        "created_by": case.created_by,
        "created_at": case.created_at,
        "values": [
            {
                "field_id": item.field_id,
                "field_name": item.field.field_name,
                "label": item.field.label,
                "value": item.value,
            }
            for item in case.field_values
        ],
    }


@router.post("", response_model=dict)
async def create_case(payload: DynamicCaseCreateRequest, db: AsyncSession = Depends(get_db_session)):
    service = CaseEntryService(CaseEntryRepository(db), CaseTypeRepository(db), FormFieldRepository(db))
    case = await service.create_case(payload)
    return success_response(data=_case_to_payload(case), message="Case created successfully")


@router.get("/{case_id}", response_model=dict)
async def get_case(case_id: int, db: AsyncSession = Depends(get_db_session)):
    service = CaseEntryService(CaseEntryRepository(db), CaseTypeRepository(db), FormFieldRepository(db))
    case = await service.get_case(case_id)
    return success_response(data=_case_to_payload(case), message="Case fetched")


@router.get("", response_model=dict)
async def list_cases(case_type_id: int | None = Query(default=None), db: AsyncSession = Depends(get_db_session)):
    service = CaseEntryService(CaseEntryRepository(db), CaseTypeRepository(db), FormFieldRepository(db))
    cases = await service.list_cases(case_type_id)
    return success_response(data=[_case_to_payload(case) for case in cases], message="Cases fetched")
