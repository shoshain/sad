# Claude Code adapter

Writes into the target project:

- `.claude/settings.json` — hooks + tool-permission allowlist for SAD scripts.
- `.claude/commands/sad-*.md` — one slash-command file per SAD lifecycle command, each a thin pointer to the canonical `commands/sad-*.md`.
- `.claude/skills/sad/SKILL.md` — skill the assistant can auto-invoke when the user mentions SAD concepts.
- `AGENTS.md` — root-level entry point with the declared-precedence block.

## Persistence (`--persistent` flag)

When the installer is run with `--persistent`, the written `.claude/settings.json` includes a **`SessionStart` hook** that re-injects `AGENTS.md`, `.sad/rules/core/README.md`, `.sad/state/sad-state.md`, and the first 80 lines of `.sad/memory/constitution.md` at the start of every Claude Code session. Without `--persistent`, the SessionStart hook is omitted and SAD context loads only when the user explicitly invokes a `/sad-*` slash command.

The SessionStart hook is the right level of "persistence" for SAD — it is **not** a daemon. See [`../../DAEMON.md`](../../DAEMON.md) for the full reasoning.

## What "persistent" looks like in practice

Every new conversation starts with the assistant seeing:

1. `AGENTS.md` (always loaded by Claude Code).
2. `.sad/rules/core/README.md` (loaded by the SessionStart hook).
3. The constitution's identity + immutable principles section (loaded by the SessionStart hook).
4. `.sad/state/sad-state.md` (loaded by the SessionStart hook) — telling the assistant which feature is active and which phase it is in.

That is the contract: an assistant with these four files in its context cannot accidentally forget that this project is SAD-anchored.

## Hooks written into `.claude/settings.json`

All four settings variants use Claude Code's hook shape (`matcher` → `hooks[]` → `{ type, if, command }`) and validate against the schema they declare.

- **Tier gate (blocking).** A `PreToolUse` hook on writes and edits to `specs/<slug>/tasks.md` runs `.sad/scripts/hook-tier-gate.sh` (`hook-tier-gate.ps1` on Windows). It reads `tool_input.file_path` from the hook's JSON input on stdin and runs `check-tier-approvals` on that feature directory. Exit 2 blocks the write, and the missing tiers are shown to the assistant.
- **Pre-spec and post-reconcile notes.** Writes to `specs/**/feature.spec.md` and `specs/**/reconciliation.md` add a short note to the assistant's context through `additionalContext`. Plain stdout from these events only reaches Claude Code's debug log.
- **SessionStart** — `--persistent` variants only; see above.

Each file filter appears twice, as `Write(...)` and `Edit(...)`, because a hook `if` rule only matches the tool it names. The tier gate is a client-side check: a developer can switch it off with `"disableAllHooks": true` in their own `.claude/settings.local.json`.

## Files in this adapter

- [`settings.json`](settings.json) — POSIX settings template; hook commands invoke `.sad/scripts/*.sh`.
- [`settings.persistent.json`](settings.persistent.json) — POSIX with the SessionStart hook added.
- [`settings.windows.json`](settings.windows.json) — Windows variant; hook commands invoke `powershell -File .sad/scripts/*.ps1` so they work without bash.
- [`settings.windows.persistent.json`](settings.windows.persistent.json) — Windows persistent variant.
- [`skills/sad/SKILL.md`](skills/sad/SKILL.md) — the auto-invoke skill.
- [`commands/sad-doctor.md`](commands/sad-doctor.md) — example slash-command pointer; the installer generates one per `commands/sad-*.md` in the SAD repo.

The PowerShell installer (`sad-init.ps1`) auto-selects the Windows variants; the bash installer (`sad-init.sh`) uses the POSIX variants. Both are dropped at `.claude/settings.json` in the target project.
