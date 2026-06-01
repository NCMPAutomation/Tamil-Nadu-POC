from app.core.exceptions import BadRequestException, NotFoundException
from app.models.case_entry import CaseEntry
from app.models.case_field_value import CaseFieldValue
from app.repositories.case_entry_repo import CaseEntryRepository
from app.repositories.case_type_repo import CaseTypeRepository
from app.repositories.form_field_repo import FormFieldRepository
from app.schemas.case_entry import CategoryCaseCreateRequest, DynamicCaseCreateRequest


class CaseEntryService:
    def __init__(
        self,
        case_entry_repo: CaseEntryRepository,
        case_type_repo: CaseTypeRepository,
        form_field_repo: FormFieldRepository,
    ):
        self.case_entry_repo = case_entry_repo
        self.case_type_repo = case_type_repo
        self.form_field_repo = form_field_repo

    async def _build_case_entry(self, case_type, payload: CategoryCaseCreateRequest | DynamicCaseCreateRequest) -> CaseEntry:
        if not case_type or not case_type.is_active:
            raise NotFoundException("Invalid case type")

        fields = await self.form_field_repo.get_by_case_type_id(case_type.id)
        fields_by_name = {field.field_name: field for field in fields}

        unknown_keys = [key for key in payload.data.keys() if key not in fields_by_name]
        if unknown_keys:
            raise BadRequestException(f"Unknown fields: {', '.join(unknown_keys)}")

        missing_required = [
            field.field_name
            for field in fields
            if field.is_required and (field.field_name not in payload.data or payload.data[field.field_name] in [None, ""])
        ]
        if missing_required:
            raise BadRequestException(f"Missing required fields: {', '.join(missing_required)}")

        case_entry = CaseEntry(
            case_type_id=case_type.id,
            created_by=payload.created_by,
            status=payload.status,
        )

        field_values: list[CaseFieldValue] = []
        for key, raw_value in payload.data.items():
            field = fields_by_name[key]

            if field.field_type.value == "DROPDOWN" and field.options:
                if raw_value not in field.options:
                    raise BadRequestException(
                        f"Invalid value for {key}. Allowed values: {', '.join(map(str, field.options))}"
                    )

            field_values.append(
                CaseFieldValue(
                    field_id=field.id,
                    value=str(raw_value),
                )
            )

        try:
            case_entry = await self.case_entry_repo.create_case_entry(case_entry)
            for item in field_values:
                item.case_entry_id = case_entry.id
            await self.case_entry_repo.create_field_values(field_values)
            await self.case_entry_repo.db.commit()
            await self.case_entry_repo.db.refresh(case_entry)
        except Exception as exc:
            await self.case_entry_repo.db.rollback()
            raise BadRequestException(f"Failed to create case entry: {str(exc)}") from exc

        return await self.get_case(case_entry.id)

    async def create_case(self, payload: DynamicCaseCreateRequest) -> CaseEntry:
        case_type = await self.case_type_repo.get_by_id(payload.case_type_id)
        return await self._build_case_entry(case_type, payload)

    async def create_case_for_identifier(
        self,
        case_type_id: int,
        payload: CategoryCaseCreateRequest,
    ) -> CaseEntry:
        case_type = await self.case_type_repo.get_by_id(case_type_id)
        return await self._build_case_entry(case_type, payload)

    async def get_case(self, case_id: int) -> CaseEntry:
        case = await self.case_entry_repo.get_case_by_id(case_id)
        if not case:
            raise NotFoundException("Case not found")
        return case

    async def list_cases(self, case_type_id: int | None = None) -> list[CaseEntry]:
        return await self.case_entry_repo.list_cases(case_type_id)

    async def get_category_history(self, case_type_identifier: int | str, limit: int = 20) -> dict:
        case_type = await self.case_type_repo.get_by_identifier(case_type_identifier)
        if not case_type:
            raise NotFoundException("Case type not found")

        records = await self.case_entry_repo.list_cases_by_case_type_id(case_type.id, limit=limit)
        total_records = await self.case_entry_repo.count_cases_by_case_type_id(case_type.id)
        status_counts = await self.case_entry_repo.count_cases_by_status(case_type.id)

        return {
            "case_type": case_type,
            "summary": {
                "total_records": total_records,
                "draft_count": status_counts.get("DRAFT", 0),
                "submitted_count": status_counts.get("SUBMITTED", 0),
                "approved_count": status_counts.get("APPROVED", 0),
                "rejected_count": status_counts.get("REJECTED", 0),
                "latest_created_at": records[0].created_at if records else None,
            },
            "records": records,
        }
