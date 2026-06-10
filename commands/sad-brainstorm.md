---
description: Interactive Q&A to right-size requirements before specifying; records intent-size triage.
phase: per-feature
inputs:
  - feature idea / problem statement
outputs:
  - specs/<feature>/requirements.draft.md
  - specs/<feature>/intent-size-triage.md
flags:
  - --feature <slug>   target a specific specs/<slug>/ folder
templates:
  - .sad/templates/requirements.draft.md
  - .sad/templates/intent-size-triage.md
---

You are facilitating **SAD Brainstorm**.

## Your task

Ask clarifying questions until the following are unambiguous: user, problem, success signal, out-of-scope hints, regulatory or privacy constraints, and rough size (S/M/L).

### Intent-size triage (first move — P4-4)

Before deep Q&A, classify the feature:

| Verdict | When | Lifecycle path |
|---------|------|----------------|
| **trivial** | Bug fix, copy change, dep bump; one PR; no NFR shift | specify → implement → reconcile → compound (technical gate on reconcile only) |
| **bounded** | Standard feature; ≤1 new contract surface | full 14-step loop |
| **strategic** | NFR shift, new contract family, cross-team blast radius | full loop + mandatory `/sad-context` before plan |

Record the verdict in `intent-size-triage.md` with rationale. The `/sad-next` conductor reads this file to route phases.

## Discipline

- Do not write `feature.spec.md` yet — that is `/sad-specify`.
- Do not default everything to **bounded** to avoid ceremony — right-size honestly.
- Capture assumptions explicitly under "Assumptions captured" so `/sad-impact-forecast` can challenge them downstream.

## Output

Fill `requirements.draft.md` and `intent-size-triage.md`. Create the `specs/<slug>/` folder if it does not exist (`.sad/scripts/create-feature.{sh,ps1}` scaffolds it).
