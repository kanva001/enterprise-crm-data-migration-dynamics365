USE AdventureWorks2022;
GO

/*
Sprint: 2
Purpose: Create batch and stage Sales Order data
*/

DECLARE @batch_id INT;

INSERT INTO ctl.migration_batch (batch_name)
VALUES ('Sprint2_SalesOrderDomain_InitialLoad');

SET @batch_id = SCOPE_IDENTITY();

-- Clear staging for safe re-runs
DELETE FROM stg.sales_order_line_extract;
DELETE FROM stg.sales_order_extract;

-- Stage Sales Order Header
INSERT INTO stg.sales_order_extract (
    source_sales_order_key,
    source_customer_key,
    order_date,
    order_status_code,
    subtotal,
    tax_amount,
    freight,
    total_due,
    currency_code,
    migration_batch_id
)
SELECT
    source_sales_order_key,
    source_customer_key,
    OrderDate,
    order_status_code,
    SubTotal,
    tax_amount,
    Freight,
    total_due,
    currency_code,
    @batch_id
FROM src.v_sales_order;

-- Stage Sales Order Lines
INSERT INTO stg.sales_order_line_extract (
    source_sales_order_key,
    source_sales_order_line_key,
    product_id,
    order_qty,
    unit_price,
    line_total,
    migration_batch_id
)
SELECT
    source_sales_order_key,
    source_sales_order_line_key,
    product_id,
    order_qty,
    unit_price,
    line_total,
    @batch_id
FROM src.v_sales_order_line;

UPDATE ctl.migration_batch
SET end_time_utc = SYSUTCDATETIME()
WHERE migration_batch_id = @batch_id;

SELECT @batch_id AS migration_batch_id;
GO
