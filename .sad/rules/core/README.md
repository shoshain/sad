# Core Rules (Always Loaded)

> **Pattern:** AWS AI-DLC / Kiro-style steering — these rules apply to every SAD phase. Add focused `.md` files here; keep them short.

## SAD-CR-001 — Constitution first

Every planning, implementation, and review action must respect `.sad/memory/constitution.md`. If a task conflicts with the constitution, stop and escalate.

## SAD-CR-002 — Spec before code

Do not implement behavior not reflected in `feature.spec.md` / `feature.plan.md` without an explicit spec update (bidirectional spec invariant).

## SAD-CR-003 — Tier-appropriate artifacts

When writing for stakeholders, match the tier: no code in non-technical walkthroughs; no line-level code in semi-technical walkthroughs.

## SAD-CR-004 — Evidence, not vibes

Claims in walkthroughs and impact forecasts must cite artifacts (spec sections, lessons, contracts, benchmarks).
