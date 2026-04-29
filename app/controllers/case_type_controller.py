from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db_session
from app.core.response import success_response
from app.repositories.case_type_repo import CaseTypeRepository
from app.schemas.case_type import CaseTypeOut
from app.services.case_type_service import CaseTypeService

router = APIRouter(prefix="/case-types", tags=["Case Types"])


@router.get("", response_model=dict)
async def list_case_types(db: AsyncSession = Depends(get_db_session)):
    service = CaseTypeService(CaseTypeRepository(db))
    result = await service.list_case_types()
    return success_response(data=[CaseTypeOut.model_validate(x).model_dump() for x in result], message="Case types fetched")


@router.get("/{case_type_id}/fields", response_model=dict)
async def get_case_type_fields(case_type_id: int, db: AsyncSession = Depends(get_db_session)):
    service = CaseTypeService(CaseTypeRepository(db))
    case_type = await service.get_case_type(case_type_id)
    fields = sorted(case_type.form_fields, key=lambda x: (x.order_index, x.id))
    return success_response(
        data={
            "case_type_id": case_type.id,
            "case_type_name": case_type.name,
            "fields": [
                {
                    "id": f.id,
                    "field_name": f.field_name,
                    "label": f.label,
                    "type": f.field_type,
                    "required": f.is_required,
                    "options": f.options,
                    "order_index": f.order_index,
                }
                for f in fields
            ],
        },
        message="Case type fields fetched",
    )
