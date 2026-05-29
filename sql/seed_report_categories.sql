-- Report category master seed for the 35 frontend categories
-- Safe to run multiple times

USE police_case_db;

INSERT INTO case_types (name, code, icon, color, is_active)
VALUES
  ('Murder', 'MURDER', 'flame.fill', 'red', TRUE),
  ('Murder for Gain', 'MURDER_FOR_GAIN', 'dollarsign.circle.fill', 'orange', TRUE),
  ('Dacoity', 'DACOITY', 'person.3.sequence.fill', 'purple', TRUE),
  ('Robbery', 'ROBBERY', 'bag.fill.badge.minus', 'pink', TRUE),
  ('Grave HB (Day)', 'GRAVE_HB_DAY', 'sun.max.fill', 'yellow', TRUE),
  ('Grave HB (Night)', 'GRAVE_HB_NIGHT', 'moon.fill', 'indigo', TRUE),
  ('Grave Major Theft', 'GRAVE_MAJOR_THEFT', 'lock.open.fill', 'red', TRUE),
  ('Snatching', 'SNATCHING', 'hand.draw.fill', 'orange', TRUE),
  ('Non Grave HB (Day)', 'NON_GRAVE_HB_DAY', 'sun.min.fill', 'green', TRUE),
  ('Non Grave HB (Night)', 'NON_GRAVE_HB_NIGHT', 'moon.stars.fill', 'blue', TRUE),
  ('Ordinary Theft', 'ORDINARY_THEFT', 'lock.slash.fill', 'gray', TRUE),
  ('Vehicle Theft', 'VEHICLE_THEFT', 'car.fill', 'teal', TRUE),
  ('Attempt to Murder', 'ATTEMPT_TO_MURDER', 'exclamationmark.triangle.fill', 'red', TRUE),
  ('Grievous Hurt', 'GRIEVOUS_HURT', 'cross.case.fill', 'pink', TRUE),
  ('Simple Hurt', 'SIMPLE_HURT', 'bandage.fill', 'green', TRUE),
  ('Rioting', 'RIOTING', 'person.3.fill', 'orange', TRUE),
  ('Assault on Public Servant', 'ASSAULT_ON_PUBLIC_SERVANT', 'shield.lefthalf.fill', 'blue', TRUE),
  ('POCSO Act', 'POCSO_ACT', 'person.crop.circle.badge.exclamationmark', 'purple', TRUE),
  ('Rape', 'RAPE', 'exclamationmark.octagon.fill', 'red', TRUE),
  ('Dowry Harassment', 'DOWRY_HARASSMENT', 'person.fill.xmark', 'pink', TRUE),
  ('Other BNS Cases', 'OTHER_BNS_CASES', 'doc.plaintext.fill', 'gray', TRUE),
  ('Non-BNS / Other Acts', 'NON_BNS_OTHER_ACTS', 'doc.on.doc.fill', 'brown', TRUE),
  ('NDPS Act', 'NDPS_ACT', 'pills.fill', 'teal', TRUE),
  ('TNPA Cases', 'TNPA_CASES', 'doc.text.magnifyingglass', 'indigo', TRUE),
  ('COTPA Cases', 'COTPA_CASES', 'smoke.fill', 'gray', TRUE),
  ('Lottery Cases', 'LOTTERY_CASES', 'number.circle.fill', 'yellow', TRUE),
  ('Gambling Cases', 'GAMBLING_CASES', 'die.face.5.fill', 'green', TRUE),
  ('Other SLL Cases / 75 TNCP Act', 'OTHER_SLL_CASES_75_TNCP_ACT', 'doc.richtext.fill', 'brown', TRUE),
  ('194 Cr.P.C. (Death within 7 Years of Marriage)', 'S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE', 'calendar.badge.exclamationmark', 'red', TRUE),
  ('194 Suspicious Death', 'S194_SUSPICIOUS_DEATH', 'questionmark.circle.fill', 'orange', TRUE),
  ('194 BNSS (Unknown Bodies)', 'S194_BNSS_UNKNOWN_BODIES', 'person.crop.circle.badge.questionmark', 'gray', TRUE),
  ('Missing Person', 'MISSING_PERSON', 'person.fill.questionmark', 'indigo', TRUE),
  ('Elopement Case', 'ELOPEMENT_CASE', 'heart.fill', 'pink', TRUE),
  ('Goondas Act', 'GOONDAS_ACT', 'hand.raised.fill', 'red', TRUE),
  ('Security Act', 'SECURITY_ACT', 'lock.shield.fill', 'blue', TRUE)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  icon = VALUES(icon),
  color = VALUES(color),
  is_active = VALUES(is_active);

