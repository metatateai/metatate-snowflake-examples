-- Smoke test for the AcmeCloud Metatate demo fixture.
--
-- Run after sql/setup_acmecloud_demo.sql.

SET SETUP_ROLE = 'NAC';
SET APP_NAME = 'METATATE_APP';

USE ROLE IDENTIFIER($SETUP_ROLE);
USE APPLICATION IDENTIFIER($APP_NAME);

SELECT 'governed table count' AS check_name;
SELECT COUNT(*) AS governed_tables
FROM app_data.governed_tables
WHERE full_table_name LIKE 'ACMECLOUD_DEMO.%';

SELECT 'non-AcmeCloud governed rows' AS check_name;
SELECT COUNT(*) AS non_acme_rows
FROM app_data.governed_tables
WHERE full_table_name NOT LIKE 'ACMECLOUD_DEMO.%';

SELECT 'canonical discover_context' AS check_name;
SELECT core.discover_context(
    PARSE_JSON('{"database":"ACMECLOUD_DEMO","schema":"PUBLIC"}')
):data:total::INTEGER AS acme_tables;

SELECT 'Snowflake Intelligence wrapper discover' AS check_name;
SELECT core.agent_discover_context(
    'ACMECLOUD_DEMO',
    'PUBLIC',
    NULL,
    NULL,
    NULL,
    NULL
):data:total::INTEGER AS wrapper_tables;

SELECT 'canonical transfer authorization' AS check_name;
CALL core.authorize_use(PARSE_JSON('{
  "table_name": "ACMECLOUD_DEMO.PUBLIC.CUSTOMERS",
  "operation": "export",
  "intended_use": "external_sharing",
  "destination": {
    "system": "SALESFORCE",
    "jurisdiction": "US"
  },
  "consumer_jurisdiction": "EU"
}'));

SELECT 'canonical query validation' AS check_name;
CALL core.validate_query_context(PARSE_JSON('{
  "sql": "SELECT customer_id, email, arr FROM ACMECLOUD_DEMO.PUBLIC.CUSTOMERS WHERE region = ''EU''",
  "operation": "read",
  "intended_use": "analytics"
}'));

