USE AdventureWorks2022;
GO

/*
Sprint: 2
Purpose: Create staging tables for Sales Orders domain
*/

IF SCHEMA_ID('stg') IS NULL
    EXEC('CREATE SCHEMA stg');
GO

IF OBJECT_ID('stg.sales_order_extract','U') IS NULL
BEGIN
    CREATE TABLE stg.sales_order_extract (
        source_sales_order_key INT NOT NULL,
        source_customer_key INT NOT NULL,
        order_date DATE NULL,
        order_status_code INT NULL,
        subtotal DECIMAL(19,4) NULL,
        tax_amount DECIMAL(19,4) NULL,
        freight DECIMAL(19,4) NULL,
        total_due DECIMAL(19,4) NULL,
        currency_code NVARCHAR(10) NULL,
        migration_batch_id INT NOT NULL
    );
END;
GO

IF OBJECT_ID('stg.sales_order_line_extract','U') IS NULL
BEGIN
    CREATE TABLE stg.sales_order_line_extract (
        source_sales_order_key INT NOT NULL,
        source_sales_order_line_key INT NOT NULL,
        product_id INT NULL,
        order_qty INT NULL,
        unit_price DECIMAL(19,4) NULL,
        line_total DECIMAL(19,4) NULL,
        migration_batch_id INT NOT NULL
    );
END;
GO
