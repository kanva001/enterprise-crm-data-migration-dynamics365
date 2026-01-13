/*
Sprint: 1
Purpose: Create staging tables for extracted source data
*/

CREATE TABLE stg.account_extract (
    source_account_key INT NOT NULL,
    first_name NVARCHAR(100) NULL,
    last_name NVARCHAR(100) NULL,
    phone NVARCHAR(50) NULL,
    email NVARCHAR(255) NULL,
    city NVARCHAR(100) NULL,
    state_province NVARCHAR(100) NULL,
    postal_code NVARCHAR(20) NULL,
    country NVARCHAR(100) NULL,
    migration_batch_id INT NOT NULL
);

CREATE TABLE stg.contact_extract (
    source_contact_key INT NOT NULL,
    first_name NVARCHAR(100) NULL,
    last_name NVARCHAR(100) NULL,
    email NVARCHAR(255) NULL,
    phone NVARCHAR(50) NULL,
    migration_batch_id INT NOT NULL
);

CREATE TABLE stg.address_extract (
    source_account_key INT NOT NULL,
    source_address_key INT NOT NULL,
    city NVARCHAR(100) NULL,
    state_province NVARCHAR(100) NULL,
    postal_code NVARCHAR(20) NULL,
    country NVARCHAR(100) NULL,
    migration_batch_id INT NOT NULL
);