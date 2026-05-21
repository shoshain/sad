# Consistency report: <feature name>

> Output of `/sad-analyze` (Spec Kit style). Read-only quality gate.
> Read by `/sad-walkthrough` to surface concerns to the semi-technical and technical reviewers.

**Tier audience:** automated · advisory
**Stage:** post-plan, pre-walkthrough

## Summary

- **Checks total:** N
- **Pass:** N
- **Concerns:** N (advisory; do not block)
- **Fail:** N (blocking)

## Checks

| # | Check | Outcome | Note |
|---|---|---|---|
| 1 | spec ↔ plan capability mapping | pass / concern / fail | Every C* in spec has a deliverable row in plan? |
| 2 | plan ↔ tasks coverage | pass / concern / fail | Every plan deliverable has at least one task? |
| 3 | EARS criteria are testable | pass / concern / fail | Each AC*.* is a single observable WHEN/THEN claim? |
| 4 | constitution articles honored | pass / concern / fail | Spell out per-article verdicts below if any concerns. |
| 5 | stakeholder tier definitions present | pass / concern / fail | `.sad/stakeholders/{tier}.md` filled? |
| 6 | out-of-scope declared | pass / concern / fail | Spec §4 non-empty? |
| 7 | impact-forecast addressed in plan risks | pass / concern / fail | Each forecast row appears in plan §Risks? |
| 8 | open questions resolved | pass / concern / fail | No "TBD" or "Decision needed" lingering in spec? |

## Constitution article check (detail)

For each constitution article (A1, A2, …), record one of: `honored` / `concern (note)` / `fail (note)`.

| Article | Verdict | Note |
|---|---|---|
| A1 | honored | — |
| A2 | honored | — |
| A3 | honored | — |

## Recommended next command

- All pass → `/sad-walkthrough`
- Concerns only → `/sad-walkthrough` after a short re-read of the concerned section
- Any fail → `/sad-clarify` (spec issues) or `/sad-plan` (plan issues) before walkthrough

## Notes

Free-form notes for the technical reviewer. Read-only — do not edit spec / plan / tasks from this file.
