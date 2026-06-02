# Roles in SAD

## Human Stakeholder Tiers

> **Novel to SAD.** This three-tier audience model is the methodology's distinctive structural dimension.

### Non-Technical Reviewer
**Cannot read code. Cannot read PRs. Reads narrative, watches demos, evaluates scenarios.**

Examples: business owner, domain expert, regulatory officer, end-user advocate, customer success lead.

What they review:
- `feature.spec.md` (the business spec, EARS criteria)
- `walkthroughs/non-technical.md` (scenario narrative)
- `demo/*.gif`, `demo/*.png` (visual demonstrations)
- Reconciliation summaries written in non-technical language

What they do not review:
- `feature.plan.md`, `tasks.md`, code, contracts, sequence diagrams.

How they approve:
- A signed-off Markdown checkbox in the walkthrough file, or an external acceptance record (e.g., a Jira approval), referenced from the file.

### Semi-Technical Reviewer
**Reads specs, plans, contracts, structured PR summaries. Does not implement.**

Examples: solution architect, product manager, technical PM, lead designer, integration engineer.

What they review:
- `feature.spec.md` and `feature.plan.md`
- `data-model.md`, `contracts/`, sequence diagrams
- `walkthroughs/semi-technical.md`
- `impact-forecast.md`
- `reconciliation.md` verdicts

What they do not review:
- Implementation diffs at the line level.

### Technical Reviewer
**Reads everything. Reviews code, sub-agent reports, eval results.**

Examples: senior engineer, staff engineer, tech lead, security engineer.

What they review:
- The full PR
- Reviewer fleet reports (correctness, security, performance, simplicity, maintainability, testing, reliability, data-integrity, architectural-conformance)
- `walkthroughs/technical.md`
- Eval suite results

## Agent Personas

### Reviewer Fleet (parallel sub-agents)
Borrowed wholesale from Compound Engineering's reviewer roster (`EveryInc/compound-engineering-plugin`). SAD adds one new reviewer:

- `architectural-conformance` [novel] checks proposed designs against `constitution.md` articles using a rubric-calibrated LLM judge. Adapted from Ramarajan's ARB augmentation pattern.

The Compound Engineering reviewers SAD reuses include: `correctness`, `security`, `security-sentinel`, `performance`, `reliability`, `maintainability`, `testing`, `code-simplicity`, `data-integrity-guardian`, `data-migrations`, `schema-drift-detector`, `deployment-verification`, `pattern-recognition`, `architecture-strategist`, `api-contract`, `adversarial`, `project-standards` (CLAUDE.md/AGENTS.md compliance).

### Walkthrough Writers (novel)
Three sub-agents, one per tier:
- `walkthrough-writer-non-technical` produces narrative + demo + screenshot diffs from the implementation; cites EARS criteria; uses step-decomposition with alternatives-per-decision (per arXiv 2508.06484, Virk & Liu).
- `walkthrough-writer-semi-technical` produces structured spec/plan/contracts summary with sequence diagrams.
- `walkthrough-writer-technical` produces the PR-level summary with reviewer-fleet aggregation.

### Reconciliation Agents
- `spec-drift-detector` (borrowed from Kinde + OpenAI scheduled garbage-collection patterns) scans spec vs code, emits diffs.
- `spec-reconciler` (borrowed from Tessl bidirectional reconciliation) proposes per-discrepancy verdicts (`spec-update`, `code-update`, `both-update`).

### Research Agents
- `impact-forecaster` [novel + Ramarajan] consults `.sad/memory/lessons/`, the spec registry, and prior `reconciliation.md` files to predict downstream effects of a proposed feature on stakeholder commitments, contracts, capabilities, and performance/security envelopes.
- `codebase-historian`, `git-history-analyzer`, `repo-research-analyst` (borrowed from Compound Engineering).
- `lesson-curator` (borrowed from Compound Engineering compound-refresh).

### Demo Agents (borrowed from Compound Engineering)
- `demo-reel-recorder`, `screenshot-differ`, `scenario-narrator`.

### Eval Graders
- `eval-grader-deterministic` (borrowed from Anthropic + Vercel)
- `eval-grader-llm-judge` (borrowed from Anthropic + Snorkel rubric calibration)
- `eval-grader-sme-calibrator` (borrowed from Snorkel SME-LLM-judge alignment pattern)
