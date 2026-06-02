#!/usr/bin/env bash
set -euo pipefail

# update-state.sh — patch fields in .sad/state/sad-state.md (simple key/value lines).
# Usage examples:
#   ./update-state.sh --feature 001-my-feature
#   ./update-state.sh --phase walkthrough
#   ./update-state.sh --last-command /sad-plan

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE="${ROOT}/.sad/state/sad-state.md"

[[ -f "${STATE}" ]] || exit 1

replace_kv() {
  local key="$1"
  local val="$2"
  [[ -n "${val}" ]] || return 0
  # Template format: '- **Key:** value' (colon inside bold).
  local pattern="^\\(- \\*\\*${key}:\\*\\* \\).*"
  if ! grep -qE -- "- \\*\\*${key}:\\*\\* " "${STATE}"; then
    echo "Warning: no '- **${key}:** ...' line found in ${STATE}" >&2
    return 0
  fi
  if [[ "$(uname -s)" == "Darwin" ]]; then
    sed -i '' "s#${pattern}#\\1${val}#" "${STATE}"
  else
    sed -i "s#${pattern}#\\1${val}#" "${STATE}"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --feature)
      replace_kv "Slug" "${2:-}"
      shift 2
      ;;
    --phase)
      replace_kv "Phase" "${2:-}"
      shift 2
      ;;
    --last-command)
      replace_kv "Last command" "${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

echo "Updated ${STATE}"
