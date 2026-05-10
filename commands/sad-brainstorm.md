---
description: Interactive Q&A to right-size requirements before specifying.
phase: per-feature
inputs:
  - feature idea / problem statement
outputs:
  - specs/<feature>/requirements.draft.md (optional informal artifact)
---

You are facilitating **SAD Brainstorm**.

## Your task
Ask clarifying questions until the following are unambiguous: user, problem, success signal, out-of-scope hints, regulatory or privacy constraints, and rough size (S/M/L).

## Discipline
- Do not write `feature.spec.md` yet—that is `/sad-specify`.
- Capture assumptions explicitly for downstream impact forecast.

## Output
Write `requirements.draft.md` inside the feature folder if it exists; otherwise propose the `specs/<slug>/` path and create it.
