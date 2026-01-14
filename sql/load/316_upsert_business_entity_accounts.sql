USE AdventureWorks2022;
GO

DECLARE @batch_id INT = (SELECT MAX(migration_batch_id) FROM tgt.sales_order);

MERGE tgt.account AS T
USING (
    SELECT
        ctl.fn_deterministic_guid('account', CAST(source_business_entity_id AS NVARCHAR(100))) AS account_id,
        account_name,
        account_type,
        @batch_id AS migration_batch_id,
        'AdventureWorks2022' AS source_system,
        CAST(source_business_entity_id AS NVARCHAR(100)) AS source_primary_key,
        SYSUTCDATETIME() AS created_utc,
        SYSUTCDATETIME() AS updated_utc,
        'PASS' AS dq_status
    FROM src.v_business_entity_accounts
) AS S
ON T.source_system = S.source_system
AND T.source_primary_key = S.source_primary_key

WHEN MATCHED THEN
  UPDATE SET
    T.account_name = S.account_name,
    T.account_type = S.account_type,
    T.migration_batch_id = S.migration_batch_id,
    T.updated_utc = SYSUTCDATETIME(),
    T.dq_status = S.dq_status

WHEN NOT MATCHED THEN
  INSERT (
      account_id, account_name, account_type,
      migration_batch_id, source_system, source_primary_key,
      created_utc, updated_utc, dq_status
  )
  VALUES (
      S.account_id, S.account_name, S.account_type,
      S.migration_batch_id, S.source_system, S.source_primary_key,
      S.created_utc, S.updated_utc, S.dq_status
  );
GO
