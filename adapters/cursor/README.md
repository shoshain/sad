# Cursor adapter

Writes into the target project:

- `.cursor/rules/sad-routing.mdc` — the routing rule. `alwaysApply: false` by default; `true` when the installer is run with `--persistent`.
- `.cursor/commands/sad-*.md` — one Cursor saved-command per SAD lifecycle command.
- `AGENTS.md` — root-level entry point.

## Persistence

- **Default:** the rule has `alwaysApply: false` and is loaded only when the user opens a file under `specs/` or types a `/sad-*` command.
- **Persistent (`--persistent`):** the rule has `alwaysApply: true` — Cursor injects it into every chat and agent session automatically.

## Files

- [`sad-routing.mdc`](sad-routing.mdc) — default variant (`alwaysApply: false`).
- [`sad-routing.persistent.mdc`](sad-routing.persistent.mdc) — persistent variant (`alwaysApply: true`).
