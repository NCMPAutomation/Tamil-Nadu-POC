from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.form_field import FormField


class FormFieldRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_case_type_id(self, case_type_id: int) -> list[FormField]:
        result = await self.db.execute(
            select(FormField)
            .where(FormField.case_type_id == case_type_id)
            .order_by(FormField.order_index.asc(), FormField.id.asc())
        )
        return list(result.scalars().all())
