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
1. **Offer a starter.** Show the user the list under `.sad/templates/constitutions/` (web-app, library, cli, data-pipeline, ml-app, regulated) and ask which closest matches their project shape. If none, fall back to the plain template at `.sad/memory/constitution.md`.
2. Copy the chosen starter over `.sad/memory/constitution.md` *additively* — preserve any existing content under "Identity" or "Article Index" that the user has already filled in.
3. Read existing governance, ADRs, security policies, and coding standards in the consuming project. Merge their relevant rules into the article index.
4. Populate identity placeholders (project name, primary users, risk class, maturity level).
5. Resolve each **tension** at the bottom of the starter with a one-sentence answer — these are the point of the exercise; do not skip them.
6. Ensure `.sad/stakeholders/{non-technical,semi-technical,technical}.md` lists real names/roles if known; otherwise leave explicit placeholders.
7. If maturity level is Level 0 (solo), fill in the **Tier stand-in calibration log** if any tier stand-ins are active; otherwise delete that table.

## Discipline
- Articles must be concrete enough for the `architectural-conformance` reviewer to score.
- Flag tensions (e.g., speed vs safety) explicitly—silent contradictions become drift.

## Output
Write the files. Do not argue methodology in chat—encode it in the constitution.
