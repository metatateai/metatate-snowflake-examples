-- AcmeCloud Metatate demo fixture
--
-- This script is for demo and example environments. It creates synthetic
-- AcmeCloud tables and seeds Metatate's serving tables so the canonical
-- CORE.* tools return deterministic results.
--
-- For production, deploy policies through Metatate instead of direct fixture
-- inserts into app_data.*.

SET SETUP_ROLE = 'NAC';
SET SETUP_WAREHOUSE = 'COMPUTE_WH';
SET APP_NAME = 'METATATE_APP';
SET DEMO_DATABASE = 'ACMECLOUD_DEMO';
SET DEMO_SCHEMA = 'PUBLIC';
SET DEMO_SCHEMA_FQN = $DEMO_DATABASE || '.' || $DEMO_SCHEMA;
SET CUSTOMERS_TABLE = $DEMO_SCHEMA_FQN || '.CUSTOMERS';
SET SUBSCRIPTIONS_TABLE = $DEMO_SCHEMA_FQN || '.SUBSCRIPTIONS';
SET EVENTS_TABLE = $DEMO_SCHEMA_FQN || '.PRODUCT_USAGE_EVENTS';
SET SUPPORT_TABLE = $DEMO_SCHEMA_FQN || '.SUPPORT_TICKETS';
SET EXPORTS_TABLE = $DEMO_SCHEMA_FQN || '.CUSTOMER_EXPORTS';

USE ROLE IDENTIFIER($SETUP_ROLE);
USE WAREHOUSE IDENTIFIER($SETUP_WAREHOUSE);

CREATE DATABASE IF NOT EXISTS IDENTIFIER($DEMO_DATABASE);
CREATE SCHEMA IF NOT EXISTS IDENTIFIER($DEMO_SCHEMA_FQN);

CREATE OR REPLACE TABLE IDENTIFIER($CUSTOMERS_TABLE) (
    CUSTOMER_ID NUMBER,
    ACCOUNT_ID VARCHAR,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    REGION VARCHAR,
    COUNTRY VARCHAR,
    ACCOUNT_STATUS VARCHAR,
    MARKETING_CONSENT VARCHAR,
    SIGNUP_DATE DATE,
    ARR NUMBER(12, 2)
);

INSERT INTO IDENTIFIER($CUSTOMERS_TABLE)
    (CUSTOMER_ID, ACCOUNT_ID, CUSTOMER_NAME, EMAIL, REGION, COUNTRY, ACCOUNT_STATUS, MARKETING_CONSENT, SIGNUP_DATE, ARR)
VALUES
    (101, 'A-1001', 'Ava Patel', 'ava.patel@example.com', 'NA', 'US', 'active', 'analytics_only', '2024-01-12', 84000),
    (102, 'A-1002', 'Mateo Garcia', 'mateo.garcia@example.com', 'EU', 'DE', 'active', 'analytics_only', '2024-02-03', 126000),
    (103, 'A-1003', 'Lina Chen', 'lina.chen@example.com', 'NA', 'US', 'review', 'support_only', '2024-03-18', 42000),
    (104, 'A-1004', 'Nora Jensen', 'nora.jensen@example.com', 'EU', 'DK', 'active', 'opted_out', '2024-05-22', 99000),
    (105, 'A-1005', 'Sam Rivera', 'sam.rivera@example.com', 'CA', 'CA', 'active', 'analytics_only', '2025-01-09', 57000);

CREATE OR REPLACE TABLE IDENTIFIER($SUBSCRIPTIONS_TABLE) (
    SUBSCRIPTION_ID VARCHAR,
    ACCOUNT_ID VARCHAR,
    PLAN_NAME VARCHAR,
    ARR NUMBER(12, 2),
    START_DATE DATE,
    RENEWAL_DATE DATE,
    STATUS VARCHAR,
    REGION VARCHAR
);

INSERT INTO IDENTIFIER($SUBSCRIPTIONS_TABLE)
    (SUBSCRIPTION_ID, ACCOUNT_ID, PLAN_NAME, ARR, START_DATE, RENEWAL_DATE, STATUS, REGION)
