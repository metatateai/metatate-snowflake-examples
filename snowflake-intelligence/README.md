# Snowflake Intelligence + Metatate

This example shows how Snowflake Intelligence can use Metatate as a decision layer for governed Snowflake data.

Metatate exposes seven Snowflake Intelligence-friendly wrappers in the app's `core` schema. These wrappers call the same canonical decision tools used by the MCP layer, but with scalar parameters that fit Snowflake Intelligence custom tools.

## What the agent can do

With the wrappers attached, a Snowflake Intelligence agent can:

- Discover governed tables by database, schema, sensitivity, PII presence, or control tags
- Retrieve full decision context for a table
- Inspect column-level meaning, sensitivity, PII, and masking guidance
- Inspect deployed usage, validation, and transfer rules
- Authorize a proposed read, export, training, or sharing use
- Validate generated SQL before execution
- Explain a prior authorization or query-validation decision

## Files

- `setup-guide.md`: recommended setup flow for Snowflake Intelligence
- `wrapper-tool-map.md`: wrapper signatures and when to use each tool
- `prompts.md`: starter prompts for buyer demos and internal testing

## Recommended first proof

Start with `core.agent_get_decision_context`.

Ask:

```text
What decision context applies to METATATE_DEMO.PUBLIC.CUSTOMERS?
```

This validates the simplest high-value path: Snowflake Intelligence can retrieve real Metatate decision context without external data egress.

