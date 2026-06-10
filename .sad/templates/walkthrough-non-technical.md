# Non-Technical Walkthrough: <feature name>

> Designed for stakeholders who do not read code. Per Virk & Liu (arXiv 2508.06484), non-programmers miss critical flaws in AI-generated artifacts even with structured explanations. This template uses step-decomposition with alternatives-per-decision to mitigate.

## What we built (one paragraph, plain English)

## Who this is for

## Scenario walk-through
For each scenario, three paragraphs:
1. What the user does.
2. What the system does in response.
3. What the user sees.

Plus, for each decision the system makes:
- The alternatives we considered.
- The choice we made.
- Why we made that choice.

## Demo artifacts
- [demo-1.gif](demo/demo-1.gif): <one-line caption>
- [screenshot-before-after.png](demo/screenshot-before-after.png): <caption>
- [terminal-recording.gif](demo/terminal-recording.gif): <caption>

## Acceptance criteria coverage
For each EARS criterion in `feature.spec.md`, we show evidence of coverage.

| Criterion | Evidence |
|---|---|
| AC1.1 | demo-1.gif shows ... |

## Things that did not change
What this feature does *not* affect, and why we want you to know that.

## Approval

Use **approved** only after a named human (or external acceptance record per
`ROLES.md`) has reviewed this tier's artifact. Use **pending** when the packet is
prepared for async review — pending still blocks `/sad-tasks`.

- [ ] Non-technical reviewer: <name>, <date>
- **Approval status:** pending | approved
- **Prepared for:** <delegate name or role>
- **Pending since:** <YYYY-MM-DD>
- **Review packet:** reports/non-technical-packet-v1.md
- Comments:
