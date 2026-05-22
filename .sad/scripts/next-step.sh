#!/usr/bin/env bash
set -euo pipefail

# next-step.sh — read-only state inspector for the SAD conductor and SessionStart hooks.
#
# Reads .sad/state/sad-state.md, the constitution, and the active feature directory,
# then prints one of:
#
#   SAD next step: /sad-<command>                   (a non-human phase is next)
#   SAD next step: GATE walkthrough <slug>          (paused on tier approvals)
#   SAD next step: GATE reconcile <slug>            (paused on semi-technical verdict approval)
#   SAD next step: /sad-setup                       (no .sad/ yet)
#   SAD next step: /sad-constitution                (constitution missing/unfilled)
#   SAD next step: /sad-brainstorm                  (no active feature)
#
# Usage:
#   ./next-step.sh                  human-readable line on stdout
#   ./next-step.sh --json           JSON for piping into other scripts
#   ./next-step.sh --quiet          exit code only (0 = ready to advance, 2 = blocked on human gate)
#
# Exit codes:
#   0  conductor can advance autonomously to the printed command
#   2  a human gate (tier approval or reconciliation sign-off) blocks progression
#   3  setup or constitution is missing (printed command is project-level, not feature-level)

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE="${ROOT}/.sad/state/sad-state.md"
CONST="${ROOT}/.sad/memory/constitution.md"
SPECS="${ROOT}/specs"

JSON=0
QUIET=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json)  JSON=1; shift;;
    --quiet) QUIET=1; shift;;
    -h|--help)
      sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'
      exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

emit() {
  local kind="$1" cmd="$2" slug="$3" reason="$4" exit_code="$5"
  if [[ "${QUIET}" -eq 1 ]]; then exit "${exit_code}"; fi
  if [[ "${JSON}" -eq 1 ]]; then
    printf '{"kind":"%s","next":"%s","slug":"%s","reason":"%s","exit":%s}\n' \
      "${kind}" "${cmd}" "${slug}" "${reason}" "${exit_code}"
  else
    case "${kind}" in
      gate)   echo "SAD next step: GATE ${cmd} ${slug}  — ${reason}";;
      run)    echo "SAD next step: ${cmd}  — ${reason}";;
      setup)  echo "SAD next step: ${cmd}  — ${reason}";;
      done)   echo "SAD next step: feature complete — set Phase: none in .sad/state/sad-state.md for the next feature.";;
      *)      echo "SAD next step: ${cmd}  — ${reason}";;
    esac
  fi
  exit "${exit_code}"
}

# 1. Project-level checks
if [[ ! -d "${ROOT}/.sad" ]]; then
  emit setup "/sad-setup" "" ".sad/ not present in this project" 3
fi
if [[ ! -f "${CONST}" ]] \
  || grep -qE '\[name\]|\[who\]|\[List people' "${CONST}" 2>/dev/null \
  || ! grep -qE '^##? ' "${CONST}" 2>/dev/null; then
  emit setup "/sad-constitution" "" "constitution missing or has unfilled placeholders" 3
fi

# 2. Parse state file
SLUG=""
PHASE="none"
LASTCMD=""
if [[ -f "${STATE}" ]]; then
  raw_slug="$(grep -E '^- \*\*Slug:\*\*' "${STATE}" 2>/dev/null | head -1 | sed 's/^- \*\*Slug:\*\* *//' || true)"
  raw_phase="$(grep -E '^- \*\*Phase:\*\*' "${STATE}" 2>/dev/null | head -1 | sed 's/^- \*\*Phase:\*\* *//' || true)"
  raw_last="$(grep -E '^- \*\*Last command:\*\*' "${STATE}" 2>/dev/null | head -1 | sed 's/^- \*\*Last command:\*\* *//' || true)"
  # strip a placeholder bracket [...] verbatim
  case "${raw_slug}" in '['*']'*|'') SLUG="";; *) SLUG="${raw_slug%% *}";; esac
  case "${raw_phase}" in '['*']'*|'') PHASE="none";; *) PHASE="${raw_phase%% *}";; esac
  case "${raw_last}" in '['*']'*|'') LASTCMD="";; *) LASTCMD="${raw_last%% *}";; esac
fi
PHASE="$(echo "${PHASE}" | tr '[:upper:]' '[:lower:]')"

# 3. Phase → next-command lookup, plus gate detection
case "${PHASE}" in
  none|"")
    # No active feature; nudge user toward starting one
    if [[ -d "${SPECS}" ]] && find "${SPECS}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | grep -q .; then
      emit run "/sad-brainstorm" "" "no active feature recorded — pick one from specs/ or start a new one" 0
    fi
    emit run "/sad-brainstorm" "" "no active feature — start by brainstorming requirements" 0
    ;;
  setup-needed)        emit setup "/sad-setup"             "${SLUG}" "setup not yet run" 3;;
  constitution-needed) emit setup "/sad-constitution"      "${SLUG}" "constitution not yet filled" 3;;
  brainstorm)          emit run   "/sad-specify"           "${SLUG}" "brainstorm complete" 0;;
  specify)             emit run   "/sad-clarify"           "${SLUG}" "spec drafted" 0;;
  clarify)             emit run   "/sad-impact-forecast"   "${SLUG}" "spec stable" 0;;
  impact-forecast)     emit run   "/sad-plan"              "${SLUG}" "impact forecast written" 0;;
  plan)                emit run   "/sad-walkthrough"       "${SLUG}" "plan written" 0;;
  walkthrough)
    # Check tier approvals — if all three are ticked, advance to walkthrough-approved.
    if [[ -n "${SLUG}" && -d "${SPECS}/${SLUG}/walkthroughs" ]] \
      && bash "${ROOT}/.sad/scripts/check-tier-approvals.sh" "${SPECS}/${SLUG}" >/dev/null 2>&1; then
      emit run "/sad-analyze" "${SLUG}" "all three tiers approved" 0
    fi
    emit gate "walkthrough" "${SLUG}" "awaiting tier approvals — see specs/${SLUG}/walkthroughs/" 2
    ;;
  walkthrough-approved) emit run "/sad-analyze"    "${SLUG}" "walkthroughs approved" 0;;
  analyze)              emit run "/sad-tasks"      "${SLUG}" "analysis complete" 0;;
  tasks)                emit run "/sad-implement"  "${SLUG}" "task list written" 0;;
  implement)            emit run "/sad-review"     "${SLUG}" "implementation complete" 0;;
  review)               emit run "/sad-reconcile"  "${SLUG}" "reviewer fleet finished" 0;;
  reconcile)            emit gate "reconcile"      "${SLUG}" "awaiting semi-technical sign-off on reconciliation verdicts" 2;;
  reconcile-approved)   emit run "/sad-compound"   "${SLUG}" "reconciliation approved" 0;;
  compound)             emit done ""               "${SLUG}" "feature complete" 0;;
  *)                    emit run "/sad-doctor"     "${SLUG}" "unrecognized phase '${PHASE}' — run doctor to diagnose" 0;;
esac
