#!/usr/bin/env bash
set -euo pipefail

: "${METATATE_HUMAN_EXCEPTION_OUTPUT:=${TMPDIR:-/tmp}/metatate-human-exception-workflow-report.json}"

set +e
python3 -m human_exception_workflow.cli \
  --output "${METATATE_HUMAN_EXCEPTION_OUTPUT}" \
  "$@"
status=$?
set -e

exit "${status}"
