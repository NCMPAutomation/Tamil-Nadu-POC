-- Sample history seed for category testing
-- Run this after case types and form fields are already seeded.
-- Safe to re-run: it removes previous sample rows first.

USE police_case_db;

DELETE cfv
FROM case_field_values cfv
INNER JOIN case_entries ce ON ce.id = cfv.case_entry_id
WHERE ce.created_by = 'seed_report_categories_history';

DELETE FROM case_entries
WHERE created_by = 'seed_report_categories_history';

INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT
  ct.id,
  CASE seq.n
    WHEN 1 THEN 'SUBMITTED'
    WHEN 2 THEN 'SUBMITTED'
    WHEN 3 THEN 'APPROVED'
    WHEN 4 THEN 'REJECTED'
    WHEN 5 THEN 'SUBMITTED'
    ELSE 'SUBMITTED'
  END AS status,
  'seed_report_categories_history' AS created_by,
  DATE_ADD('2026-05-29 10:00:00', INTERVAL ((ct.id - 1) * 6 + seq.n) MINUTE) AS created_at
FROM case_types ct
JOIN (
  SELECT 1 AS n
  UNION ALL SELECT 2
  UNION ALL SELECT 3
  UNION ALL SELECT 4
  UNION ALL SELECT 5
  UNION ALL SELECT 6
) seq
WHERE ct.is_active = TRUE;

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT
  ce.id,
  ff.id,
  CASE ff.field_name
    WHEN 'sl_no' THEN CAST(MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1 AS CHAR)
    WHEN 'ps_cr_no_section_of_law' THEN CONCAT(ct.name, ' PS No. ', 100 + MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1, '/2026')
    WHEN 'incident_date' THEN DATE_FORMAT(DATE_ADD('2026-05-29', INTERVAL MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) DAY), '%Y-%m-%d')
    WHEN 'date_of_incident' THEN DATE_FORMAT(DATE_ADD('2026-05-28', INTERVAL MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) DAY), '%Y-%m-%d')
    WHEN 'incident_place' THEN CONCAT('Place ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'victim_name' THEN CONCAT('Victim ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'victim_or_injured' THEN CONCAT('Injured Person ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'accused_details' THEN CONCAT('Accused details sample ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'brief_facts' THEN CONCAT('Brief facts for ', ct.code, ' entry ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'gist_of_case' THEN CONCAT('History record for ', ct.code, ' entry ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'complainant_name_phone' THEN CONCAT('Complainant ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1, ' - 98765', LPAD(MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1, 5, '0'))
    WHEN 'estimated_value' THEN CAST(100000 + (MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) * 25000) AS CHAR)
    WHEN 'property_taken' THEN CONCAT('Property sample ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'do_dr_soc_cctv_details' THEN CONCAT('D/O - CCTV sample ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'evidence_or_seizure_details' THEN CONCAT('Seizure sample ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'missing_person_name' THEN CONCAT('Missing Person ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'age' THEN CAST(20 + MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) AS CHAR)
    WHEN 'gender' THEN CASE MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 3)
      WHEN 0 THEN 'Male'
      WHEN 1 THEN 'Female'
      ELSE 'Other'
    END
    WHEN 'last_seen_date' THEN DATE_FORMAT(DATE_ADD('2026-05-20', INTERVAL MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) DAY), '%Y-%m-%d')
    WHEN 'last_seen_place' THEN CONCAT('Last seen place ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'range_name' THEN CONCAT('Range ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'ps' THEN CONCAT('PS ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'ac_or_ins' THEN 'AC'
    WHEN 'officer_name' THEN CONCAT('Officer ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'nature_of_leave' THEN 'Detention'
    WHEN 'leave_from' THEN '2026-05-29'
    WHEN 'leave_to' THEN '2026-06-05'
    WHEN 'due_on' THEN '2026-06-06'
    WHEN 'incharge_officer' THEN 'SI Raj'
    WHEN 'bind_over_on' THEN '2026-06-01'
    WHEN 'previous_case' THEN CONCAT('Previous case ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'place_of_incident' THEN CONCAT('Place of incident ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'body_identification_details' THEN CONCAT('Body identification sample ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    WHEN 'post_mortem_report_no' THEN CONCAT('PMR-', 100 + MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
    ELSE CONCAT(REPLACE(ff.label, ' ', '_'), ' sample ', MOD(TIMESTAMPDIFF(MINUTE, '2026-05-29 10:00:00', ce.created_at), 6) + 1)
  END AS value
FROM case_entries ce
INNER JOIN case_types ct ON ct.id = ce.case_type_id
INNER JOIN form_fields ff ON ff.case_type_id = ct.id
WHERE ce.created_by = 'seed_report_categories_history';
