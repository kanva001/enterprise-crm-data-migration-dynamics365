/*
Sprint: 1
Entity: Account
Source: stg.account_extract
Target: tgt.account
Idempotent: MERGE by source_primary_key
*/

DECLARE @batch_id INT = (SELECT MAX(migration_batch_id) FROM stg.account_extract);

MERGE tgt.account AS T
USING (
    SELECT DISTINCT
        ctl.fn_deterministic_guid('account', CAST(source_account_key AS NVARCHAR(100))) AS account_id,
        CONCAT(ISNULL(NULLIF(LTRIM(RTRIM(first_name)),''),''), ' ', ISNULL(NULLIF(LTRIM(RTRIM(last_name)),''),'')) AS account_name,
        CASE 
            WHEN first_name IS NOT NULL OR last_name IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END AS account_type,
        @batch_id AS migration_batch_id,
        'AdventureWorks2022' AS source_system,
        CAST(source_account_key AS NVARCHAR(100)) AS source_primary_key,
        SYSUTCDATETIME() AS created_utc,
        SYSUTCDATETIME() AS updated_utc,
        'PASS' AS dq_status
    FROM stg.account_extract
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
    INSERT (account_id, account_name, account_type, migration_batch_id, source_system, source_primary_key, created_utc, updated_utc, dq_status)
    VALUES (S.account_id, S.account_name, S.account_type, S.migration_batch_id, S.source_system, S.source_primary_key, S.created_utc, S.updated_utc, S.dq_status);
