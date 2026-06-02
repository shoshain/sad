# Semi-Technical Stakeholders

## Who they are
[Solution architects, technical PMs, integration leads, designers who read specs and contracts.]

## What they review
- `feature.spec.md` and `feature.plan.md`
- `data-model.md`, `contracts/`, diagrams describing behavior and integration
- `walkthroughs/semi-technical.md`
- `impact-forecast.md`
- `reconciliation.md` verdicts

## What they do not review
- Line-by-line code diffs, raw stack traces, low-level implementation trivia unless escalated for risk.

## Approval mechanism
Checkbox in `walkthroughs/semi-technical.md` for walkthrough approval; separate sign-off on `reconciliation.md` verdicts before merge (see `LIFECYCLE.md`).

## Communication preferences
- Prefer structured summaries, contract deltas, backward-compatibility statements.
- Cadence: [per milestone / per PR / other]

## What "approved" means here
The semi-technical reviewer attests that the plan and contracts match business intent, that integration risk is understood, and that spec–implementation reconciliation is coherent—not that every line of code was read.
