from datetime import datetime

from app.schemas.common import ORMModel


class CaseTypeOut(ORMModel):
    id: int
    name: str
    code: str
    icon: str | None = None
    color: str | None = None
    is_active: bool
    created_at: datetime
