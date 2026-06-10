# SAD Session State

> Borrowed from AWS AI-DLC session continuity (`aidlc-state.md`). Update during long-running work so any agent can resume. The `Phase` value is also read by `.sad/scripts/next-step.{sh,ps1}` and the `/sad-next` conductor — keep it on the enum below so the conductor can find the next step deterministically.

## Active feature

- **Slug:** [specs/<slug>/ or empty]
- **Phase:** [enum — see below]
- **Last command:** [e.g. /sad-plan]

### Phase enum (machine-readable values for `Phase:` above)

| Value | Meaning | Next command the conductor will run |
|---|---|---|
| `none` | no active feature | `/sad-brainstorm` (after `/sad-setup` + `/sad-constitution` are done) |
| `setup-needed` | `.sad/` not installed in this project | `/sad-setup` |
| `constitution-needed` | constitution missing or unfilled | `/sad-constitution` |
| `brainstorm` | brainstorm complete | `/sad-specify` |
| `specify` | spec drafted | `/sad-clarify` |
| `clarify` | spec stable | `/sad-impact-forecast` |
| `impact-forecast` | forecast written | `/sad-context` (strategic) or `/sad-plan` |
| `context` | context bundle written | `/sad-plan` |
| `plan` | plan written | `/sad-walkthrough` |
| `walkthrough` | three walkthroughs written, awaiting tier approvals (approved or pending-async) | **GATE — conductor pauses, surfaces approval prompts inline** |
| `walkthrough-approved` | all three checkboxes ticked | `/sad-analyze` |
| `analyze` | analysis complete | `/sad-tasks` |
| `tasks` | task list written | `/sad-implement` |
| `implement` | code + tests written | `/sad-review` |
| `review` | reviewer fleet reports complete | `/sad-reconcile` |
| `reconcile` | reconciliation written, awaiting semi-technical sign-off on verdicts | **GATE — conductor pauses, surfaces approval prompt inline** |
| `reconcile-approved` | verdicts approved | `/sad-compound` |
| `compound` | lessons captured | feature done — set `Phase: none` for the next feature |

Free-form prose next to the value is allowed (`Phase: plan — first cut, may revise`); the conductor parses only the first whitespace-separated token.

## Blockers

- [ ] [Tier / reason]

## Recent decisions

- [date] [Decision summary — link to lesson file if recorded]

## Next actions

1. [ordered list]

## Resume prompt (paste into agent)

```
Continue SAD for feature [slug]. Read .sad/state/sad-state.md and specs/[slug]/feature.spec.md. Next step: [step].
```
