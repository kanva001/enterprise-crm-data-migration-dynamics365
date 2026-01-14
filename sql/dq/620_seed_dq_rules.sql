USE AdventureWorks2022;
GO

/*
Sprint: 3
Purpose: Seed baseline rules for Sprint 1 and Sprint 2 entities
*/

INSERT INTO dq.rule_catalog (rule_name, rule_description, severity, entity_name, owner_role)
VALUES
('ACCOUNT_NAME_REQUIRED', 'Account name must not be null or blank', 'CRITICAL', 'account', 'Data Engineer'),
('CONTACT_LASTNAME_REQUIRED', 'Contact last name must not be null or blank', 'HIGH', 'contact', 'Data Engineer'),
('CONTACT_EMAIL_FORMAT', 'Contact email must contain @ when present', 'MEDIUM', 'contact', 'QA'),
('ADDRESS_COUNTRY_REQUIRED', 'Address country must not be null or blank', 'HIGH', 'address', 'Data Engineer'),
('ORDER_ACCOUNT_REQUIRED', 'Sales order must resolve to a valid account', 'CRITICAL', 'sales_order', 'Data Engineer'),
('ORDERLINE_ORDER_REQUIRED', 'Sales order line must resolve to a valid sales order', 'CRITICAL', 'sales_order_line', 'Data Engineer');
