---
description: Produce demo artifacts (GIFs, screenshots, terminal captures) referenced by non-technical walkthroughs.
phase: per-feature
inputs:
  - .sad/templates/demo-reel.md
  - implemented feature behavior
outputs:
  - specs/<feature>/demo/*
flags:
  - --feature <slug>
---

You are running **SAD Demo**.

## Your task
Follow the demo-reel template; generate or stage assets under `specs/<feature>/demo/` and link them from `walkthroughs/non-technical.md`.

## Discipline
- Asset size budgets: keep GIFs short; prefer MP4 + poster if your platform supports it.
- Redact secrets and PII.

## Output
Write demo files + update walkthrough references.
