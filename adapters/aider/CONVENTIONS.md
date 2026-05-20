# Project conventions

This project follows the **Stakeholder-Anchored Development** (SAD) methodology. Read `AGENTS.md` at the repo root for the declared-precedence block, then read `.sad/memory/constitution.md` for project-specific policy.

## Rule precedence

1. `.sad/memory/constitution.md` (immutable project policy)
2. `AGENTS.md` (operational entry point)
3. This `CONVENTIONS.md` file (tool-mechanical only)
4. user-level rules
5. Aider's defaults

If you detect a conflict, surface it. Do not silently follow a lower-layer rule that contradicts the constitution.

## When working on features

Feature work lives under `specs/<NNN>-<slug>/`. Each feature produces three walkthroughs (`walkthroughs/{non-technical,semi-technical,technical}.md`) and the approval gate requires all three. The lifecycle is in `LIFECYCLE.md`; the one-page summary is in `CHEATSHEET.md`.

## Always-loaded short rules

- **SAD-CR-001 — Constitution first.**
- **SAD-CR-002 — Spec before code.**
- **SAD-CR-003 — Tier-appropriate artifacts.** No code in non-technical walkthroughs.
- **SAD-CR-004 — Evidence, not vibes.**

Full text in `.sad/rules/core/README.md`.

## Approval is human-only

Even at Level 0 (Solo SAD), do not tick a walkthrough approval checkbox on the user's behalf. The optional `agents/reviewers/tier-stand-in-{tier}.md` personas provide adversarial review *before* approval, never *as* approval.
