from app.core.exceptions import NotFoundException
from app.repositories.case_type_repo import CaseTypeRepository


class CaseTypeService:
    def __init__(self, repo: CaseTypeRepository):
        self.repo = repo

    async def list_case_types(self):
        return await self.repo.list_active()

    async def get_case_type(self, case_type_id: int):
        case_type = await self.repo.get_by_id(case_type_id)
        if not case_type:
            raise NotFoundException("Case type not found")
        return case_type
