---
description: Prune stale lessons and archive obsolete decisions (Compound Engineering compound-refresh ritual).
phase: maintenance
inputs:
  - .sad/memory/lessons/
outputs:
  - .sad/memory/lessons/_archive/* (moved files with tombstone headers)
  - .sad/memory/lessons/LESSONS_INDEX.md
template: .sad/templates/LESSONS_INDEX.md
flags:
  - --max-age-days <N>   archive lessons older than N days (default 365)
  - --dry-run            list what would be archived; do not move files
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
