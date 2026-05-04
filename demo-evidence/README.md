# Demo Evidence

This folder contains sanitized examples generated from Metatate's demo reliability gate.

The original internal evidence run validates:

- physical Snowflake demo tables
- deployed governance metadata
- MCP cookbook recipes
- Snowflake Intelligence wrappers
- HTTP MCP smoke checks

Only sanitized summaries are published here. Internal app URLs, account identifiers, tokens, command logs, hostnames, and raw environment state are intentionally excluded.

## Evidence files

- `sample-report.md`: human-readable scenario summary
- `sample-json/transfer-governance.json`: conditional and denied transfer decisions
- `sample-json/query-validation.json`: query-validation shape

## Evidence policy

Published evidence must:

- use customer-defined controls only
- avoid named external compliance catalogs
- avoid account-specific identifiers
- avoid credentials and access tokens
- be reproducible from the demo reliability gate
