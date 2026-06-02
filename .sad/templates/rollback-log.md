# Rollback log

> Used to operationalize the graduation criterion "less than one rollback per 20 features in the prior level" — see [MATURITY.md](../../MATURITY.md).
> Append one row per **production** rollback (a revert PR, a hotfix patching back to a prior version, or a feature-flag-off after rollout).
> Do **not** record rollbacks that never reached prod (those are dev-loop iterations, not rollbacks).

Live copy: `.sad/state/rollback-log.md` (created on first append).

| Date | Feature slug | Severity | Cause | Tier that should have caught this | Resolution |
|---|---|---|---|---|---|
| YYYY-MM-DD | `001-example-feature` | sev-1 / sev-2 / sev-3 | one line | non-tech / semi-tech / technical / none | one line |

## Rolling counters

`.sad/scripts/maturity-report.{sh,ps1}` reads this log and computes:

- **Rollbacks this maturity level:** `<count>`
- **Features shipped this maturity level:** `<count>` (from `specs/` folders created since level start)
- **Rate:** `<count> / <features>` — passes the graduation criterion when below `1 / 20` (i.e. ≤ 0.05).

The level-start date sits in `.sad/state/maturity-level.json` (see [`commands/sad-doctor.md`](../../commands/sad-doctor.md)).