-- Murder
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 3
  UNION ALL SELECT 'incident_place', 'Incident Place', 'TEXTAREA', 1, NULL, 4
  UNION ALL SELECT 'victim_name', 'Victim Name', 'TEXT', 1, NULL, 5
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 6
  UNION ALL SELECT 'brief_facts', 'Brief Facts', 'TEXTAREA', 1, NULL, 7
) v
WHERE ct.code = 'MURDER'
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Final history value seeding for categories whose form fields are defined later in this file.
INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '3' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Property PS No. 103/2026 u/s 392 IPC'
  UNION ALL SELECT 'do_dr_soc_cctv_details', 'D/O: 2026-05-29, CCTV available'
  UNION ALL SELECT 'complainant_name_phone', 'Suresh - 9876543210'
  UNION ALL SELECT 'victim_or_injured', 'Lakshmi'
  UNION ALL SELECT 'accused_details', 'Unknown persons'
  UNION ALL SELECT 'pl', 'PL sample'
  UNION ALL SELECT 'pr', 'PR sample'
  UNION ALL SELECT 'gist_of_case', 'Sample property crime record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'DACOITY',
  'ROBBERY',
  'GRAVE_HB_DAY',
  'GRAVE_HB_NIGHT',
  'GRAVE_MAJOR_THEFT',
  'SNATCHING',
  'NON_GRAVE_HB_DAY',
  'NON_GRAVE_HB_NIGHT',
  'ORDINARY_THEFT',
  'VEHICLE_THEFT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:02:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '4' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Crime No. 104/2026'
  UNION ALL SELECT 'incident_date', '2026-05-29'
  UNION ALL SELECT 'complainant_name_phone', 'Priya - 9999999999'
  UNION ALL SELECT 'victim_or_injured', 'Victim Name'
  UNION ALL SELECT 'accused_details', 'Accused details'
  UNION ALL SELECT 'gist_of_case', 'Sample personal offence record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'ATTEMPT_TO_MURDER',
  'GRIEVOUS_HURT',
  'SIMPLE_HURT',
  'RIOTING',
  'ASSAULT_ON_PUBLIC_SERVANT',
  'POCSO_ACT',
  'RAPE',
  'DOWRY_HARASSMENT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:03:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '5' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Special Act PS No. 105/2026'
  UNION ALL SELECT 'complainant_name_phone', 'Inspector - 9000000000'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'evidence_or_seizure_details', 'Seizure details'
  UNION ALL SELECT 'gist_of_case', 'Sample special law record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'OTHER_BNS_CASES',
  'NON_BNS_OTHER_ACTS',
  'NDPS_ACT',
  'TNPA_CASES',
  'COTPA_CASES',
  'LOTTERY_CASES',
  'GAMBLING_CASES',
  'OTHER_SLL_CASES_75_TNCP_ACT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:04:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '6' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', '194 PS No. 106/2026'
  UNION ALL SELECT 'date_of_incident', '2026-05-28'
  UNION ALL SELECT 'place_of_incident', 'Chennai'
  UNION ALL SELECT 'body_identification_details', 'Unknown body'
  UNION ALL SELECT 'post_mortem_report_no', 'PMR-106'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'gist_of_case', 'Sample 194 record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE',
  'S194_SUSPICIOUS_DEATH',
  'S194_BNSS_UNKNOWN_BODIES'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:05:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '7' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Missing PS No. 107/2026'
  UNION ALL SELECT 'missing_person_name', 'Karthik'
  UNION ALL SELECT 'age', '24'
  UNION ALL SELECT 'gender', 'Male'
  UNION ALL SELECT 'last_seen_date', '2026-05-28'
  UNION ALL SELECT 'last_seen_place', 'Tambaram Railway Station'
  UNION ALL SELECT 'complainant_name_phone', 'Anitha - 8888888888'
  UNION ALL SELECT 'gist_of_case', 'Sample missing person record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN ('MISSING_PERSON', 'ELOPEMENT_CASE')
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:06:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'range_name' AS field_name, 'Chennai Range' AS value
  UNION ALL SELECT 'ps', 'Koyambedu'
  UNION ALL SELECT 'ac_or_ins', 'AC'
  UNION ALL SELECT 'officer_name', 'Inspector Kumar'
  UNION ALL SELECT 'nature_of_leave', 'Detention'
  UNION ALL SELECT 'leave_from', '2026-05-29'
  UNION ALL SELECT 'leave_to', '2026-06-05'
  UNION ALL SELECT 'due_on', '2026-06-06'
  UNION ALL SELECT 'incharge_officer', 'SI Raj'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'GOONDAS_ACT'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:07:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '8' AS value
  UNION ALL SELECT 'ps_sl_no_section_of_law', 'Security PS No. 108/2026'
  UNION ALL SELECT 'name_address_accused', 'John Doe, 12 Example Street'
  UNION ALL SELECT 'previous_case', 'Previous preventive action'
  UNION ALL SELECT 'bind_over_on', '2026-06-01'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'SECURITY_ACT'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:08:00';

