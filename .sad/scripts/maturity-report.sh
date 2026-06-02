#!/usr/bin/env bash
set -euo pipefail

# maturity-report.sh — graduation-readiness card.
#
# Reads:
#   .sad/state/maturity-level.json           (current level + thresholds)
#   .sad/state/rollback-log.md (if present)  (rollback rows since level start)
#   .sad/state/satisfaction/YYYY-MM/*.md     (per-tier monthly surveys)
#   specs/*/                                 (feature counts)
#
# Emits:
#   Pretty text report (default).
#   --json  : structured JSON to stdout.
#
# Exit codes:
#   0 = report produced; 1 = required state file missing.

JSON=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=1; shift ;;
    -h|--help)
      sed -n '3,17p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE_FILE="${ROOT}/.sad/state/maturity-level.json"

if [[ ! -f "${STATE_FILE}" ]]; then
  echo "Missing ${STATE_FILE}. Copy the template from .sad/templates/ or run /sad-doctor." >&2
  exit 1
fi

current_level=$(grep -oE '"current_level"\s*:\s*[0-9]+' "${STATE_FILE}" | grep -oE '[0-9]+$' | head -n1)
level_started=$(grep -oE '"level_started_on"\s*:\s*"[^"]+"' "${STATE_FILE}" | sed -E 's/.*"([^"]+)"$/\1/')

# Feature count: directories under specs/ created since level_started.
features_total=0
features_since=0
if [[ -d "${ROOT}/specs" ]]; then
  while IFS= read -r -d '' d; do
    features_total=$((features_total + 1))
    if [[ -n "${level_started}" ]]; then
      # Use mtime as a proxy for creation date (POSIX has no portable birthtime).
      if [[ "$(date -u -r "${d}" +%F 2>/dev/null || echo '')" > "${level_started}" || \
            "$(date -u -r "${d}" +%F 2>/dev/null || echo '')" == "${level_started}" ]]; then
        features_since=$((features_since + 1))
      fi
    fi
  done < <(find "${ROOT}/specs" -mindepth 1 -maxdepth 1 -type d -print0)
fi

# Rollbacks: data rows under "## Rolling counters" in .sad/state/rollback-log.md.
rollbacks=0
ROLLBACK_LOG="${ROOT}/.sad/state/rollback-log.md"
if [[ -f "${ROLLBACK_LOG}" ]]; then
  # Count table rows starting with a YYYY-MM-DD date column.
  rollbacks=$(grep -cE '^\| [0-9]{4}-[0-9]{2}-[0-9]{2} \|' "${ROLLBACK_LOG}" || true)
fi

# Satisfaction: average Satisfaction % per tier across surveys in the most recent month.
sat_root="${ROOT}/.sad/state/satisfaction"
sat_avg_overall=""
sat_tiers_below=""
if [[ -d "${sat_root}" ]]; then
  latest_month=$(ls -1 "${sat_root}" 2>/dev/null | sort -r | head -n1 || true)
  if [[ -n "${latest_month}" && -d "${sat_root}/${latest_month}" ]]; then
    total=0; count=0
    for f in "${sat_root}/${latest_month}"/*.md; do
      [[ -f "${f}" ]] || continue
      pct=$(grep -oE 'Satisfaction[ _]%[^0-9]+[0-9]+' "${f}" | grep -oE '[0-9]+$' | head -n1 || true)
      if [[ -n "${pct:-}" ]]; then
        total=$((total + pct))
        count=$((count + 1))
        if [[ "${pct}" -lt 80 ]]; then
          tier=$(basename "${f}" .md)
          sat_tiers_below="${sat_tiers_below}${tier} (${pct}%) "
        fi
      fi
    done
    if [[ "${count}" -gt 0 ]]; then
      sat_avg_overall=$((total / count))
    fi
  fi
fi

# Compute rollback rate (since current level).
if [[ "${features_since}" -gt 0 ]]; then
  # bash has no float math; use awk.
  rb_rate=$(awk -v r="${rollbacks}" -v f="${features_since}" 'BEGIN{ printf("%.3f", r / f) }')
else
  rb_rate="n/a"
fi

# Pass/fail per threshold.
rb_ok="n/a"
if [[ "${rb_rate}" != "n/a" ]]; then
  rb_ok=$(awk -v x="${rb_rate}" 'BEGIN{ print (x+0 <= 0.05) ? "yes" : "no" }')
fi
sat_ok="n/a"
[[ -n "${sat_avg_overall}" ]] && sat_ok=$([[ "${sat_avg_overall}" -ge 80 ]] && echo yes || echo no)

if [[ "${JSON}" -eq 1 ]]; then
  cat <<EOF
{
  "current_level": ${current_level:-0},
  "level_started_on": "${level_started}",
  "features_total": ${features_total},
  "features_since_level_start": ${features_since},
  "rollbacks_since_level_start": ${rollbacks},
  "rollback_rate_per_feature": "${rb_rate}",
  "rollback_threshold_met": "${rb_ok}",
  "stakeholder_satisfaction_avg_pct": ${sat_avg_overall:-null},
  "stakeholder_satisfaction_threshold_met": "${sat_ok}",
  "tiers_below_threshold": "${sat_tiers_below% }"
}
EOF
else
  echo "/sad-maturity-report"
  echo "------------------------------------------------------------"
  echo "Current level         : ${current_level:-0}"
  echo "Level started         : ${level_started:-?}"
  echo "Features total        : ${features_total}"
  echo "Features since level  : ${features_since}"
  echo "Rollbacks since level : ${rollbacks}"
  echo "Rollback rate         : ${rb_rate} (threshold ≤ 0.05) → ${rb_ok}"
  if [[ -n "${sat_avg_overall}" ]]; then
    echo "Satisfaction avg %    : ${sat_avg_overall}% (threshold ≥ 80) → ${sat_ok}"
    if [[ -n "${sat_tiers_below}" ]]; then
      echo "Tiers below threshold : ${sat_tiers_below}"
    fi
  else
    echo "Satisfaction avg %    : no surveys recorded yet"
  fi
fi
