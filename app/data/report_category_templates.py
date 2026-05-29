from typing import Any


def field(
    field_name: str,
    label: str,
    field_type: str,
    is_required: bool,
    order_index: int,
    options: list[str] | None = None,
) -> dict[str, Any]:
    return {
        "field_name": field_name,
        "label": label,
        "field_type": field_type,
        "is_required": is_required,
        "options": options,
        "order_index": order_index,
    }


MURDER_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("incident_date", "Incident Date", "DATE", True, 3),
    field("incident_place", "Incident Place", "TEXTAREA", True, 4),
    field("victim_name", "Victim Name", "TEXT", True, 5),
    field("accused_details", "Accused Details", "TEXTAREA", False, 6),
    field("brief_facts", "Brief Facts", "TEXTAREA", True, 7),
]

MURDER_FOR_GAIN_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("incident_date", "Incident Date", "DATE", True, 3),
    field("property_taken", "Property Taken", "TEXTAREA", True, 4),
    field("estimated_value", "Estimated Value", "NUMBER", True, 5),
    field("victim_name", "Victim Name", "TEXT", True, 6),
    field("accused_details", "Accused Details", "TEXTAREA", False, 7),
    field("brief_facts", "Brief Facts", "TEXTAREA", True, 8),
]

PROPERTY_CRIME_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("do_dr_soc_cctv_details", "D/O, D/R, SOC & CCTV Details", "TEXTAREA", False, 3),
    field("complainant_name_phone", "Name of the Complainant with Phone Number", "TEXT", True, 4),
    field("victim_or_injured", "Victim / Injured", "TEXT", False, 5),
    field("accused_details", "Accused Details", "TEXTAREA", False, 6),
    field("pl", "PL", "TEXT", False, 7),
    field("pr", "PR", "TEXT", False, 8),
    field("gist_of_case", "Gist of the Case", "TEXTAREA", True, 9),
]

PERSONAL_OFFENCE_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("incident_date", "Incident Date", "DATE", True, 3),
    field("complainant_name_phone", "Name of the Complainant with Phone Number", "TEXT", True, 4),
    field("victim_or_injured", "Victim / Injured", "TEXT", False, 5),
    field("accused_details", "Accused Details", "TEXTAREA", False, 6),
    field("gist_of_case", "Gist of the Case", "TEXTAREA", True, 7),
]

SPECIAL_LAW_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("complainant_name_phone", "Name of the Complainant with Phone Number", "TEXT", True, 3),
    field("accused_details", "Accused Details", "TEXTAREA", False, 4),
    field("evidence_or_seizure_details", "Evidence / Seizure Details", "TEXTAREA", False, 5),
    field("gist_of_case", "Gist of the Case", "TEXTAREA", True, 6),
]

SECTION_194_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("date_of_incident", "Date of Incident", "DATE", True, 3),
    field("place_of_incident", "Place of Incident", "TEXTAREA", True, 4),
    field("body_identification_details", "Body Identification Details", "TEXTAREA", False, 5),
    field("post_mortem_report_no", "Post Mortem Report No.", "TEXT", False, 6),
    field("accused_details", "Accused Details", "TEXTAREA", False, 7),
    field("gist_of_case", "Gist of the Case", "TEXTAREA", True, 8),
]

MISSING_PERSON_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("missing_person_name", "Missing Person Name", "TEXT", True, 3),
    field("age", "Age", "NUMBER", False, 4),
    field("gender", "Gender", "DROPDOWN", False, 5, ["Male", "Female", "Other"]),
    field("last_seen_date", "Last Seen Date", "DATE", True, 6),
    field("last_seen_place", "Last Seen Place", "TEXTAREA", True, 7),
    field("complainant_name_phone", "Name of the Complainant with Phone Number", "TEXT", True, 8),
    field("gist_of_case", "Gist of the Case", "TEXTAREA", True, 9),
]

GOONDAS_TEMPLATE = [
    field("range_name", "RANGE", "TEXT", True, 1),
    field("ps", "PS", "TEXT", True, 2),
    field("ac_or_ins", "AC / INS", "DROPDOWN", True, 3, ["AC", "INS"]),
    field("officer_name", "THE OFFICER", "TEXT", True, 4),
    field("nature_of_leave", "NATURE OF LEAVE", "TEXT", True, 5),
    field("leave_from", "FROM", "DATE", True, 6),
    field("leave_to", "TO", "DATE", True, 7),
    field("due_on", "DUE ON", "DATE", False, 8),
    field("incharge_officer", "INCHARGE OFFICER", "TEXT", False, 9),
]