VALUES
    ('S-5001', 'A-1001', 'Enterprise', 84000, '2024-01-15', '2027-01-15', 'active', 'NA'),
    ('S-5002', 'A-1002', 'Enterprise', 126000, '2024-02-07', '2027-02-07', 'active', 'EU'),
    ('S-5003', 'A-1003', 'Team', 42000, '2024-03-20', '2026-09-20', 'review', 'NA'),
    ('S-5004', 'A-1004', 'Scale', 99000, '2024-05-25', '2027-05-25', 'active', 'EU'),
    ('S-5005', 'A-1005', 'Team', 57000, '2025-01-12', '2027-01-12', 'active', 'CA');

CREATE OR REPLACE TABLE IDENTIFIER($EVENTS_TABLE) (
    EVENT_ID NUMBER,
    CUSTOMER_ID NUMBER,
    EVENT_TYPE VARCHAR,
    EVENT_TS TIMESTAMP_NTZ,
    FEATURE_NAME VARCHAR,
    DEVICE_ID VARCHAR,
    REGION VARCHAR
);

INSERT INTO IDENTIFIER($EVENTS_TABLE)
    (EVENT_ID, CUSTOMER_ID, EVENT_TYPE, EVENT_TS, FEATURE_NAME, DEVICE_ID, REGION)
VALUES
    (1, 101, 'login', '2026-04-20 09:15:00', 'dashboard', 'device-us-001', 'NA'),
    (2, 102, 'export', '2026-04-22 16:44:00', 'report_builder', 'device-eu-002', 'EU'),
    (3, 103, 'support_view', '2026-04-24 12:30:00', 'case_console', 'device-us-003', 'NA'),
    (4, 104, 'login', '2026-04-25 08:11:00', 'dashboard', 'device-eu-004', 'EU'),
    (5, 105, 'workflow_run', '2026-04-27 14:02:00', 'automation', 'device-ca-005', 'CA');

CREATE OR REPLACE TABLE IDENTIFIER($SUPPORT_TABLE) (
    TICKET_ID VARCHAR,
    CUSTOMER_ID NUMBER,
    PRIORITY VARCHAR,
    CREATED_AT TIMESTAMP_NTZ,
    REGION VARCHAR,
    TICKET_TEXT VARCHAR
);

INSERT INTO IDENTIFIER($SUPPORT_TABLE)
    (TICKET_ID, CUSTOMER_ID, PRIORITY, CREATED_AT, REGION, TICKET_TEXT)
VALUES
    ('T-7001', 101, 'medium', '2026-04-21 10:12:00', 'NA', 'Customer asked why renewal report includes personal contact email.'),
    ('T-7002', 102, 'high', '2026-04-23 09:40:00', 'EU', 'Customer requested account export for regional privacy review.'),
    ('T-7003', 103, 'low', '2026-04-25 13:18:00', 'NA', 'Customer asked about invoice history and user access.'),
    ('T-7004', 104, 'high', '2026-04-26 16:50:00', 'EU', 'Customer reported unwanted marketing outreach after opting out.');

CREATE OR REPLACE TABLE IDENTIFIER($EXPORTS_TABLE) (
    EXPORT_ID VARCHAR,
    CUSTOMER_ID NUMBER,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    ACCOUNT_STATUS VARCHAR,
    EXPORT_BATCH_ID VARCHAR,
    DESTINATION_SYSTEM VARCHAR
);

INSERT INTO IDENTIFIER($EXPORTS_TABLE)
    (EXPORT_ID, CUSTOMER_ID, CUSTOMER_NAME, EMAIL, ACCOUNT_STATUS, EXPORT_BATCH_ID, DESTINATION_SYSTEM)
VALUES
    ('E-9001', 101, 'Ava Patel', 'ava.patel@example.com', 'active', 'batch-demo-001', 'SALESFORCE'),
    ('E-9002', 102, 'Mateo Garcia', 'mateo.garcia@example.com', 'active', 'batch-demo-001', 'SALESFORCE'),
    ('E-9003', 104, 'Nora Jensen', 'nora.jensen@example.com', 'active', 'batch-demo-002', 'ADS_PLATFORM');

