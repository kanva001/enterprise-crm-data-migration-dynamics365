USE AdventureWorks2022;
GO

/*
Sprint: 2
Purpose: Validate Sales Order domain migration
Checks:
  1) Target counts
  2) Orphans (Order -> Account, Line -> Order)
  3) Duplicate checks (idempotency)
  4) Financial reconciliation (header total_due vs sum(line_total)+tax+freight)
*/

-------------------------------------------------
-- 1) Target Row Counts
-------------------------------------------------
SELECT 'tgt.sales_order' AS table_name, COUNT(*) AS row_count FROM tgt.sales_order
UNION ALL
SELECT 'tgt.sales_order_line', COUNT(*) FROM tgt.sales_order_line;

-------------------------------------------------
-- 2) Orphan Checks
-------------------------------------------------
-- Orders without valid Accounts
SELECT COUNT(*) AS orphan_orders
FROM tgt.sales_order o
LEFT JOIN tgt.account a ON o.account_id = a.account_id
WHERE a.account_id IS NULL;

-- Lines without valid Orders
SELECT COUNT(*) AS orphan_order_lines
FROM tgt.sales_order_line l
LEFT JOIN tgt.sales_order o ON l.sales_order_id = o.sales_order_id
WHERE o.sales_order_id IS NULL;

-------------------------------------------------
-- 3) Duplicate Checks
-------------------------------------------------
SELECT 'sales_order_dupes' AS check_name, COUNT(*) AS dupes
FROM (
  SELECT source_system, source_primary_key, COUNT(*) AS c
  FROM tgt.sales_order
  GROUP BY source_system, source_primary_key
  HAVING COUNT(*) > 1
) d;

SELECT 'sales_order_line_dupes' AS check_name, COUNT(*) AS dupes
FROM (
  SELECT source_system, source_primary_key, COUNT(*) AS c
  FROM tgt.sales_order_line
  GROUP BY source_system, source_primary_key
  HAVING COUNT(*) > 1
) d;

-------------------------------------------------
-- 4) Financial Reconciliation
-------------------------------------------------
;WITH line_rollup AS (
    SELECT
        o.source_primary_key AS source_sales_order_key,
        SUM(ISNULL(l.line_total,0)) AS sum_line_total
    FROM tgt.sales_order o
    JOIN tgt.sales_order_line l
        ON o.sales_order_id = l.sales_order_id
    GROUP BY o.source_primary_key
),
recon AS (
    SELECT
        o.source_primary_key AS source_sales_order_key,
        o.subtotal,
        o.tax_amount,
        o.freight,
        o.total_due,
        lr.sum_line_total,
        (ISNULL(lr.sum_line_total,0) + ISNULL(o.tax_amount,0) + ISNULL(o.freight,0)) AS computed_total,
        ABS(ISNULL(o.total_due,0) - (ISNULL(lr.sum_line_total,0) + ISNULL(o.tax_amount,0) + ISNULL(o.freight,0))) AS abs_diff
    FROM tgt.sales_order o
    LEFT JOIN line_rollup lr
        ON o.source_primary_key = lr.source_sales_order_key
)
SELECT
    COUNT(*) AS recon_issues_count
FROM recon
WHERE abs_diff > 0.01;

-- Optional: view top discrepancies if recon_issues_count > 0
SELECT TOP 20 *
FROM recon
WHERE abs_diff > 0.01
ORDER BY abs_diff DESC;
