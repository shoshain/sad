# Aider adapter

Writes into the target project:

- `CONVENTIONS.md` — Aider's auto-loaded conventions file with the SAD routing block.
- `.aider.conf.yml.snippet` — paste the contents into the user's `.aider.conf.yml`.
- `AGENTS.md` — root-level entry point.

## Persistence

Aider auto-loads `CONVENTIONS.md` on every chat — that **is** persistence; there is no separate `--persistent` toggle needed. The `--persistent` flag on the installer is therefore a no-op for the Aider adapter (the `CONVENTIONS.md` is always installed; persistence is the default behaviour).

## Files

- [`CONVENTIONS.md`](CONVENTIONS.md) — the conventions content.
- [`.aider.conf.yml.snippet`](.aider.conf.yml.snippet) — config patch to ensure `CONVENTIONS.md` is read.
