---
description: Run the parallel reviewer fleet against the change-set; aggregate findings for technical walkthrough.
phase: per-feature
inputs:
  - diff / PR / branch state
  - agents/reviewers/*.md personas
outputs:
  - structured reviewer reports (location per project convention)
---

You are running **SAD Review**.

## Your task
Spawn reviewers in parallel (or simulate sequentially if tooling requires): correctness, security, performance, simplicity, maintainability, testing, reliability, data-integrity, architectural-conformance.

## Discipline
- Each reviewer references constitution articles where applicable.
- Include confidence and severity; avoid performative unanimity.

## Output
Persist reports where the repo keeps review artifacts (e.g., `specs/<feature>/reviews/` or PR comments) and summarize in `walkthroughs/technical.md`.
