from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db_session
from app.core.response import success_response
from app.repositories.case_type_repo import CaseTypeRepository
from app.repositories.form_field_repo import FormFieldRepository
from app.schemas.form_field import FormFieldOut
from app.services.form_service import FormService

router = APIRouter(prefix="/forms", tags=["Forms"])


@router.get("/{case_type_id}", response_model=dict)
async def get_form(case_type_id: int, db: AsyncSession = Depends(get_db_session)):
    service = FormService(CaseTypeRepository(db), FormFieldRepository(db))
    form = await service.get_form_schema(case_type_id)

    return success_response(
        data={
            "case_type": form["case_type"],
            "fields": [FormFieldOut.model_validate(field).model_dump() for field in form["fields"]],
        },
        message="Form schema fetched",
    )
