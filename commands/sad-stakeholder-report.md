---
description: Emit versioned async review packet for a tier; links to walkthrough pending state.
phase: reporting
inputs:
  - specs/<feature>/walkthroughs/<tier>.md
  - specs/<feature>/feature.spec.md
  - specs/<feature>/feature.plan.md (semi-technical / technical)
  - specs/<feature>/reconciliation.md (optional rollup)
outputs:
  - specs/<feature>/reports/<tier>-packet-vN.md
flags:
  - --feature <slug>
  - --tier non-technical|semi-technical|technical
  - --since <prior-packet-path>   optional delta baseline
gate: none
template: .sad/templates/stakeholder-review-packet.md
---

You are running **`/sad-stakeholder-report`**.

## Your task

Given `feature` and `tier`, produce an **async review packet** under
`specs/<feature>/reports/`:

| Tier | Packet contents |
|------|-----------------|
| **non-technical** | Scenario narrative, demo links, EARS coverage table, "what did NOT change"; strip pathnames and module names. |
| **semi-technical** | Plan + contract delta, risks, reconciliation summary; no line-level diffs. |
| **technical** | PR summary, reviewer rollup, eval table, known debt. |

Increment version (`v1`, `v2`, …) when a prior packet exists for the same tier.

## Deferred approval workflow

After writing the packet:

1. Set the matching walkthrough **Approval status** to `pending`.
2. Fill **Prepared for**, **Pending since** (today), and **Review packet** path.
3. Leave the reviewer checkbox **unchecked** until the human approves.
4. Tell the user to run `./.sad/scripts/gate-status.sh` to see queue position.

Transition to **approved** only when the human ticks `[x]` and sets status to `approved`.

## Discipline

- Never leak other tiers' confidential artifacts into a lower-tier packet.
- Include a **Changes since last packet** section when `--since` or a prior `reports/*-packet-v*.md` exists.
- If data is missing, state what blocked packaging — do not invent evidence.

## Output

Write `reports/<tier>-packet-vN.md` and update the walkthrough approval block.
