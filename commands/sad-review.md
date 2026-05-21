---
description: Run the parallel reviewer fleet against the change-set; aggregate findings for technical walkthrough.
phase: per-feature
inputs:
  - diff / PR / branch state
  - agents/reviewers/*.md personas
outputs:
  - structured reviewer reports (location per project convention)
flags:
  - --feature <slug>
  - --reviewer <name>   run a single reviewer by filename (e.g. security-sentinel)
---

You are running **SAD Review**.

## Your task
Spawn reviewers in parallel (or simulate sequentially if tooling requires). The **default subset** for `/sad-review` is nine reviewers — correctness, security, performance, simplicity, maintainability, testing, reliability, data-integrity, architectural-conformance — chosen to fit a single human technical-reviewer's load.

The **full fleet** lives under `agents/reviewers/` (18 first-class reviewers plus 3 tier stand-ins for Level 0):

- **Default subset (9):** correctness, security, performance, simplicity, maintainability, testing, reliability, data-integrity, architectural-conformance
- **Optional (9):** adversarial, api-contract, architecture-strategist, data-migrations, deployment-verification, pattern-recognition, project-standards, schema-drift-detector, security-sentinel
- **Tier stand-ins (Level 0 only, 3):** tier-stand-in-non-technical, tier-stand-in-semi-technical, tier-stand-in-technical

Use `--reviewer <name>` to run a single reviewer; pass none to run the default subset. Teams configure the subset in their constitution under `Article Index → Reviewer fleet`.

## Discipline
- Each reviewer references constitution articles where applicable.
- Include confidence and severity; avoid performative unanimity.

## Output
Persist reports where the repo keeps review artifacts (e.g., `specs/<feature>/reviews/` or PR comments) and summarize in `walkthroughs/technical.md`.
