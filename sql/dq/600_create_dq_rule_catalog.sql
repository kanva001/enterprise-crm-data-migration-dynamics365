USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: DQ rule catalog for auditability and ownership
*/

IF SCHEMA_ID('dq') IS NULL
    EXEC('CREATE SCHEMA dq');
GO

IF OBJECT_ID('dq.rule_catalog','U') IS NULL
BEGIN
    CREATE TABLE dq.rule_catalog (
        dq_rule_id INT IDENTITY(1,1) PRIMARY KEY,
        rule_name NVARCHAR(150) NOT NULL,
        rule_description NVARCHAR(500) NOT NULL,
        severity NVARCHAR(20) NOT NULL,          -- CRITICAL, HIGH, MEDIUM, LOW
        entity_name NVARCHAR(100) NOT NULL,      -- account, contact, address, sales_order, sales_order_line
        owner_role NVARCHAR(50) NOT NULL,        -- Data Engineer, QA, Business Analyst
        is_active BIT NOT NULL DEFAULT 1,
        created_utc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO
