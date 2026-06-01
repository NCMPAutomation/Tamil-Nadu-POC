from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db_session
from app.core.response import success_response
from app.repositories.case_entry_repo import CaseEntryRepository
from app.repositories.case_type_repo import CaseTypeRepository
from app.repositories.form_field_repo import FormFieldRepository
from app.schemas.case_entry import CategoryCaseCreateRequest, CaseHistoryResponseOut
from app.schemas.case_type import CaseTypeOut
from app.schemas.form_field import FormFieldOut
from app.services.case_entry_service import CaseEntryService
from app.services.case_type_service import CaseTypeService
from app.services.form_service import FormService

router = APIRouter(prefix="/case-types", tags=["Case Types"])


def _case_to_payload(case):
    return {
        "id": case.id,
        "case_type_id": case.case_type_id,
        "case_type": {
            "id": case.case_type.id,
            "name": case.case_type.name,
            "code": case.case_type.code,
            "icon": case.case_type.icon,
            "color": case.case_type.color,
            "is_active": case.case_type.is_active,
            "created_at": case.case_type.created_at,
        }
        if case.case_type
        else None,
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


@router.get("", response_model=dict)
async def list_case_types(db: AsyncSession = Depends(get_db_session)):
    service = CaseTypeService(CaseTypeRepository(db))
    result = await service.list_case_types()
    return success_response(data=[CaseTypeOut.model_validate(x).model_dump() for x in result], message="Case types fetched")


@router.get("/{case_type_id}/fields", response_model=dict)
async def get_case_type_fields(case_type_id: int, db: AsyncSession = Depends(get_db_session)):
    service = FormService(CaseTypeRepository(db), FormFieldRepository(db))
    form = await service.get_form_schema(case_type_id)
    return success_response(
        data={
            "case_type": form["case_type"],
            "fields": [FormFieldOut.model_validate(field).model_dump() for field in form["fields"]],
        },
        message="Case type fields fetched",
    )


@router.get("/{case_type_id}/history", response_model=dict)
async def get_case_type_history(
    case_type_id: int,
    limit: int = Query(default=20, ge=1, le=100),
    db: AsyncSession = Depends(get_db_session),
):
    service = CaseEntryService(CaseEntryRepository(db), CaseTypeRepository(db), FormFieldRepository(db))
    history = await service.get_category_history(case_type_id, limit=limit)
    response = CaseHistoryResponseOut(
        records=[_case_to_payload(case) for case in history["records"]],
        form_endpoint=f"/forms/{case_type_id}",
        submit_endpoint=f"/case-types/{case_type_id}/cases",
    )
    return success_response(data=response.model_dump(), message="Case type history fetched")


@router.post("/{case_type_id}/cases", response_model=dict)
async def create_case_for_case_type(
    case_type_id: int,
    payload: CategoryCaseCreateRequest,
    db: AsyncSession = Depends(get_db_session),
):
    service = CaseEntryService(CaseEntryRepository(db), CaseTypeRepository(db), FormFieldRepository(db))
    case = await service.create_case_for_identifier(case_type_id, payload)
    return success_response(data=_case_to_payload(case), message="Case created successfully")
