USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: Run DQ checks for latest migrated data and populate exception queue
Scope: account, contact, address, sales_order, sales_order_line
*/

DECLARE @latest_customer_batch INT = (SELECT MAX(migration_batch_id) FROM tgt.account);
DECLARE @latest_order_batch INT = (SELECT MAX(migration_batch_id) FROM tgt.sales_order);

-- Helper: rule ids
DECLARE @r_account_name INT = (SELECT dq_rule_id FROM dq.rule_catalog WHERE rule_name = 'ACCOUNT_NAME_REQUIRED');
DECLARE @r_contact_last INT = (SELECT dq_rule_id FROM dq.rule_catalog WHERE rule_name = 'CONTACT_LASTNAME_REQUIRED');
DECLARE @r_contact_email INT = (SELECT dq_rule_id FROM dq.rule_catalog WHERE rule_name = 'CONTACT_EMAIL_FORMAT');
DECLARE @r_address_country INT = (SELECT dq_rule_id FROM dq.rule_catalog WHERE rule_name = 'ADDRESS_COUNTRY_REQUIRED');
DECLARE @r_order_account INT = (SELECT dq_rule_id FROM dq.rule_catalog WHERE rule_name = 'ORDER_ACCOUNT_REQUIRED');
DECLARE @r_line_order INT = (SELECT dq_rule_id FROM dq.rule_catalog WHERE rule_name = 'ORDERLINE_ORDER_REQUIRED');

-- Clear OPEN exceptions for these batches to keep runs repeatable
DELETE d
FROM dq.exception_detail d
JOIN dq.exception e ON d.dq_exception_id = e.dq_exception_id
WHERE e.status = 'OPEN'
  AND (e.migration_batch_id IN (@latest_customer_batch, @latest_order_batch));

DELETE FROM dq.exception
WHERE status = 'OPEN'
  AND (migration_batch_id IN (@latest_customer_batch, @latest_order_batch));

-------------------------------------------------
-- 1) Account name required
-------------------------------------------------
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT
    @latest_customer_batch, @r_account_name, 'account', source_system, source_primary_key
FROM tgt.account
WHERE migration_batch_id = @latest_customer_batch
  AND (account_name IS NULL OR LTRIM(RTRIM(account_name)) = '');

-------------------------------------------------
-- 2) Contact last name required
-------------------------------------------------
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT
    @latest_customer_batch, @r_contact_last, 'contact', source_system, source_primary_key
FROM tgt.contact
WHERE migration_batch_id = @latest_customer_batch
  AND (last_name IS NULL OR LTRIM(RTRIM(last_name)) = '');

-------------------------------------------------
-- 3) Contact email format (if present must contain @)
-------------------------------------------------
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT
    @latest_customer_batch, @r_contact_email, 'contact', source_system, source_primary_key
FROM tgt.contact
WHERE migration_batch_id = @latest_customer_batch
  AND email IS NOT NULL
  AND email NOT LIKE '%@%';

-------------------------------------------------
-- 4) Address country required
-------------------------------------------------
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT
    @latest_customer_batch, @r_address_country, 'address', source_system, source_primary_key
FROM tgt.address
WHERE migration_batch_id = @latest_customer_batch
  AND (country IS NULL OR LTRIM(RTRIM(country)) = '');

-------------------------------------------------
-- 5) Order must resolve to valid account
-------------------------------------------------
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT
    @latest_order_batch, @r_order_account, 'sales_order', o.source_system, o.source_primary_key
FROM tgt.sales_order o
LEFT JOIN tgt.account a ON o.account_id = a.account_id
WHERE o.migration_batch_id = @latest_order_batch
  AND a.account_id IS NULL;

-------------------------------------------------
-- 6) Order line must resolve to valid order
-------------------------------------------------
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT
    @latest_order_batch, @r_line_order, 'sales_order_line', l.source_system, l.source_primary_key
FROM tgt.sales_order_line l
LEFT JOIN tgt.sales_order o ON l.sales_order_id = o.sales_order_id
WHERE l.migration_batch_id = @latest_order_batch
  AND o.sales_order_id IS NULL;

-- Summary output
SELECT dq_rule_id, entity_name, COUNT(*) AS exception_count
FROM dq.exception
WHERE status = 'OPEN'
  AND (migration_batch_id IN (@latest_customer_batch, @latest_order_batch))
GROUP BY dq_rule_id, entity_name
ORDER BY exception_count DESC;