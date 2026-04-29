from app.repositories.case_type_repo import CaseTypeRepository
from app.repositories.form_field_repo import FormFieldRepository
from app.services.case_type_service import CaseTypeService


class FormService:
    def __init__(self, case_type_repo: CaseTypeRepository, field_repo: FormFieldRepository):
        self.case_type_service = CaseTypeService(case_type_repo)
        self.field_repo = field_repo

    async def get_form_schema(self, case_type_id: int) -> dict:
        case_type = await self.case_type_service.get_case_type(case_type_id)
        fields = await self.field_repo.get_by_case_type_id(case_type_id)

        return {
            "case_type": {
                "id": case_type.id,
                "name": case_type.name,
                "code": case_type.code,
            },
            "fields": fields,
        }
