#!/usr/bin/env bash
# sad-init.sh — install SAD methodology into a target project.
#
# Usage:
#   ./scripts/sad-init.sh [flags] <target-dir>
#
# Flags:
#   --minimal              Install only the methodology core (.sad/ + LIFECYCLE.md, CHEATSHEET.md,
#                          QUICKSTART.md, MATURITY.md, ROLES.md, MANIFESTO.md, NOVEL.md, GLOSSARY.md,
#                          DAEMON.md) and the matching adapter pack.
#                          Skip commands/, agents/, hooks/, evals/, examples/, SAD_USER_GUIDE.md,
#                          ATTRIBUTION.md.
#   --persistent           Wire SessionStart hooks (Claude Code) or alwaysApply:true rules (Cursor).
#                          No-op for adapters where persistence is the default (Aider, Codex, Windsurf).
#   --assistant=NAME       Force adapter: auto | claude-code | cursor | aider | codex | windsurf | none.
#                          Default: auto-detect.
#   --telemetry=on|off     Opt-in anonymous adoption telemetry. Default: off.
#   --force                Overwrite existing files. Default: skip files that already exist.
#   --dry-run              Print what would be done; write nothing.
#   -h, --help             This message.
#
# Exit codes:
#   0  success
#   1  generic error
#   2  usage error
#   3  target directory does not exist (use --create-target to mkdir)

set -euo pipefail

MINIMAL=0
PERSISTENT=0
ASSISTANT=auto
TELEMETRY=off
FORCE=0
DRY_RUN=0
TARGET=""

usage() { sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --minimal)        MINIMAL=1; shift;;
    --persistent)     PERSISTENT=1; shift;;
    --assistant=*)    ASSISTANT="${1#--assistant=}"; shift;;
    --telemetry=*)    TELEMETRY="${1#--telemetry=}"; shift;;
    --force)          FORCE=1; shift;;
    --dry-run)        DRY_RUN=1; shift;;
    -h|--help)        usage; exit 0;;
    -* )              echo "Unknown flag: $1" >&2; usage; exit 2;;
    *)                TARGET="$1"; shift;;
  esac
done

[[ -n "${TARGET}" ]] || { echo "Missing target dir." >&2; usage; exit 2; }
[[ -d "${TARGET}" ]] || { echo "Target dir does not exist: ${TARGET}" >&2; exit 3; }

SAD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$(cd "${TARGET}" && pwd)"

say() { echo "[sad-init] $*"; }
do_run() { if [[ "${DRY_RUN}" -eq 1 ]]; then say "DRY: $*"; else "$@"; fi; }

# --- detection ---
detect_assistant() {
  if [[ "${ASSISTANT}" != "auto" ]]; then echo "${ASSISTANT}"; return; fi
  if [[ -d "${TARGET}/.claude"   ]]; then echo "claude-code"; return; fi
  if [[ -d "${TARGET}/.cursor"   ]]; then echo "cursor";      return; fi
  if [[ -d "${TARGET}/.windsurf" ]]; then echo "windsurf";    return; fi
  if [[ -f "${TARGET}/.aider.conf.yml" || -f "${TARGET}/.aider.input.history" ]]; then echo "aider"; return; fi
  if [[ -d "${TARGET}/.codex"    ]]; then echo "codex";       return; fi
  if [[ -f "${TARGET}/AGENTS.md" ]]; then echo "codex";       return; fi  # AGENTS.md alone -> Codex/cross-assistant minimal
  echo "none"
}
DETECTED=$(detect_assistant)
say "detected assistant: ${DETECTED}"

# --- copy helpers ---
copy_dir() {
  local src="$1" dst="$2"
  if [[ ! -d "${src}" ]]; then return; fi
  do_run mkdir -p "${dst}"
  if [[ "${FORCE}" -eq 1 ]]; then
    do_run cp -R "${src}/." "${dst}/"
  else
    # additive copy: do not overwrite existing files
    (cd "${src}" && find . -type f -print0) | while IFS= read -r -d '' f; do
      if [[ ! -e "${dst}/${f}" ]]; then
        do_run mkdir -p "$(dirname "${dst}/${f}")"
        do_run cp "${src}/${f}" "${dst}/${f}"
      fi
    done
  fi
}

copy_file() {
  local src="$1" dst="$2"
  if [[ ! -f "${src}" ]]; then return; fi
  if [[ -e "${dst}" && "${FORCE}" -ne 1 ]]; then
    say "skip (exists): ${dst#${TARGET}/}"
    return
  fi
  do_run mkdir -p "$(dirname "${dst}")"
  do_run cp "${src}" "${dst}"
}

# --- methodology core ---
say "installing methodology core into ${TARGET}"
copy_dir  "${SAD_ROOT}/.sad"             "${TARGET}/.sad"
copy_file "${SAD_ROOT}/LIFECYCLE.md"     "${TARGET}/LIFECYCLE.md"
copy_file "${SAD_ROOT}/CHEATSHEET.md"    "${TARGET}/CHEATSHEET.md"
copy_file "${SAD_ROOT}/QUICKSTART.md"    "${TARGET}/QUICKSTART.md"
copy_file "${SAD_ROOT}/MATURITY.md"      "${TARGET}/MATURITY.md"
copy_file "${SAD_ROOT}/ROLES.md"         "${TARGET}/ROLES.md"
copy_file "${SAD_ROOT}/MANIFESTO.md"     "${TARGET}/MANIFESTO.md"
copy_file "${SAD_ROOT}/NOVEL.md"         "${TARGET}/NOVEL.md"
copy_file "${SAD_ROOT}/GLOSSARY.md"      "${TARGET}/GLOSSARY.md"
copy_file "${SAD_ROOT}/DAEMON.md"        "${TARGET}/DAEMON.md"

