from app.enums.field_type import FieldType
from app.schemas.common import ORMModel


class FormFieldOut(ORMModel):
    id: int
    field_name: str
    label: str
    field_type: FieldType
    is_required: bool
    options: list | None = None
    order_index: int
