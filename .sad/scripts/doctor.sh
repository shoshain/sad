#!/usr/bin/env bash
set -euo pipefail

# /sad-doctor — project-wide SAD health check.
# Prints green / yellow / red per check with one-line remediation hints.
# Exit 0 if no reds. Exit 1 if any red. JSON mode via --json.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

JSON=0
QUIET=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json)  JSON=1; shift;;
    --quiet) QUIET=1; shift;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

reds=0; yellows=0; greens=0
rows=()
record() {
  local name="$1" status="$2" message="$3" hint="${4:-}"
  case "$status" in
    green)  greens=$((greens+1));;
    yellow) yellows=$((yellows+1));;
    red)    reds=$((reds+1));;
  esac
  rows+=("${name}|${status}|${message}|${hint}")
}

# constitution
CONST="${ROOT}/.sad/memory/constitution.md"
if [[ ! -f "${CONST}" ]]; then
  record "constitution.exists" "red" ".sad/memory/constitution.md is missing" "Run /sad-constitution or copy a starter from .sad/templates/constitutions/"
else
  # Distinguish "untouched ships-with-the-kit template" (yellow, expected in the
  # methodology repo itself and on day 0 of a consuming project) from "someone
  # started filling it in and abandoned mid-edit" (red, blocks the gate).
  if grep -qE "^> \*\*Template\.\*\*" "${CONST}"; then
    record "constitution.identity" "yellow" "Constitution is still the unmodified template" "Run /sad-constitution or copy a starter from .sad/templates/constitutions/"
  elif grep -qE "\[name\]|\[who\]" "${CONST}"; then
    record "constitution.identity" "red" "Constitution still contains [name] / [who] placeholders" "Fill in Identity section"
  else
    record "constitution.identity" "green" "Identity section filled"
  fi
  if ! grep -qE "^\| A[0-9]" "${CONST}"; then
    record "constitution.articles" "yellow" "No article rows (A1, A2, ...) in the article index" "Add at least 3 articles"
  else
    record "constitution.articles" "green" "Article index populated"
  fi
  if ! grep -q "Maturity level" "${CONST}"; then
    record "constitution.maturity" "red" "Maturity level line missing in Identity" "Add 'Maturity level (initial): Level X' — see MATURITY.md"
  else
    record "constitution.maturity" "green" "Maturity level declared"
  fi
fi

# stakeholders
for tier in non-technical semi-technical technical; do
  f="${ROOT}/.sad/stakeholders/${tier}.md"
  if [[ ! -f "${f}" ]]; then
    record "stakeholders.${tier}" "red" "stakeholders/${tier}.md missing" "Run /sad-setup or copy from .sad/templates"
  elif grep -qE "TBD|\[List people" "${f}"; then
    record "stakeholders.${tier}" "yellow" "stakeholders/${tier}.md still has TBD or placeholder names" "Name real reviewers"
  else
    record "stakeholders.${tier}" "green" "stakeholders/${tier}.md filled"
  fi
done

# hooks
if [[ -d "${ROOT}/hooks" ]]; then
  hookcount=$(find "${ROOT}/hooks" -name '*.json' -type f 2>/dev/null | wc -l | tr -d ' ')
  record "hooks.present" "green" "${hookcount} hook descriptor(s) found"
else
  record "hooks.present" "yellow" "hooks/ directory missing" "Re-run the installer"
fi

# per-feature
SPECS="${ROOT}/specs"
if [[ -d "${SPECS}" ]]; then
  fcount=$(find "${SPECS}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
  if [[ "${fcount}" -eq 0 ]]; then
    record "features.any" "yellow" "specs/ exists but is empty" "Run .sad/scripts/create-feature.{sh,ps1}"
  fi
  while IFS= read -r -d '' fdir; do
    name="$(basename "${fdir}")"
    missing=()
    for r in feature.spec.md feature.plan.md tasks.md reconciliation.md \
             walkthroughs/non-technical.md walkthroughs/semi-technical.md walkthroughs/technical.md; do
      [[ -f "${fdir}/${r}" ]] || missing+=("${r}")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      record "feature.${name}.artifacts" "yellow" "${name} missing: ${missing[*]}" "Re-run create-feature or fill manually"
    else
      record "feature.${name}.artifacts" "green" "${name} has all required artifacts"
    fi
  done < <(find "${SPECS}" -mindepth 1 -maxdepth 1 -type d -print0)
else
  record "features.any" "yellow" "specs/ directory missing" "Create at project root; convention specs/<NNN>-<slug>/"
fi

# scripts platform
SH_COUNT=$(ls "${ROOT}/.sad/scripts/"*.sh 2>/dev/null | wc -l | tr -d ' ')
if [[ "${SH_COUNT}" -ge 4 ]]; then
  record "scripts.platform" "green" "Bash scripts present (POSIX-ready)"
else
  record "scripts.platform" "yellow" "Only ${SH_COUNT} .sh scripts found; expected at least 4"
fi

json_escape() {
  # Escape a string for safe inclusion inside a JSON string literal.
  # Handles \, ", control chars (newline, CR, tab, backspace, form feed).
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  s="${s//$'\b'/\\b}"
  s="${s//$'\f'/\\f}"
  printf '%s' "${s}"
}

# output
if [[ "${JSON}" -eq 1 ]]; then
  printf '{ "summary": { "red": %d, "yellow": %d, "green": %d }, "checks": [\n' "${reds}" "${yellows}" "${greens}"
  first=1
  for row in "${rows[@]}"; do
    IFS='|' read -r n s m h <<<"${row}"
    [[ "${first}" -eq 1 ]] || printf ',\n'
    first=0
    printf '  { "name": "%s", "status": "%s", "message": "%s", "hint": "%s" }' \
      "$(json_escape "${n}")" "$(json_escape "${s}")" "$(json_escape "${m}")" "$(json_escape "${h}")"
  done
  printf '\n]}\n'
elif [[ "${QUIET}" -ne 1 ]]; then
  echo "/sad-doctor — ${greens} green, ${yellows} yellow, ${reds} red"
  echo "------------------------------------------------------------"
  for row in "${rows[@]}"; do
    IFS='|' read -r n s m h <<<"${row}"
    case "${s}" in
      green)  tag='[OK]  ';;
      yellow) tag='[WARN]';;
      red)    tag='[FAIL]';;
    esac
    echo "${tag} ${n} — ${m}"
    [[ -n "${h}" ]] && echo "       hint: ${h}"
  done
fi

[[ "${reds}" -gt 0 ]] && exit 1 || exit 0
