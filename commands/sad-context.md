---
description: Context bundle before plan — lessons, prior reconciliations, constitution triggers (strategic triage).
phase: per-feature
inputs:
  - specs/<feature>/feature.intent.md
  - specs/<feature>/feature.spec.md
  - specs/<feature>/impact-forecast.md
  - .sad/memory/lessons/
  - specs/*/reconciliation.md (overlapping contracts)
  - .sad/memory/constitution.md
outputs:
  - specs/<feature>/context.md
template: .sad/templates/context.md
flags:
  - --feature <slug>
gate: semi-technical reviewer (advisory)
---

You are running **`/sad-context`**.

## Your task

Produce `context.md` from `.sad/templates/context.md`:

1. Search `.sad/memory/lessons/L-*.md` for domain-relevant entries; cite IDs.
2. Scan other features' `reconciliation.md` for overlapping contract surfaces.
3. List constitution articles the intent triggers (for the plan phase to address).
4. Summarize risks already named in `impact-forecast.md`.

## Discipline

- **Mandatory** when `intent-size-triage.md` verdict is **strategic**.
- **Optional** for bounded features when prior art is non-obvious.
- Every row must cite a source file — no ungrounded context bullets.
- `/sad-plan` must reference `context.md` in its opening section when this file exists.

## Output

Write `context.md`. Do not modify `feature.plan.md` in this phase.
