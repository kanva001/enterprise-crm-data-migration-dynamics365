USE AdventureWorks2022;
GO

/*
Sprint: 1
Purpose: Customer Domain Migration Validation
Entities: Account, Contact, Address
*/

-------------------------------------------------
-- 1. Target Row Counts
-------------------------------------------------
SELECT 'tgt.account' AS table_name, COUNT(*) AS row_count FROM tgt.account
UNION ALL
SELECT 'tgt.contact', COUNT(*) FROM tgt.contact
UNION ALL
SELECT 'tgt.address', COUNT(*) FROM tgt.address;

-------------------------------------------------
-- 2. Orphan Checks (Referential Integrity)
-------------------------------------------------
SELECT COUNT(*) AS orphan_contacts
FROM tgt.contact c
LEFT JOIN tgt.account a
    ON c.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS orphan_addresses
FROM tgt.address ad
LEFT JOIN tgt.account a
    ON ad.account_id = a.account_id
WHERE a.account_id IS NULL;

-------------------------------------------------
-- 3. Duplicate Checks (Idempotency)
-------------------------------------------------
SELECT 'account_dupes' AS check_name, COUNT(*) AS dupes
FROM (
    SELECT source_system, source_primary_key, COUNT(*) AS c
    FROM tgt.account
    GROUP BY source_system, source_primary_key
    HAVING COUNT(*) > 1
) d;

SELECT 'contact_dupes' AS check_name, COUNT(*) AS dupes
FROM (
    SELECT source_system, source_primary_key, COUNT(*) AS c
    FROM tgt.contact
    GROUP BY source_system, source_primary_key
    HAVING COUNT(*) > 1
) d;

SELECT 'address_dupes' AS check_name, COUNT(*) AS dupes
FROM (
    SELECT source_system, source_primary_key, COUNT(*) AS c
    FROM tgt.address
    GROUP BY source_system, source_primary_key
    HAVING COUNT(*) > 1
) d;
