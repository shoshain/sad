#!/usr/bin/env bash
set -euo pipefail

# drift-scan.sh — list features missing reconciliation artifact (batch / CI helper).

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SPECS="${ROOT}/specs"

if [[ ! -d "${SPECS}" ]]; then
  echo "No specs/ directory at ${SPECS} (nothing to scan)." >&2
  exit 0
fi

rc=0
while IFS= read -r -d '' dir; do
  if [[ ! -f "${dir}/reconciliation.md" ]]; then
    echo "MISSING_RECONCILIATION ${dir}"
    rc=2
  fi
done < <(find "${SPECS}" -mindepth 1 -maxdepth 1 -type d -print0)

exit "${rc}"
