import re

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

    async def get_by_identifier(self, identifier: int | str) -> CaseType | None:
        if isinstance(identifier, int):
            return await self.get_by_id(identifier)

        identifier_text = str(identifier).strip()
        if not identifier_text:
            return None

        if identifier_text.isdigit():
            return await self.get_by_id(int(identifier_text))

        normalized_code = re.sub(r"[^A-Za-z0-9]+", "_", identifier_text).strip("_").upper()

        result = await self.db.execute(
            select(CaseType)
            .where(
                CaseType.code.ilike(normalized_code)
                | CaseType.name.ilike(identifier_text)
            )
            .options(selectinload(CaseType.form_fields))
        )
        return result.scalars().first()
