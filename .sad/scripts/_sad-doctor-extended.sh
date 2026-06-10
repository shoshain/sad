#!/usr/bin/env bash
# _sad-doctor-extended.sh — theater + substrate checks (sourced by doctor.sh).

_sad_doctor_extended() {
  local root="$1"
  local specs="${root}/specs"
  local lib
  lib="$(dirname "$0")/_sad-approval-lib.sh"
  # shellcheck source=_sad-approval-lib.sh
  source "${lib}"

  local pending_days=14
  if [[ -f "${root}/.sad/memory/constitution.md" ]] \
    && grep -qE 'pending approval.*days|PENDING_APPROVAL_DAYS' "${root}/.sad/memory/constitution.md" 2>/dev/null; then
    pending_days="$(grep -iE 'pending approval.*days|PENDING_APPROVAL_DAYS' "${root}/.sad/memory/constitution.md" | head -1 | grep -oE '[0-9]+' | head -1 || echo 14)"
  fi

  # Stale pending approvals
  if [[ -d "${specs}" ]]; then
    while IFS= read -r -d '' fdir; do
      name="$(basename "${fdir}")"
      for tier in non-technical semi-technical technical; do
        local label file st since
        label="$(_sad_tier_label "${tier}")"
        file="$(_sad_tier_file "${fdir}" "${tier}")"
        st="$(_sad_approval_status "${file}" "${label}")"
        [[ "${st}" == "pending" ]] || continue
        since="$(_sad_approval_field "${file}" 'pending since:')"
        if [[ -n "${since}" ]]; then
          local now epoch since_epoch days
          now="$(date +%s)"
          since_epoch="$(date -j -f "%Y-%m-%d" "${since}" +%s 2>/dev/null || date -d "${since}" +%s 2>/dev/null || echo 0)"
          if [[ "${since_epoch}" -gt 0 ]]; then
            days=$(( (now - since_epoch) / 86400 ))
            if [[ "${days}" -gt "${pending_days}" ]]; then
              record "gates.${name}.${tier}.stale_pending" "yellow" \
                "${name}: ${tier} pending ${days}d (threshold ${pending_days}d)" \
                "Send review packet via /sad-stakeholder-report or escalate delegate"
            fi
          fi
        fi
      done
      # Single-tier collapse heuristic
      local nt st t ov
      nt="$(_sad_tier_file "${fdir}" non-technical)"
      st="$(_sad_tier_file "${fdir}" semi-technical)"
      t="$(_sad_tier_file "${fdir}" technical)"
      ov="$(_sad_walkthrough_overlap_pct "${nt}" "${st}")"
      if [[ "${ov}" -ge 70 ]]; then
        record "theater.${name}.collapse_nt_st" "yellow" \
          "${name}: non-technical vs semi-technical walkthrough ${ov}% overlap" \
          "Differentiate tiers; see SAD_USER_GUIDE §16 single-tier collapse"
      fi
      ov="$(_sad_walkthrough_overlap_pct "${st}" "${t}")"
      if [[ "${ov}" -ge 70 ]]; then
        record "theater.${name}.collapse_st_t" "yellow" \
          "${name}: semi-technical vs technical walkthrough ${ov}% overlap" \
          "Technical walkthrough should include PR/eval detail ST tier omits"
      fi
    done < <(find "${specs}" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
  fi

  # Stakeholder TBD with features in flight
  local feat_count=0
  [[ -d "${specs}" ]] && feat_count="$(find "${specs}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  if [[ "${feat_count}" -gt 0 ]]; then
    for tier in non-technical semi-technical technical; do
      local sf="${root}/.sad/stakeholders/${tier}.md"
      if [[ -f "${sf}" ]] && grep -qE 'TBD|\[List people' "${sf}"; then
        record "theater.stakeholders.${tier}_tbd" "yellow" \
          "${feat_count} feature(s) exist but stakeholders/${tier}.md still TBD" \
          "Name real reviewers — collapsing tiers is spec theater"
      fi
    done
  fi

  # Substrate vs claimed maturity
  local claimed=""
  if [[ -f "${root}/.sad/memory/constitution.md" ]]; then
    claimed="$(grep -i 'Maturity level' "${root}/.sad/memory/constitution.md" | head -1 | grep -oE 'Level [0-9]+' || true)"
  fi
  local lesson_count=0
  if [[ -d "${root}/.sad/memory/lessons" ]]; then
    lesson_count="$(find "${root}/.sad/memory/lessons" -maxdepth 1 -name 'L-*.md' 2>/dev/null | wc -l | tr -d ' ')"
  fi
  if [[ "${claimed}" == *"Level 3"* || "${claimed}" == *"Level 4"* ]]; then
    if [[ "${lesson_count}" -lt 3 ]]; then
      record "substrate.lessons_shallow" "yellow" \
        "Claimed ${claimed} but only ${lesson_count} lesson(s) in .sad/memory/lessons/" \
        "Compound after features; substrate suggests lower maturity"
    fi
  fi

  local code_up=0 spec_up=0
  if [[ -d "${specs}" ]]; then
    while IFS= read -r -d '' rec; do
      grep -qi 'code-update' "${rec}" && code_up=$((code_up + 1))
      grep -qi 'spec-update' "${rec}" && spec_up=$((spec_up + 1))
    done < <(find "${specs}" -name 'reconciliation.md' -print0 2>/dev/null)
  fi
  local total=$((code_up + spec_up))
  if [[ "${total}" -ge 5 && "${code_up}" -gt $((spec_up * 3)) ]]; then
    record "substrate.reconcile_drift" "yellow" \
      "Reconciliation skew: ${code_up} code-update vs ${spec_up} spec-update verdicts" \
      "Review spec quality or implementation discipline"
  fi

  # Level 0 stand-in calibration
  if [[ -f "${root}/.sad/memory/constitution.md" ]] \
    && grep -qi 'Level 0\|Solo SAD' "${root}/.sad/memory/constitution.md" 2>/dev/null; then
    if ! grep -qi 'last calibrated' "${root}/.sad/memory/constitution.md" 2>/dev/null; then
      record "substrate.standin_calibration" "yellow" \
        "Level 0 / stand-in active but no calibration line in constitution" \
        "Add 'Tier X reviewer is AI-stand-in (last calibrated YYYY-MM-DD)' per MATURITY.md"
    fi
  fi
}
