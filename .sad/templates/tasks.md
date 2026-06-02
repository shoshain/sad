# Tasks: <name>

> Borrowed from GitHub Spec Kit task patterns. Use `[P]` on tasks that are parallel-safe within a wave.

## Metadata
- **Feature slug:** `<slug>`
- **Waves:** execute waves in order; within a wave, `[P]` tasks may run in parallel.

## Wave 1 — <theme>

- [ ] [P] Task 1.1 — …
- [ ] Task 1.2 — …

## Wave 2 — <theme>

- [ ] Task 2.1 — …

## Wave N — Documentation & evals

- [ ] [P] Update walkthrough drafts after implementation
- [ ] [P] Add or update eval cases if behavior changed

## Completion checklist

- [ ] All tasks checked
- [ ] `walkthroughs/` three-tier approvals obtained before shipping (per `LIFECYCLE.md`)
- [ ] `reconciliation.md` produced under `/sad-reconcile`