USE APPLICATION IDENTIFIER($APP_NAME);

DELETE FROM app_data.governance_decision_log
WHERE table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.deployed_transfer_rules
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.deployed_validation_rules
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.deployed_data_meaning
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.deployed_usage_rules
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.deployed_column_details
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.deployed_instructions
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);
DELETE FROM app_data.governed_tables
WHERE full_table_name IN ($CUSTOMERS_TABLE, $SUBSCRIPTIONS_TABLE, $EVENTS_TABLE, $SUPPORT_TABLE, $EXPORTS_TABLE);

INSERT INTO app_data.governed_tables (
    full_table_name, database_name, schema_name, table_name, sensitivity,
    enforcement_mode, policy_count, policy_ids, policy_names, tags,
    compliance_frameworks, has_pii, pii_column_count, is_classified,
    classified_column_count, domain, owner
)
WITH governed_rows (
    full_table_name, table_name, sensitivity, enforcement_mode, policy_count,
    policy_ids_json, policy_names_json, tags_json, controls_json,
    has_pii, pii_column_count, classified_column_count, domain, owner
) AS (
    SELECT * FROM VALUES
    (
        $CUSTOMERS_TABLE, 'CUSTOMERS', 'confidential', 'enforce', 2,
        '["acme-customer-use","acme-transfer"]',
        '["Customer Use Guardrails","Transfer Guardrails"]',
        '["acmecloud","customer","privacy_sensitive"]',
        '["privacy_sensitive","restricted_transfer","ai_training_blocked"]',
        TRUE, 3, 5, 'Customer Data', 'Revenue Operations'
    ),
    (
        $SUBSCRIPTIONS_TABLE, 'SUBSCRIPTIONS', 'internal', 'advisory', 1,
        '["acme-retention"]',
        '["Revenue Retention Guardrails"]',
        '["acmecloud","revenue"]',
        '["commercial_sensitive","retention_required"]',
        FALSE, 0, 4, 'Revenue Operations', 'Finance Analytics'
    ),
    (
        $EVENTS_TABLE, 'PRODUCT_USAGE_EVENTS', 'internal', 'monitor', 1,
        '["acme-customer-use"]',
        '["Customer Use Guardrails"]',
        '["acmecloud","behavioral_events"]',
        '["privacy_sensitive","retention_required"]',
        TRUE, 1, 3, 'Product Analytics', 'Product Analytics'
    ),
    (
        $SUPPORT_TABLE, 'SUPPORT_TICKETS', 'confidential', 'enforce', 1,
        '["acme-customer-use"]',
        '["Customer Use Guardrails"]',
        '["acmecloud","support"]',
        '["privacy_sensitive","ai_training_blocked"]',
        TRUE, 2, 3, 'Customer Data', 'Support Operations'
    ),
    (
        $EXPORTS_TABLE, 'CUSTOMER_EXPORTS', 'restricted', 'enforce', 1,
        '["acme-transfer"]',
        '["Transfer Guardrails"]',
        '["acmecloud","exports","privacy_sensitive"]',
        '["restricted_transfer","privacy_sensitive"]',
        TRUE, 2, 4, 'Customer Data', 'Data Platform'
    )
)
SELECT
    full_table_name, $DEMO_DATABASE, $DEMO_SCHEMA, table_name, sensitivity,
    enforcement_mode, policy_count, PARSE_JSON(policy_ids_json),
    PARSE_JSON(policy_names_json), PARSE_JSON(tags_json),
    PARSE_JSON(controls_json), has_pii, pii_column_count, TRUE,
    classified_column_count, domain, owner
FROM governed_rows;

