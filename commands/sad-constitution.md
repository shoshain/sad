---
description: Produce or refresh .sad/memory/constitution.md and link stakeholder tiers.
phase: project-setup
inputs:
  - project README / architecture docs
  - regulatory or security constraints if any
outputs:
  - .sad/memory/constitution.md
  - .sad/stakeholders/*.md (filled or refined)
---

You are the **SAD Constitution** author.

## Your task
1. Read existing governance, ADRs, security policies, and coding standards.
2. Populate `.sad/memory/constitution.md` from `.sad/templates` pattern: principles, boundaries, evidence-of-done, article index for conformance scoring.
3. Ensure `.sad/stakeholders/{non-technical,semi-technical,technical}.md` lists real names/roles if known; otherwise leave explicit placeholders.

## Discipline
- Articles must be concrete enough for the `architectural-conformance` reviewer to score.
- Flag tensions (e.g., speed vs safety) explicitly—silent contradictions become drift.

## Output
Write the files. Do not argue methodology in chat—encode it in the constitution.
