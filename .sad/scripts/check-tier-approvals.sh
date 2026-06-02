#!/usr/bin/env bash
set -euo pipefail

# check-tier-approvals.sh — verify all three tier walkthrough approvals are checked.
# Usage: ./check-tier-approvals.sh /path/to/specs/NNN-slug
# Exit 0: all approved; 2: missing or unchecked (per hooks/stakeholder-tier-router.json).

FEAT="${1:?Usage: $0 /path/to/specs/feature-dir}"

approve_line_ok() {
  local file="$1"
  local label="$2"
  if [[ ! -f "${file}" ]]; then
    echo "missing ${file}" >&2
    return 1
  fi
  if grep -qiE -- "^-[[:space:]]*\\[x\\].*${label}.*reviewer" "${file}"; then
    return 0
  fi
  echo "Tier approval not checked for '${label}' in ${file}" >&2
  return 1
}

ok=0
approve_line_ok "${FEAT}/walkthroughs/non-technical.md" "Non-technical" || ok=1
approve_line_ok "${FEAT}/walkthroughs/semi-technical.md" "Semi-technical" || ok=1
approve_line_ok "${FEAT}/walkthroughs/technical.md" "Technical" || ok=1

if [[ "${ok}" -ne 0 ]]; then
  echo "One or more tier approvals are incomplete. Complete walkthrough checkboxes per LIFECYCLE.md." >&2
  exit 2
fi

exit 0