INSERT INTO app_data.deployed_instructions (
    id, full_table_name, policy_id, policy_name, instruction_type, category,
    enforcement_mode, title, description, priority, weight, parameters, scope
)
WITH instruction_rows (
    id, full_table_name, policy_id, policy_name, instruction_type, category,
    enforcement_mode, title, description, priority, weight, parameters_json, scope_json
) AS (
    SELECT * FROM VALUES
    (
        'acme-customers-allow-analytics', $CUSTOMERS_TABLE, 'acme-customer-use',
        'Customer Use Guardrails', 'data_handling', 'governance', 'enforce',
        'Allow customer analytics',
        'Customer data may be used for analytics and reporting when sensitive columns are minimized or masked.',
        'high', 0.75, '{"uses":["analytics","reporting"]}', '{"level":"table"}'
    ),
    (
        'acme-customers-deny-marketing', $CUSTOMERS_TABLE, 'acme-customer-use',
        'Customer Use Guardrails', 'data_handling', 'governance', 'enforce',
        'Block direct marketing use',
        'Customer PII must not be used for advertising, personalization, or direct marketing workflows.',
        'critical', 0.95, '{"uses":["marketing","advertising","personalization"]}', '{"level":"table"}'
    ),
    (
        'acme-customers-block-training', $CUSTOMERS_TABLE, 'acme-customer-use',
        'Customer Use Guardrails', 'ai_governance', 'governance', 'enforce',
        'Block model training on customer PII',
        'Customer PII is not approved for model training.',
        'critical', 0.90, '{"allowTraining":false,"allowInference":true}', '{"level":"table"}'
    ),
    (
        'acme-customers-transfer-conditions', $CUSTOMERS_TABLE, 'acme-transfer',
        'Transfer Guardrails', 'transfer_governance', 'governance', 'enforce',
        'Require controls before customer export',
        'Customer exports require approval and anonymization when sent to approved external systems.',
        'critical', 0.90, '{"requires_approval":true,"requires_anonymization":true}', '{"level":"table"}'
    ),
    (
        'acme-subscriptions-retention', $SUBSCRIPTIONS_TABLE, 'acme-retention',
        'Revenue Retention Guardrails', 'retention', 'governance', 'advisory',
        'Keep subscription facts for reporting',
        'Subscription facts may be used for reporting and retained for finance analytics.',
        'medium', 0.45, '{"period":"5 years","action":"archive"}', '{"level":"table"}'
    ),
    (
        'acme-events-monitor', $EVENTS_TABLE, 'acme-customer-use',
        'Customer Use Guardrails', 'usage_guidance', 'governance', 'monitor',
        'Monitor behavioral event use',
        'Behavioral events should be used only for product analytics and support workflows.',
        'medium', 0.60, '{"uses":["product_analytics","support"]}', '{"level":"table"}'
    ),
    (
        'acme-support-block-training', $SUPPORT_TABLE, 'acme-customer-use',
        'Customer Use Guardrails', 'ai_governance', 'governance', 'enforce',
        'Block model training on support text',
        'Support text is not approved for model training.',
        'critical', 0.92, '{"allowTraining":false,"allowInference":true}', '{"level":"table"}'
    ),
    (
        'acme-exports-transfer', $EXPORTS_TABLE, 'acme-transfer',
        'Transfer Guardrails', 'transfer_governance', 'governance', 'enforce',
        'Review prepared export files',
        'Prepared customer export files require transfer approval before leaving Snowflake.',
        'critical', 0.95, '{"requires_approval":true}', '{"level":"table"}'
    )
)
SELECT
    id, full_table_name, policy_id, policy_name, instruction_type, category,
    enforcement_mode, title, description, priority, weight,
    PARSE_JSON(parameters_json), PARSE_JSON(scope_json)
FROM instruction_rows;

