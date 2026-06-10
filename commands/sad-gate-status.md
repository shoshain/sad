---
description: Program-level approval queue — which features block on which tier.
phase: maintenance
inputs:
  - specs/*/walkthroughs/*.md
  - specs/*/reconciliation.md
outputs:
  - stdout table (default) or JSON (--json)
flags:
  - --json
  - --repo-root <path>
gate: none
---

You are running **`/sad-gate-status`**.

## Your task

From the repository root, run:

```bash
./.sad/scripts/gate-status.sh
```

Windows:

```powershell
.\.sad\scripts\gate-status.ps1
```

Optional JSON for dashboards / Archangel methodology packs:

```bash
./.sad/scripts/gate-status.sh --json
```

## Discipline

- Read-only — never tick approval checkboxes from this command.
- Symbols: ✅ approved, ⏳ pending or reconcile awaiting sign-off, ⬜ unchecked.
- Pair with `/sad-stakeholder-report` when rows show ⏳ with stale `pending_since`.

## Output

Human-readable table: feature × (NT, ST, T, Reconcile) × pending metadata.

## When to run

- Weekly program stand-up when stakeholders are scarce.
- After `/sad-walkthrough` when packaging async review packets.
- When `/sad-doctor` flags `gates.*.stale_pending`.
