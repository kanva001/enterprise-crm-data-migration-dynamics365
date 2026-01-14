USE AdventureWorks2022;
GO

CREATE OR ALTER VIEW src.v_business_entity_accounts AS
SELECT
    p.BusinessEntityID AS source_business_entity_id,
    CONCAT(pp.FirstName, ' ', pp.LastName) AS account_name,
    'Person' AS account_type
FROM Person.Person p
JOIN Person.Person pp
  ON p.BusinessEntityID = pp.BusinessEntityID

UNION ALL

SELECT
    s.BusinessEntityID AS source_business_entity_id,
    s.Name AS account_name,
    'Organization' AS account_type
FROM Sales.Store s;
GO
