# TNDP Case Management API Docs (Frontend)

## Base URL
`https://dev.arche.global/api/v1/tndp`

## Response Envelope
All APIs return this format. Response keys are in `camelCase`:

```json
{
  "success": true,
  "data": {},
  "message": "Success"
}
```

Error format:

```json
{
  "success": false,
  "data": null,
  "message": "Error message"
}
```

## Enums

### Case Status
- `DRAFT`
- `SUBMITTED`
- `APPROVED`
- `REJECTED`

### Field Type
- `TEXT`
- `NUMBER`
- `DATE`
- `PHONE`
- `TEXTAREA`
- `DROPDOWN`

---

## 1) Health Check
### GET `/health`

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/health'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "status": "ok"
  },
  "message": "Healthy"
}
```

---

## 2) Get Case Types
### GET `/case-types`
Returns active case types configured from DB.

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/case-types'
```

#### Success Response
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "GCR - MURDER FOR GAIN",
      "code": "GCR_MURDER_FOR_GAIN",
      "isActive": true,
      "createdAt": "2026-04-29T10:00:00"
    }
  ],
  "message": "Case types fetched"
}
```

---

## 3) Get Fields By Case Type
### GET `/case-types/{case_type_id}/fields`
Returns schema for one case type.

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/case-types/1/fields'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "caseTypeId": 1,
    "caseTypeName": "GCR - MURDER FOR GAIN",
    "fields": [
      {
        "id": 101,
        "fieldName": "ps_cr_no_section_of_law",
        "label": "P.S, Cr. No. & Section Of Law",
        "type": "TEXT",
        "required": true,
        "options": null,
        "orderIndex": 2
      }
    ]
  },
  "message": "Case type fields fetched"
}
```

---

## 4) Get Dynamic Form Schema
### GET `/forms/{case_type_id}`
Frontend should call this before rendering create form.

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/forms/1'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "caseType": {
      "id": 1,
      "name": "GCR - MURDER FOR GAIN",
      "code": "GCR_MURDER_FOR_GAIN"
    },
    "fields": [
      {
        "id": 100,
        "fieldName": "sl_no",
        "label": "Sl. No",
        "fieldType": "NUMBER",
        "isRequired": true,
        "options": null,
        "orderIndex": 1
      },
      {
        "id": 101,
        "fieldName": "ps_cr_no_section_of_law",
        "label": "P.S, Cr. No. & Section Of Law",
        "fieldType": "TEXT",
        "isRequired": true,
        "options": null,
        "orderIndex": 2
      }
    ]
  },
  "message": "Form schema fetched"
}
```

---

## 5) Create Case Entry
### POST `/cases`
Creates one case record with dynamic field values.

#### Request Body
```json
{
  "case_type_id": 1,
  "created_by": "inspector_101",
  "status": "DRAFT",
  "data": {
    "sl_no": 1,
    "ps_cr_no_section_of_law": "Tambaram PS Cr.No 123/2026 u/s 302 IPC",
    "do_dr_soc_cctv_details": "D/O: 29-04-2026, CCTV footage available",
    "complainant_name_phone": "Ravi Kumar - 9876543210",
    "deceased_name": "Arun",
    "accused_details": "Unknown",
    "pl": "PL details",
    "pr": "PR details",
    "gist_of_case": "Brief facts of case"
  }
}
```

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/cases' \
--header 'Content-Type: application/json' \
--data '{
  "case_type_id": 1,
  "created_by": "inspector_101",
  "status": "DRAFT",
  "data": {
    "sl_no": 1,
    "ps_cr_no_section_of_law": "Tambaram PS Cr.No 123/2026 u/s 302 IPC",
    "do_dr_soc_cctv_details": "D/O: 29-04-2026, CCTV footage available",
    "complainant_name_phone": "Ravi Kumar - 9876543210",
    "deceased_name": "Arun",
    "accused_details": "Unknown",
    "pl": "PL details",
    "pr": "PR details",
    "gist_of_case": "Brief facts of case"
  }
}'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "id": 55,
    "caseTypeId": 1,
    "status": "DRAFT",
    "createdBy": "inspector_101",
    "createdAt": "2026-04-29T12:15:00",
    "values": [
      {
        "fieldId": 100,
        "fieldName": "sl_no",
        "label": "Sl. No",
        "value": "1"
      }
    ]
  },
  "message": "Case created successfully"
}
```

#### Validation Errors (examples)
- Unknown field key:
```json
{
  "success": false,
  "data": null,
  "message": "Unknown fields: invalid_field"
}
```

- Missing required fields:
```json
{
  "success": false,
  "data": null,
  "message": "Missing required fields: sl_no, ps_cr_no_section_of_law"
}
```

---

## 6) Get Case By ID
### GET `/cases/{id}`

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/cases/55'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "id": 55,
    "caseTypeId": 1,
    "status": "DRAFT",
    "createdBy": "inspector_101",
    "createdAt": "2026-04-29T12:15:00",
    "values": [
      {
        "fieldId": 100,
        "fieldName": "sl_no",
        "label": "Sl. No",
        "value": "1"
      }
    ]
  },
  "message": "Case fetched"
}
```

---

## 7) List Cases
### GET `/cases`
Optional query param: `case_type_id`

#### cURL (all)
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/cases'
```

#### cURL (filtered)
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/cases?case_type_id=1'
```

---

## Frontend Integration Flow
1. Call `GET /case-types` and show case type dropdown.
2. On case type select, call `GET /forms/{case_type_id}`.
3. Render fields by `fieldType` and `orderIndex`.
4. For `DROPDOWN`, render options from `options`.
5. Submit to `POST /cases` with `data` object keys exactly equal to `field_name` (from response `fieldName`).
6. Use `GET /cases/{id}` for details page and `GET /cases` for list page.

---

## Notes for Frontend Team
- `value` is stored and returned as string in API output.
- Response payload keys are `camelCase`.
- Request body and query parameter keys remain `snake_case` (for example: `case_type_id`, `created_by`).
- Do not send unknown keys in `data`.
- Required validation should be done in UI, but backend also enforces it.
- `created_by` is currently a free text field in request (can be mapped to logged-in user later).
