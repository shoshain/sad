# SAD adapters — per AI coding assistant

Each subdirectory is a *turn-key adapter pack* for one AI coding assistant. The installer (`scripts/sad-init.sh` / `.ps1`) detects which assistant your target project uses and copies the matching adapter into the target.

| Adapter | Detected via | Writes into target |
|---------|--------------|---------------------|
| [`claude-code/`](claude-code/) | `.claude/` directory **or** Claude Code-shaped settings | `.claude/settings.json`, `.claude/commands/sad-*.md`, `.claude/skills/sad/`, `AGENTS.md` |
| [`cursor/`](cursor/) | `.cursor/` directory | `.cursor/rules/sad-routing.mdc`, `.cursor/commands/sad-*.md`, `AGENTS.md` |
| [`aider/`](aider/) | `.aider.conf.yml` or `.aider.input.history` | `CONVENTIONS.md`, `.aider.conf.yml` snippet, `AGENTS.md` |
| [`codex/`](codex/) | `.codex/` directory or `AGENTS.md` only | `AGENTS.md` (canonical) |
| [`windsurf/`](windsurf/) | `.windsurf/` directory | `.windsurf/rules/sad-routing.md`, `AGENTS.md` |

If no assistant is detected, the installer writes only `AGENTS.md` (the cross-assistant standard file) — every modern assistant reads it.

## Persistence

Each adapter ships in two flavors:

- **Default** — SAD context loads when the user explicitly mentions a `/sad-*` command or opens a SAD-adjacent file.
- **Persistent** (`--persistent` flag on the installer) — SAD context loads at the start of every chat / agent session automatically. See each adapter's README for the exact mechanism.

## Source of truth

Each adapter is a *thin pointer* to the canonical files in this repo:

- Slash-command prompts live in [`commands/`](../commands/).
- Personas live in [`agents/`](../agents/).
- Hook descriptions live in [`hooks/`](../hooks/).
- Always-loaded short rules live in [`.sad/rules/core/`](../.sad/rules/core/).

The adapter packs do **not** restate policy — they tell the assistant where to look. This is the [thin-pointer pattern](../SAD_USER_GUIDE.md#84-six-methodology-preservation-patterns) (pattern 3 in §8.4).
