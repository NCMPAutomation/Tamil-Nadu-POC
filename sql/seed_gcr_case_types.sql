-- GCR master seed (based on provided format)
-- Safe to re-run

USE police_case_db;

INSERT INTO case_types (name, code, is_active)
VALUES
  ('GCR - MURDER FOR GAIN', 'GCR_MURDER_FOR_GAIN', TRUE),
  ('GCR - DACOITY', 'GCR_DACOITY', TRUE),
  ('GCR - ROBBERY', 'GCR_ROBBERY', TRUE),
  ('GCR - GRAVE HB (DAY)', 'GCR_GRAVE_HB_DAY', TRUE),
  ('GCR - GRAVE HB (NIGHT)', 'GCR_GRAVE_HB_NIGHT', TRUE),
  ('GCR - GRAVE MAJOR THEFT', 'GCR_GRAVE_MAJOR_THEFT', TRUE),
  ('GCR - SNATCHING', 'GCR_SNATCHING', TRUE),
  ('GCR - NON GRAVE HB (DAY)', 'GCR_NON_GRAVE_HB_DAY', TRUE),
  ('GCR - NON GRAVE HB (NIGHT)', 'GCR_NON_GRAVE_HB_NIGHT', TRUE),
  ('GCR - ORDINARY THEFT', 'GCR_ORDINARY_THEFT', TRUE),
  ('GCR - VEHICLE THEFT', 'GCR_VEHICLE_THEFT', TRUE),
  ('GCR - CHEATING', 'GCR_CHEATING', TRUE),
  ('GCR - OTHER BNS CASE', 'GCR_OTHER_BNS_CASE', TRUE),
  ('GCR - NON BNS CASE', 'GCR_NON_BNS_CASE', TRUE),
  ('GCR - GOONDAS ACT', 'GCR_GOONDAS_ACT', TRUE),
  ('GCR - SECURITY ACT', 'GCR_SECURITY_ACT', TRUE),
  ('GCR - OFFICERS ON LEAVE', 'GCR_OFFICERS_ON_LEAVE', TRUE)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  is_active = VALUES(is_active);

-- Shared common field block for most crime-case formats
-- sl_no, ps_cr_no_section, do_dr_soc_cctv_details, complainant_name_phone, accused_details, pl, pr, gist_of_case

-- MURDER FOR GAIN
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'do_dr_soc_cctv_details', 'D/O, D/R, SOC & CCTV Details', 'TEXTAREA', 0, NULL, 3
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'deceased_name', 'The Deceased', 'TEXT', 1, NULL, 5
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 6
  UNION ALL SELECT 'pl', 'PL', 'TEXT', 0, NULL, 7
  UNION ALL SELECT 'pr', 'PR', 'TEXT', 0, NULL, 8
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 9
) v
WHERE ct.code = 'GCR_MURDER_FOR_GAIN'
ON DUPLICATE KEY UPDATE label=VALUES(label), field_type=VALUES(field_type), is_required=VALUES(is_required), options=VALUES(options), order_index=VALUES(order_index);

-- Template used for dacoity/robbery/hb/theft/snatching/vehicle theft/cheating
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'do_dr_soc_cctv_details', 'D/O, D/R, SOC & CCTV Details', 'TEXTAREA', 0, NULL, 3
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'victim_or_injured', 'The Injured / Victim', 'TEXT', 0, NULL, 5
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 6
  UNION ALL SELECT 'pl', 'PL', 'TEXT', 0, NULL, 7
  UNION ALL SELECT 'pr', 'PR', 'TEXT', 0, NULL, 8
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 9
) v
WHERE ct.code IN (
  'GCR_DACOITY','GCR_ROBBERY','GCR_GRAVE_HB_DAY','GCR_GRAVE_HB_NIGHT','GCR_GRAVE_MAJOR_THEFT',
  'GCR_SNATCHING','GCR_NON_GRAVE_HB_DAY','GCR_NON_GRAVE_HB_NIGHT','GCR_ORDINARY_THEFT',
  'GCR_VEHICLE_THEFT','GCR_CHEATING'
)
ON DUPLICATE KEY UPDATE label=VALUES(label), field_type=VALUES(field_type), is_required=VALUES(is_required), options=VALUES(options), order_index=VALUES(order_index);

