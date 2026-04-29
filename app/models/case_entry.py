from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String
from sqlalchemy import Enum as SQLEnum
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.enums.case_status import CaseStatus


class CaseEntry(Base):
    __tablename__ = "case_entries"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    case_type_id: Mapped[int] = mapped_column(ForeignKey("case_types.id"), nullable=False, index=True)
    status: Mapped[CaseStatus] = mapped_column(SQLEnum(CaseStatus), nullable=False, default=CaseStatus.DRAFT)
    created_by: Mapped[str] = mapped_column(String(100), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)

    case_type = relationship("CaseType", back_populates="case_entries")
    field_values = relationship("CaseFieldValue", back_populates="case_entry", cascade="all, delete-orphan")
