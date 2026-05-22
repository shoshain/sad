#!/usr/bin/env bash
# sad-schedule.sh — install or remove cron entries for SAD's scheduled commands.
#
# Per DAEMON.md §2: SAD does not run a long-lived daemon. Cadence work is owned
# by the user's existing scheduler — this script just writes (or removes) entries
# in their crontab.
#
# Scheduled commands installed:
#   /sad-spec-drift-scan    — daily   — runs .sad/scripts/drift-scan.sh
#   /sad-compound-refresh   — monthly — emits a reminder to invoke the slash command
#   /sad-evolve-evals       — weekly  — emits a reminder to invoke the slash command
#
# Why reminders for the latter two: those commands do meaningful work *inside* the
# AI assistant session (curating lessons, evolving evals). A cron job cannot
# substitute for that — it can only nudge the human to invoke the slash command.
# /sad-spec-drift-scan, by contrast, has a real script (drift-scan.sh) and runs
# unattended.
#
# Usage:
#   ./scripts/sad-schedule.sh install <target-dir>       install crontab entries
#   ./scripts/sad-schedule.sh uninstall <target-dir>     remove them
#   ./scripts/sad-schedule.sh list <target-dir>          show current SAD entries
#   ./scripts/sad-schedule.sh dry-run install <dir>      print what would be written
#
# Notes:
#   - Modifies the invoking user's crontab via `crontab -l | … | crontab -`.
#   - SAD-owned lines are tagged with the comment marker "# sad-schedule:<target>"
#     so uninstall is a deterministic line filter.
#   - Reminder cron jobs write a one-line note to .sad/state/scheduled-reminders.log;
#     the user can tail this on startup or check it from /sad-doctor.

set -euo pipefail

ACTION="${1:-}"
TARGET="${2:-}"

usage() { sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

[[ -n "${ACTION}" && -n "${TARGET}" ]] || usage

DRY=0
if [[ "${ACTION}" == "dry-run" ]]; then
  DRY=1
  ACTION="${3:-}"
  [[ -n "${ACTION}" ]] || usage
fi

[[ -d "${TARGET}" ]] || { echo "Target does not exist: ${TARGET}" >&2; exit 3; }
TARGET="$(cd "${TARGET}" && pwd)"
MARKER="# sad-schedule:${TARGET}"
LOG="${TARGET}/.sad/state/scheduled-reminders.log"

ensure_crontab() {
  if ! command -v crontab >/dev/null 2>&1; then
    echo "crontab not found on this system. Install cron or use your own scheduler." >&2
    echo "Equivalent entries to add manually:" >&2
    print_entries
    exit 4
  fi
}

print_entries() {
  cat <<EOF
0 9 * * *  (cd "${TARGET}" && bash .sad/scripts/drift-scan.sh >> .sad/state/scheduled-reminders.log 2>&1)  ${MARKER}:drift-scan
0 9 1 * *  echo "[\$(date -u +%FT%TZ)] SAD reminder: run /sad-compound-refresh in ${TARGET}" >> "${LOG}"  ${MARKER}:compound-refresh
0 9 * * 1  echo "[\$(date -u +%FT%TZ)] SAD reminder: run /sad-evolve-evals in ${TARGET}" >> "${LOG}"  ${MARKER}:evolve-evals
EOF
}

list_entries() {
  crontab -l 2>/dev/null | grep -F "${MARKER}" || echo "(no SAD entries for ${TARGET})"
}

install_entries() {
  ensure_crontab
  local current new
  current="$(crontab -l 2>/dev/null || true)"
  # Strip any existing SAD entries for this target so we replace cleanly.
  new="$(printf '%s\n' "${current}" | grep -vF "${MARKER}" || true)"
  new="${new}
$(print_entries)"
  if [[ "${DRY}" -eq 1 ]]; then
    echo "DRY: would write the following crontab:"
    echo "----"
    printf '%s\n' "${new}"
    echo "----"
    return 0
  fi
  printf '%s\n' "${new}" | crontab -
  echo "Installed 3 SAD scheduled entries for ${TARGET}."
  echo "Tagged with: ${MARKER}"
}

uninstall_entries() {
  ensure_crontab
  local current new
  current="$(crontab -l 2>/dev/null || true)"
  new="$(printf '%s\n' "${current}" | grep -vF "${MARKER}" || true)"
  if [[ "${DRY}" -eq 1 ]]; then
    echo "DRY: would write the following crontab:"
    echo "----"
    printf '%s\n' "${new}"
    echo "----"
    return 0
  fi
  printf '%s\n' "${new}" | crontab -
  echo "Removed SAD scheduled entries for ${TARGET}."
}

case "${ACTION}" in
  install)   install_entries;;
  uninstall) uninstall_entries;;
  list)      list_entries;;
  *) usage;;
esac
