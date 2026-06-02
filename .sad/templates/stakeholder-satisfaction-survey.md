# Stakeholder satisfaction survey — Tier <N>

> Used to operationalize the graduation criterion "stakeholder satisfaction > 80% per tier" in [MATURITY.md](../../MATURITY.md).
> One filled survey per tier per measurement period (default: monthly). Save under `.sad/state/satisfaction/<YYYY-MM>/<tier>.md`.

**Tier:** non-technical / semi-technical / technical
**Period:** YYYY-MM
**Respondent:** <name or role; pseudonymous OK>
**Features reviewed this period:** <list of slugs>

## Likert questions (1 = strongly disagree, 5 = strongly agree)

| # | Statement | Score (1–5) |
|---|---|---|
| 1 | The walkthroughs I read were in **my** language — not the other tiers' language. | _ |
| 2 | I had enough information to either approve or reject without asking follow-ups. | _ |
| 3 | When I rejected something, the spec / plan came back with my concern addressed. | _ |
| 4 | The reconciliation report (when present) was honest about what changed mid-flight. | _ |
| 5 | I did **not** feel I was rubber-stamping. | _ |

## Score

- **Total:** sum / 25
- **Satisfaction %:** (total / 25) × 100
- **Passes 80% threshold?** yes / no

## Free-form

- What was the single best thing this period?
- What was the single worst thing this period?
- One thing you would change before next period.

## How this rolls up

`.sad/scripts/maturity-report.{sh,ps1}` reads every `<tier>.md` for the current period and averages the Satisfaction % per tier. A tier is "passing" when its average ≥ 80%.
