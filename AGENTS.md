# AGENTS.md — SAD methodology repository

This file helps coding agents navigate **this** repository (the SAD kit), not a consuming product repo.

## What this repo is
- Methodology sources: `MANIFESTO.md`, `LIFECYCLE.md`, `ROLES.md`, `MATURITY.md`.
- Operational prompts: `commands/sad-*.md`.
- Personas: `agents/**`.
- Templates & scripts: `.sad/`.
- Hook sketches: `hooks/*.json` (+ `hooks/README.md`).
- Eval skeleton: `evals/`.
- Worked example: `examples/001-hello-feature/`.

## When editing
- Preserve attribution: update `ATTRIBUTION.md` when adding sourced primitives; update `NOVEL.md` only for genuinely new SAD-specific claims.
- Keep artifacts **portable** (Markdown-first, minimal vendor lock-in in hook JSON).

## Consuming projects
After copying SAD into an application repository, point that repo's `AGENTS.md` at **its** `.sad/memory/constitution.md` and `LIFECYCLE.md`; use `specs/<slug>/` for real feature work (`examples/` here is illustrative only).
