from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.case_entry import CaseEntry
from app.models.case_field_value import CaseFieldValue


class CaseEntryRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def create_case_entry(self, case_entry: CaseEntry) -> CaseEntry:
        self.db.add(case_entry)
        await self.db.flush()
        return case_entry

    async def create_field_values(self, values: list[CaseFieldValue]) -> None:
        self.db.add_all(values)

    async def get_case_by_id(self, case_id: int) -> CaseEntry | None:
        result = await self.db.execute(
            select(CaseEntry)
            .where(CaseEntry.id == case_id)
            .options(
                selectinload(CaseEntry.case_type),
                selectinload(CaseEntry.field_values).selectinload(CaseFieldValue.field),
            )
        )
        return result.scalars().first()

    async def list_cases(self, case_type_id: int | None = None) -> list[CaseEntry]:
        query = select(CaseEntry).options(
            selectinload(CaseEntry.case_type),
            selectinload(CaseEntry.field_values).selectinload(CaseFieldValue.field),
        )
        if case_type_id is not None:
            query = query.where(CaseEntry.case_type_id == case_type_id)
        result = await self.db.execute(query.order_by(CaseEntry.created_at.desc()))
        return list(result.scalars().all())

    async def list_cases_by_case_type_id(self, case_type_id: int, limit: int | None = None) -> list[CaseEntry]:
        query = (
            select(CaseEntry)
            .where(CaseEntry.case_type_id == case_type_id)
            .options(
                selectinload(CaseEntry.case_type),
                selectinload(CaseEntry.field_values).selectinload(CaseFieldValue.field),
            )
            .order_by(CaseEntry.created_at.desc())
        )
        if limit is not None:
            query = query.limit(limit)
        result = await self.db.execute(query)
        return list(result.scalars().all())

    async def count_cases_by_case_type_id(self, case_type_id: int) -> int:
        result = await self.db.execute(select(func.count(CaseEntry.id)).where(CaseEntry.case_type_id == case_type_id))
        return int(result.scalar_one())

    async def count_cases_by_status(self, case_type_id: int) -> dict[str, int]:
        result = await self.db.execute(
            select(CaseEntry.status, func.count(CaseEntry.id))
            .where(CaseEntry.case_type_id == case_type_id)
            .group_by(CaseEntry.status)
        )
        return {status.value: int(count) for status, count in result.all()}