INSERT INTO app_data.deployed_usage_rules (
    full_table_name, rule_type, rule_data, policy_id, policy_name,
    enforcement_mode, priority, weight, instruction_id
)
WITH usage_rows (
    full_table_name, rule_type, rule_data_json, policy_id, policy_name,
    enforcement_mode, priority, weight, instruction_id
) AS (
    SELECT * FROM VALUES
    (
        $CUSTOMERS_TABLE, 'permitted_use',
        '{"uses":["analytics","reporting"],"effect":"allow","scope":{"level":"table","columns":null}}',
        'acme-customer-use', 'Customer Use Guardrails',
        'enforce', 'high', 0.75, 'acme-customers-allow-analytics'
    ),
    (
        $CUSTOMERS_TABLE, 'prohibited_use',
        '{"uses":["marketing","advertising","personalization"],"effect":"deny","scope":{"level":"table","columns":null}}',
        'acme-customer-use', 'Customer Use Guardrails',
        'enforce', 'critical', 0.95, 'acme-customers-deny-marketing'
    ),
    (
        $CUSTOMERS_TABLE, 'ai_governance',
        '{"allowTraining":false,"allowInference":true,"effect":"deny","scope":{"level":"table","columns":null}}',
        'acme-customer-use', 'Customer Use Guardrails',
        'enforce', 'critical', 0.90, 'acme-customers-block-training'
    ),
    (
        $SUBSCRIPTIONS_TABLE, 'permitted_use',
        '{"uses":["analytics","reporting","renewal_planning"],"effect":"allow","scope":{"level":"table","columns":null}}',
        'acme-retention', 'Revenue Retention Guardrails',
        'advisory', 'medium', 0.45, 'acme-subscriptions-retention'
    ),
    (
        $EVENTS_TABLE, 'permitted_use',
        '{"uses":["product_analytics","support"],"effect":"allow","scope":{"level":"table","columns":null}}',
        'acme-customer-use', 'Customer Use Guardrails',
        'monitor', 'medium', 0.60, 'acme-events-monitor'
    ),
    (
        $SUPPORT_TABLE, 'permitted_use',
        '{"uses":["support","analytics"],"effect":"allow","scope":{"level":"table","columns":null}}',
        'acme-customer-use', 'Customer Use Guardrails',
        'enforce', 'high', 0.70, 'acme-events-monitor'
    ),
    (
        $SUPPORT_TABLE, 'ai_governance',
        '{"allowTraining":false,"allowInference":true,"effect":"deny","scope":{"level":"table","columns":null}}',
        'acme-customer-use', 'Customer Use Guardrails',
        'enforce', 'critical', 0.92, 'acme-support-block-training'
    ),
    (
        $EXPORTS_TABLE, 'permitted_use',
        '{"uses":["external_sharing"],"effect":"allow","scope":{"level":"table","columns":null}}',
        'acme-transfer', 'Transfer Guardrails',
        'enforce', 'critical', 0.95, 'acme-exports-transfer'
    )
)
SELECT
    full_table_name, rule_type, PARSE_JSON(rule_data_json), policy_id, policy_name,
    enforcement_mode, priority, weight, instruction_id
FROM usage_rows;

INSERT INTO app_data.deployed_transfer_rules (
    full_table_name, rule_id, effect, operations, destination_systems,
    destination_jurisdictions, consumer_jurisdictions, requires_approval,
    requires_anonymization, policy_id, policy_name, enforcement_mode, priority,
    weight, instruction_id
)
WITH transfer_rows (
    full_table_name, rule_id, effect, operations_json, systems_json,
    destination_jurisdictions_json, consumer_jurisdictions_json, requires_approval,
    requires_anonymization, policy_id, policy_name, enforcement_mode, priority,
    weight, instruction_id
) AS (
    SELECT * FROM VALUES
    (
        $CUSTOMERS_TABLE, 'acme-transfer-salesforce-conditional', 'conditional',
        '["EXPORT"]', '["SALESFORCE"]', '["US"]', '["EU"]',
        TRUE, TRUE, 'acme-transfer', 'Transfer Guardrails',
        'enforce', 'critical', 0.90, 'acme-customers-transfer-conditions'
    ),
    (
        $CUSTOMERS_TABLE, 'acme-transfer-ad-platform-deny', 'deny',
        '["EXPORT"]', '["ADS_PLATFORM"]', '["US"]', '["US"]',
        FALSE, FALSE, 'acme-transfer', 'Transfer Guardrails',
        'enforce', 'critical', 0.95, 'acme-customers-transfer-conditions'
    ),
    (
        $CUSTOMERS_TABLE, 'acme-transfer-external-llm-deny', 'deny',
        '["EXPORT"]', '["EXTERNAL_LLM_VENDOR"]', '["US"]', '["US"]',
        FALSE, FALSE, 'acme-transfer', 'Transfer Guardrails',
        'enforce', 'critical', 0.95, 'acme-customers-transfer-conditions'
    ),
    (
        $EXPORTS_TABLE, 'acme-export-salesforce-conditional', 'conditional',
        '["EXPORT"]', '["SALESFORCE"]', '["US"]', '["EU"]',
        TRUE, TRUE, 'acme-transfer', 'Transfer Guardrails',
        'enforce', 'critical', 0.95, 'acme-exports-transfer'
    )
)
SELECT
    full_table_name, rule_id, effect, PARSE_JSON(operations_json),
    PARSE_JSON(systems_json), PARSE_JSON(destination_jurisdictions_json),
    PARSE_JSON(consumer_jurisdictions_json), requires_approval,
    requires_anonymization, policy_id, policy_name, enforcement_mode, priority,
    weight, instruction_id
