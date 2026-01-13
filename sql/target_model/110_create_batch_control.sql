SELECT *
FROM sys.tables t
JOIN sys.schemas s
  ON t.schema_id = s.schema_id
WHERE s.name = 'ctl'
  AND t.name = 'migration_batch';
