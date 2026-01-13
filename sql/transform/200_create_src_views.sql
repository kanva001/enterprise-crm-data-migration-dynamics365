/*
Sprint: 1
Purpose: Create controlled source views for CRM migration
Database: AdventureWorks2022
*/

-- Accounts (BusinessEntity as account surrogate)
CREATE OR ALTER VIEW src.v_account AS
SELECT
    be.BusinessEntityID            AS source_account_key,
    p.FirstName,
    p.LastName,
    pp.PhoneNumber,
    ea.EmailAddress,
    a.City,
    sp.Name                        AS StateProvince,
    a.PostalCode,
    cr.Name                        AS CountryRegion
FROM Person.BusinessEntity be
LEFT JOIN Person.Person p
    ON be.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp
    ON p.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN Person.EmailAddress ea
    ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress bea
    ON be.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN Person.Address a
    ON bea.AddressID = a.AddressID
LEFT JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode;
GO

-- Contacts (Person as contact)
CREATE OR ALTER VIEW src.v_contact AS
SELECT
    p.BusinessEntityID             AS source_contact_key,
    p.FirstName,
    p.LastName,
    ea.EmailAddress,
    pp.PhoneNumber
FROM Person.Person p
LEFT JOIN Person.EmailAddress ea
    ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN Person.PersonPhone pp
    ON p.BusinessEntityID = pp.BusinessEntityID;
GO

-- Addresses (BusinessEntityAddress join)
CREATE OR ALTER VIEW src.v_address AS
SELECT
    bea.BusinessEntityID           AS source_account_key,
    bea.AddressID                  AS source_address_key,
    a.City,
    sp.Name                        AS StateProvince,
    a.PostalCode,
    cr.Name                        AS CountryRegion
FROM Person.BusinessEntityAddress bea
JOIN Person.Address a
    ON bea.AddressID = a.AddressID
LEFT JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode;
GO