USE AdventureWorks2022;
GO

/*
Sprint: 1
Entity: Account
Purpose: Create Dataverse-aligned target table
*/

IF SCHEMA_ID('tgt') IS NULL
    EXEC('CREATE SCHEMA tgt');
GO

IF OBJECT_ID('tgt.account','U') IS NULL
BEGIN
    CREATE TABLE tgt.account (
        account_id UNIQUEIDENTIFIER NOT NULL,
        account_name NVARCHAR(255) NOT NULL,
        account_type NVARCHAR(50) NULL,

        migration_batch_id INT NOT NULL,
        source_system NVARCHAR(50) NOT NULL,
        source_primary_key NVARCHAR(100) NOT NULL,

        created_utc DATETIME2 NOT NULL,
        updated_utc DATETIME2 NOT NULL,
        dq_status NVARCHAR(20) NOT NULL,

        CONSTRAINT pk_account PRIMARY KEY (account_id)
    );
END
GO
