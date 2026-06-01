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

## Quick Reference

| API | When to call |
| --- | --- |
| `GET /health` | App startup or connectivity check. |
| `GET /case-types` | Load the category grid/list screen. |
| `GET /case-types/{case_type_id}/fields` | Open a category form and need the field list. |
| `GET /forms/{case_type_id}` | Open the create form screen for a category. |
| `POST /cases` | Save a new case if your screen still uses the generic create flow. |
| `GET /cases/{id}` | Open a case detail page from history or search. |
| `GET /cases?case_type_id=` | Open a flat list of cases, optionally filtered by category. |
| `GET /case-types/{case_type_id}/history` | Open the category history page. |
| `GET /case-types/{case_type_id}/history/csv` | Download the full history for that category as CSV. |
| `POST /case-types/{case_type_id}/cases` | Submit a new case directly from a category-specific form. |

---

## 1) Health Check
### GET `/health`

Use this to confirm the API is reachable before loading the app or retrying after a network error.

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
Use this to load the category grid/list shown on the mobile home screen.

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
      "name": "Murder for Gain",
      "code": "MURDER_FOR_GAIN",
      "icon": "dollarsign.circle.fill",
      "color": "orange",
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
Use this when you already know the category and need its field schema to render a form. Send the numeric `case_type_id` so the client does not need to normalize names or encode URLs.

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/case-types/1/fields'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "caseType": {
      "id": 1,
      "name": "Murder for Gain",
      "code": "MURDER_FOR_GAIN",
      "icon": "dollarsign.circle.fill",
      "color": "orange",
      "isActive": true,
      "createdAt": "2026-04-29T10:00:00"
    },
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
Use this before rendering the create form screen for a category. Send the numeric `case_type_id` so the frontend can just pass the selected category id through.

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/forms/1'
```

#### Success Response
```json
{
  "success": true,
  "data": {
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
Use this as the standard case-submit endpoint when the frontend already has the selected category id and form data.
Default status: `SUBMITTED`.

#### Request Body
```json
{
  "case_type_id": 1,
  "created_by": "inspector_101",
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
    "caseType": {
      "id": 1,
      "name": "Murder for Gain",
      "code": "MURDER_FOR_GAIN",
      "icon": "dollarsign.circle.fill",
      "color": "orange",
      "isActive": true,
      "createdAt": "2026-04-29T10:00:00"
    },
    "status": "SUBMITTED",
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
Use this to open the detailed view of a single saved case from history or search results.

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
    "caseType": {
      "id": 1,
      "name": "Murder for Gain",
      "code": "MURDER_FOR_GAIN",
      "icon": "dollarsign.circle.fill",
      "color": "orange",
      "isActive": true,
      "createdAt": "2026-04-29T10:00:00"
    },
    "status": "SUBMITTED",
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
Use this for a flat case list page, or pass `case_type_id` to filter by category.

#### cURL (all)
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/cases'
```

#### cURL (filtered)
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/cases?case_type_id=1'
```

---

## 8) Category History Page
### GET `/case-types/{case_type_id}/history`
Use this when the user taps a category and you want to show that category's history screen. Optional query param: `limit` controls how many recent records to return.

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/case-types/1/history?limit=20'
```

#### Success Response
```json
{
  "success": true,
  "data": {
    "records": [
      {
        "id": 55,
        "caseTypeId": 1,
        "status": "SUBMITTED",
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
      }
    ],
    "formEndpoint": "/forms/1",
    "submitEndpoint": "/case-types/1/cases"
  },
  "message": "Case type history fetched"
}
```

### POST `/case-types/{case_type_id}/cases`
Use this from the category-specific form submit button so the payload is created directly under the selected category.

#### Request Body
```json
{
  "created_by": "inspector_101",
  "status": "SUBMITTED",
  "data": {
    "sl_no": 1,
    "ps_cr_no_section_of_law": "Tambaram PS Cr.No 123/2026 u/s 302 IPC",
    "incident_date": "2026-04-29",
    "incident_place": "Tambaram",
    "victim_name": "Arun",
    "accused_details": "Unknown",
    "brief_facts": "Brief facts of case"
  }
}
```

#### cURL
```bash
curl --location 'https://dev.arche.global/api/v1/tndp/case-types/1/cases' \
--header 'Content-Type: application/json' \
--data '{
  "created_by": "inspector_101",
  "status": "SUBMITTED",
  "data": {
    "sl_no": 1,
    "ps_cr_no_section_of_law": "Tambaram PS Cr.No 123/2026 u/s 302 IPC",
    "incident_date": "2026-04-29",
    "incident_place": "Tambaram",
    "victim_name": "Arun",
    "accused_details": "Unknown",
    "brief_facts": "Brief facts of case"
  }
}'
```

#### Success Response
Same shape as `POST /cases`, with `caseType` included in the response.

### GET `/case-types/{case_type_id}/history/csv`
Use this when the user taps the “Download history” button on the category screen and you want a CSV file with all records for that category.

#### cURL
```bash
curl --location --output murder_history.csv 'https://dev.arche.global/api/v1/tndp/case-types/1/history/csv'
```

#### Response
- `Content-Type: text/csv`
- `Content-Disposition: attachment; filename="murder_history.csv"`
- Each row contains the case metadata plus one column per field in the selected category.

---

## Frontend Integration Flow
1. Call `GET /case-types` and show case type dropdown.
2. On category click, call `GET /case-types/{case_type_id}/history`.
3. Show the history list from `records` and keep a small "New Case" button that opens the form.
4. Add a "Download history" button that calls `GET /case-types/{case_type_id}/history/csv`.
5. On button tap, call `GET /forms/{case_type_id}`.
6. Render fields by `fieldType` and `orderIndex`.
7. For `DROPDOWN`, render options from `options`.
8. Submit to `POST /cases` with `case_type_id`, `created_by`, and `data` only.
9. Use `GET /cases/{id}` for details page and `GET /cases` for cross-category list view.

---

## Notes for Frontend Team
- `value` is stored and returned as string in API output.
- Response payload keys are `camelCase`.
- Request body and query parameter keys remain `snake_case` (for example: `case_type_id`, `created_by`).
- `case_type_id` should be the numeric id everywhere.
- For the mobile category page, prefer `GET /case-types/{case_type_id}/history` plus `POST /case-types/{case_type_id}/cases`.
- For the simplest create flow, use `POST /cases` with the selected category id and form data.
- Do not send unknown keys in `data`.
- Required validation should be done in UI, but backend also enforces it.
- `created_by` is currently a free text field in request (can be mapped to logged-in user later).
