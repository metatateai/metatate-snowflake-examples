# Sanitized Demo Reliability Report

Generated from a passing Metatate demo reliability gate run.

## Scenario results

- PASS `governance_aware_ai_coding_assistant`: agent discovers governed demo tables, retrieves decision context, and validates a generated query.
- PASS `pre_query_pii_audit`: PII columns are identified before a role-scoped analytics authorization check.
- PASS `authorization_check_before_data_export`: external export is conditionally approved for an approved destination and denied for a prohibited destination.
- PASS `column_sensitivity_discovery`: sensitive columns are discovered across physical demo tables from live governance metadata.
- PASS `control_coverage_reporting`: customer-control-tagged tables produce a policy, PII, retention, owner, and steward coverage report.

## Gate coverage

- MCP cookbook workflows passed.
- Canonical MCP SQL suite passed.
- Snowflake Intelligence wrapper SQL suite passed.
- HTTP MCP acceptance smoke passed after network policy refresh and warm rerun.

## Demo controls

The demo fixture uses customer-defined controls:

- `privacy_sensitive`
- `restricted_transfer`
- `retention_required`
- `ai_training_blocked`

