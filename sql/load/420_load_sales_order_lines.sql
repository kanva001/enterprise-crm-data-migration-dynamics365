USE AdventureWorks2022;
GO

/*
Sprint: 2
Entity: SalesOrderLine (Detail)
Source: stg.sales_order_line_extract
Target: tgt.sales_order_line
Keys:
  - sales_order_id deterministic from source_sales_order_key
  - line_id deterministic from (order_key-line_key)
Idempotent: MERGE on (source_system, source_primary_key)
*/

DECLARE @batch_id INT = (SELECT MAX(migration_batch_id) FROM stg.sales_order_line_extract);

MERGE tgt.sales_order_line AS T
USING (
    SELECT
        ctl.fn_deterministic_guid(
            'sales_order_line',
            CONCAT(CAST(source_sales_order_key AS NVARCHAR(100)), '-', CAST(source_sales_order_line_key AS NVARCHAR(100)))
        ) AS sales_order_line_id,

        ctl.fn_deterministic_guid('sales_order', CAST(source_sales_order_key AS NVARCHAR(100))) AS sales_order_id,

        -- Not all D365 implementations store product_id as-is; we keep it as reference for this repo
        product_id,
        order_qty,
        unit_price,
        line_total,

        @batch_id AS migration_batch_id,
        'AdventureWorks2022' AS source_system,
        CONCAT(CAST(source_sales_order_key AS NVARCHAR(100)), '-', CAST(source_sales_order_line_key AS NVARCHAR(100))) AS source_primary_key,

        SYSUTCDATETIME() AS created_utc,
        SYSUTCDATETIME() AS updated_utc,
        'PASS' AS dq_status
    FROM stg.sales_order_line_extract
) AS S
ON T.source_system = S.source_system
AND T.source_primary_key = S.source_primary_key

WHEN MATCHED THEN
    UPDATE SET
        T.sales_order_id = S.sales_order_id,
        T.product_id = S.product_id,
        T.order_qty = S.order_qty,
        T.unit_price = S.unit_price,
        T.line_total = S.line_total,
        T.migration_batch_id = S.migration_batch_id,
        T.updated_utc = SYSUTCDATETIME(),
        T.dq_status = S.dq_status

WHEN NOT MATCHED THEN
    INSERT (
        sales_order_line_id, sales_order_id,
        line_number, product_id, order_qty, unit_price, line_total,
        migration_batch_id, source_system, source_primary_key,
        created_utc, updated_utc, dq_status
    )
    VALUES (
        S.sales_order_line_id, S.sales_order_id,
        NULL, S.product_id, S.order_qty, S.unit_price, S.line_total,
        S.migration_batch_id, S.source_system, S.source_primary_key,
        S.created_utc, S.updated_utc, S.dq_status
    );
GO
