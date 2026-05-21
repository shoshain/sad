# Hooks

SAD ships **descriptive** hook JSON files. Map them to your agent harness (Claude Code `hooks.json`, Cursor rules, Amazon Q, Kiro, etc.).

| File | Purpose |
| --- | --- |
| `pre-spec.json` | Load constitution + non-technical stakeholder context before spec edits |
| `post-spec.json` | Prompt clarify pass if open questions linger |
| `pre-reconcile.json` | Assert reconcile inputs |
| `post-reconcile.json` | Nudge semi-technical approval + compound |
| `stakeholder-tier-router.json` | Block advance to `tasks.md` until tier walkthroughs approved |

## Tier approvals script (cross-platform)

`stakeholder-tier-router.json` references both POSIX and Windows variants:

- `command` / `args` — POSIX: `.sad/scripts/check-tier-approvals.sh <feature_path>`
- `windows_command` / `windows_args` — Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File .sad/scripts/check-tier-approvals.ps1 <feature_path>`

Pick the field your harness supports. Both have identical exit semantics:

| Exit code | Meaning |
|---|---|
| 0 | all three tier checkboxes are checked |
| 2 | at least one tier approval is missing or unchecked |

Example:

```bash
# POSIX
.sad/scripts/check-tier-approvals.sh specs/001-my-feature
```

```powershell
# Windows
powershell -NoProfile -ExecutionPolicy Bypass -File .sad/scripts/check-tier-approvals.ps1 specs/001-my-feature
```

## Hook taxonomy: guides vs sensors

Adopted from Martin Fowler's harness-engineering pattern (see [ATTRIBUTION.md](../ATTRIBUTION.md)):

- **Guides (feed-forward).** Run *before* a tool call to inject context — `pre-spec`, `pre-reconcile`. They shape the model's input.
- **Sensors (feed-back).** Run *after* a tool call to verify state or nudge the next action — `post-spec`, `post-reconcile`. They observe outputs.

`stakeholder-tier-router` is a gate-style sensor: it runs before `/sad-tasks` and blocks the transition.
