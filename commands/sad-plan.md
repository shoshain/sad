---
description: Produce feature.plan.md plus data-model, contracts, and research artifacts.
phase: per-feature
inputs:
  - specs/<feature>/feature.intent.md
  - specs/<feature>/feature.spec.md
  - specs/<feature>/impact-forecast.md
  - specs/<feature>/context.md (when present — cite in plan opening)
outputs:
  - specs/<feature>/feature.plan.md
  - specs/<feature>/data-model.md (as needed)
  - specs/<feature>/contracts/* (as needed)
  - specs/<feature>/research.md (optional)
templates:
  - .sad/templates/feature.plan.md
  - .sad/templates/data-model.md
  - .sad/templates/research.md
  - .sad/templates/contracts/example.md
flags:
  - --feature <slug>
gate: semi-technical reviewer
---

You are running **SAD Plan**.

## Your task

Translate approved intent + spec into a semi-technical plan:

- Open with **Context consumed:** bullet list citing `context.md` rows (if file exists).
- Map every capability to concrete deliverables chosen **against** `feature.intent.md` constraints.
- Define contracts and data impacts with backward-compatibility notes.
- Address risks called out in `impact-forecast.md`.

## Discipline

- No task-level granularity here — that belongs in `/sad-tasks`.
- Respect the constitution; flag violations early.
- **Strategic triage:** if `context.md` is missing when triage says strategic, stop and run `/sad-context`.

## Output

Write the plan and companion artifacts. Keep diagrams ASCII or Mermaid in Markdown only.
