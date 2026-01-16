USE AdventureWorks2022;
GO

/* Verify views exist */
SELECT
    s.name AS schema_name,
    v.name AS view_name
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
WHERE s.name = 'src'
  AND v.name IN ('v_invoice_header', 'v_invoice_line')
ORDER BY v.name;
GO

/* Row counts */
SELECT 'src.v_invoice_header' AS object_name, COUNT(*) AS row_count
FROM src.v_invoice_header
UNION ALL
SELECT 'src.v_invoice_line' AS object_name, COUNT(*) AS row_count
FROM src.v_invoice_line;
GO

/* Uniqueness checks */
SELECT COUNT(*) AS header_rows,
       COUNT(DISTINCT source_invoice_key) AS distinct_invoice_keys
FROM src.v_invoice_header;
GO

SELECT COUNT(*) AS line_rows,
       COUNT(DISTINCT source_invoice_line_key) AS distinct_invoice_line_keys
FROM src.v_invoice_line;
GO

/* Join integrity: each line must match a header */
SELECT COUNT(*) AS orphan_invoice_lines
FROM src.v_invoice_line l
LEFT JOIN src.v_invoice_header h
  ON l.source_invoice_key = h.source_invoice_key
WHERE h.source_invoice_key IS NULL;
GO