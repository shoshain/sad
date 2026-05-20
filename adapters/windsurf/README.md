# Windsurf adapter

Writes into the target project:

- `.windsurf/rules/sad-routing.md` — routing rule (always loaded by Windsurf when present).
- `AGENTS.md` — root-level entry point.

## Persistence

Windsurf auto-loads files under `.windsurf/rules/` — that **is** persistence; the `--persistent` flag on the installer is a no-op for this adapter.

## Files

- [`sad-routing.md`](sad-routing.md) — the routing rule.
