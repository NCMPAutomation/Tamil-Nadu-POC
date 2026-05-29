from app.core.exceptions import NotFoundException
from app.data.report_category_templates import CATEGORY_FORM_TEMPLATES
from app.repositories.case_type_repo import CaseTypeRepository
from app.repositories.form_field_repo import FormFieldRepository
from app.schemas.case_type import CaseTypeOut


class FormService:
    def __init__(self, case_type_repo: CaseTypeRepository, field_repo: FormFieldRepository):
        self.case_type_repo = case_type_repo
        self.field_repo = field_repo

    async def get_form_schema(self, case_type_id: int) -> dict:
        case_type = await self.case_type_repo.get_by_id(case_type_id)
        if not case_type:
            raise NotFoundException("Case type not found")

        fields = await self.field_repo.get_by_case_type_id(case_type.id)
        if not fields:
            fields = CATEGORY_FORM_TEMPLATES.get(case_type.code, [])

        return {
            "case_type": CaseTypeOut.model_validate(case_type).model_dump(),
            "fields": fields,
        }
