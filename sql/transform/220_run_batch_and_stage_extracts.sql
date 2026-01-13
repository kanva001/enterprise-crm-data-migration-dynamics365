/*
Sprint: 1
Purpose: Create batch record and stage source extracts
*/

DECLARE @batch_id INT;

INSERT INTO ctl.migration_batch (batch_name)
VALUES ('Sprint1_CustomerDomain_InitialLoad');

SET @batch_id = SCOPE_IDENTITY();

-- Clear staging tables for re-run safety
DELETE FROM stg.account_extract;
DELETE FROM stg.contact_extract;
DELETE FROM stg.address_extract;

-- Stage extracts
INSERT INTO stg.account_extract (
    source_account_key, first_name, last_name, phone, email,
    city, state_province, postal_code, country, migration_batch_id
)
SELECT
    source_account_key, FirstName, LastName, PhoneNumber, EmailAddress,
    City, StateProvince, PostalCode, CountryRegion, @batch_id
FROM src.v_account;

INSERT INTO stg.contact_extract (
    source_contact_key, first_name, last_name, email, phone, migration_batch_id
)
SELECT
    source_contact_key, FirstName, LastName, EmailAddress, PhoneNumber, @batch_id
FROM src.v_contact;

INSERT INTO stg.address_extract (
    source_account_key, source_address_key, city, state_province, postal_code, country, migration_batch_id
)
SELECT
    source_account_key, source_address_key, City, StateProvince, PostalCode, CountryRegion, @batch_id
FROM src.v_address;

-- Mark batch completion timestamp (status stays STARTED until end-to-end load is done in later steps)
UPDATE ctl.migration_batch
SET end_time_utc = SYSUTCDATETIME()
WHERE migration_batch_id = @batch_id;

SELECT @batch_id AS migration_batch_id;