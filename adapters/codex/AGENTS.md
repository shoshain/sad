# AGENTS.md

This project follows the **Stakeholder-Anchored Development** (SAD) methodology.

## Rule precedence

When two rules conflict, the higher layer wins.

1. `.sad/memory/constitution.md` (immutable project policy)
2. THIS FILE (operational entry point)
3. tool-adapter files (per-assistant mechanical guidance)
4. user-level rule files (personal preferences)
5. assistant defaults

If you detect a conflict, surface it. Do not silently follow a lower-layer rule that contradicts the constitution.

## Where to look

- Lifecycle: `LIFECYCLE.md`
- One-page summary: `CHEATSHEET.md`
- Always-loaded short rules: `.sad/rules/core/README.md` (SAD-CR-001 .. 004)
- Current session state: `.sad/state/sad-state.md`
- Project policy: `.sad/memory/constitution.md`

## When a /sad-* command is invoked

Read the canonical prompt at `commands/sad-<command>.md`. Follow its `Your task` and `Discipline` sections exactly.

## Approval is human-only

Even at Level 0 (Solo SAD), do not tick a walkthrough approval checkbox on the user's behalf. The optional `agents/reviewers/tier-stand-in-{tier}.md` personas provide adversarial review *before* approval, never *as* approval.
