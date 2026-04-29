from sqlalchemy import ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class CaseFieldValue(Base):
    __tablename__ = "case_field_values"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    case_entry_id: Mapped[int] = mapped_column(ForeignKey("case_entries.id", ondelete="CASCADE"), nullable=False, index=True)
    field_id: Mapped[int] = mapped_column(ForeignKey("form_fields.id"), nullable=False, index=True)
    value: Mapped[str] = mapped_column(Text, nullable=False)

    case_entry = relationship("CaseEntry", back_populates="field_values")
    field = relationship("FormField", back_populates="values")
