USE AdventureWorks2022;
GO

/*
Sprint: 2
Entity: SalesOrder (Header)
*/

IF SCHEMA_ID('tgt') IS NULL
    EXEC('CREATE SCHEMA tgt');
GO

IF OBJECT_ID('tgt.sales_order','U') IS NULL
BEGIN
    CREATE TABLE tgt.sales_order (
        sales_order_id UNIQUEIDENTIFIER NOT NULL,
        account_id UNIQUEIDENTIFIER NOT NULL,

        order_date DATE NULL,
        order_status NVARCHAR(30) NULL,
        subtotal DECIMAL(19,4) NULL,
        tax_amount DECIMAL(19,4) NULL,
        freight DECIMAL(19,4) NULL,
        total_due DECIMAL(19,4) NULL,
        currency_code NVARCHAR(10) NULL,

        migration_batch_id INT NOT NULL,
        source_system NVARCHAR(50) NOT NULL,
        source_primary_key NVARCHAR(100) NOT NULL,

        created_utc DATETIME2 NOT NULL,
        updated_utc DATETIME2 NOT NULL,
        dq_status NVARCHAR(20) NOT NULL,

        CONSTRAINT pk_sales_order PRIMARY KEY (sales_order_id)
    );
END
GO
