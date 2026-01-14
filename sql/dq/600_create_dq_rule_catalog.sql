USE AdventureWorks2022;
GO

IF SCHEMA_ID('dq') IS NULL
    EXEC('CREATE SCHEMA dq');
GO

IF OBJECT_ID('dq.rule_catalog','U') IS NULL
BEGIN
    CREATE TABLE dq.rule_catalog (
        dq_rule_id INT IDENTITY(1,1) PRIMARY KEY,
        rule_name NVARCHAR(150) NOT NULL,
        rule_description NVARCHAR(500) NOT NULL,
        severity NVARCHAR(20) NOT NULL,
        entity_name NVARCHAR(100) NOT NULL,
        owner_role NVARCHAR(50) NOT NULL,
        is_active BIT NOT NULL DEFAULT 1,
        created_utc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO
