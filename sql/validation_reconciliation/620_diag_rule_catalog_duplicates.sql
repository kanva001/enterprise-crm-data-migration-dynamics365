USE AdventureWorks2022;
GO

SELECT rule_name, COUNT(*) AS cnt
FROM dq.rule_catalog
GROUP BY rule_name
HAVING COUNT(*) > 1
ORDER BY cnt DESC, rule_name;
GO
