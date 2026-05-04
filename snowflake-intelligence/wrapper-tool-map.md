# Snowflake Intelligence Wrapper Tool Map

Metatate keeps one canonical decision engine and exposes Snowflake Intelligence wrappers for agent-builder compatibility.

## Wrapper inventory

| Wrapper | Type | Primary use |
|---|---|---|
| `core.agent_discover_context` | Function | Find governed tables using scalar filters |
| `core.agent_get_decision_context` | Function | Retrieve full decision context for one table |
| `core.agent_inspect_data_meaning` | Function | Inspect column meaning, sensitivity, PII, and masking guidance |
| `core.agent_inspect_governance_rules` | Function | Inspect usage, validation, and transfer rules |
| `core.agent_authorize_use` | Procedure | Decide whether a proposed data use can proceed |
| `core.agent_validate_query_context` | Procedure | Validate generated SQL before execution |
| `core.agent_explain_why` | Procedure | Explain a prior authorization or validation decision |

## Recommended tool order

1. `agent_get_decision_context`
2. `agent_discover_context`
3. `agent_inspect_data_meaning`
4. `agent_inspect_governance_rules`
5. `agent_authorize_use`
6. `agent_validate_query_context`
7. `agent_explain_why`

Start with context retrieval before authorization. It gives the agent enough background to ask better follow-up questions.

## Important parameter patterns

### Authorization

`core.agent_authorize_use` accepts:

```text
table_name
operation
intended_use
actor_role
columns_csv
destination_system
destination_jurisdiction
consumer_jurisdiction
context_json
```

Use transfer fields for export, sharing, activation, external delivery, or other movement workflows.

### Query validation

`core.agent_validate_query_context` accepts:

```text
sql
operation
intended_use
actor_role
destination_system
destination_jurisdiction
consumer_jurisdiction
```

Use `operation` and `intended_use` when you want validation to include embedded authorization.

### Explanation

`core.agent_explain_why` accepts a prior decision or validation identifier.

Use it after:

- `agent_authorize_use` returns a decision ID
- `agent_validate_query_context` returns a validation ID

