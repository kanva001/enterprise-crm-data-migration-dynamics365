USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: Remediate tgt.sales_order.account_id using authoritative source tables
Source of truth:
  Sales.SalesOrderHeader.CustomerID
  Sales.Customer.PersonID -> Person.BusinessEntityID
  Sales.Customer.StoreID -> Sales.Store.BusinessEntityID
Target:
  tgt.sales_order.account_id must match tgt.account.account_id keying:
  ctl.fn_deterministic_guid('account', BusinessEntityID)
*/

;WITH customer_map AS (
    -- Person customers
    SELECT
        c.CustomerID AS source_customer_key,
        p.BusinessEntityID AS business_entity_id
    FROM Sales.Customer c
    JOIN Person.Person p
      ON c.PersonID = p.BusinessEntityID
    WHERE c.PersonID IS NOT NULL

    UNION ALL

    -- Store customers
    SELECT
        c.CustomerID AS source_customer_key,
        s.BusinessEntityID AS business_entity_id
    FROM Sales.Customer c
    JOIN Sales.Store s
      ON c.StoreID = s.BusinessEntityID
    WHERE c.StoreID IS NOT NULL
),
map_dedup AS (
    SELECT
        source_customer_key,
        business_entity_id,
        ROW_NUMBER() OVER (
            PARTITION BY source_customer_key
            ORDER BY business_entity_id
        ) AS rn
    FROM customer_map
),
order_map AS (
    SELECT
        soh.SalesOrderID AS source_sales_order_key,
        m.business_entity_id
    FROM Sales.SalesOrderHeader soh
    LEFT JOIN map_dedup m
      ON soh.CustomerID = m.source_customer_key
     AND m.rn = 1
)
UPDATE o
SET
    o.account_id = ctl.fn_deterministic_guid('account', CAST(om.business_entity_id AS NVARCHAR(100))),
    o.updated_utc = SYSUTCDATETIME(),
    o.dq_status = CASE WHEN om.business_entity_id IS NULL THEN 'FAIL' ELSE 'PASS' END
FROM tgt.sales_order o
JOIN order_map om
  ON TRY_CONVERT(INT, o.source_primary_key) = om.source_sales_order_key;
GO
