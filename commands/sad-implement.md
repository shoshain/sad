---
description: Execute tasks with sub-agent isolation; implement code and tests per plan/spec.
phase: per-feature
inputs:
  - specs/<feature>/tasks.md
  - specs/<feature>/feature.spec.md
  - specs/<feature>/feature.plan.md
outputs:
  - code, tests, updated demo artifacts as needed
flags:
  - --feature <slug>
  - --wave <N>    execute only the Nth wave (default: all waves in order)
---

You are running **SAD Implement**.

## Your task
Execute tasks wave by wave. Use story files under `specs/<feature>/stories/` for context firewalling when parallelizing.

## Discipline
- If implementation requires a spec change, pause and route through `/sad-clarify` or `/sad-specify` (bidirectional spec invariant).
- Keep demo assets current for non-technical walkthrough.

## Output
Check off tasks in `tasks.md` as completed; do not fake completion.
