# Claude Code adapter

Writes into the target project:

- `.claude/settings.json` — hooks + tool-permission allowlist for SAD scripts.
- `.claude/commands/sad-*.md` — one slash-command file per SAD lifecycle command, each a thin pointer to the canonical `commands/sad-*.md`.
- `.claude/skills/sad/SKILL.md` — skill the assistant can auto-invoke when the user mentions SAD concepts.
- `AGENTS.md` — root-level entry point with the declared-precedence block.

## Persistence (`--persistent` flag)

When the installer is run with `--persistent`, the writing of `.claude/settings.json` includes a **`SessionStart` hook** that runs `.sad/scripts/doctor.{sh,ps1} --quiet` and re-injects the constitution + the four always-loaded core rules at the start of every Claude Code session. Without `--persistent`, the SessionStart hook is omitted and SAD context loads only when the user explicitly invokes a `/sad-*` slash command.

The SessionStart hook is the right level of "persistence" for SAD — it is **not** a daemon. See [`../../DAEMON.md`](../../DAEMON.md) for the full reasoning.

## What "persistent" looks like in practice

Every new conversation starts with the assistant seeing:

1. `AGENTS.md` (always loaded by Claude Code).
2. `.sad/rules/core/README.md` (loaded by the SessionStart hook).
3. The constitution's identity + immutable principles section (loaded by the SessionStart hook).
4. `.sad/state/sad-state.md` (loaded by the SessionStart hook) — telling the assistant which feature is active and which phase it is in.

That is the contract: an assistant with these four files in its context cannot accidentally forget that this project is SAD-anchored.

## Files in this adapter

- [`settings.json`](settings.json) — the canonical settings template (the installer substitutes the SAD repo path).
- [`settings.persistent.json`](settings.persistent.json) — adds the SessionStart hook.
- [`skills/sad/SKILL.md`](skills/sad/SKILL.md) — the auto-invoke skill.
- [`commands/sad-doctor.md`](commands/sad-doctor.md) — example slash-command pointer; the installer generates one per `commands/sad-*.md` in the SAD repo.
