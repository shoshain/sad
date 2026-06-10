# Adoption Maturity Ladder

> **Synthesis** of Jesper Lowgren's AI Agent Capability Maturity Levels (LinkedIn, Feb 18, 2025) and Vidar Furuholt's trust-based decentralization framing. Adapted to SAD's stakeholder-tier model.

Not every team needs Level 5. Pick a level that matches your trust, tooling, and risk tolerance, then graduate over time.

### Level 0: Solo SAD

- **One human approves all three walkthroughs.** The artifact discipline (three differentiated walkthroughs, each in its tier's register) is preserved — the multi-human rubber-stamp protection is the only thing traded.
- AI coding assistant drafts every artifact; the lone human reviews and approves.
- **Opt-in AI tier stand-in:** the lone human may invoke an `agents/reviewers/tier-stand-in-{tier}.md` persona that runs an adversarial pass over a tier's walkthrough *before* the human approves. The stand-in does **not** approve — only the human ticks the box.
- When a stand-in is in use, the constitution gains a calibration line: `Tier X reviewer is AI-stand-in (last calibrated against human review on YYYY-MM-DD)`. The team commits to revisiting the calibration on a stated cadence (default: every 5 shipped features or every 90 days, whichever comes first).
- Reviewer fleet is optional but recommended for the `correctness` and `security` reviewers only — full-fleet at Level 0 buries the lone human in reports.
- **Use when:** solo developer; OSS maintainer with no co-maintainers reviewing each PR; weekend project; pre-PMF startup with one engineer.
- **Trade-off you accept:** Level 0 trades the Virk & Liu *multi-reviewer protection* for the Virk & Liu *artifact-discipline protection* (which is the larger of the two — arXiv 2508.06484 §4). You must be explicit about this in your constitution under Identity. If your domain is regulated or safety-critical, **do not use Level 0**; start at Level 1.
- **Graduation to Level 1** is automatic the moment a second named reviewer joins any tier. No formal criteria apply.
- **Presence in the loop (Article A11):** at Level 1+, record `checkpoints/` during `/sad-implement` when intent owners cannot pair live. Presence complements gates; it does not replace them.

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

A team should not skip levels (Level 0 → 1 is the exception — see Level 0 above; it graduates automatically when a second reviewer joins any tier).

Graduation from Level N to Level N+1 (for N ≥ 1) requires:
- Sustained green eval suites for 4+ consecutive weeks
- Reviewer-fleet false-positive rate below 10%
- Stakeholder satisfaction surveys (per tier) above 80%
- Less than one rollback per 20 features in the prior level
