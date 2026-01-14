USE AdventureWorks2022;
GO

;WITH ranked AS (
    SELECT
        dq_rule_id,
        rule_name,
        ROW_NUMBER() OVER (PARTITION BY rule_name ORDER BY dq_rule_id) AS rn
    FROM dq.rule_catalog
)
DELETE FROM dq.rule_catalog
WHERE dq_rule_id IN (
    SELECT dq_rule_id
    FROM ranked
    WHERE rn > 1
);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'uq_rule_catalog_rule_name'
      AND object_id = OBJECT_ID('dq.rule_catalog')
)
BEGIN
    CREATE UNIQUE INDEX uq_rule_catalog_rule_name
    ON dq.rule_catalog(rule_name);
END
GO
