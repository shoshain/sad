# Adoption Maturity Ladder

> **Synthesis** of Jesper Lowgren's AI Agent Capability Maturity Levels (LinkedIn, Feb 18, 2025) and Vidar Furuholt's trust-based decentralization framing. Adapted to SAD's stakeholder-tier model.

Not every team needs Level 5. Pick a level that matches your trust, tooling, and risk tolerance, then graduate over time.

### Level 1: AI-Assisted Drafting
- AI assists humans in drafting `feature.spec.md`, `feature.plan.md`.
- All approval gates require manual human review at every tier.
- Reviewer fleet does not run; humans do all reviews.
- Reconciliation is manual.
- **Use when:** team is new to AI workflows or domain is high-risk (medical, safety-critical, financial regulation).

### Level 2: AI-Augmented Review
- Reviewer fleet runs in parallel and emits reports; humans approve.
- Walkthrough writers produce drafts; humans edit before sending to stakeholders.
- Tier-routed approval enforced; AI cannot proceed across phase boundaries.
- **Use when:** team has AI fluency but stakeholders need to build trust in AI-generated artifacts.

### Level 3: AI-Autonomous Within Approved Spec
- Once spec is human-approved at Level 8 (walkthrough), AI runs `/sad-tasks` through `/sad-review` autonomously.
- Reviewer fleet's confidence scores gate auto-merge for low-risk diffs (small, additive, well-tested).
- High-risk diffs still require human technical reviewer.
- Reconciliation runs automatically; verdicts surface to semi-technical reviewer.
- **Use when:** team has 6+ months SAD experience, eval suites are calibrated, lessons store is mature.

### Level 4: AI-Autonomous With Periodic Stakeholder Reconciliation
- Stakeholders approve spec, then AI runs the entire loop including walkthrough generation.
- Stakeholder review happens at scheduled intervals (weekly demo, monthly compound-refresh) rather than per-feature.
- Spec-drift-scan runs continuously; humans only intervene on flagged divergence.
- **Use when:** team has years of SAD experience, eval coverage is thorough, lessons store is curated.

### Level 5: Fully Autonomous With Outcome-Only Oversight (speculative)
- Stakeholders define outcomes and constraints in the constitution; agents handle everything else.
- Humans review only outcome metrics and serious deviations.
- Lowgren explicitly notes Level 5 is speculative; SAD includes it for completeness, not endorsement.

## Graduation Criteria

A team should not skip levels. Graduation from Level N to Level N+1 requires:
- Sustained green eval suites for 4+ consecutive weeks
- Reviewer-fleet false-positive rate below 10%
- Stakeholder satisfaction surveys (per tier) above 80%
- Less than one rollback per 20 features in the prior level
