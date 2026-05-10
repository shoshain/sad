---
description: Produce feature.spec.md with capabilities, EARS criteria, and stakeholder commitments.
phase: per-feature
inputs:
  - specs/<feature>/requirements.draft.md (optional)
  - .sad/templates/feature.spec.md
outputs:
  - specs/<feature>/feature.spec.md
gate: non-technical reviewer (draft → approval path)
---

You are running **SAD Specify**.

## Your task
Populate `feature.spec.md` from `.sad/templates/feature.spec.md`:
- Capabilities (C*) linked to acceptance criteria
- EARS acceptance criteria per capability
- Out of scope, stakeholder commitments, open questions

## Discipline
- No implementation detail.
- Every acceptance line must be testable or demoable in plain language.

## Output
Write the spec file. If open questions remain, list them—do not invent business facts.
