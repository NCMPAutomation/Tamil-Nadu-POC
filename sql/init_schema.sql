-- Dynamic Police Case Management System
-- MySQL 8+ DDL

CREATE DATABASE IF NOT EXISTS police_case_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE police_case_db;

CREATE TABLE IF NOT EXISTS case_types (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(100) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX ix_case_types_code (code)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS form_fields (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    case_type_id BIGINT UNSIGNED NOT NULL,
    field_name VARCHAR(128) NOT NULL,
    label VARCHAR(255) NOT NULL,
    field_type ENUM('TEXT', 'NUMBER', 'DATE', 'PHONE', 'TEXTAREA', 'DROPDOWN') NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    options JSON NULL,
    order_index INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_form_fields_case_type
      FOREIGN KEY (case_type_id) REFERENCES case_types(id)
      ON DELETE CASCADE,
    UNIQUE KEY uq_form_fields_case_type_field_name (case_type_id, field_name),
    INDEX ix_form_fields_case_type_id (case_type_id),
    INDEX ix_form_fields_order_index (order_index)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS case_entries (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    case_type_id BIGINT UNSIGNED NOT NULL,
    status ENUM('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'DRAFT',
    created_by VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_case_entries_case_type
      FOREIGN KEY (case_type_id) REFERENCES case_types(id),
    INDEX ix_case_entries_case_type_id (case_type_id),
    INDEX ix_case_entries_status (status),
    INDEX ix_case_entries_created_at (created_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS case_field_values (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    case_entry_id BIGINT UNSIGNED NOT NULL,
    field_id BIGINT UNSIGNED NOT NULL,
    value TEXT NOT NULL,
    CONSTRAINT fk_case_field_values_case_entry
      FOREIGN KEY (case_entry_id) REFERENCES case_entries(id)
      ON DELETE CASCADE,
    CONSTRAINT fk_case_field_values_field
      FOREIGN KEY (field_id) REFERENCES form_fields(id),
    INDEX ix_case_field_values_case_entry_id (case_entry_id),
    INDEX ix_case_field_values_field_id (field_id)
) ENGINE=InnoDB;
