USE AdventureWorks2022;
GO

MERGE dq.rule_catalog AS T
USING (VALUES
('ACCOUNT_NAME_REQUIRED',      'Account name must not be null or blank',                     'CRITICAL', 'account',          'Data Engineer'),
('CONTACT_LASTNAME_REQUIRED',  'Contact last name must not be null or blank',                'HIGH',     'contact',          'Data Engineer'),
('CONTACT_EMAIL_FORMAT',       'Contact email must contain @ when present',                  'MEDIUM',   'contact',          'QA'),
('ADDRESS_COUNTRY_REQUIRED',   'Address country must not be null or blank',                  'HIGH',     'address',          'Data Engineer'),
('ORDER_ACCOUNT_REQUIRED',     'Sales order must resolve to a valid account',                'CRITICAL', 'sales_order',      'Data Engineer'),
('ORDERLINE_ORDER_REQUIRED',   'Sales order line must resolve to a valid sales order',       'CRITICAL', 'sales_order_line', 'Data Engineer')
) AS S(rule_name, rule_description, severity, entity_name, owner_role)
ON T.rule_name = S.rule_name
WHEN MATCHED THEN
    UPDATE SET
        T.rule_description = S.rule_description,
        T.severity = S.severity,
        T.entity_name = S.entity_name,
        T.owner_role = S.owner_role,
        T.is_active = 1
WHEN NOT MATCHED THEN
    INSERT (rule_name, rule_description, severity, entity_name, owner_role, is_active)
    VALUES (S.rule_name, S.rule_description, S.severity, S.entity_name, S.owner_role, 1);
GO
