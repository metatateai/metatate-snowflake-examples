#!/usr/bin/env bash
set -euo pipefail

: "${SNOW_CONNECTION:=}"
: "${METATATE_PAT_USER:=METATATE_EXAMPLES_MCP_USER}"
: "${METATATE_PAT_ROLE:=NAC}"
: "${METATATE_PAT_WAREHOUSE:=WH_NAC}"
: "${METATATE_PAT_NETWORK_POLICY:=METATATE_EXAMPLES_MCP_NETWORK_POLICY}"
: "${METATATE_PAT_DAYS_TO_EXPIRY:=7}"
: "${METATATE_PAT_SECRET_FILE:=/private/tmp/metatate_examples_mcp_pat}"
: "${METATATE_PAT_TOKEN_NAME:=METATATE_EXAMPLES_MCP_$(date +%Y%m%d%H%M%S)}"

if [[ -z "${SNOW_CONNECTION}" ]]; then
  echo "SNOW_CONNECTION is required, for example: SNOW_CONNECTION=metatate_dev" >&2
  exit 1
fi

if [[ -z "${METATATE_PAT_ALLOWED_IP:-}" ]]; then
  METATATE_PAT_ALLOWED_IP="$(curl -sS https://checkip.amazonaws.com | tr -d '[:space:]')"
fi

if [[ -z "${METATATE_PAT_ALLOWED_IP}" ]]; then
  echo "Could not determine METATATE_PAT_ALLOWED_IP" >&2
  exit 1
fi

if [[ "${METATATE_PAT_ALLOWED_IP}" != */* ]]; then
  METATATE_PAT_ALLOWED_IP="${METATATE_PAT_ALLOWED_IP}/32"
fi

admin_sql="USE ROLE ACCOUNTADMIN;
CREATE USER IF NOT EXISTS ${METATATE_PAT_USER}
  TYPE = SERVICE
  DEFAULT_ROLE = ${METATATE_PAT_ROLE}
  DEFAULT_WAREHOUSE = ${METATATE_PAT_WAREHOUSE}
  COMMENT = 'Dedicated service user for Metatate examples managed MCP live testing';
GRANT ROLE ${METATATE_PAT_ROLE} TO USER ${METATATE_PAT_USER};
CREATE NETWORK POLICY IF NOT EXISTS ${METATATE_PAT_NETWORK_POLICY}
  ALLOWED_IP_LIST = ('${METATATE_PAT_ALLOWED_IP}')
  COMMENT = 'Narrow allowlist for Metatate examples managed MCP live testing';
ALTER NETWORK POLICY ${METATATE_PAT_NETWORK_POLICY}
  SET ALLOWED_IP_LIST = ('${METATATE_PAT_ALLOWED_IP}')
  COMMENT = 'Narrow allowlist for Metatate examples managed MCP live testing';
ALTER USER ${METATATE_PAT_USER} SET NETWORK_POLICY = ${METATATE_PAT_NETWORK_POLICY};"

snow sql -c "${SNOW_CONNECTION}" -q "${admin_sql}" --format json >/dev/null

pat_sql="USE ROLE ACCOUNTADMIN;
ALTER USER ${METATATE_PAT_USER}
  ADD PROGRAMMATIC ACCESS TOKEN ${METATATE_PAT_TOKEN_NAME}
  ROLE_RESTRICTION = '${METATATE_PAT_ROLE}'
  DAYS_TO_EXPIRY = ${METATATE_PAT_DAYS_TO_EXPIRY}
  COMMENT = 'Temporary PAT for Metatate examples live MCP validation';"

pat_json="$(snow sql -c "${SNOW_CONNECTION}" -q "${pat_sql}" --format json)"

TOKEN_JSON="${pat_json}" TOKEN_FILE="${METATATE_PAT_SECRET_FILE}" python3 - <<'INNER_PY'
import json
import os
from pathlib import Path

def walk(value):
    if isinstance(value, dict):
        for key, candidate in value.items():
            if key.lower() == "token_secret" and isinstance(candidate, str) and len(candidate) > 20:
                return candidate
            found = walk(candidate)
            if found:
                return found
    if isinstance(value, list):
        for item in value:
            found = walk(item)
            if found:
                return found
    return None

token = walk(json.loads(os.environ["TOKEN_JSON"]))
if not token:
    raise SystemExit("No token_secret found in Snowflake response")
path = Path(os.environ["TOKEN_FILE"])
path.write_text(token + "\n", encoding="utf-8")
path.chmod(0o600)
INNER_PY

cat <<EOF
Created Snowflake PAT for ${METATATE_PAT_USER}.

Token name: ${METATATE_PAT_TOKEN_NAME}
Role restriction: ${METATATE_PAT_ROLE}
Network policy: ${METATATE_PAT_NETWORK_POLICY} (${METATATE_PAT_ALLOWED_IP})
Secret file: ${METATATE_PAT_SECRET_FILE}

Use it with:
  export METATATE_EXAMPLES_PAT="\$(cat ${METATATE_PAT_SECRET_FILE})"
EOF
