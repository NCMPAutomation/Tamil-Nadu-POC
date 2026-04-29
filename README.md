# Dynamic Police Case Management System Backend

## Run

```bash
python -m venv .venv
. .venv/Scripts/activate
pip install -r requirements.txt
copy .env.example .env
uvicorn app.main:app --reload
```

## Create Database + DDL (MySQL)

```bash
mysql -u root -p < sql/init_schema.sql
```

If your MySQL user/host is different:

```bash
mysql -h 127.0.0.1 -P 3306 -u <user> -p < sql/init_schema.sql
```

## Seed Case Types + Dynamic Fields

```bash
mysql -u Arche_emp_db -h 20.40.46.223 -p < sql/seed_case_types.sql
```

## Seed GCR Case Types

```bash
mysql -u Arche_emp_db -h 20.40.46.223 -p < sql/seed_gcr_case_types.sql
```

## Migrations (Alternative to raw DDL)

```bash
alembic upgrade head
```

## API

- `GET /case-types`
- `GET /case-types/{id}/fields`
- `GET /forms/{case_type_id}`
- `POST /cases`
- `GET /cases/{id}`
- `GET /cases?case_type_id=`
