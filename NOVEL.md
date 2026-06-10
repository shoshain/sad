# What SAD Contributes That Is New

This file is short on purpose. SAD is mostly synthesis. Here is what SAD genuinely contributes beyond its sources.

## 1. Three-Tier Stakeholder Audience Model as a First-Class Structural Dimension

No prior methodology in the survey treats the *audience* of an artifact as a structural dimension. BMAD has named persona agents on the producer side; CodeRabbit and Greptile target one undifferentiated reviewer; Spec Kit, Kiro, AI-DLC, Compound Engineering, Tessl all assume a single reader for each artifact (usually a developer or PM). SAD makes audience structural by:

- Defining three named tiers (non-technical, semi-technical, technical) with explicit definitions in `.sad/stakeholders/*.md`
- Producing differentiated artifacts per tier per feature (`walkthroughs/{tier}.md`)
- Routing approval gates by tier (a feature does not advance until all three tiers approve)
- Providing tier-specific reviewer sub-agents and tier-specific eval graders

This is the central differentiator and the reason SAD exists. The empirical motivation is arXiv 2508.06484, which showed non-programmers fail to detect critical flaws in AI-generated code even when primed; the methodological consequence is that you cannot pretend a single PR walkthrough serves a non-technical stakeholder.

## 2. Reconcile as a Numbered Phase

Drift detection exists in Tessl (proprietary), Kinde (advisory), and OpenAI scheduled background jobs. None of them treat reconciliation as a discrete numbered step in the per-feature loop with its own artifact (`reconciliation.md`) and its own approval gate (semi-technical reviewer). SAD does. The Compound Engineering loop is Plan → Work → Review → Compound (four steps); SAD is Plan → Work → Review → Reconcile → Compound (five). The added step closes the bidirectional spec-as-source promise that Tessl makes but most teams cannot operationalize without explicit ceremony.

## 3. `/sad-impact-forecast` as a Pre-Plan Primitive

Adapted from Balaji Ramarajan's Predictive Impact Assessment idea (June 2024) and extended with two specific scope dimensions: stakeholder commitments (which prior approvals does this feature affect?) and contract surface (which downstream consumers does this feature touch?). Run before `/sad-plan`. Consults the lessons store and the spec registry. None of the six source methodologies has an equivalent.

## 4. `architectural-conformance` Reviewer

Adapted from Ramarajan's ARB augmentation. SAD operationalizes it as a parallel reviewer sub-agent in the Compound Engineering reviewer fleet, with a rubric calibrated against constitution articles using Snorkel's SME-LLM-judge alignment technique. The reviewer is invoked at `/sad-review` and emits structured findings.

## 5. Tier-Routed Approval Gates

The walkthrough phase produces three artifacts and demands three independent approvals. Adapted from AWS AI-DLC's "10 to 26 approval gates per Bolt" pattern, but with two additions: (a) gates are routed by stakeholder tier (different approvers see different artifacts), (b) the system blocks until *all* gates are satisfied (a feature with two of three approvals does not advance).

## 6. Six-Level Maturity Ladder Anchored in Approval-Routing

Synthesizing Lowgren's five-level CMMM-style scaffold with Furuholt's trust-based decentralization, SAD's `MATURITY.md` defines each level by *who approves what*. SAD prefixes Lowgren's five levels with **Level 0 — Solo SAD** (one human carrying all three tiers) so that the lightweight floor is operationally defined too. This is operational rather than aspirational; a team can audit which level it is actually operating at by counting which gates are human-approved and which are AI-approved.

## 7. Federated Stakeholder Authority as the Manifesto Frame

Furuholt's three-pillar enterprise-architecture frame is reapplied at the feature level. The novelty is the application, not the frame: applying enterprise governance principles to per-feature software development is, to our knowledge, not a published pattern. It pays off because at AI-augmented velocity the per-feature decision rate now resembles the per-quarter EA decision rate of a decade ago.

## 8. Composition Itself

SAD's repository structure and lifecycle are the integration. We do not claim any individual primitive listed in `ATTRIBUTION.md` as our own. We claim the specific composition (which primitives compose with which, in what order, with what gates), the audience-tiered routing layer, the explicit `Reconcile` phase, and the predictive impact-forecast primitive. The synthesis is the contribution.

## 9. Deferred Approval Protocol (async stakeholder workflow)

No prior spec-driven methodology in the SAD survey treats **stakeholder unavailability** as a first-class gate state. SAD adds an explicit **pending** approval status on walkthrough artifacts: packets can be prepared, queued, and tracked while still blocking `/sad-tasks` until a named human approves. See `commands/sad-stakeholder-report.md` and `commands/sad-gate-status.md`.

## 10. Program Gate Rollup (`/sad-gate-status`)

REQ traceability rollups answer "which requirements are covered?" `/sad-gate-status` answers "which features block on which tier?" — the operational question when review bandwidth is the binding constraint.

## 11. Spec-Theater Detector (substrate honesty in `/sad-doctor`)

SAD names spec theatre and single-tier collapse as anti-patterns; `/sad-doctor` now detects overlap across walkthrough tiers, stale pending approvals, shallow lesson stores vs claimed maturity, and reconciliation skew. See `.sad/scripts/_sad-doctor-extended.{sh,ps1}`.

## 12. Intent / Context Layer Split (Ahuja substrate)

`feature.intent.md` separates goals and constraints from test-shaped `feature.spec.md`. `/sad-context` materializes empirical memory before `/sad-plan`. `/sad-brainstorm` records **trivial / bounded / strategic** triage so ceremony matches risk. See `ROADMAP.md` P4 (landed).
