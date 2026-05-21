---
description: Run spec-drift-detector + spec-reconciler; emit reconciliation.md with verdicts.
phase: per-feature
inputs:
  - specs/<feature>/feature.spec.md
  - specs/<feature>/data-model.md / contracts/
  - implementation source files
outputs:
  - specs/<feature>/reconciliation.md
flags:
  - --feature <slug>
gate: semi-technical reviewer approves verdicts before merge
---

You are running **SAD Reconcile**.

## Your task
Follow `agents/reconciliation/spec-drift-detector.md` and `agents/reconciliation/spec-reconciler.md` to populate `reconciliation.md` from `.sad/templates/reconciliation.md`.

## Discipline
- Detection first—do not silently edit code in this phase unless the user explicitly requests auto-fix in their harness.
- Every discrepancy gets a verdict: `spec-update`, `code-update`, or `both-update`.

## Output
Write `reconciliation.md`; highlight blocking items at top.
