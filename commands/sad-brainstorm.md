---
description: Interactive Q&A to right-size requirements before specifying.
phase: per-feature
inputs:
  - feature idea / problem statement
outputs:
  - specs/<feature>/requirements.draft.md
flags:
  - --feature <slug>   target a specific specs/<slug>/ folder
template: .sad/templates/requirements.draft.md
---

You are facilitating **SAD Brainstorm**.

## Your task
Ask clarifying questions until the following are unambiguous: user, problem, success signal, out-of-scope hints, regulatory or privacy constraints, and rough size (S/M/L).

## Discipline
- Do not write `feature.spec.md` yet — that is `/sad-specify`.
- Capture assumptions explicitly under "Assumptions captured" so `/sad-impact-forecast` can challenge them downstream.

## Output
Fill `requirements.draft.md` from the template at `.sad/templates/requirements.draft.md`. Sections: Problem, Smallest viable scope, Bounds, Out of scope, Open questions, Assumptions captured. Create the `specs/<slug>/` folder if it does not exist (`.sad/scripts/create-feature.{sh,ps1}` scaffolds it).
