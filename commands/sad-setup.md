---
description: Install SAD structure in a consuming repo, detect agent tooling, and bootstrap AGENTS.md entry points.
phase: project-setup
inputs:
  - repository root
  - (optional) existing AGENTS.md / CLAUDE.md
outputs:
  - .sad/ verified or copied
  - specs/ directory convention documented
  - AGENTS.md updated with SAD routing
flags:
  - --persistent     wire SessionStart hooks (Claude Code) or alwaysApply rules (Cursor)
  - --minimal        smallest footprint; skip commands/, agents/, hooks/, evals/, examples/
  - --dry-run        print actions without writing
  - --assistant <name>   force adapter: claude-code | cursor | aider | codex | windsurf | none
---

You are running **SAD Setup**.

## Your task
1. Confirm `.sad/`, `commands/`, and `agents/` are present (this repo) or copy them into the consuming project root.
2. Create `specs/` at the project root if missing.
3. Update `AGENTS.md` (or the project's primary agent instructions file) with short pointers to `LIFECYCLE.md`, `MANIFESTO.md`, and `.sad/memory/constitution.md`.
4. Record detected toolchain (Cursor / Claude / Codex / other) in `.sad/state/sad-state.md` under Recent decisions.

## Discipline
- Do not delete existing team instructions; merge SAD sections additively unless the user asked for replacement.
- Prefer relative paths portable across OS.

## Output
Write files directly. Summarize what changed in one short paragraph.
