/*
Purpose: Identify potential duplicate contacts by email
*/

SELECT
    EmailAddress,
    COUNT(*) AS occurrence_count
FROM Person.EmailAddress
GROUP BY EmailAddress
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;