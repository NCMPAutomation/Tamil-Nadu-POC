from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.case_type import CaseType


class CaseTypeRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def list_active(self) -> list[CaseType]:
        result = await self.db.execute(select(CaseType).where(CaseType.is_active.is_(True)))
        return list(result.scalars().all())

    async def get_by_id(self, case_type_id: int) -> CaseType | None:
        result = await self.db.execute(
            select(CaseType)
            .where(CaseType.id == case_type_id)
            .options(selectinload(CaseType.form_fields))
        )
        return result.scalars().first()
