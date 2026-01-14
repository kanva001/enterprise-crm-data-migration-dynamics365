USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: Resolve Sales.Customer.CustomerID to a BusinessEntityID for Account lookup
*/

CREATE OR ALTER VIEW src.v_customer_account_map AS
SELECT
    c.CustomerID AS source_customer_key,
    -- Person customer maps to Person.BusinessEntityID via PersonID
    CAST(c.PersonID AS INT) AS source_business_entity_id,
    'Person' AS customer_type
FROM Sales.Customer c
WHERE c.PersonID IS NOT NULL

UNION ALL

SELECT
    c.CustomerID AS source_customer_key,
    -- Store customer maps to Sales.Store.BusinessEntityID via StoreID
    CAST(s.BusinessEntityID AS INT) AS source_business_entity_id,
    'Store' AS customer_type
FROM Sales.Customer c
JOIN Sales.Store s
    ON c.StoreID = s.BusinessEntityID
WHERE c.StoreID IS NOT NULL;
GO
