---
description: Scheduled sweep for spec drift across features (garbage-collection sensor pattern).
phase: maintenance
inputs:
  - specs/*/feature.spec.md
  - repository implementation
outputs:
  - .sad/state/drift-report.md
flags:
  - --feature <slug>   restrict the scan to a single feature
  - --json             emit machine-readable JSON instead of Markdown
---

You are running **SAD Spec Drift Scan**.

## Your task
For each feature under `specs/`, run detection heuristics from `agents/reconciliation/spec-drift-detector.md` at lower fidelity than `/sad-reconcile`. Flag features needing full reconciliation.

Helper script: `.sad/scripts/drift-scan.sh` (missing reconciliation artifact).

## Discipline
- Do not mutate prod code in scan-only mode.
- Aggregate by severity for triage.

## Output
Emit a concise report with next actions per feature slug.