-- Sample history data for mobile testing
-- Safe to re-run because it removes the previously seeded sample rows first.
DELETE cfv
FROM case_field_values cfv
INNER JOIN case_entries ce ON ce.id = cfv.case_entry_id
WHERE ce.created_by = 'seed_report_categories_history';

DELETE FROM case_entries
WHERE created_by = 'seed_report_categories_history';

-- Murder
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'SUBMITTED', 'seed_report_categories_history', '2026-05-29 10:00:00'
FROM case_types ct
WHERE ct.code = 'MURDER';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '1' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Murder PS No. 101/2026 u/s 302 IPC'
  UNION ALL SELECT 'incident_date', '2026-05-29'
  UNION ALL SELECT 'incident_place', 'Tambaram'
  UNION ALL SELECT 'victim_name', 'Arun'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'brief_facts', 'Sample murder history record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'MURDER'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:00:00';

-- Murder for Gain
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'SUBMITTED', 'seed_report_categories_history', '2026-05-29 10:01:00'
FROM case_types ct
WHERE ct.code = 'MURDER_FOR_GAIN';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '2' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'MFG PS No. 102/2026 u/s 302 IPC'
  UNION ALL SELECT 'incident_date', '2026-05-29'
  UNION ALL SELECT 'property_taken', 'Gold chain and cash'
  UNION ALL SELECT 'estimated_value', '150000'
  UNION ALL SELECT 'victim_name', 'Ravi'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'brief_facts', 'Sample murder for gain history record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'MURDER_FOR_GAIN'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:01:00';

-- Property crime group
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'SUBMITTED', 'seed_report_categories_history', '2026-05-29 10:02:00'
FROM case_types ct
WHERE ct.code IN (
  'DACOITY',
  'ROBBERY',
  'GRAVE_HB_DAY',
  'GRAVE_HB_NIGHT',
  'GRAVE_MAJOR_THEFT',
  'SNATCHING',
  'NON_GRAVE_HB_DAY',
  'NON_GRAVE_HB_NIGHT',
  'ORDINARY_THEFT',
  'VEHICLE_THEFT'
);

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '3' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Property PS No. 103/2026 u/s 392 IPC'
  UNION ALL SELECT 'do_dr_soc_cctv_details', 'D/O: 2026-05-29, CCTV available'
  UNION ALL SELECT 'complainant_name_phone', 'Suresh - 9876543210'
  UNION ALL SELECT 'victim_or_injured', 'Lakshmi'
  UNION ALL SELECT 'accused_details', 'Unknown persons'
  UNION ALL SELECT 'pl', 'PL sample'
  UNION ALL SELECT 'pr', 'PR sample'
  UNION ALL SELECT 'gist_of_case', 'Sample property crime record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'DACOITY',
  'ROBBERY',
  'GRAVE_HB_DAY',
  'GRAVE_HB_NIGHT',
  'GRAVE_MAJOR_THEFT',
  'SNATCHING',
  'NON_GRAVE_HB_DAY',
  'NON_GRAVE_HB_NIGHT',
  'ORDINARY_THEFT',
  'VEHICLE_THEFT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:02:00';

