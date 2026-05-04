# MCP Cookbook

This folder contains five Snowflake-native workflows that demonstrate how Metatate's decision tools compose into practical agent behavior.

The examples use SQL because it is the clearest common denominator for Snowflake users. Snowflake Intelligence uses the `core.agent_*` wrappers, while the canonical MCP layer uses the underlying JSON-oriented tools.

## Recipes

1. Governance-aware AI coding assistant
2. Pre-query PII audit
3. Authorization check before data export
4. Column sensitivity discovery across a database
5. Control coverage reporting

## What to run

Use `recipes.sql` as the walkthrough source. It references:

```text
METATATE_APP
METATATE_DEMO.PUBLIC
```

Adjust the app name or schema if your installation uses different names.

## Expected outcomes

See `expected-results.md` for the decisions and response patterns to expect.

