# Hooks

SAD ships **descriptive** hook JSON files. Map them to your agent harness (Claude Code `hooks.json`, Cursor rules, Amazon Q, Kiro, etc.).

| File | Purpose |
| --- | --- |
| `pre-spec.json` | Load constitution + non-technical stakeholder context before spec edits |
| `post-spec.json` | Prompt clarify pass if open questions linger |
| `pre-reconcile.json` | Assert reconcile inputs |
| `post-reconcile.json` | Nudge semi-technical approval + compound |
| `stakeholder-tier-router.json` | Block advance to `tasks.md` until tier walkthroughs approved |

## Tier approvals script

`stakeholder-tier-router.json` references `.sad/scripts/check-tier-approvals.sh`.

Example:

```bash
.sad/scripts/check-tier-approvals.sh specs/001-my-feature
```

Exit `2` means one or more tier checkboxes are incomplete.