-- OTHER BNS / NON BNS
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'sl_no' AS field_name, 'Sl No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_section_of_law', 'P.S, Cr. No. & Section Of Law', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'do_dr_soc_details', 'D/O, D/R & Soc', 'TEXTAREA', 0, NULL, 3
  UNION ALL SELECT 'complainant_name_phone', 'Name of the Complainant with Phone Number', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'victim_or_injured', 'Name of the Injured / Victim', 'TEXT', 0, NULL, 5
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 0, NULL, 6
  UNION ALL SELECT 'gist_of_case', 'Gist of the Case', 'TEXTAREA', 1, NULL, 7
) v
WHERE ct.code IN ('GCR_OTHER_BNS_CASE','GCR_NON_BNS_CASE')
ON DUPLICATE KEY UPDATE label=VALUES(label), field_type=VALUES(field_type), is_required=VALUES(is_required), options=VALUES(options), order_index=VALUES(order_index);

-- GOONDAS ACT
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'serial_no' AS field_name, 'S. No' AS label, 'NUMBER' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps_cr_no_sec', 'Ps Cr. No. & Sec', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'goondas_bdfgisv_no_date', 'Goondas / Bdfgisv No & Date', 'TEXT', 0, NULL, 3
  UNION ALL SELECT 'accused_details', 'Accused Details', 'TEXTAREA', 1, NULL, 4
  UNION ALL SELECT 'order_date', 'Order Date', 'DATE', 0, NULL, 5
  UNION ALL SELECT 'date_of_detention', 'Date Of Detention', 'DATE', 0, NULL, 6
  UNION ALL SELECT 'classification_of_mo', 'Classification Of Mo', 'TEXT', 0, NULL, 7
) v
WHERE ct.code = 'GCR_GOONDAS_ACT'
ON DUPLICATE KEY UPDATE label=VALUES(label), field_type=VALUES(field_type), is_required=VALUES(is_required), options=VALUES(options), order_index=VALUES(order_index);

-- SECURITY ACT
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
WHERE ct.code = 'GCR_SECURITY_ACT'
ON DUPLICATE KEY UPDATE label=VALUES(label), field_type=VALUES(field_type), is_required=VALUES(is_required), options=VALUES(options), order_index=VALUES(order_index);

-- OFFICERS ON LEAVE
INSERT INTO form_fields (case_type_id, field_name, label, field_type, is_required, options, order_index)
SELECT ct.id, v.field_name, v.label, v.field_type, v.is_required, v.options, v.order_index
FROM case_types ct
JOIN (
  SELECT 'range_name' AS field_name, 'RANGE' AS label, 'TEXT' AS field_type, 1 AS is_required, NULL AS options, 1 AS order_index
  UNION ALL SELECT 'ps', 'PS', 'TEXT', 1, NULL, 2
  UNION ALL SELECT 'ac_or_ins', 'AC / INS', 'DROPDOWN', 1, JSON_ARRAY('AC','INS'), 3
  UNION ALL SELECT 'officer_name', 'THE OFFICER', 'TEXT', 1, NULL, 4
  UNION ALL SELECT 'nature_of_leave', 'NATURE OF LEAVE', 'TEXT', 1, NULL, 5
  UNION ALL SELECT 'leave_from', 'FROM', 'DATE', 1, NULL, 6
  UNION ALL SELECT 'leave_to', 'TO', 'DATE', 1, NULL, 7
  UNION ALL SELECT 'due_on', 'DUE ON', 'DATE', 0, NULL, 8
  UNION ALL SELECT 'incharge_officer', 'INCHARGE OFFICER', 'TEXT', 0, NULL, 9
) v
WHERE ct.code = 'GCR_OFFICERS_ON_LEAVE'
ON DUPLICATE KEY UPDATE label=VALUES(label), field_type=VALUES(field_type), is_required=VALUES(is_required), options=VALUES(options), order_index=VALUES(order_index);
