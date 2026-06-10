---
description: Produce feature.intent.md + feature.spec.md (intent/spec layer split).
phase: per-feature
inputs:
  - specs/<feature>/requirements.draft.md (optional)
  - specs/<feature>/intent-size-triage.md
  - .sad/templates/feature.intent.md
  - .sad/templates/feature.spec.md
outputs:
  - specs/<feature>/feature.intent.md
  - specs/<feature>/feature.spec.md
flags:
  - --feature <slug>
gate: non-technical reviewer (draft → approval path)
---

You are running **SAD Specify**.

## Your task

### 1. Intent layer (`feature.intent.md`)

Populate from `.sad/templates/feature.intent.md`:

- Goals, constraints, success/failure conditions, non-goals
- Intent-level stakeholder commitments
- **No implementation nouns** (no microservice, queue, lambda, framework names)

### 2. Spec layer (`feature.spec.md`)

Populate from `.sad/templates/feature.spec.md`:

- One-paragraph business intent **pointing at** `feature.intent.md`
- Capabilities (C*) linked to EARS acceptance criteria
- Out of scope, spec-level stakeholder commitments, open questions

## Discipline

- **Trivial triage:** minimal spec — one capability, one EARS line, tight out-of-scope.
- Every acceptance line must be testable or demoable in plain language.
- Architecture belongs in `/sad-plan`, not in intent or spec.

## Output

Write both files. If open questions remain, list them — do not invent business facts.
