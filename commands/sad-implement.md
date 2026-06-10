---
description: Execute tasks with sub-agent isolation; presence checkpoints during build.
phase: per-feature
inputs:
  - specs/<feature>/tasks.md
  - specs/<feature>/feature.intent.md
  - specs/<feature>/feature.spec.md
  - specs/<feature>/feature.plan.md
outputs:
  - code, tests, updated demo artifacts as needed
  - specs/<feature>/checkpoints/checkpoint-N.md (when stakeholders cannot join live)
flags:
  - --feature <slug>
  - --wave <N>    execute only the Nth wave (default: all waves in order)
template: .sad/templates/checkpoint.md
---

You are running **SAD Implement**.

## Your task

Execute tasks wave by wave. Use story files under `specs/<feature>/stories/` for context firewalling when parallelizing.

## Presence in the loop (Article A11)

Gates stay mandatory; **presence** means the intent owner is not surprised at the gate:

- After each wave (or daily on long runs), append `checkpoints/checkpoint-N.md` using the template.
- Each checkpoint includes tier-appropriate summaries (NT plain English, ST plan delta, T files/tests).
- Surface spec questions immediately — do not batch them until `/sad-review`.

When the intent owner is available synchronously, checkpoints may be verbal; still record a one-line note in the checkpoint file for audit.

## Discipline

- If implementation requires a spec change, pause and route through `/sad-clarify` or `/sad-specify` (bidirectional spec invariant).
- Keep demo assets current for non-technical walkthrough.
- **Trivial triage:** skip formal task waves if `tasks.md` is empty — implement the minimal fix and proceed to reconcile.

## Output

Check off tasks in `tasks.md` as completed; do not fake completion.
