/*
Purpose: Identify null risks in critical CRM attributes
*/

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN FirstName IS NULL THEN 1 ELSE 0 END) AS null_first_name,
    SUM(CASE WHEN LastName IS NULL THEN 1 ELSE 0 END) AS null_last_name,
    SUM(CASE WHEN EmailPromotion IS NULL THEN 1 ELSE 0 END) AS null_email_flag
FROM Person.Person;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN EmailAddress IS NULL THEN 1 ELSE 0 END) AS null_email
FROM Person.EmailAddress;