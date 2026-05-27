#!/usr/bin/env bash
set -euo pipefail

: "${METATATE_EXAMPLES_MODE:=offline}"
: "${METATATE_NOTEBOOK_OUTPUT_DIR:=/private/tmp/metatate-examples-${METATATE_EXAMPLES_MODE}-executed}"
: "${JUPYTER_BIN:=jupyter}"

NOTEBOOKS=(
  notebooks/00_setup_live_or_offline.ipynb
  notebooks/01_decision_layer_cookbook.ipynb
  notebooks/02_governed_sql_agent_langgraph.ipynb
  notebooks/03_transfer_governance_before_export.ipynb
  notebooks/04_governed_text_to_sql_agent.ipynb
  notebooks/05_agent_red_team_evaluation_harness.ipynb
  notebooks/06_ci_gate_for_data_ai_changes.ipynb
)

if [[ "${METATATE_EXAMPLES_MODE}" == "live" ]]; then
  : "${METATATE_MCP_URL:?METATATE_MCP_URL is required in live mode}"
  : "${METATATE_MCP_PAT_ENV:=METATATE_EXAMPLES_PAT}"
  token_value="${!METATATE_MCP_PAT_ENV:-}"
  if [[ -z "${token_value}" ]]; then
    echo "${METATATE_MCP_PAT_ENV} must contain the Snowflake PAT secret in live mode" >&2
    exit 1
  fi
fi

"${JUPYTER_BIN}" nbconvert \
  --to notebook \
  --execute "${NOTEBOOKS[@]}" \
  --output-dir "${METATATE_NOTEBOOK_OUTPUT_DIR}"

printf 'Executed %s notebook pack into %s\n' "${METATATE_EXAMPLES_MODE}" "${METATATE_NOTEBOOK_OUTPUT_DIR}"
