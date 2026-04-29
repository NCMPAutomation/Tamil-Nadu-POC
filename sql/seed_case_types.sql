-- Seed data for Dynamic Police Case Management System
-- Safe to run multiple times

USE police_case_db;

-- 1) Case Types
INSERT INTO case_types (name, code, is_active)
VALUES
  ('MURDER', 'MURDER', TRUE),
  ('MURDER FOR GAIN', 'MURDER_FOR_GAIN', TRUE),
  ('ROBBERY', 'ROBBERY', TRUE),
  ('DACOITY', 'DACOITY', TRUE),
  ('THEFT', 'THEFT', TRUE),
  ('BURGLARY', 'BURGLARY', TRUE),
  ('KIDNAPPING', 'KIDNAPPING', TRUE),
  ('ASSAULT', 'ASSAULT', TRUE),
  ('CYBER CRIME', 'CYBER_CRIME', TRUE),
  ('NARCOTICS OFFENCE', 'NARCOTICS_OFFENCE', TRUE)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  is_active = VALUES(is_active);

-- 2) Shared Fields Helper (insert per case type via code)
-- Field types allowed: TEXT, NUMBER, DATE, PHONE, TEXTAREA, DROPDOWN

-- MURDER
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'victim_name' AS field_name, 'Victim Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 2
  UNION ALL SELECT 'incident_place', 'Incident Place', 'TEXTAREA', 1, NULL, 3
  UNION ALL SELECT 'suspect_name', 'Suspect Name', 'TEXT', 0, NULL, 4
  UNION ALL SELECT 'weapon_used', 'Weapon Used', 'DROPDOWN', 0, JSON_ARRAY('Knife','Firearm','Blunt Object','Unknown'), 5
  UNION ALL SELECT 'brief_facts', 'Brief Facts', 'TEXTAREA', 1, NULL, 6
) v
WHERE ct.code = 'MURDER'
ON DUPLICATE KEY UPDATE
  label = VALUES(label),
  field_type = VALUES(field_type),
  is_required = VALUES(is_required),
  options = VALUES(options),
  order_index = VALUES(order_index);

