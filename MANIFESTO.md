# The SAD Manifesto

## Three Pillars of Federated Stakeholder Authority

> Borrowed wholesale from Vidar Furuholt's *Three Enduring Pillars of Enterprise Architecture in the Age of AI* (LinkedIn, April 15, 2026), reapplied from enterprise-architecture governance to feature-level software development.

In an AI-augmented engineering environment, code is cheap and stakeholder review bandwidth is the binding constraint. Centralized review by a single architect or product owner becomes a bottleneck. Pure local autonomy produces drift, contract violations, and stakeholder surprise. SAD answers with **federated stakeholder authority**: decisions are made close to where context resides, within rules and governance defined centrally and applied consistently across the three stakeholder tiers.

The three pillars hold this together:

### Pillar 1. Set the ground rules

A project constitution (`constitution.md`) defines what is permissible architecture, what acceptance criteria look like, what counts as evidence of stakeholder approval, and what the unbreakable principles are. The constitution is loaded into every phase as real-time decision support, not consulted after the fact for compliance. Its credibility comes from being unambiguous, complete enough to cover the situations the project will encounter, and accessible to the agents and humans who use it.

> Furuholt: *"As architectural decisions are pushed closer to delivery teams and made at higher velocity, predictable and well-understood governance becomes less about control and more about enabling teams to assess compliance autonomously."*

### Pillar 2. Make compliance natural

A federated review board, instantiated per feature as a fleet of tier-aware reviewer sub-agents, evaluates work against the constitution before phase transitions. Approval gates are tier-routed: the non-technical reviewer approves the business spec; the semi-technical reviewer approves the technical plan; the technical reviewer approves the implementation. Each tier sees only the artifacts in its language. AI proposes; humans on each tier approve.

> AWS AI-DLC contributes the principle: "AI proposes, human approves." SAD extends it with tier-specific routing.

### Pillar 3. Build it together

The constitution and lessons store are co-owned, edited collaboratively, and refined through use. Compound learnings (from Every Inc.'s Compound Engineering) accumulate in `AGENTS.md` and the `.sad/memory/lessons/` directory. They feed back into future planning and review cycles. Stakeholders across all three tiers can propose constitution amendments. The compound-refresh ritual prevents lesson rot.

## The 80/20 Inversion

Borrowed from Compound Engineering (Every Inc.). Default time allocation per feature:

- **Plan: 40%** (brainstorm + specify + impact-forecast + plan)
- **Work: 20%** (implement)
- **Review: 20%** (analyze + walkthrough + review + reconcile)
- **Compound: 20%** (lessons + refresh + evolve evals)

When code generation is cheap, planning and review are where leverage lives.

## The Bidirectional Spec Invariant

Borrowed from Tessl and AWS Kiro. Spec changes flow through the spec first, then code. When code drifts from spec, the `spec-drift-detector` agent flags it and proposes one of three reconciliations: update the spec to match (intentional change), update the code to match (drift bug), or update both (refactor). Specs are the perpetual artifact; code is a derivation.

## The Three-Tier Stakeholder Model

> **Novel to SAD.** No prior methodology in the survey treats stakeholder audience as a first-class structural dimension. BMAD has persona agents on the *producer* side; SAD adds personas on the *audience* side, and routes artifacts and approval gates accordingly.

Every feature produces three differentiated artifacts:

- A non-technical walkthrough (scenario narrative, demo reel, screenshot diffs, EARS-style acceptance criteria, no code)
- A semi-technical walkthrough (spec, plan, sequence diagrams, contract changes, structured PR summary, no implementation detail)
- A technical walkthrough (full PR, reviewer sub-agent reports, tasks completion, eval results)

Approval at each tier is independent. A feature does not ship until all three tiers have approved their respective artifacts. This is the binding constraint SAD optimizes around.

## The Twelve Steps

See `LIFECYCLE.md`. Briefly: Setup, Constitution, Brainstorm, Specify, Clarify, Impact-Forecast, Plan, Walkthrough, Analyze, Tasks, Implement, Review, Reconcile, Compound. (Setup and Constitution are project-level; the rest are per-feature.)

## What SAD Will Not Do

- Replace your existing CI, build, or deploy systems.
- Promise specific velocity multipliers (vendor claims of 10x are vendor claims, not SAD claims).
- Work without genuine stakeholder commitment of review time. The methodology assumes the three tiers actually review their tier's artifacts. If they do not, SAD degenerates into spec theater.
- Eliminate the need for engineering judgment. The reviewer fleet finds 60 to 80 percent of issues; the remaining 20 to 40 percent require humans who understand the system.