FROM transfer_rows;

INSERT INTO app_data.deployed_validation_rules (
    full_table_name, rule_type, rule_id, enforcement_mode, priority,
    weight, rule_config, policy_id, policy_name
)
WITH validation_rows (
    full_table_name, rule_type, rule_id, enforcement_mode, priority,
    weight, rule_config_json, policy_id, policy_name
) AS (
    SELECT * FROM VALUES
    (
        $CUSTOMERS_TABLE, 'column_masking', 'acme-mask-email', 'enforce',
        'high', 0.80, '{"columns":["EMAIL"],"type":"partial_mask"}',
        'acme-customer-use', 'Customer Use Guardrails'
    ),
    (
        $CUSTOMERS_TABLE, 'row_access', 'acme-region-minimization', 'monitor',
        'medium', 0.55, '{"filter":"REGION","purpose":"regional minimization"}',
        'acme-customer-use', 'Customer Use Guardrails'
    ),
    (
        $CUSTOMERS_TABLE, 'ai_restriction', 'acme-ai-training-block', 'enforce',
        'critical', 0.90, '{"scope":"ml_training"}',
        'acme-customer-use', 'Customer Use Guardrails'
    ),
    (
        $SUPPORT_TABLE, 'ai_restriction', 'acme-support-training-block', 'enforce',
        'critical', 0.92, '{"scope":"ml_training"}',
        'acme-customer-use', 'Customer Use Guardrails'
    ),
    (
        $EXPORTS_TABLE, 'export_review', 'acme-export-review', 'enforce',
        'critical', 0.95, '{"requires_approval":true,"requires_anonymization":true}',
        'acme-transfer', 'Transfer Guardrails'
    )
)
SELECT
    full_table_name, rule_type, rule_id, enforcement_mode, priority,
    weight, PARSE_JSON(rule_config_json), policy_id, policy_name
FROM validation_rows;

