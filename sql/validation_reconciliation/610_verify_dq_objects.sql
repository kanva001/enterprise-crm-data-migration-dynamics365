USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: Verify DQ framework objects exist
Expected: 3 rows (rule_catalog, exception, exception_detail)
*/

SELECT s.name AS schema_name, t.name AS table_name
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'dq'
  AND t.name IN ('rule_catalog','exception','exception_detail')
ORDER BY t.name;
GO