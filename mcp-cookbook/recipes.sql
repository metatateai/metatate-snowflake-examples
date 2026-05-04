-- Metatate MCP Cookbook
-- Replace METATATE_APP and METATATE_DEMO.PUBLIC if your installation uses different names.

-- Recipe 1: Governance-aware AI coding assistant
-- Discover governed tables, retrieve context, then validate generated SQL.
SELECT METATATE_APP.CORE.DISCOVER_CONTEXT(
  OBJECT_CONSTRUCT(
    'database', 'METATATE_DEMO',
    'schema', 'PUBLIC'
  )
);

SELECT METATATE_APP.CORE.GET_DECISION_CONTEXT(
  OBJECT_CONSTRUCT('table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS')
);

CALL METATATE_APP.CORE.VALIDATE_QUERY_CONTEXT(
  OBJECT_CONSTRUCT(
    'sql', 'SELECT customer_id, account_status, region FROM METATATE_DEMO.PUBLIC.CUSTOMERS WHERE region = ''US''',
    'operation', 'read',
    'intended_use', 'reporting'
  )
);

-- Recipe 2: Pre-query PII audit
-- Inspect data meaning, then authorize the exact intended use.
SELECT METATATE_APP.CORE.INSPECT_DATA_MEANING(
  OBJECT_CONSTRUCT('table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS')
);

CALL METATATE_APP.CORE.AUTHORIZE_USE(
  OBJECT_CONSTRUCT(
    'table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS',
    'operation', 'read',
    'intended_use', 'analytics',
    'actor_role', 'DATA_ANALYST',
    'columns', ARRAY_CONSTRUCT('CUSTOMER_ID', 'EMAIL', 'ACCOUNT_STATUS')
  )
);

-- Recipe 3: Authorization before data export
-- Approved destination returns CONDITIONAL with controls.
CALL METATATE_APP.CORE.AUTHORIZE_USE(
  OBJECT_CONSTRUCT(
    'table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS',
    'operation', 'export',
    'intended_use', 'external_sharing',
    'actor_role', 'DATA_ENGINEER',
    'columns', ARRAY_CONSTRUCT('CUSTOMER_ID', 'NAME', 'EMAIL', 'ACCOUNT_STATUS'),
    'destination', OBJECT_CONSTRUCT(
      'system', 'Salesforce',
      'jurisdiction', 'US'
    ),
    'consumer_jurisdiction', 'EU'
  )
);

-- Use the decision_id from the previous response.
CALL METATATE_APP.CORE.EXPLAIN_WHY(
  OBJECT_CONSTRUCT('decision_id', '<decision_id>')
);

-- Prohibited destination returns DENY.
CALL METATATE_APP.CORE.AUTHORIZE_USE(
  OBJECT_CONSTRUCT(
    'table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS',
    'operation', 'export',
    'intended_use', 'external_sharing',
    'actor_role', 'DATA_ENGINEER',
    'columns', ARRAY_CONSTRUCT('CUSTOMER_ID', 'NAME', 'EMAIL'),
    'destination', OBJECT_CONSTRUCT(
      'system', 'ADS_PLATFORM',
      'jurisdiction', 'US'
    ),
    'consumer_jurisdiction', 'US'
  )
);

-- Recipe 4: Column sensitivity discovery
SELECT METATATE_APP.CORE.DISCOVER_CONTEXT(
  OBJECT_CONSTRUCT('database', 'METATATE_DEMO')
);

SELECT METATATE_APP.CORE.INSPECT_DATA_MEANING(
  OBJECT_CONSTRUCT('table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS')
);

SELECT METATATE_APP.CORE.INSPECT_DATA_MEANING(
  OBJECT_CONSTRUCT('table_name', 'METATATE_DEMO.PUBLIC.ORDERS')
);

SELECT METATATE_APP.CORE.INSPECT_DATA_MEANING(
  OBJECT_CONSTRUCT('table_name', 'METATATE_DEMO.PUBLIC.CUSTOMER_EVENTS')
);

-- Recipe 5: Control coverage reporting
SELECT METATATE_APP.CORE.DISCOVER_CONTEXT(
  OBJECT_CONSTRUCT(
    'compliance_any', ARRAY_CONSTRUCT('privacy_sensitive')
  )
);

SELECT METATATE_APP.CORE.GET_DECISION_CONTEXT(
  OBJECT_CONSTRUCT('table_name', 'METATATE_DEMO.PUBLIC.CUSTOMERS')
);