-- Personal offences group
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'DRAFT', 'seed_report_categories_history', '2026-05-29 10:03:00'
FROM case_types ct
WHERE ct.code IN (
  'ATTEMPT_TO_MURDER',
  'GRIEVOUS_HURT',
  'SIMPLE_HURT',
  'RIOTING',
  'ASSAULT_ON_PUBLIC_SERVANT',
  'POCSO_ACT',
  'RAPE',
  'DOWRY_HARASSMENT'
);

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '4' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Crime No. 104/2026'
  UNION ALL SELECT 'incident_date', '2026-05-29'
  UNION ALL SELECT 'complainant_name_phone', 'Priya - 9999999999'
  UNION ALL SELECT 'victim_or_injured', 'Victim Name'
  UNION ALL SELECT 'accused_details', 'Accused details'
  UNION ALL SELECT 'gist_of_case', 'Sample personal offence record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'ATTEMPT_TO_MURDER',
  'GRIEVOUS_HURT',
  'SIMPLE_HURT',
  'RIOTING',
  'ASSAULT_ON_PUBLIC_SERVANT',
  'POCSO_ACT',
  'RAPE',
  'DOWRY_HARASSMENT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:03:00';

-- Special law cases
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'SUBMITTED', 'seed_report_categories_history', '2026-05-29 10:04:00'
FROM case_types ct
WHERE ct.code IN (
  'OTHER_BNS_CASES',
  'NON_BNS_OTHER_ACTS',
  'NDPS_ACT',
  'TNPA_CASES',
  'COTPA_CASES',
  'LOTTERY_CASES',
  'GAMBLING_CASES',
  'OTHER_SLL_CASES_75_TNCP_ACT'
);

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '5' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Special Act PS No. 105/2026'
  UNION ALL SELECT 'complainant_name_phone', 'Inspector - 9000000000'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'evidence_or_seizure_details', 'Seizure details'
  UNION ALL SELECT 'gist_of_case', 'Sample special law record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'OTHER_BNS_CASES',
  'NON_BNS_OTHER_ACTS',
  'NDPS_ACT',
  'TNPA_CASES',
  'COTPA_CASES',
  'LOTTERY_CASES',
  'GAMBLING_CASES',
  'OTHER_SLL_CASES_75_TNCP_ACT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:04:00';

-- Section 194 cases
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'DRAFT', 'seed_report_categories_history', '2026-05-29 10:05:00'
FROM case_types ct
WHERE ct.code IN (
  'S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE',
  'S194_SUSPICIOUS_DEATH',
  'S194_BNSS_UNKNOWN_BODIES'
);

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '6' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', '194 PS No. 106/2026'
  UNION ALL SELECT 'date_of_incident', '2026-05-28'
  UNION ALL SELECT 'place_of_incident', 'Chennai'
  UNION ALL SELECT 'body_identification_details', 'Unknown body'
  UNION ALL SELECT 'post_mortem_report_no', 'PMR-106'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'gist_of_case', 'Sample 194 record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE',
  'S194_SUSPICIOUS_DEATH',
  'S194_BNSS_UNKNOWN_BODIES'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:05:00';

-- Missing person and elopement
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'SUBMITTED', 'seed_report_categories_history', '2026-05-29 10:06:00'
FROM case_types ct
WHERE ct.code IN ('MISSING_PERSON', 'ELOPEMENT_CASE');

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '7' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Missing PS No. 107/2026'
  UNION ALL SELECT 'missing_person_name', 'Karthik'
  UNION ALL SELECT 'age', '24'
  UNION ALL SELECT 'gender', 'Male'
  UNION ALL SELECT 'last_seen_date', '2026-05-28'
  UNION ALL SELECT 'last_seen_place', 'Tambaram Railway Station'
  UNION ALL SELECT 'complainant_name_phone', 'Anitha - 8888888888'
  UNION ALL SELECT 'gist_of_case', 'Sample missing person record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN ('MISSING_PERSON', 'ELOPEMENT_CASE')
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:06:00';

