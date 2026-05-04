# Expected Results

These outcomes were validated by Metatate's demo reliability gate against physical Snowflake demo tables.

## Recipe 1: Governance-aware AI coding assistant

Expected:

- `discover_context` returns governed tables from `METATATE_DEMO.PUBLIC`.
- `get_decision_context` returns a policy summary for `CUSTOMERS`.
- `validate_query_context` returns a validation ID and table/column extraction metadata.
- The generated query avoids broad `SELECT *` access and can be reviewed before execution.

## Recipe 2: Pre-query PII audit

Expected:

- `inspect_data_meaning` identifies PII columns such as customer identifiers, names, and email.
- `authorize_use` returns `ALLOW` or `CONDITIONAL` for role-scoped analytics, with obligations when sensitive columns require handling controls.

## Recipe 3: Authorization before data export

Expected:

- Export to an approved business destination can return `CONDITIONAL`.
- The response includes `TRANSFER_CONDITIONAL`, required controls, and next actions.
- Export to a prohibited destination returns `DENY`.
- The response includes `TRANSFER_DENIED`.
- `explain_why` resolves the decision ID and returns an authorization trace.

## Recipe 4: Column sensitivity discovery

Expected:

- The agent can discover governed tables and inspect column meaning for each table.
- The output can be summarized into a sensitivity map.

## Recipe 5: Control coverage reporting

Expected:

- Filtering by `privacy_sensitive` returns tables governed by that customer-defined control.
- `get_decision_context` provides policy count, PII posture, retention guidance, owner/steward context, and applied controls.

