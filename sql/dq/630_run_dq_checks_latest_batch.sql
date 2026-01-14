USE AdventureWorks2022;
GO

DECLARE @latest_customer_batch INT = (SELECT MAX(migration_batch_id) FROM tgt.account);
DECLARE @latest_order_batch INT    = (SELECT MAX(migration_batch_id) FROM tgt.sales_order);

DECLARE @r_account_name INT     = (SELECT MAX(dq_rule_id) FROM dq.rule_catalog WHERE rule_name = 'ACCOUNT_NAME_REQUIRED');
DECLARE @r_contact_last INT     = (SELECT MAX(dq_rule_id) FROM dq.rule_catalog WHERE rule_name = 'CONTACT_LASTNAME_REQUIRED');
DECLARE @r_contact_email INT    = (SELECT MAX(dq_rule_id) FROM dq.rule_catalog WHERE rule_name = 'CONTACT_EMAIL_FORMAT');
DECLARE @r_address_country INT  = (SELECT MAX(dq_rule_id) FROM dq.rule_catalog WHERE rule_name = 'ADDRESS_COUNTRY_REQUIRED');
DECLARE @r_order_account INT    = (SELECT MAX(dq_rule_id) FROM dq.rule_catalog WHERE rule_name = 'ORDER_ACCOUNT_REQUIRED');
DECLARE @r_line_order INT       = (SELECT MAX(dq_rule_id) FROM dq.rule_catalog WHERE rule_name = 'ORDERLINE_ORDER_REQUIRED');

-- Re-run repeatability: delete OPEN exceptions for these batches
DELETE d
FROM dq.exception_detail d
JOIN dq.exception e ON d.dq_exception_id = e.dq_exception_id
WHERE e.status = 'OPEN'
  AND e.migration_batch_id IN (@latest_customer_batch, @latest_order_batch);

DELETE FROM dq.exception
WHERE status = 'OPEN'
  AND migration_batch_id IN (@latest_customer_batch, @latest_order_batch);

-- Account name required
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT @latest_customer_batch, @r_account_name, 'account', source_system, source_primary_key
FROM tgt.account
WHERE migration_batch_id = @latest_customer_batch
  AND (account_name IS NULL OR LTRIM(RTRIM(account_name)) = '');

-- Contact last name required
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT @latest_customer_batch, @r_contact_last, 'contact', source_system, source_primary_key
FROM tgt.contact
WHERE migration_batch_id = @latest_customer_batch
  AND (last_name IS NULL OR LTRIM(RTRIM(last_name)) = '');

-- Contact email format
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT @latest_customer_batch, @r_contact_email, 'contact', source_system, source_primary_key
FROM tgt.contact
WHERE migration_batch_id = @latest_customer_batch
  AND email IS NOT NULL
  AND email NOT LIKE '%@%';

-- Address country required
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT @latest_customer_batch, @r_address_country, 'address', source_system, source_primary_key
FROM tgt.address
WHERE migration_batch_id = @latest_customer_batch
  AND (country IS NULL OR LTRIM(RTRIM(country)) = '');

-- Order must resolve to valid account
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT @latest_order_batch, @r_order_account, 'sales_order', o.source_system, o.source_primary_key
FROM tgt.sales_order o
LEFT JOIN tgt.account a ON o.account_id = a.account_id
WHERE o.migration_batch_id = @latest_order_batch
  AND a.account_id IS NULL;

-- Order line must resolve to valid order
INSERT INTO dq.exception (migration_batch_id, dq_rule_id, entity_name, source_system, source_primary_key)
SELECT @latest_order_batch, @r_line_order, 'sales_order_line', l.source_system, l.source_primary_key
FROM tgt.sales_order_line l
LEFT JOIN tgt.sales_order o ON l.sales_order_id = o.sales_order_id
WHERE l.migration_batch_id = @latest_order_batch
  AND o.sales_order_id IS NULL;

-- Evidence outputs
SELECT dq_rule_id, entity_name, COUNT(*) AS exception_count
FROM dq.exception
WHERE status = 'OPEN'
GROUP BY dq_rule_id, entity_name
ORDER BY exception_count DESC;

SELECT COUNT(*) AS dq_exception_total_rows FROM dq.exception;
SELECT COUNT(*) AS dq_exception_open_rows  FROM dq.exception WHERE status = 'OPEN';
GO