-- MURDER FOR GAIN
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'victim_name' AS field_name, 'Victim Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'property_taken', 'Property Taken', 'TEXTAREA', 1, NULL, 2
  UNION ALL SELECT 'estimated_value', 'Estimated Value', 'NUMBER', 1, NULL, 3
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 4
  UNION ALL SELECT 'suspect_count', 'Suspect Count', 'NUMBER', 0, NULL, 5
  UNION ALL SELECT 'brief_facts', 'Brief Facts', 'TEXTAREA', 1, NULL, 6
) v
WHERE ct.code = 'MURDER_FOR_GAIN'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- ROBBERY
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'complainant_name' AS field_name, 'Complainant Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'complainant_phone', 'Complainant Phone', 'PHONE', 1, NULL, 2
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 3
  UNION ALL SELECT 'location', 'Location', 'TEXTAREA', 1, NULL, 4
  UNION ALL SELECT 'property_lost', 'Property Lost', 'TEXTAREA', 1, NULL, 5
  UNION ALL SELECT 'estimated_loss', 'Estimated Loss', 'NUMBER', 1, NULL, 6
  UNION ALL SELECT 'violence_level', 'Violence Level', 'DROPDOWN', 0, JSON_ARRAY('Low','Medium','High'), 7
) v
WHERE ct.code = 'ROBBERY'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- DACOITY
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'complainant_name' AS field_name, 'Complainant Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 2
  UNION ALL SELECT 'location', 'Location', 'TEXTAREA', 1, NULL, 3
  UNION ALL SELECT 'gang_size', 'Gang Size (Approx)', 'NUMBER', 0, NULL, 4
  UNION ALL SELECT 'arms_used', 'Arms Used', 'DROPDOWN', 0, JSON_ARRAY('None','Knife','Firearm','Mixed'), 5
  UNION ALL SELECT 'property_lost', 'Property Lost', 'TEXTAREA', 1, NULL, 6
) v
WHERE ct.code = 'DACOITY'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- THEFT
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'complainant_name' AS field_name, 'Complainant Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'complainant_phone', 'Complainant Phone', 'PHONE', 0, NULL, 2
  UNION ALL SELECT 'theft_date', 'Theft Date', 'DATE', 1, NULL, 3
  UNION ALL SELECT 'theft_location', 'Theft Location', 'TEXTAREA', 1, NULL, 4
  UNION ALL SELECT 'stolen_items', 'Stolen Items', 'TEXTAREA', 1, NULL, 5
  UNION ALL SELECT 'estimated_loss', 'Estimated Loss', 'NUMBER', 0, NULL, 6
) v
WHERE ct.code = 'THEFT'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- BURGLARY
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'property_owner' AS field_name, 'Property Owner' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 2
  UNION ALL SELECT 'premises_type', 'Premises Type', 'DROPDOWN', 1, JSON_ARRAY('House','Shop','Office','Warehouse'), 3
  UNION ALL SELECT 'entry_method', 'Entry Method', 'TEXTAREA', 0, NULL, 4
  UNION ALL SELECT 'items_stolen', 'Items Stolen', 'TEXTAREA', 1, NULL, 5
) v
WHERE ct.code = 'BURGLARY'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- KIDNAPPING
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'missing_person_name' AS field_name, 'Missing Person Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'age' , 'Age', 'NUMBER', 1, NULL, 2
  UNION ALL SELECT 'gender', 'Gender', 'DROPDOWN', 1, JSON_ARRAY('Male','Female','Other'), 3
  UNION ALL SELECT 'last_seen_date', 'Last Seen Date', 'DATE', 1, NULL, 4
  UNION ALL SELECT 'last_seen_place', 'Last Seen Place', 'TEXTAREA', 1, NULL, 5
  UNION ALL SELECT 'suspected_abductor', 'Suspected Abductor', 'TEXT', 0, NULL, 6
) v
WHERE ct.code = 'KIDNAPPING'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- ASSAULT
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'victim_name' AS field_name, 'Victim Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 2
  UNION ALL SELECT 'injury_type', 'Injury Type', 'DROPDOWN', 1, JSON_ARRAY('Simple','Grievous','Life-threatening'), 3
  UNION ALL SELECT 'medical_report_no', 'Medical Report No', 'TEXT', 0, NULL, 4
  UNION ALL SELECT 'accused_name', 'Accused Name', 'TEXT', 0, NULL, 5
  UNION ALL SELECT 'incident_summary', 'Incident Summary', 'TEXTAREA', 1, NULL, 6
) v
WHERE ct.code = 'ASSAULT'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- CYBER CRIME
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'complainant_name' AS field_name, 'Complainant Name' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'complainant_phone', 'Complainant Phone', 'PHONE', 1, NULL, 2
  UNION ALL SELECT 'platform', 'Platform', 'DROPDOWN', 1, JSON_ARRAY('UPI','Banking','Social Media','Email','E-commerce','Other'), 3
  UNION ALL SELECT 'incident_date', 'Incident Date', 'DATE', 1, NULL, 4
  UNION ALL SELECT 'amount_lost', 'Amount Lost', 'NUMBER', 0, NULL, 5
  UNION ALL SELECT 'transaction_id', 'Transaction ID', 'TEXT', 0, NULL, 6
  UNION ALL SELECT 'description', 'Description', 'TEXTAREA', 1, NULL, 7
) v
WHERE ct.code = 'CYBER_CRIME'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);

-- NARCOTICS OFFENCE
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'seizure_date' AS field_name, 'Seizure Date' AS label, 'DATE' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'seizure_place', 'Seizure Place', 'TEXTAREA', 1, NULL, 2
  UNION ALL SELECT 'substance_type', 'Substance Type', 'DROPDOWN', 1, JSON_ARRAY('Ganja','Heroin','Cocaine','Synthetic Drug','Other'), 3
  UNION ALL SELECT 'quantity', 'Quantity (in grams)', 'NUMBER', 1, NULL, 4
  UNION ALL SELECT 'accused_name', 'Accused Name', 'TEXT', 0, NULL, 5
  UNION ALL SELECT 'remarks', 'Remarks', 'TEXTAREA', 0, NULL, 6
) v
WHERE ct.code = 'NARCOTICS_OFFENCE'
ON DUPLICATE KEY UPDATE
  label = VALUES(label), field_type = VALUES(field_type), is_required = VALUES(is_required), options = VALUES(options), order_index = VALUES(order_index);
