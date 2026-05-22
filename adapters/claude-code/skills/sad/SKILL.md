---
name: sad
description: Stakeholder-Anchored Development methodology. Use when the user mentions /sad-*, asks about features/specs/walkthroughs/reconciliation, or works inside specs/. Routes to the canonical commands/sad-*.md prompts in this repo.
disable-model-invocation: false
---

# SAD (Stakeholder-Anchored Development) skill

When this skill is active, the assistant operates under the SAD methodology defined at the repo root.

## Triggers

- The user types `/sad-<command>` (any of the 20 lifecycle commands, including the conductor `/sad-next`).
- The user asks "what's next?", "where was I?", or any equivalent that implies they want the conductor to resolve and run the next SAD phase — invoke `/sad-next` from [`commands/sad-next.md`](../../../../commands/sad-next.md).
- The user edits or creates files under `specs/<NNN>-<slug>/`.
- The user asks about features, specs, walkthroughs, the three tiers, the reconciliation phase, the constitution, or the maturity ladder.
- The user runs `sad-doctor`, `create-feature`, `next-step`, or any script under `.sad/scripts/`.

## What to do

1. **Read `AGENTS.md`** for the declared-precedence block. The constitution always wins over this file's instructions.
2. **Read `.sad/memory/constitution.md`** for project-specific policy.
3. **Read `.sad/rules/core/README.md`** for the four always-loaded SAD-CR rules (constitution first; spec before code; tier-appropriate artifacts; evidence not vibes).
4. **Look up the requested `/sad-<command>` prompt** at `commands/sad-<command>.md` and follow its `Your task` / `Discipline` sections exactly.
5. **Respect tier-routed gates.** The assistant must not advance to `/sad-tasks` until all three walkthrough approval checkboxes are checked. The `.sad/scripts/check-tier-approvals.{sh,ps1}` script is the source of truth.

## What NOT to do

- Do not silently restate constitution policy in any other rule file (Layer 3 files are tool-mechanical only — see `SAD_USER_GUIDE.md §8.2`).
- Do not approve any walkthrough on the user's behalf, even at Level 0. Approval is human-only.
- Do not modify `MANIFESTO.md`, `LIFECYCLE.md`, `ROLES.md`, `MATURITY.md`, `NOVEL.md`, `GLOSSARY.md`, or anything under `.sad/templates/`. These are upstream; fork into a local file if you need to customise.

## Outputs you should produce

- Updated artifacts under `specs/<slug>/` per the requested command.
- Updated `.sad/state/sad-state.md` reflecting the current phase, via `.sad/scripts/update-state.{sh,ps1}`. The `Phase:` value must be one of the enum values defined in `.sad/state/sad-state.md` so `/sad-next` and `next-step.{sh,ps1}` can resolve the next step.
- New lessons under `.sad/memory/lessons/` when invoking `/sad-compound`.

## Reading order on first invocation

If this is the first message of a session and you have not yet read SAD context:

1. `AGENTS.md`
2. `CHEATSHEET.md` (fast orientation)
3. `.sad/memory/constitution.md` (full)
4. `.sad/rules/core/README.md`
5. `.sad/state/sad-state.md`

After that, load specific lifecycle files on demand.
