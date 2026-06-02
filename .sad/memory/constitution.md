# Project Constitution

> **Template.** Replace bracketed sections. Borrowed from the GitHub Spec Kit governance pattern; adapted for SAD tier-routed approvals.
>
> Looking for a project-shape starter? See [`.sad/templates/constitutions/`](../templates/constitutions/) — web-app, library, cli, data-pipeline, ml-app, regulated. Copy the closest match over this file, then customise.

## Identity

- **Project name:** [name]
- **Primary users:** [who]
- **Risk class:** [low / medium / high / regulated]
- **Maturity level (initial):** [Level 0 / 1 / 2 / 3 / 4] — see [`MATURITY.md`](../../MATURITY.md). Solo developers default to Level 0; multi-person teams default to Level 1.
- **AI tier stand-ins active:** [none / non-technical / semi-technical / technical / all] — only allowed at Level 0. If any are active, name the persona file and the last human-vs-stand-in calibration date below.

### Tier stand-in calibration log (Level 0 only)

| Tier stand-in | Persona file | Last calibrated | Next calibration due |
|---|---|---|---|
| Non-technical | `agents/reviewers/tier-stand-in-non-technical.md` | YYYY-MM-DD | every 5 features or 90 days |
| Semi-technical | `agents/reviewers/tier-stand-in-semi-technical.md` | YYYY-MM-DD | every 5 features or 90 days |
| Technical | `agents/reviewers/tier-stand-in-technical.md` | YYYY-MM-DD | every 5 features or 90 days |

(Delete this table entirely if at Level 1+ or if no stand-ins are active.)

## Immutable Principles

1. [Principle one — non-negotiable]
2. [Principle two]
3. [Principle three]

## Architecture Boundaries

- **Allowed:** [patterns, stacks, integration styles]
- **Requires ADR:** [when a design decision must be recorded]
- **Forbidden:** [anti-patterns, banned dependencies]

## Evidence of Done

- **Non-technical tier:** EARS criteria in `feature.spec.md` satisfied; walkthrough and demo evidence linked.
- **Semi-technical tier:** Plan, contracts, and reconciliation coherent with implementation intent.
- **Technical tier:** Tests, reviewer fleet, eval suites per team policy.

## Stakeholder Approval

- Constitution amendments require: [process — e.g. lead architect + product owner + security].

## Article Index (for `architectural-conformance` rubric)

| ID | Title |
|----|--------|
| A1 | [e.g. Security baseline] |
| A2 | [e.g. Data handling] |
| A3 | [e.g. Observability] |

Expand this table as the project grows. The conformance reviewer scores each article.
