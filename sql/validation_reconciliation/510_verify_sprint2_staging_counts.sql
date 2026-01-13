USE AdventureWorks2022;
GO

/*
Sprint: 2
Purpose: Verify staging row counts for Sales Orders
*/

SELECT 'stg.sales_order_extract' AS table_name, COUNT(*) AS row_count
FROM stg.sales_order_extract
UNION ALL
SELECT 'stg.sales_order_line_extract', COUNT(*)
FROM stg.sales_order_line_extract;
