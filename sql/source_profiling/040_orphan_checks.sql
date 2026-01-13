/*
Purpose: Identify orphan sales orders without valid customers
*/

SELECT soh.SalesOrderID
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.Customer c
    ON soh.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;