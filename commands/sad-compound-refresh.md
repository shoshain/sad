---
description: Prune stale lessons and archive obsolete decisions (Compound Engineering compound-refresh ritual).
phase: maintenance
inputs:
  - .sad/memory/lessons/
outputs:
  - archived lessons / refreshed index notes in AGENTS.md (optional)
---

You are running **SAD Compound Refresh**.

## Your task
1. Identify lessons older than N days that no longer apply (superseded by code removal, constitution change, or product pivot).
2. Move superseded lessons to `.sad/memory/lessons/_archive/` with a short reason header.
3. Summarize remaining active lessons in a digest suitable for planner context windows.

## Discipline
- Never delete history without archive pointer.
- Prefer tags over huge narrative digests.

## Output
Write archive entries and optional `LESSONS_INDEX.md` in `.sad/memory/lessons/` if the team wants it.
