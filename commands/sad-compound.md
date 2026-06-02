---
description: Record Decision + Lesson entries after shipping a feature; update AGENTS.md pointers if needed.
phase: per-feature
inputs:
  - completed tasks.md
  - specs/<feature>/reconciliation.md
outputs:
  - .sad/memory/lessons/YYYY-MM-DD-<slug>.md (or similar convention)
  - incremental updates to AGENTS.md (if lesson is global)
flags:
  - --feature <slug>
---

You are running **SAD Compound**.

## Your task
Capture durable lessons using `.sad/templates/lesson.md`. Link to spec, PR, and impacted constitution articles if relevant.

## Discipline
- Lessons are specific and actionable, not generic advice.
- Avoid duplicating existing lesson—extend prior file if same decision surface.

## Output
Write lesson file(s) under `.sad/memory/lessons/`.