INSERT INTO app_data.deployed_column_details (
    full_table_name, column_name, data_type_id, data_type_label,
    classification_sensitivity, classification_confidence, classification_source,
    policy_sensitivity, data_category, subcategory, masking_type, masking_config,
    exempt_roles, policy_id, policy_name, source_policy_ids, source_instruction_ids,
    effective_sensitivity, is_pii
)
WITH column_rows (
    full_table_name, column_name, data_type_id, data_type_label,
    classification_sensitivity, confidence, data_category, subcategory,
    masking_type, masking_config_json, exempt_roles_json, policy_id, policy_name,
    source_policy_ids_json, source_instruction_ids_json, effective_sensitivity, is_pii
) AS (
    SELECT * FROM VALUES
    ($CUSTOMERS_TABLE, 'CUSTOMER_ID', 'CUSTOMER_IDENTIFIER', 'Customer Identifier', 'medium', 0.93, 'Identifier', 'Customer', NULL, '{}', '["DATA_STEWARD"]', 'acme-customer-use', 'Customer Use Guardrails', '["acme-customer-use"]', '["acme-customers-allow-analytics"]', 'medium', TRUE),
    ($CUSTOMERS_TABLE, 'CUSTOMER_NAME', 'PERSON_NAME', 'Person Name', 'medium', 0.91, 'PII', 'Name', 'redact', '{}', '["DATA_STEWARD","PRIVACY_ADMIN"]', 'acme-customer-use', 'Customer Use Guardrails', '["acme-customer-use"]', '["acme-customers-allow-analytics"]', 'medium', TRUE),
    ($CUSTOMERS_TABLE, 'EMAIL', 'EMAIL_ADDRESS', 'Email Address', 'high', 0.97, 'PII', 'Contact', 'partial_mask', '{"visible_domain":true}', '["DATA_STEWARD","PRIVACY_ADMIN"]', 'acme-customer-use', 'Customer Use Guardrails', '["acme-customer-use","acme-transfer"]', '["acme-customers-allow-analytics","acme-customers-transfer-conditions"]', 'high', TRUE),
    ($CUSTOMERS_TABLE, 'ACCOUNT_STATUS', 'ACCOUNT_STATUS', 'Account Status', 'internal', 0.86, 'Operational', 'Account', NULL, '{}', '[]', 'acme-customer-use', 'Customer Use Guardrails', '["acme-customer-use"]', '["acme-customers-allow-analytics"]', 'internal', FALSE),
    ($CUSTOMERS_TABLE, 'ARR', 'MONETARY_AMOUNT', 'Annual Recurring Revenue', 'internal', 0.90, 'Financial', 'Revenue', NULL, '{}', '[]', 'acme-retention', 'Revenue Retention Guardrails', '["acme-retention"]', '["acme-subscriptions-retention"]', 'internal', FALSE),
    ($SUBSCRIPTIONS_TABLE, 'ARR', 'MONETARY_AMOUNT', 'Annual Recurring Revenue', 'internal', 0.90, 'Financial', 'Revenue', NULL, '{}', '[]', 'acme-retention', 'Revenue Retention Guardrails', '["acme-retention"]', '["acme-subscriptions-retention"]', 'internal', FALSE),
    ($EVENTS_TABLE, 'DEVICE_ID', 'DEVICE_IDENTIFIER', 'Device Identifier', 'medium', 0.82, 'Identifier', 'Device', 'hash', '{}', '["DATA_STEWARD"]', 'acme-customer-use', 'Customer Use Guardrails', '["acme-customer-use"]', '["acme-events-monitor"]', 'medium', TRUE),
    ($SUPPORT_TABLE, 'TICKET_TEXT', 'FREE_TEXT', 'Support Ticket Text', 'high', 0.84, 'PII', 'Support Text', 'redact', '{}', '["SUPPORT_MANAGER","PRIVACY_ADMIN"]', 'acme-customer-use', 'Customer Use Guardrails', '["acme-customer-use"]', '["acme-support-block-training"]', 'high', TRUE),
    ($EXPORTS_TABLE, 'EMAIL', 'EMAIL_ADDRESS', 'Email Address', 'high', 0.97, 'PII', 'Contact', 'partial_mask', '{"visible_domain":true}', '["DATA_STEWARD","PRIVACY_ADMIN"]', 'acme-transfer', 'Transfer Guardrails', '["acme-transfer"]', '["acme-exports-transfer"]', 'high', TRUE),
    ($EXPORTS_TABLE, 'CUSTOMER_NAME', 'PERSON_NAME', 'Person Name', 'medium', 0.91, 'PII', 'Name', 'redact', '{}', '["DATA_STEWARD","PRIVACY_ADMIN"]', 'acme-transfer', 'Transfer Guardrails', '["acme-transfer"]', '["acme-exports-transfer"]', 'medium', TRUE)
)
SELECT
    full_table_name, column_name, data_type_id, data_type_label,
    classification_sensitivity, confidence, 'demo',
    classification_sensitivity, data_category, subcategory, masking_type,
    PARSE_JSON(masking_config_json), PARSE_JSON(exempt_roles_json),
    policy_id, policy_name, PARSE_JSON(source_policy_ids_json),
    PARSE_JSON(source_instruction_ids_json), effective_sensitivity, is_pii
FROM column_rows;

