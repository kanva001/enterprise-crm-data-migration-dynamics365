USE AdventureWorks2022;
GO

/*
Sprint: 1
Entity: Contact
Purpose: Create Dataverse-aligned target table
*/

IF SCHEMA_ID('tgt') IS NULL
    EXEC('CREATE SCHEMA tgt');
GO

IF OBJECT_ID('tgt.contact','U') IS NULL
BEGIN
    CREATE TABLE tgt.contact (
        contact_id UNIQUEIDENTIFIER NOT NULL,
        account_id UNIQUEIDENTIFIER NULL,

        first_name NVARCHAR(100),
        last_name NVARCHAR(100),
        email NVARCHAR(255),
        phone NVARCHAR(50),

        migration_batch_id INT NOT NULL,
        source_system NVARCHAR(50) NOT NULL,
        source_primary_key NVARCHAR(100) NOT NULL,

        created_utc DATETIME2 NOT NULL,
        updated_utc DATETIME2 NOT NULL,
        dq_status NVARCHAR(20) NOT NULL,

        CONSTRAINT pk_contact PRIMARY KEY (contact_id)
    );
END
GO
