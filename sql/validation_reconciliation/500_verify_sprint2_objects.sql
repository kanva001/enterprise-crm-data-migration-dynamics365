USE AdventureWorks2022;
GO

/*
Sprint: 2
Purpose: Verify Sprint 2 required objects exist before staging and loading
*/

-- 1) Verify required schemas exist
SELECT name AS schema_name
FROM sys.schemas
WHERE name IN ('src','stg','tgt','ctl','dq')
ORDER BY name;

-- 2) Verify required target tables exist
SELECT s.name AS schema_name, t.name AS table_name
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'tgt'
  AND t.name IN ('sales_order','sales_order_line','account','contact','address')
ORDER BY t.name;

-- 3) Verify required source views exist (Sprint 2)
SELECT SCHEMA_NAME(v.schema_id) AS schema_name, v.name AS view_name
FROM sys.views v
WHERE SCHEMA_NAME(v.schema_id) = 'src'
  AND v.name IN ('v_sales_order','v_sales_order_line')
ORDER BY v.name;

-- 4) Verify required staging tables exist (Sprint 2)
SELECT s.name AS schema_name, t.name AS table_name
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'stg'
  AND t.name IN ('sales_order_extract','sales_order_line_extract')
ORDER BY t.name;

-- 5) Verify deterministic GUID function exists
SELECT OBJECT_ID('ctl.fn_deterministic_guid') AS fn_object_id;
