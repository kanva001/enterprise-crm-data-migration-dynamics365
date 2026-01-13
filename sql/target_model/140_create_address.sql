USE AdventureWorks2022;
GO

/*
Sprint: 1
Entity: Address
Purpose: Create Dataverse-aligned target table
*/

IF SCHEMA_ID('tgt') IS NULL
    EXEC('CREATE SCHEMA tgt');
GO

IF OBJECT_ID('tgt.address','U') IS NULL
BEGIN
    CREATE TABLE tgt.address (
        address_id UNIQUEIDENTIFIER NOT NULL,
        account_id UNIQUEIDENTIFIER NOT NULL,

        address_type NVARCHAR(50),
        city NVARCHAR(100),
        state NVARCHAR(50),
        postal_code NVARCHAR(20),
        country NVARCHAR(50),

        migration_batch_id INT NOT NULL,
        source_system NVARCHAR(50) NOT NULL,
        source_primary_key NVARCHAR(100) NOT NULL,

        created_utc DATETIME2 NOT NULL,
        updated_utc DATETIME2 NOT NULL,
        dq_status NVARCHAR(20) NOT NULL,

        CONSTRAINT pk_address PRIMARY KEY (address_id)
    );
END
GO
