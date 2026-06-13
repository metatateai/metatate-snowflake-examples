# Human-in-the-Loop Exception Workflow

This example shows how an agent or workflow can turn Metatate decisions into operational review steps.

It covers three outcomes:

- safe aggregate analytics proceeds without an exception
- conditional Salesforce export creates an exception packet and resumes only after reviewer controls are attested
- blocked support-ticket training remains blocked and does not resume

The workflow is implemented in `human_exception_workflow/` and used by notebook `10_human_approval_packet_for_conditional_export.ipynb`.

## Run Locally

```bash
scripts/run_human_exception_workflow.sh
scripts/run_human_exception_workflow_acceptance.sh
```

The runner writes a JSON report to the system temporary directory, for example `/tmp/metatate-human-exception-workflow-report.json`.

To make blocked requests return a non-zero exit code:

```bash
scripts/run_human_exception_workflow.sh --fail-on-blocked
```

## Live MCP Mode

Offline mode uses committed fixtures. Live mode sends every Metatate decision request through the Snowflake-managed MCP server.

```bash
export METATATE_EXAMPLES_MODE=live
export METATATE_MCP_URL=https://<account-url>/api/v2/databases/METATATE_APP/schemas/CORE/mcp-servers/METATATE_MCP
export SNOWFLAKE_ROLE=NAC
export METATATE_MCP_PAT_ENV=METATATE_EXAMPLES_PAT
export METATATE_EXAMPLES_PAT='<snowflake-pat-secret>'

scripts/run_human_exception_workflow_acceptance.sh
```

Use a dedicated Snowflake service user and role-restricted PAT. See `docs/live-mode.md`.

## Workflow Model

Each request is evaluated through Metatate:

- `query` requests call `validate-query-context`
- `authorization` requests call `authorize-use`

The decision controls routing:

- `ALLOW` -> `ready_without_exception`
- `CONDITIONAL` -> `pending_human_review`
- `DENY` -> `blocked_by_policy`
- unknown decisions -> `needs_policy_review`

Reviewer approval only resumes conditional requests when every required attestation is present. The example requires:

- `approval_recorded`
- `anonymization_before_transfer`

Denied decisions are not treated as informal overrides. They remain blocked and require a changed request or changed deployed policy.

## Report Fields

Each item in the JSON report includes:

- request metadata
- Metatate decision
- evidence ID
- reviewer packet
- review decision, when applicable
- resume payload, when applicable
- final workflow status

Store the report with the workflow run so downstream systems can trace execution back to the Metatate evidence ID and reviewer decision.
