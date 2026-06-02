---
description: Emit stakeholder-facing report for a tier; supports --tier flag (non-technical | semi-technical | technical).
phase: reporting
inputs:
  - specs/<feature>/walkthroughs/<tier>.md
  - optional analytics / eval summaries
outputs:
  - stdout Markdown or specs/<feature>/reports/<tier>.md
flags:
  - --tier non-technical|semi-technical|technical
---

You are running **SAD Stakeholder Report**.

## Your task
Given `feature` and `tier`, distill the appropriate walkthrough into an executive-ready artifact:
- **non-technical:** scenario narrative + demo links + EARS coverage table; strip pathnames.
- **semi-technical:** plan + contracts + risks + reconciliation summary; no code diffs.
- **technical:** PR summary + reviewer rollup + eval table.

## Discipline
- Never leak other tiers' confidential artifacts when producing a lower tier packet.
- If data is missing, state what blocked packaging explicitly.

## Output
Write the report file or return Markdown if the harness expects inline response.