if [[ "${MINIMAL}" -ne 1 ]]; then
  copy_dir "${SAD_ROOT}/commands"        "${TARGET}/commands"
  copy_dir "${SAD_ROOT}/agents"          "${TARGET}/agents"
  copy_dir "${SAD_ROOT}/hooks"           "${TARGET}/hooks"
  copy_dir "${SAD_ROOT}/evals"           "${TARGET}/evals"
  copy_dir "${SAD_ROOT}/examples"        "${TARGET}/examples"
  copy_file "${SAD_ROOT}/SAD_USER_GUIDE.md" "${TARGET}/SAD_USER_GUIDE.md"
  copy_file "${SAD_ROOT}/ATTRIBUTION.md"    "${TARGET}/ATTRIBUTION.md"
fi

# specs/ dir at target root
do_run mkdir -p "${TARGET}/specs"

# --- adapter ---
apply_adapter() {
  local name="$1" persistent="$2"
  if [[ "${name}" == "none" ]]; then
    copy_file "${SAD_ROOT}/adapters/codex/AGENTS.md" "${TARGET}/AGENTS.md"
    return
  fi
  local apath="${SAD_ROOT}/adapters/${name}"
  if [[ ! -d "${apath}" ]]; then say "no adapter: ${name}"; return; fi
  case "${name}" in
    claude-code)
      do_run mkdir -p "${TARGET}/.claude/commands" "${TARGET}/.claude/skills/sad"
      if [[ "${persistent}" -eq 1 ]]; then
        copy_file "${apath}/settings.persistent.json" "${TARGET}/.claude/settings.json"
      else
        copy_file "${apath}/settings.json"            "${TARGET}/.claude/settings.json"
      fi
      copy_file "${apath}/skills/sad/SKILL.md"        "${TARGET}/.claude/skills/sad/SKILL.md"
      # Generate one command pointer per commands/sad-*.md
      for cmd in "${SAD_ROOT}/commands/"sad-*.md; do
        [[ -f "${cmd}" ]] || continue
        local base="$(basename "${cmd}")"
        local dst="${TARGET}/.claude/commands/${base}"
        if [[ -e "${dst}" && "${FORCE}" -ne 1 ]]; then continue; fi
        do_run bash -c "cat > '${dst}' <<EOF
# ${base%.*}

Claude Code slash-command pointer. The canonical prompt lives at \`commands/${base}\` in this repo. Read it and follow its 'Your task' / 'Discipline' sections exactly.
EOF
"
      done
      copy_file "${SAD_ROOT}/adapters/codex/AGENTS.md" "${TARGET}/AGENTS.md"  # canonical root file
      ;;
    cursor)
      do_run mkdir -p "${TARGET}/.cursor/rules" "${TARGET}/.cursor/commands"
      if [[ "${persistent}" -eq 1 ]]; then
        copy_file "${apath}/sad-routing.persistent.mdc" "${TARGET}/.cursor/rules/sad-routing.mdc"
      else
        copy_file "${apath}/sad-routing.mdc"            "${TARGET}/.cursor/rules/sad-routing.mdc"
      fi
      for cmd in "${SAD_ROOT}/commands/"sad-*.md; do
        [[ -f "${cmd}" ]] || continue
        copy_file "${cmd}" "${TARGET}/.cursor/commands/$(basename "${cmd}")"
      done
      copy_file "${SAD_ROOT}/adapters/codex/AGENTS.md" "${TARGET}/AGENTS.md"
      ;;
    aider)
      copy_file "${apath}/CONVENTIONS.md"              "${TARGET}/CONVENTIONS.md"
      copy_file "${apath}/.aider.conf.yml.snippet"     "${TARGET}/.aider.conf.yml.snippet"
      copy_file "${SAD_ROOT}/adapters/codex/AGENTS.md" "${TARGET}/AGENTS.md"
      ;;
    codex)
      copy_file "${apath}/AGENTS.md"                   "${TARGET}/AGENTS.md"
      ;;
    windsurf)
      do_run mkdir -p "${TARGET}/.windsurf/rules"
      copy_file "${apath}/sad-routing.md"              "${TARGET}/.windsurf/rules/sad-routing.md"
      copy_file "${SAD_ROOT}/adapters/codex/AGENTS.md" "${TARGET}/AGENTS.md"
      ;;
    *) say "unknown adapter: ${name}";;
  esac
}

apply_adapter "${DETECTED}" "${PERSISTENT}"

# --- telemetry ---
if [[ "${TELEMETRY}" == "on" ]]; then
  do_run bash -c "echo '{\"telemetry\": \"opt-in\", \"installed\": \"$(date -u +%FT%TZ)\"}' > '${TARGET}/.sad/state/telemetry.json'"
fi

# --- run doctor ---
if [[ -f "${TARGET}/.sad/scripts/doctor.sh" ]]; then
  say "running /sad-doctor on the freshly installed target"
  (cd "${TARGET}" && bash .sad/scripts/doctor.sh) || say "doctor reported findings (this is normal on a fresh install)"
fi

say "done. target: ${TARGET} ; adapter: ${DETECTED} ; persistent: ${PERSISTENT} ; minimal: ${MINIMAL}"
say "next: cd ${TARGET} && open QUICKSTART.md"
