# The SAD Lifecycle

The SAD loop has named steps. Steps 1 and 2 run once at project setup. Steps 3 onward run per feature. The diagram below uses slash-style command names for discoverability; map them to your agent product.

```text
PROJECT-LEVEL (run once)
  1. /sad-setup          install structure, detect agents, write AGENTS.md
  2. /sad-constitution   produce .sad/memory/constitution.md + tier definitions

PER-FEATURE LOOP
  3. /sad-brainstorm     interactive Q&A → requirements + intent-size triage (trivial/bounded/strategic)
  4. /sad-specify        feature.intent.md + feature.spec.md (layer split)
  5. /sad-clarify        resolve ambiguities; iterate spec
  6. /sad-impact-forecast predict downstream effects on spec registry + lessons    [NOVEL]
  6b./sad-context        context bundle (mandatory for strategic triage)             [NOVEL]
  7. /sad-plan           feature.plan.md + data-model + contracts + research
  8. /sad-walkthrough    generate three tier-specific artifacts                    [NOVEL]
                         ├── walkthroughs/non-technical.md
                         ├── walkthroughs/semi-technical.md
                         └── walkthroughs/technical.md
                         GATE: tier-routed approval (approved or pending-async; all three required)
  9. /sad-analyze        consistency check vs constitution (read-only quality gate)
 10. /sad-tasks          tasks.md with [P] parallel-safe tags
 11. /sad-implement      sub-agent dispatch; presence checkpoints during build
 12. /sad-review         parallel reviewer fleet (code + doc + tier reviewers)
 13. /sad-reconcile      bidirectional spec/code diff; produce reconciliation.md   [NOVEL]
 14. /sad-compound       lessons → AGENTS.md + .sad/memory/lessons/

TRIAGE SHORTCUT (trivial — recorded in intent-size-triage.md)
  brainstorm → specify → implement → reconcile → compound
  (skips clarify, forecast, context, plan, walkthrough, analyze, tasks, review)

MAINTENANCE (any time)
   /sad-gate-status      program-level approval queue across specs/
   /sad-stakeholder-report  async review packets for unavailable tiers
   /sad-doctor           health + spec-theater detector + substrate diagnostic
   /sad-spec-drift-scan  scheduled drift detection across all features
   /sad-compound-refresh prune stale lessons, archive obsolete decisions
   /sad-evolve-evals     fold new failure modes into eval suites
   /sad-requirements-progress  refresh REQ/traceability rollup markdown when configured
```

## REQ traceability rollup (optional)

Projects that maintain a canonical REQ mapping alongside `specs/<slug>/` SHOULD run
**`/sad-requirements-progress`** after each lifecycle iteration that edits mapping rows,
`feature.spec.md`, or `req-coverage.yaml`, so engineers see cross-feature compliance at a glance.

See [commands/sad-requirements-progress.md](commands/sad-requirements-progress.md).

## Phase Gates and Artifacts

| Phase | Inputs | Outputs | Gate | Approver |
|-------|--------|---------|------|----------|
| Brainstorm | feature idea | `requirements.draft.md`, `intent-size-triage.md` | informal | feature owner |
| Specify | requirements | `feature.intent.md`, `feature.spec.md` (EARS) | spec review | non-technical reviewer |
| Clarify | spec | revised spec + intent | iteration | non-technical reviewer |
| Impact-Forecast | spec | `impact-forecast.md` | informational | semi-technical reviewer |
| Context | intent + forecast + lessons | `context.md` | advisory (mandatory if strategic) | semi-technical reviewer |
| Plan | spec + forecast + context | `feature.plan.md`, `data-model.md`, `contracts/`, `research.md` | plan review | semi-technical reviewer |
| Walkthrough | spec + plan | three tier walkthroughs | TIER-ROUTED APPROVAL | one approver per tier |
| Analyze | spec + plan + tasks | analysis report | consistency gate | automated, advisory |
| Tasks | plan | `tasks.md` | none | none |
| Implement | tasks | code, tests | per-task | sub-agent context firewall |
| Review | code | reviewer reports | code review | technical reviewer |
| Reconcile | spec + code | `reconciliation.md` | spec-code coherence | semi-technical reviewer |
| Compound | the entire feature | lessons | informational | none |

## Tier-Routed Approval Gate (Step 8)

> **Novel to SAD.** Adapted from AWS AI-DLC's "10–26 human approval gates per Bolt" pattern, extended with stakeholder-tier routing.

The walkthrough phase produces three artifacts and demands three independent approvals. The methodology blocks until each tier has approved. This is the most expensive single gate in the loop and is the source of SAD's quality leverage.

```text
    walkthrough-non-technical.md   →  Non-Technical Approver
    walkthrough-semi-technical.md  →  Semi-Technical Approver
    walkthrough-technical.md       →  Technical Approver
                  ↓
        ALL THREE REQUIRED
                  ↓
            /sad-tasks
```

If the non-technical approver rejects, the spec returns to `/sad-clarify`. If the semi-technical reviewer rejects, the plan returns to `/sad-plan`. If the technical approver rejects, the plan returns to `/sad-plan` with a technical-feedback annotation.

## Reconciliation (Step 13)

> **Novel as a numbered methodology phase.** Drift detection exists in Tessl, Kinde, and OpenAI's "garbage collection" agents, but no prior methodology in the survey treats reconciliation as a discrete numbered step in the per-feature loop.

After implementation and review, before merge, the `spec-drift-detector` runs against the feature. It compares spec capabilities, EARS acceptance criteria, contract signatures, and data-model definitions against the implementation. Output is `reconciliation.md` with a verdict per discrepancy:

- **`spec-update`**: implementation is correct; spec was incomplete; update spec.
- **`code-update`**: spec is correct; implementation drifted; fix code.
- **`both-update`**: refactor needed; both diverged from a clearer intent.

The semi-technical reviewer approves the reconciliation verdicts before merge.

## Per-feature directory (consuming project)

Convention: `specs/<slug>/` containing `feature.spec.md`, `feature.plan.md`, `tasks.md`, `walkthroughs/`, optional `demo/`, `stories/`, `evals/`, and `reconciliation.md`. Your `.sad/` directory may live at repo root; feature work stays under `specs/`.
