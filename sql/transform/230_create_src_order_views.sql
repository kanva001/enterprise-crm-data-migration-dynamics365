USE AdventureWorks2022;
GO

/*
Sprint: 2
Purpose: Create controlled source views for Sales Orders migration
*/

-- Sales Order Header
CREATE OR ALTER VIEW src.v_sales_order AS
SELECT
    soh.SalesOrderID                 AS source_sales_order_key,
    soh.CustomerID                   AS source_customer_key,
    soh.OrderDate,
    soh.Status                       AS order_status_code,
    soh.SubTotal,
    soh.TaxAmt,
    soh.Freight,
    soh.TotalDue,
    'USD'                            AS currency_code
FROM Sales.SalesOrderHeader soh;
GO

-- Sales Order Line
CREATE OR ALTER VIEW src.v_sales_order_line AS
SELECT
    sod.SalesOrderID                 AS source_sales_order_key,
    sod.SalesOrderDetailID           AS source_sales_order_line_key,
    sod.ProductID,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal
FROM Sales.SalesOrderDetail sod;
GO