SECURITY_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_sl_no_section_of_law", "P.S, Sl. No. & Section of Law", "TEXT", True, 2),
    field("name_address_accused", "Name & Address Accused", "TEXTAREA", True, 3),
    field("previous_case", "Previous Case", "TEXTAREA", False, 4),
    field("bind_over_on", "Bind over on", "DATE", False, 5),
]

DEFAULT_TEMPLATE = [
    field("sl_no", "Sl. No", "NUMBER", True, 1),
    field("ps_cr_no_section_of_law", "P.S, Cr. No. & Section Of Law", "TEXT", True, 2),
    field("complainant_name_phone", "Name of the Complainant with Phone Number", "TEXT", True, 3),
    field("accused_details", "Accused Details", "TEXTAREA", False, 4),
    field("gist_of_case", "Gist of the Case", "TEXTAREA", True, 5),
]


CATEGORY_FORM_TEMPLATES: dict[str, list[dict[str, Any]]] = {
    "MURDER": MURDER_TEMPLATE,
    "MURDER_FOR_GAIN": MURDER_FOR_GAIN_TEMPLATE,
    "DACOITY": PROPERTY_CRIME_TEMPLATE,
    "ROBBERY": PROPERTY_CRIME_TEMPLATE,
    "GRAVE_HB_DAY": PROPERTY_CRIME_TEMPLATE,
    "GRAVE_HB_NIGHT": PROPERTY_CRIME_TEMPLATE,
    "GRAVE_MAJOR_THEFT": PROPERTY_CRIME_TEMPLATE,
    "SNATCHING": PROPERTY_CRIME_TEMPLATE,
    "NON_GRAVE_HB_DAY": PROPERTY_CRIME_TEMPLATE,
    "NON_GRAVE_HB_NIGHT": PROPERTY_CRIME_TEMPLATE,
    "ORDINARY_THEFT": PROPERTY_CRIME_TEMPLATE,
    "VEHICLE_THEFT": PROPERTY_CRIME_TEMPLATE,
    "ATTEMPT_TO_MURDER": PERSONAL_OFFENCE_TEMPLATE,
    "GRIEVOUS_HURT": PERSONAL_OFFENCE_TEMPLATE,
    "SIMPLE_HURT": PERSONAL_OFFENCE_TEMPLATE,
    "RIOTING": PERSONAL_OFFENCE_TEMPLATE,
    "ASSAULT_ON_PUBLIC_SERVANT": PERSONAL_OFFENCE_TEMPLATE,
    "POCSO_ACT": PERSONAL_OFFENCE_TEMPLATE,
    "RAPE": PERSONAL_OFFENCE_TEMPLATE,
    "DOWRY_HARASSMENT": PERSONAL_OFFENCE_TEMPLATE,
    "OTHER_BNS_CASES": SPECIAL_LAW_TEMPLATE,
    "NON_BNS_OTHER_ACTS": SPECIAL_LAW_TEMPLATE,
    "NDPS_ACT": SPECIAL_LAW_TEMPLATE,
    "TNPA_CASES": SPECIAL_LAW_TEMPLATE,
    "COTPA_CASES": SPECIAL_LAW_TEMPLATE,
    "LOTTERY_CASES": SPECIAL_LAW_TEMPLATE,
    "GAMBLING_CASES": SPECIAL_LAW_TEMPLATE,
    "OTHER_SLL_CASES_75_TNCP_ACT": SPECIAL_LAW_TEMPLATE,
    "S194_CRPC_DEATH_WITHIN_7_YEARS_OF_MARRIAGE": SECTION_194_TEMPLATE,
    "S194_SUSPICIOUS_DEATH": SECTION_194_TEMPLATE,
    "S194_BNSS_UNKNOWN_BODIES": SECTION_194_TEMPLATE,
    "MISSING_PERSON": MISSING_PERSON_TEMPLATE,
    "ELOPEMENT_CASE": MISSING_PERSON_TEMPLATE,
    "GOONDAS_ACT": GOONDAS_TEMPLATE,
    "SECURITY_ACT": SECURITY_TEMPLATE,
}
