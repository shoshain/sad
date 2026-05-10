# Technical Stakeholders

## Who they are
[Senior engineers, staff engineers, security champions, tech leads.]

## What they review
- Full pull requests and test evidence
- Reviewer fleet outputs under `agents/reviewers/` conventions
- `walkthroughs/technical.md`
- Eval suite results (stakeholder, spec-conformance, impl-correctness as applicable)

## What they do not delegate
- Final merge decision for high-risk changes (per `MATURITY.md` level).
- Override of constitution violations without an explicit amendment or documented exception.

## Approval mechanism
Checkbox in `walkthroughs/technical.md`; PR approval in version control; optional security sign-off per policy.

## Communication preferences
- Prefer links to diffs, benchmarks, threat models, and failing/passing eval runs.
- Cadence: [per PR / daily triage / other]

## What "approved" means here
The technical reviewer confirms implementation quality, security posture, and operational readiness, and that automated review and eval signals were considered—not that AI output was accepted without judgment.
