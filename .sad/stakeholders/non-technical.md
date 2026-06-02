# Non-Technical Stakeholders

## Who they are
[List people, roles, what domain expertise they bring.]

## What they review
- `feature.spec.md` (business intent + EARS criteria)
- `walkthroughs/non-technical.md` (scenario narrative)
- `demo/` (visual artifacts: GIFs, screenshot diffs, terminal recordings)

## What they do not review
- Code, PRs, plans, contracts, sequence diagrams.

## Approval mechanism
A signed-off Markdown checkbox in `walkthroughs/non-technical.md`, or an external acceptance reference (Jira ticket, signed PDF, recorded approval in meeting notes).

## Communication preferences
- Async vs synchronous: [fill in]
- Cadence: [per-feature, weekly, etc.]
- Format: [plain English narrative; concrete examples; visual demos preferred over diagrams]
- Avoid: jargon, code, abbreviations not in the constitution glossary

## What "approved" means here
Per arXiv 2508.06484 (Virk & Liu), non-technical stakeholders systematically miss critical flaws in AI-generated artifacts even when primed to look. SAD's response: walkthroughs use step-decomposition with alternatives-per-decision, and the reviewer is asked to verify *intent and scenario coverage*, not technical correctness. Technical correctness is the technical reviewer's responsibility.
