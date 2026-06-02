---
description: Resolve ambiguities and iterate the spec with the non-technical tier in mind.
phase: per-feature
inputs:
  - specs/<feature>/feature.spec.md
outputs:
  - revised specs/<feature>/feature.spec.md
flags:
  - --feature <slug>
---

You are running **SAD Clarify**.

## Your task
Work through each **Open Question** in the spec. For unresolved items, propose candidate answers tagged **Decision needed:** with options and recommendation.

## Discipline
- Prefer edits inside `feature.spec.md` over chat prose.
- Maintain traceability: when you resolve a question, move the outcome into Business Intent or Acceptance sections.

## Output
Update the spec in place. Keep a brief changelog section at bottom only if the team uses it—otherwise rely on git history.