-- Goondas Act
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'REJECTED', 'seed_report_categories_history', '2026-05-29 10:07:00'
FROM case_types ct
WHERE ct.code = 'GOONDAS_ACT';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'range_name' AS field_name, 'Chennai Range' AS value
  UNION ALL SELECT 'ps', 'Koyambedu'
  UNION ALL SELECT 'ac_or_ins', 'AC'
  UNION ALL SELECT 'officer_name', 'Inspector Kumar'
  UNION ALL SELECT 'nature_of_leave', 'Detention'
  UNION ALL SELECT 'leave_from', '2026-05-29'
  UNION ALL SELECT 'leave_to', '2026-06-05'
  UNION ALL SELECT 'due_on', '2026-06-06'
  UNION ALL SELECT 'incharge_officer', 'SI Raj'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'GOONDAS_ACT'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:07:00';

-- Security Act
INSERT INTO case_entries (case_type_id, status, created_by, created_at)
SELECT ct.id, 'APPROVED', 'seed_report_categories_history', '2026-05-29 10:08:00'
FROM case_types ct
WHERE ct.code = 'SECURITY_ACT';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '8' AS value
  UNION ALL SELECT 'ps_sl_no_section_of_law', 'Security PS No. 108/2026'
  UNION ALL SELECT 'name_address_accused', 'John Doe, 12 Example Street'
  UNION ALL SELECT 'previous_case', 'Previous preventive action'
  UNION ALL SELECT 'bind_over_on', '2026-06-01'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'SECURITY_ACT'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:08:00';

