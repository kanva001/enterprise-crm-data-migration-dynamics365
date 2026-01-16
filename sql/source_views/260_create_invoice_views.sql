USE AdventureWorks2022;
GO

/*
Sprint 4.2
Purpose: Create authoritative source views for invoice header and invoice line constructs.
Design: Invoice is a surrogate financial document derived from Sales Order financials.
*/

IF SCHEMA_ID('src') IS NULL
    EXEC('CREATE SCHEMA src');
GO

/* Invoice Header */
CREATE OR ALTER VIEW src.v_invoice_header AS
SELECT
    CAST(soh.SalesOrderID AS INT) AS source_invoice_key,                -- surrogate invoice key
    CAST(soh.SalesOrderID AS NVARCHAR(50)) AS invoice_number,
    CAST(soh.OrderDate AS DATE) AS invoice_date,
    CASE WHEN soh.Status = 5 THEN 'Invoiced' ELSE 'Open' END AS invoice_status,
    CAST(NULL AS NVARCHAR(10)) AS currency_code,
    CAST(soh.SubTotal AS DECIMAL(19,4)) AS subtotal_amount,
    CAST(soh.TaxAmt AS DECIMAL(19,4)) AS tax_amount,
    CAST(soh.Freight AS DECIMAL(19,4)) AS freight_amount,
    CAST(soh.TotalDue AS DECIMAL(19,4)) AS total_amount,
    CAST(soh.SalesOrderID AS INT) AS source_sales_order_key,
    CAST('AdventureWorks2022' AS NVARCHAR(50)) AS source_system
FROM Sales.SalesOrderHeader soh;
GO

/* Invoice Line */
CREATE OR ALTER VIEW src.v_invoice_line AS
SELECT
    CAST(sod.SalesOrderID AS INT) AS source_invoice_key,
    CAST(CONCAT(sod.SalesOrderID, '-', sod.SalesOrderDetailID) AS NVARCHAR(100)) AS source_invoice_line_key,
    CAST(sod.SalesOrderDetailID AS INT) AS line_number,
    CAST(sod.ProductID AS INT) AS source_product_key,
    CAST(sod.OrderQty AS DECIMAL(19,4)) AS quantity,
    CAST(sod.UnitPrice AS DECIMAL(19,4)) AS unit_price,
    CAST(sod.LineTotal AS DECIMAL(19,4)) AS line_amount,
    CAST(sod.SalesOrderID AS INT) AS source_sales_order_key,
    CAST(sod.SalesOrderDetailID AS INT) AS source_sales_order_line_key,
    CAST('AdventureWorks2022' AS NVARCHAR(50)) AS source_system
FROM Sales.SalesOrderDetail sod;
GO