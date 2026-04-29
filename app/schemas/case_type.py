from datetime import datetime

from app.schemas.common import ORMModel


class CaseTypeOut(ORMModel):
    id: int
    name: str
    code: str
    is_active: bool
    created_at: datetime