-- Murder for Gain
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 3
  UNION ALL SELECT 'property_taken', 'Property Taken', 'TEXTAREA', 1, NULL, 4
  UNION ALL SELECT 'estimated_value', 'Estimated Value', 'NUMBER', 1, NULL, 5
  UNION ALL SELECT 'victim_name', 'Victim Name', 'TEXT', 1, NULL, 6
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 7
  UNION ALL SELECT 'brief_facts', 'Brief Facts', 'TEXTAREA', 1, NULL, 8
) v
WHERE ct.code = 'MURDER_FOR_GAIN'
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Property crime group
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'do_dr_soc_cctv_details', 'D/O, D/R, SOC & CCTV Details', 'TEXTAREA', 0, NULL, 3
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'victim_or_injured', 'Victim / Injured', 'TEXT', 0, NULL, 5
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 6
  UNION ALL SELECT 'pl', 'PL', 'TEXT', 0, NULL, 7
  UNION ALL SELECT 'pr', 'PR', 'TEXT', 0, NULL, 8
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 9
) v
WHERE ct.code IN (
  'DACOITY',
  'ROBBERY',
  'GRAVE_HB_DAY',
  'GRAVE_HB_NIGHT',
  'GRAVE_MAJOR_THEFT',
  'SNATCHING',
  'NON_GRAVE_HB_DAY',
  'NON_GRAVE_HB_NIGHT',
  'ORDINARY_THEFT',
  'VEHICLE_THEFT'
)
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Personal offences
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 3
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'victim_or_injured', 'Victim / Injured', 'TEXT', 0, NULL, 5
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 6
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 7
) v
WHERE ct.code IN (
  'ATTEMPT_TO_MURDER',
  'GRIEVOUS_HURT',
  'SIMPLE_HURT',
  'RIOTING',
  'ASSAULT_ON_PUBLIC_SERVANT',
  'POCSO_ACT',
  'RAPE',
  'DOWRY_HARASSMENT'
)
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Special law cases
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 3
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 4
  UNION ALL SELECT 'evidence_or_seizure_details', 'Evidence / Seizure Details', 'TEXTAREA', 0, NULL, 5
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 6
) v
WHERE ct.code IN (
  'OTHER_BNS_CASES',
  'NON_BNS_OTHER_ACTS',
  'NDPS_ACT',
  'TNPA_CASES',
  'COTPA_CASES',
  'LOTTERY_CASES',
  'GAMBLING_CASES',
  'OTHER_SLL_CASES_75_TNCP_ACT'
)
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Section 194 cases
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'date_of_incident', 'Date of Incident', 'DATE', 1, NULL, 3
  UNION ALL SELECT 'place_of_incident', 'Place of Incident', 'TEXTAREA', 1, NULL, 4
  UNION ALL SELECT 'body_identification_details', 'Body Identification Details', 'TEXTAREA', 0, NULL, 5
  UNION ALL SELECT 'post_mortem_report_no', 'Post Mortem Report No.', 'TEXT', 0, NULL, 6
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 7
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 8
) v
WHERE ct.code IN (
  'S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE',
  'S194_SUSPICIOUS_DEATH',
  'S194_BNSS_UNKNOWN_BODIES'
)
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Missing person and elopement
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'missing_person_name', 'Missing Person Name', 'TEXT', 1, NULL, 3
  UNION ALL SELECT 'age', 'Age', 'NUMBER', 0, NULL, 4
  UNION ALL SELECT 'gender', 'Gender', 'DROPDOWN', 0, JSON_ARRAY('Male', 'Female', 'Other'), 5
  UNION ALL SELECT 'last_seen_date', 'Last Seen Date', 'DATE', 1, NULL, 6
  UNION ALL SELECT 'last_seen_place', 'Last Seen Place', 'TEXTAREA', 1, NULL, 7
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 8
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 9
) v
WHERE ct.code IN ('MISSING_PERSON', 'ELOPEMENT_CASE')
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Goondas Act
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'range_name' AS field_name, 'RANGE' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps', 'PS', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'ac_or_ins', 'AC / INS', 'DROPDOWN', 1, JSON_ARRAY('AC', 'INS'), 3
  UNION ALL SELECT 'officer_name', 'THE OFFICER', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'nature_of_leave', 'NATURE OF LEAVE', 'TEXT', 1, NULL, 5
  UNION ALL SELECT 'leave_from', 'FROM', 'DATE', 1, NULL, 6
  UNION ALL SELECT 'leave_to', 'TO', 'DATE', 1, NULL, 7
  UNION ALL SELECT 'due_on', 'DUE ON', 'DATE', 0, NULL, 8
  UNION ALL SELECT 'incharge_officer', 'INCHARGE OFFICER', 'TEXT', 0, NULL, 9
) v
WHERE ct.code = 'GOONDAS_ACT'
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Security Act
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_sl_no_section_of_law', 'P.S, Sl. No. & Section of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'name_address_accused', 'Name & Address Accused', 'TEXTAREA', 1, NULL, 3
  UNION ALL SELECT 'previous_case', 'Previous Case', 'TEXTAREA', 0, NULL, 4
  UNION ALL SELECT 'bind_over_on', 'Bind over on', 'DATE', 0, NULL, 5
) v
WHERE ct.code = 'SECURITY_ACT'
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- Final history value seeding for categories whose form fields are defined later in this file.
INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '3' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Property PS No. 103/2026 u/s 392 IPC'
  UNION ALL SELECT 'do_dr_soc_cctv_details', 'D/O: 2026-05-29, CCTV available'
  UNION ALL SELECT 'complainant_name_phone', 'Suresh - 9876543210'
  UNION ALL SELECT 'victim_or_injured', 'Lakshmi'
  UNION ALL SELECT 'accused_details', 'Unknown persons'
  UNION ALL SELECT 'pl', 'PL sample'
  UNION ALL SELECT 'pr', 'PR sample'
  UNION ALL SELECT 'gist_of_case', 'Sample property crime record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'DACOITY',
  'ROBBERY',
  'GRAVE_HB_DAY',
  'GRAVE_HB_NIGHT',
  'GRAVE_MAJOR_THEFT',
  'SNATCHING',
  'NON_GRAVE_HB_DAY',
  'NON_GRAVE_HB_NIGHT',
  'ORDINARY_THEFT',
  'VEHICLE_THEFT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:02:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '4' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Crime No. 104/2026'
  UNION ALL SELECT 'incident_date', '2026-05-29'
  UNION ALL SELECT 'complainant_name_phone', 'Priya - 9999999999'
  UNION ALL SELECT 'victim_or_injured', 'Victim Name'
  UNION ALL SELECT 'accused_details', 'Accused details'
  UNION ALL SELECT 'gist_of_case', 'Sample personal offence record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'ATTEMPT_TO_MURDER',
  'GRIEVOUS_HURT',
  'SIMPLE_HURT',
  'RIOTING',
  'ASSAULT_ON_PUBLIC_SERVANT',
  'POCSO_ACT',
  'RAPE',
  'DOWRY_HARASSMENT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:03:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '5' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Special Act PS No. 105/2026'
  UNION ALL SELECT 'complainant_name_phone', 'Inspector - 9000000000'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'evidence_or_seizure_details', 'Seizure details'
  UNION ALL SELECT 'gist_of_case', 'Sample special law record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'OTHER_BNS_CASES',
  'NON_BNS_OTHER_ACTS',
  'NDPS_ACT',
  'TNPA_CASES',
  'COTPA_CASES',
  'LOTTERY_CASES',
  'GAMBLING_CASES',
  'OTHER_SLL_CASES_75_TNCP_ACT'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:04:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '6' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', '194 PS No. 106/2026'
  UNION ALL SELECT 'date_of_incident', '2026-05-28'
  UNION ALL SELECT 'place_of_incident', 'Chennai'
  UNION ALL SELECT 'body_identification_details', 'Unknown body'
  UNION ALL SELECT 'post_mortem_report_no', 'PMR-106'
  UNION ALL SELECT 'accused_details', 'Unknown'
  UNION ALL SELECT 'gist_of_case', 'Sample 194 record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN (
  'S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE',
  'S194_SUSPICIOUS_DEATH',
  'S194_BNSS_UNKNOWN_BODIES'
)
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:05:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '7' AS value
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'Missing PS No. 107/2026'
  UNION ALL SELECT 'missing_person_name', 'Karthik'
  UNION ALL SELECT 'age', '24'
  UNION ALL SELECT 'gender', 'Male'
  UNION ALL SELECT 'last_seen_date', '2026-05-28'
  UNION ALL SELECT 'last_seen_place', 'Tambaram Railway Station'
  UNION ALL SELECT 'complainant_name_phone', 'Anitha - 8888888888'
  UNION ALL SELECT 'gist_of_case', 'Sample missing person record'
) sample ON sample.field_name = ff.field_name
WHERE ct.code IN ('MISSING_PERSON', 'ELOPEMENT_CASE')
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:06:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'range_name' AS field_name, 'Chennai Range' AS value
  UNION ALL SELECT 'ps', 'Koyambedu'
  UNION ALL SELECT 'ac_or_ins', 'AC'
  UNION ALL SELECT 'officer_name', 'Inspector Kumar'
  UNION ALL SELECT 'nature_of_leave', 'Detention'
  UNION ALL SELECT 'leave_from', '2026-05-29'
  UNION ALL SELECT 'leave_to', '2026-06-05'
  UNION ALL SELECT 'due_on', '2026-06-06'
  UNION ALL SELECT 'incharge_officer', 'SI Raj'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'GOONDAS_ACT'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:07:00';

INSERT INTO case_field_values (case_entry_id, field_id, value)
SELECT ce.id, ff.id, sample.value
FROM case_entries ce
JOIN case_types ct ON ct.id = ce.case_type_id
JOIN form_fields ff ON ff.case_type_id = ct.id
JOIN (
  SELECT 'sl_no' AS field_name, '8' AS value
  UNION ALL SELECT 'ps_sl_no_section_of_law', 'Security PS No. 108/2026'
  UNION ALL SELECT 'name_address_accused', 'John Doe, 12 Example Street'
  UNION ALL SELECT 'previous_case', 'Previous preventive action'
  UNION ALL SELECT 'bind_over_on', '2026-06-01'
) sample ON sample.field_name = ff.field_name
WHERE ct.code = 'SECURITY_ACT'
  AND ce.created_by = 'seed_report_categories_history'
  AND ce.created_at = '2026-05-29 10:08:00';
