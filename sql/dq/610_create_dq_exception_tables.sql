USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: Central exception queue and detail table
*/

IF SCHEMA_ID('dq') IS NULL
    EXEC('CREATE SCHEMA dq');
GO

IF OBJECT_ID('dq.exception','U') IS NULL
BEGIN
    CREATE TABLE dq.exception (
        dq_exception_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        migration_batch_id INT NOT NULL,
        dq_rule_id INT NOT NULL,
        entity_name NVARCHAR(100) NOT NULL,
        source_system NVARCHAR(50) NOT NULL,
        source_primary_key NVARCHAR(100) NOT NULL,
        status NVARCHAR(20) NOT NULL DEFAULT 'OPEN',     -- OPEN, TRIAGED, RESOLVED, WAIVED
        created_utc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        resolved_utc DATETIME2 NULL,
        resolution_notes NVARCHAR(500) NULL
    );
END
GO

IF OBJECT_ID('dq.exception_detail','U') IS NULL
BEGIN
    CREATE TABLE dq.exception_detail (
        dq_exception_detail_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        dq_exception_id BIGINT NOT NULL,
        field_name NVARCHAR(100) NOT NULL,
        field_value NVARCHAR(4000) NULL,
        issue_description NVARCHAR(500) NOT NULL
    );
END
GO

-- Optional: foreign key for integrity (safe to add now)
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_exception_rule'
)
BEGIN
    ALTER TABLE dq.exception
    ADD CONSTRAINT fk_exception_rule
    FOREIGN KEY (dq_rule_id) REFERENCES dq.rule_catalog(dq_rule_id);
END
GO
