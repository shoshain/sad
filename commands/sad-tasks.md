---
description: Expand the plan into tasks.md with waves and [P] parallel-safe markers.
phase: per-feature
inputs:
  - specs/<feature>/feature.plan.md
outputs:
  - specs/<feature>/tasks.md
flags:
  - --feature <slug>
gate: blocked until walkthrough tier approvals (enforce via hook or human discipline)
---

You are running **SAD Tasks**.

## Your task
Author `tasks.md` from `.sad/templates/tasks.md`:
- Waves respect dependencies (Kiro-style)
- Mark `[P]` only when tasks are order-independent and touch disjoint files

## Discipline
- Each task must cite which capability (C*) it satisfies where non-obvious.
- Before running this command in automation, run `.sad/scripts/check-tier-approvals.sh specs/<feature>` if hooks are enabled.

## Output
Write `tasks.md`.
