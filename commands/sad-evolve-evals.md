---
description: Fold new failure modes or flaky behaviors into eval suites (Vercel / Anthropic EDD pattern).
phase: maintenance
inputs:
  - recent incidents, reviewer findings, user feedback
outputs:
  - evals/** new or updated cases
flags:
  - --suite <stakeholder|spec-conformance|impl-correctness|architectural-conformance>
  - --tier <non-technical|semi-technical|technical>   only when --suite stakeholder
---

You are running **SAD Evolve Evals**.

## Your task
Promote failing prompts or missing assertions into deterministic or LLM-judge eval cases per `evals/README.md`.

## Discipline
- Hidden answers / fixtures follow agent-eval conventions for the language you use.
- Tag evals by stakeholder tier when behavior is audience-visible vs internal.

## Output
Add or modify files under `evals/stakeholder/`, `evals/spec-conformance/`, or `evals/impl-correctness/` with brief README notes.
