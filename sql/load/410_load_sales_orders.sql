USE AdventureWorks2022;
GO

/*
Sprint: 2
Entity: SalesOrder (Header)
Source: stg.sales_order_extract
Target: tgt.sales_order
Keying: deterministic GUID from source_sales_order_key
Lookup: account_id derived from source_customer_key (CustomerID)
Idempotent: MERGE on (source_system, source_primary_key)
*/

DECLARE @batch_id INT = (SELECT MAX(migration_batch_id) FROM stg.sales_order_extract);

MERGE tgt.sales_order AS T
USING (
    SELECT
        ctl.fn_deterministic_guid('sales_order', CAST(source_sales_order_key AS NVARCHAR(100))) AS sales_order_id,

        -- Account lookup strategy (enterprise assumption for this repo):
        -- Use CustomerID as the account source key namespace to maintain stable relationships.
        ctl.fn_deterministic_guid('account', CAST(source_customer_key AS NVARCHAR(100))) AS account_id,

        order_date,
        CASE order_status_code
            WHEN 1 THEN 'In Process'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Backordered'
            WHEN 4 THEN 'Rejected'
            WHEN 5 THEN 'Shipped'
            WHEN 6 THEN 'Cancelled'
            ELSE 'Unknown'
        END AS order_status,

        subtotal,
        tax_amount,
        freight,
        total_due,
        currency_code,

        @batch_id AS migration_batch_id,
        'AdventureWorks2022' AS source_system,
        CAST(source_sales_order_key AS NVARCHAR(100)) AS source_primary_key,

        SYSUTCDATETIME() AS created_utc,
        SYSUTCDATETIME() AS updated_utc,
        'PASS' AS dq_status
    FROM stg.sales_order_extract
) AS S
ON T.source_system = S.source_system
AND T.source_primary_key = S.source_primary_key

WHEN MATCHED THEN
    UPDATE SET
        T.account_id = S.account_id,
        T.order_date = S.order_date,
        T.order_status = S.order_status,
        T.subtotal = S.subtotal,
        T.tax_amount = S.tax_amount,
        T.freight = S.freight,
        T.total_due = S.total_due,
        T.currency_code = S.currency_code,
        T.migration_batch_id = S.migration_batch_id,
        T.updated_utc = SYSUTCDATETIME(),
        T.dq_status = S.dq_status

WHEN NOT MATCHED THEN
    INSERT (
        sales_order_id, account_id, order_date, order_status,
        subtotal, tax_amount, freight, total_due, currency_code,
        migration_batch_id, source_system, source_primary_key,
        created_utc, updated_utc, dq_status
    )
    VALUES (
        S.sales_order_id, S.account_id, S.order_date, S.order_status,
        S.subtotal, S.tax_amount, S.freight, S.total_due, S.currency_code,
        S.migration_batch_id, S.source_system, S.source_primary_key,
        S.created_utc, S.updated_utc, S.dq_status
    );
GO