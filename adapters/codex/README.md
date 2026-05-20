# Codex CLI adapter

Codex CLI (OpenAI's `codex` terminal client) reads `AGENTS.md` at the repo root as its primary instruction file. This adapter is therefore the minimal one — it writes a single `AGENTS.md` at the repo root with the SAD declared-precedence block.

## Persistence

`AGENTS.md` is always loaded by Codex — that **is** persistence; there is no separate `--persistent` toggle. The `--persistent` flag on the installer is a no-op for the Codex adapter.

## Files

- [`AGENTS.md`](AGENTS.md) — the root-level entry point template.
