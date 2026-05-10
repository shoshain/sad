#!/usr/bin/env bash
set -euo pipefail

# create-feature.sh — scaffold specs/<prefix>-<slug>/ from SAD templates.
# Usage: ./create-feature.sh 001 my-feature-name

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <numeric-prefix> <slug-dashed>" >&2
  exit 1
fi

prefix="$1"
shift
slug_raw="$*"
slug="$(echo "${slug_raw}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
feat="${root}/specs/${prefix}-${slug}"
tpl="${root}/.sad/templates"

mkdir -p "${feat}/walkthroughs" "${feat}/demo" "${feat}/stories" "${feat}/evals" "${feat}/contracts"

copy_tpl() {
  local name="$1"
  local dest="$2"
  if [[ -f "${tpl}/${name}" ]]; then
    cp "${tpl}/${name}" "${dest}"
  else
    echo "Template missing: ${tpl}/${name}" >&2
    exit 1
  fi
}

copy_tpl "feature.spec.md" "${feat}/feature.spec.md"
copy_tpl "feature.plan.md" "${feat}/feature.plan.md"
copy_tpl "tasks.md" "${feat}/tasks.md"
copy_tpl "impact-forecast.md" "${feat}/impact-forecast.md"
copy_tpl "reconciliation.md" "${feat}/reconciliation.md"
copy_tpl "walkthrough-non-technical.md" "${feat}/walkthroughs/non-technical.md"
copy_tpl "walkthrough-semi-technical.md" "${feat}/walkthroughs/semi-technical.md"
copy_tpl "walkthrough-technical.md" "${feat}/walkthroughs/technical.md"

echo "Scaffolded ${feat}"
