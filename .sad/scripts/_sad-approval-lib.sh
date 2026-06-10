#!/usr/bin/env bash
# _sad-approval-lib.sh — shared walkthrough approval parsing (sourced, not executed).
# Recognizes: approved ([x] checkbox), pending (explicit status), unchecked (blocks tasks).

_sad_tier_file() {
  local feat="$1" tier="$2"
  case "${tier}" in
    non-technical|nt)  echo "${feat}/walkthroughs/non-technical.md" ;;
    semi-technical|st) echo "${feat}/walkthroughs/semi-technical.md" ;;
    technical|t)       echo "${feat}/walkthroughs/technical.md" ;;
    *) return 1 ;;
  esac
}

_sad_tier_label() {
  case "$1" in
    non-technical|nt)  echo "Non-technical" ;;
    semi-technical|st) echo "Semi-technical" ;;
    technical|t)       echo "Technical" ;;
  esac
}

# Echo: approved | pending | unchecked | missing
_sad_approval_status() {
  local file="$1" label="$2"
  if [[ ! -f "${file}" ]]; then
    echo "missing"
    return
  fi
  if grep -qiE -- "^-[[:space:]]*\\[x\\].*${label}.*reviewer" "${file}"; then
    echo "approved"
    return
  fi
  if grep -qiE -- "approval status:[[:space:]]*\*\*pending\*\*|\\*\\*status:\\*\\*[[:space:]]*pending" "${file}"; then
    echo "pending"
    return
  fi
  if grep -qiE -- "^-[[:space:]]*\\[ \\].*${label}.*reviewer" "${file}"; then
    echo "unchecked"
    return
  fi
  echo "unchecked"
}

_sad_approval_field() {
  local file="$1" pattern="$2"
  [[ -f "${file}" ]] || return 0
  grep -iE "${pattern}" "${file}" 2>/dev/null | head -1 | sed -E 's/^[^:]*:[[:space:]]*//' | sed 's/^\*\*//;s/\*\*$//' | tr -d '\r' || true
}

_sad_all_tiers_approved() {
  local feat="$1"
  local ok=0
  for tier in non-technical semi-technical technical; do
    local label file st
    label="$(_sad_tier_label "${tier}")"
    file="$(_sad_tier_file "${feat}" "${tier}")"
    st="$(_sad_approval_status "${file}" "${label}")"
    [[ "${st}" == "approved" ]] || ok=1
  done
  return "${ok}"
}

# Jaccard-like word overlap 0-100 between two files (body before ## Approval)
_sad_walkthrough_overlap_pct() {
  local a="$1" b="$2"
  [[ -f "${a}" && -f "${b}" ]] || { echo "0"; return; }
  local tmp
  tmp="$(mktemp)"
  for f in "${a}" "${b}"; do
    sed '/^## Approval/,$d' "${f}" | tr '[:upper:]' '[:lower:]' | tr -cs 'A-Za-z0-9' '\n' | sort -u >> "${tmp}"
  done
  local wa wb inter union
  wa="$(sed '/^## Approval/,$d' "${a}" | tr '[:upper:]' '[:lower:]' | tr -cs 'A-Za-z0-9' '\n' | sort -u | wc -l | tr -d ' ')"
  wb="$(sed '/^## Approval/,$d' "${b}" | tr '[:upper:]' '[:lower:]' | tr -cs 'A-Za-z0-9' '\n' | sort -u | wc -l | tr -d ' ')"
  inter="$(comm -12 \
    <(sed '/^## Approval/,$d' "${a}" | tr '[:upper:]' '[:lower:]' | tr -cs 'A-Za-z0-9' '\n' | sort -u) \
    <(sed '/^## Approval/,$d' "${b}" | tr '[:upper:]' '[:lower:]' | tr -cs 'A-Za-z0-9' '\n' | sort -u) | wc -l | tr -d ' ')"
  union=$(( wa + wb - inter ))
  rm -f "${tmp}"
  [[ "${union}" -gt 0 ]] || { echo "0"; return; }
  echo $(( inter * 100 / union ))
}

_sad_read_triage_size() {
  local f="$1/intent-size-triage.md"
  [[ -f "${f}" ]] || { echo "bounded"; return; }
  if grep -qiE '^\*\*Size:\*\*[[:space:]]*trivial|size:[[:space:]]*trivial' "${f}"; then
    echo "trivial"
  elif grep -qiE '^\*\*Size:\*\*[[:space:]]*strategic|size:[[:space:]]*strategic' "${f}"; then
    echo "strategic"
  else
    echo "bounded"
  fi
}
