# Provider Studio SQL Example

Paste these fields into **Quick Start Examples -> Add SQL example** for a Metatate Snowflake Marketplace listing.

## Usage Example Title

```text
Make governed data agent-ready with Metatate
```

## Description

```text
Inspect decision-grade metadata that Metatate exposes for governed Snowflake data. This quick start shows how an AI or analytics workflow can discover governed tables, retrieve policy context, and inspect column-level meaning before using sensitive data.
```

## Query

Use the preferred query first. It is read-only and returns three rows of Metatate governance context from the demo fixture.

```sql
SELECT
  'Discover governed demo tables' AS step,
  METATATE_APP.CORE.AGENT_DISCOVER_CONTEXT(
    'METATATE_DEMO',
    'PUBLIC',
    NULL,
    NULL,
    NULL,
    NULL
  ) AS result
UNION ALL
SELECT
  'Review customer table decision context' AS step,
  METATATE_APP.CORE.AGENT_GET_DECISION_CONTEXT(
    'METATATE_DEMO.PUBLIC.CUSTOMERS'
  ) AS result
UNION ALL
SELECT
  'Inspect EMAIL governance meaning' AS step,
  METATATE_APP.CORE.AGENT_INSPECT_DATA_MEANING(
    'METATATE_DEMO.PUBLIC.CUSTOMERS',
    'EMAIL'
  ) AS result;
```

If Provider Studio rejects Native App function calls or database-qualified demo identifiers, use this validator-safe fallback instead and rely on docs, screenshots, or video for the richer live proof.

```sql
SELECT
  '1. Install Metatate from this listing' AS step,
  'Open the app, complete setup, and deploy at least one policy against a governed Snowflake table.' AS action
UNION ALL
SELECT
  '2. Make metadata operational' AS step,
  'Metatate turns policies, classifications, data meaning, retention, and transfer rules into reusable decision context.' AS action
UNION ALL
SELECT
  '3. Use the decision layer from agents' AS step,
  'Snowflake Intelligence and MCP clients can call discover_context, get_decision_context, authorize_use, validate_query_context, and explain_why.' AS action;
```

