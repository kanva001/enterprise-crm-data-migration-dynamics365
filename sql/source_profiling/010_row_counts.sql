/* 
Purpose: Establish baseline row counts for in-scope CRM entities
Database: AdventureWorks2022
Sprint: 0
*/

SELECT 'Customer' AS entity_name, COUNT(*) AS row_count
FROM Sales.Customer

UNION ALL

SELECT 'Person' AS entity_name, COUNT(*) AS row_count
FROM Person.Person

UNION ALL

SELECT 'BusinessEntityAddress' AS entity_name, COUNT(*) AS row_count
FROM Person.BusinessEntityAddress

UNION ALL

SELECT 'Address' AS entity_name, COUNT(*) AS row_count
FROM Person.Address

UNION ALL

SELECT 'SalesOrderHeader' AS entity_name, COUNT(*) AS row_count
FROM Sales.SalesOrderHeader

UNION ALL

SELECT 'SalesOrderDetail' AS entity_name, COUNT(*) AS row_count
FROM Sales.SalesOrderDetail;