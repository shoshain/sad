#!/usr/bin/env bash
set -euo pipefail

# check-tier-approvals.sh — verify all three tier walkthrough approvals are checked.
# Usage: ./check-tier-approvals.sh /path/to/specs/NNN-slug [--report-only] [--json]
# Exit 0: all approved; 2: missing, unchecked, or pending (blocks tasks.md).

FEAT="${1:?Usage: $0 /path/to/specs/feature-dir [--report-only] [--json]}"
shift || true

REPORT_ONLY=0
JSON=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --report-only) REPORT_ONLY=1; shift;;
    --json)        JSON=1; REPORT_ONLY=1; shift;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

LIB="$(dirname "$0")/_sad-approval-lib.sh"
# shellcheck source=_sad-approval-lib.sh
source "${LIB}"

report_tier() {
  local tier="$1"
  local label file st prepared since
  label="$(_sad_tier_label "${tier}")"
  file="$(_sad_tier_file "${FEAT}" "${tier}")"
  st="$(_sad_approval_status "${file}" "${label}")"
  prepared="$(_sad_approval_field "${file}" 'prepared for:')"
  since="$(_sad_approval_field "${file}" 'pending since:')"
  if [[ "${JSON}" -eq 1 ]]; then
    printf '{"tier":"%s","status":"%s","prepared_for":"%s","pending_since":"%s"}' \
      "${tier}" "${st}" "${prepared}" "${since}"
  else
    echo "${tier}: ${st} (prepared_for=${prepared:-—}, pending_since=${since:-—})"
  fi
}

if [[ "${REPORT_ONLY}" -eq 1 ]]; then
  if [[ "${JSON}" -eq 1 ]]; then
    printf '['
    first=1
    for tier in non-technical semi-technical technical; do
      [[ "${first}" -eq 1 ]] || printf ','
      first=0
      report_tier "${tier}"
    done
    printf ']\n'
  else
    for tier in non-technical semi-technical technical; do
      report_tier "${tier}"
    done
  fi
  _sad_all_tiers_approved "${FEAT}" && exit 0 || exit 2
fi

ok=0
for tier in non-technical semi-technical technical; do
  label="$(_sad_tier_label "${tier}")"
  file="$(_sad_tier_file "${FEAT}" "${tier}")"
  st="$(_sad_approval_status "${file}" "${label}")"
  case "${st}" in
    approved) ;;
    pending)
      echo "Tier '${label}' is pending async review in ${file} — blocks /sad-tasks until approved." >&2
      ok=1
      ;;
    missing)
      echo "missing ${file}" >&2
      ok=1
      ;;
    *)
      echo "Tier approval not checked for '${label}' in ${file}" >&2
      ok=1
      ;;
  esac
done

if [[ "${ok}" -ne 0 ]]; then
  echo "One or more tier approvals are incomplete. Complete walkthrough checkboxes or run /sad-stakeholder-report for async packets." >&2
  exit 2
fi
exit 0
