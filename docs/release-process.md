# Release Process

This repository uses automated offline CI for every pull request and manual live validation before public releases.

## Pull Request Gate

Every pull request runs `.github/workflows/offline-ci.yml`.

The offline gate checks:

- static repository validation
- shell syntax for all scripts
- Python compile checks
- CI/CD policy gate acceptance and CLI behavior
- human exception workflow acceptance and CLI behavior
- framework runtime acceptance for LangGraph, OpenAI Agents SDK, and LlamaIndex
- offline notebook pack execution

These checks use committed fixtures only. They do not require Snowflake credentials.

## Live MCP Release Gate

Before tagging a release, run `.github/workflows/live-mcp-validation.yml` from GitHub Actions.

Required repository secrets:

- `METATATE_MCP_URL`
- `METATATE_EXAMPLES_PAT`

The PAT must belong to a dedicated service user and be role-restricted to the role supplied in the workflow input, usually `NAC`.

The live gate checks:

- static repository validation
- CI/CD policy gate acceptance through managed MCP
- human exception workflow acceptance through managed MCP
- framework runtime acceptance through managed MCP
- live core notebook pack execution
- live LangGraph runtime notebook execution

Cortex Agent hosted runtime validation is intentionally separate because it creates scratch Snowflake Cortex Agent objects. Run `scripts/run_cortex_agent_runtime_acceptance.sh` manually when preparing a release that changes Cortex Agent behavior.

## Tagging

Tag only from `main` after:

- the release PR has merged
- offline CI is green on `main`
- manual live MCP validation has passed
- `CHANGELOG.md` has the intended release notes

First public tag:

```bash
git checkout main
git pull --ff-only origin main
git tag -a v0.1.0 -m "metatate-examples v0.1.0"
git push origin v0.1.0
```

Subsequent releases should use semantic version tags such as `v0.2.0`, `v0.2.1`, and `v1.0.0`.

## Release Notes

Release notes should state:

- which examples are included
- which examples run offline
- which examples were validated through managed MCP
- which examples require hosted Snowflake runtimes such as Cortex Agents
- any required Snowflake app, role, or PAT setup changes
