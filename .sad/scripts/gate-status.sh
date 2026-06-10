#!/usr/bin/env bash
set -euo pipefail

# gate-status.sh — program-level approval queue across all specs/<slug>/ features.
# Usage: ./gate-status.sh [--json] [--repo-root PATH]

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
JSON=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=1; shift;;
    --repo-root) ROOT="$(cd "$2" && pwd)"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

LIB="$(dirname "$0")/_sad-approval-lib.sh"
# shellcheck source=_sad-approval-lib.sh
source "${LIB}"

SPECS="${ROOT}/specs"
if [[ ! -d "${SPECS}" ]]; then
  echo "No specs/ directory under ${ROOT}" >&2
  exit 0
fi

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '%s' "${s}"
}

rows=()
while IFS= read -r -d '' fdir; do
  name="$(basename "${fdir}")"
  nt_sym=st_sym=t_sym=rec="—"
  pending_since=""
  delegate=""
  for tier in non-technical semi-technical technical; do
    label="$(_sad_tier_label "${tier}")"
    file="$(_sad_tier_file "${fdir}" "${tier}")"
    appr="$(_sad_approval_status "${file}" "${label}")"
    sym="⬜"
    [[ "${appr}" == "approved" ]] && sym="✅"
    [[ "${appr}" == "pending" ]] && sym="⏳"
    case "${tier}" in
      non-technical) nt_sym="${sym}";;
      semi-technical) st_sym="${sym}";;
      technical) t_sym="${sym}";;
    esac
    if [[ "${appr}" == "pending" && -z "${pending_since}" ]]; then
      pending_since="$(_sad_approval_field "${file}" 'pending since:')"
      delegate="$(_sad_approval_field "${file}" 'prepared for:')"
    fi
  done
  rec_file="${fdir}/reconciliation.md"
  if [[ -f "${rec_file}" ]] && grep -qiE '^-[[:space:]]*\[x\].*semi-technical.*reviewer' "${rec_file}"; then
    rec="✅"
  elif [[ -f "${rec_file}" ]]; then
    rec="⏳"
  fi
  rows+=("${name}|${nt_sym}|${st_sym}|${t_sym}|${rec}|${pending_since}|${delegate}")
done < <(find "${SPECS}" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null | sort -z)

if [[ "${JSON}" -eq 1 ]]; then
  printf '[\n'
  first=1
  for row in "${rows[@]}"; do
    IFS='|' read -r n nt st t rec ps del <<<"${row}"
    [[ "${first}" -eq 1 ]] || printf ',\n'
    first=0
    printf '  {"feature":"%s","non_technical":"%s","semi_technical":"%s","technical":"%s","reconcile":"%s","pending_since":"%s","delegate":"%s"}' \
      "$(json_escape "${n}")" "${nt}" "${st}" "${t}" "${rec}" "$(json_escape "${ps}")" "$(json_escape "${del}")"
  done
  printf '\n]\n'
  exit 0
fi

echo "/sad-gate-status — approval queue (${#rows[@]} feature(s))"
echo "--------------------------------------------------------------------------------"
printf "%-28s %3s %3s %3s %3s  %-12s  %s\n" "Feature" "NT" "ST" "T" "Rec" "Pending" "Delegate"
for row in "${rows[@]}"; do
  IFS='|' read -r n nt st t rec ps del <<<"${row}"
  printf "%-28s %3s %3s %3s %3s  %-12s  %s\n" "${n}" "${nt}" "${st}" "${t}" "${rec}" "${ps:-—}" "${del:-—}"
done
