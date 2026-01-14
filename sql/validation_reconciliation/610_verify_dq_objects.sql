USE AdventureWorks2022;
GO

SELECT s.name AS schema_name, t.name AS table_name
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'dq'
  AND t.name IN ('rule_catalog','exception','exception_detail')
ORDER BY t.name;
GO