INSERT INTO app_data.deployed_data_meaning (
    full_table_name, owner, steward, domain, purpose, definitions,
    lineage_sources, lineage_transformations, lineage_dependents,
    compliance_regulations, compliance_certifications, retention_period,
    retention_trigger, retention_action, policy_context, policy_ids,
    instruction_ids, source_fact_types
)
WITH meaning_rows (
    full_table_name, owner, steward, domain, purpose, definitions_json,
    lineage_sources_json, lineage_transformations_json, lineage_dependents_json,
    control_tags_json, retention_period, retention_trigger, retention_action,
    policy_ids_json, instruction_ids_json
) AS (
    SELECT * FROM VALUES
    (
        $CUSTOMERS_TABLE, 'Revenue Operations', 'privacy-review@example.com', 'Customer Data',
        'Customer master data used for approved reporting, analytics, support, and controlled operational exports.',
        '[{"term":"customer","definition":"An organization or contact with an active or historical commercial relationship with AcmeCloud."},{"term":"privacy_sensitive","definition":"Customer-defined control tag for data requiring extra handling."}]',
        '["CRM.CONTACTS","SUPPORT.CASES"]', '["identity_resolution","consent_enrichment"]', '["SUBSCRIPTIONS","CUSTOMER_EXPORTS"]',
        '["privacy_sensitive","restricted_transfer","ai_training_blocked"]', '7 years', 'account closure', 'archive',
        '["acme-customer-use","acme-transfer"]',
        '["acme-customers-allow-analytics","acme-customers-transfer-conditions"]'
    ),
    (
        $SUBSCRIPTIONS_TABLE, 'Finance Analytics', 'finance-data@example.com', 'Revenue Operations',
        'Subscription facts used for ARR reporting and renewal planning.',
        '[{"term":"arr","definition":"Annual recurring revenue associated with a subscription."}]',
        '["BILLING.SUBSCRIPTIONS"]', '["currency_standardization"]', '["CUSTOMERS"]',
        '["commercial_sensitive","retention_required"]', '5 years', 'subscription end', 'archive',
        '["acme-retention"]', '["acme-subscriptions-retention"]'
    ),
    (
        $EVENTS_TABLE, 'Product Analytics', 'product-data@example.com', 'Product Analytics',
        'Product events used for product analytics and support diagnostics.',
        '[{"term":"event","definition":"A product interaction captured for analytics."}]',
        '["APP.EVENT_STREAM"]', '["sessionization"]', '[]',
        '["privacy_sensitive","retention_required"]', '18 months', 'event timestamp', 'delete',
        '["acme-customer-use"]', '["acme-events-monitor"]'
    ),
    (
        $SUPPORT_TABLE, 'Support Operations', 'support-data@example.com', 'Customer Data',
        'Support cases used for service operations and approved analytics, not model training.',
        '[{"term":"support_ticket","definition":"A customer support interaction that may contain personal or confidential information."}]',
        '["SUPPORT.CASES"]', '["case_normalization"]', '[]',
        '["privacy_sensitive","ai_training_blocked"]', '3 years', 'case closure', 'archive',
        '["acme-customer-use"]', '["acme-support-block-training"]'
    ),
    (
        $EXPORTS_TABLE, 'Data Platform', 'data-platform@example.com', 'Customer Data',
        'Prepared export table used to demonstrate transfer governance decisions.',
        '[{"term":"export_batch","definition":"A governed file-equivalent table staged for outbound transfer."}]',
        '["CUSTOMERS"]', '["export_projection"]', '[]',
        '["privacy_sensitive","restricted_transfer"]', '30 days', 'export batch creation', 'delete',
        '["acme-transfer"]', '["acme-exports-transfer"]'
    )
)
SELECT
    full_table_name, owner, steward, domain, purpose, PARSE_JSON(definitions_json),
    PARSE_JSON(lineage_sources_json), PARSE_JSON(lineage_transformations_json),
    PARSE_JSON(lineage_dependents_json), PARSE_JSON('[]'), PARSE_JSON('[]'),
    retention_period, retention_trigger, retention_action,
    OBJECT_CONSTRUCT('control_tags', PARSE_JSON(control_tags_json)),
    PARSE_JSON(policy_ids_json), PARSE_JSON(instruction_ids_json),
    PARSE_JSON('["catalog","policy","example_fixture"]')
FROM meaning_rows;

SELECT 'AcmeCloud demo tables and Metatate serving fixture installed.' AS status;

