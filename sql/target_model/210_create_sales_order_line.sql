USE AdventureWorks2022;
GO

/*
Sprint: 2
Entity: SalesOrderLine (Detail)
*/

IF SCHEMA_ID('tgt') IS NULL
    EXEC('CREATE SCHEMA tgt');
GO

IF OBJECT_ID('tgt.sales_order_line','U') IS NULL
BEGIN
    CREATE TABLE tgt.sales_order_line (
        sales_order_line_id UNIQUEIDENTIFIER NOT NULL,
        sales_order_id UNIQUEIDENTIFIER NOT NULL,

        line_number INT NULL,
        product_id INT NULL,
        order_qty INT NULL,
        unit_price DECIMAL(19,4) NULL,
        line_total DECIMAL(19,4) NULL,

        migration_batch_id INT NOT NULL,
        source_system NVARCHAR(50) NOT NULL,
        source_primary_key NVARCHAR(100) NOT NULL,

        created_utc DATETIME2 NOT NULL,
        updated_utc DATETIME2 NOT NULL,
        dq_status NVARCHAR(20) NOT NULL,

        CONSTRAINT pk_sales_order_line PRIMARY KEY (sales_order_line_id)
    );
END
GO
