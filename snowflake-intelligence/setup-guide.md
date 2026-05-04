# Setup Guide

Use this guide to create a Snowflake Intelligence agent that can call Metatate's decision layer.

## 1. Confirm Metatate is ready

In Snowflake, confirm:

- The Metatate Native App is installed and initialized.
- The app has an app warehouse reference configured.
- The role used in Snowflake Intelligence can access the app role and wrapper objects.
- At least one governed table has deployed Metatate context.

For demos, this repo assumes the app name is `METATATE_APP` and the demo schema is `METATATE_DEMO.PUBLIC`.

## 2. Add wrapper tools to the agent

Create or edit a Snowflake Intelligence agent and attach Metatate custom tools from:

```text
METATATE_APP.CORE
```

Start with:

```text
core.agent_get_decision_context(table_name STRING)
```

Then add the remaining wrappers as the demo expands:

```text
core.agent_discover_context
core.agent_inspect_data_meaning
core.agent_inspect_governance_rules
core.agent_authorize_use
core.agent_validate_query_context
core.agent_explain_why
```

## 3. Use a first prompt

```text
What decision context applies to METATATE_DEMO.PUBLIC.CUSTOMERS?
```

Expected behavior:

- The agent calls `core.agent_get_decision_context`.
- Metatate returns policy summary, sensitivity, PII posture, business context, retention, and instruction context.
- The agent summarizes the operational meaning and safe next action.

## 4. Expand into authorization

Add `core.agent_authorize_use`, then ask:

```text
Can I export customer names and emails from METATATE_DEMO.PUBLIC.CUSTOMERS to Salesforce for external sharing?
```

Expected behavior:

- The agent identifies this as an export use.
- Metatate evaluates destination and jurisdiction metadata when supplied.
- The answer is `ALLOW`, `CONDITIONAL`, `DENY`, or `UNKNOWN`, with reasons and next actions.

## 5. Validate generated SQL

Add `core.agent_validate_query_context`, then ask:

```text
Review this SQL before execution:
SELECT customer_id, email, account_status
FROM METATATE_DEMO.PUBLIC.CUSTOMERS
WHERE region = 'US';
```

Expected behavior:

- Metatate extracts referenced tables and columns.
- The agent receives findings and an execution gate.
- If unsafe, the agent suggests a safer query shape.

