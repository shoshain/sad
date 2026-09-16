#!/usr/bin/env bash
set -euo pipefail

# hook-tier-gate.sh — Claude Code PreToolUse adapter for check-tier-approvals.sh.
# Claude Code sends the hook input as JSON on stdin; this reads tool_input.file_path
# (a specs/<slug>/tasks.md being written) and checks that feature's tier approvals.
# Exit 0: allow. Exit 2: block; stderr is shown to Claude as the reason.

input="$(cat)"

# No jq dependency: take the first unescaped "file_path" string, then undo JSON escapes.
file_path="$(printf '%s' "${input}" | tr -d '\n' \
  | sed -nE 's/^.*"file_path"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*$/\1/p' \
  | sed -e 's/\\\//\//g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')"

if [[ -z "${file_path}" ]]; then
  echo "SAD tier gate: could not read tool_input.file_path from the hook input, so tasks.md stays blocked. Check .sad/scripts/hook-tier-gate.sh." >&2
  exit 2
fi

exec bash "$(dirname "$0")/check-tier-approvals.sh" "$(dirname "${file_path}")"
