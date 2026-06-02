# Reviewer output schema

> Every reviewer persona in `agents/reviewers/*.md` MUST emit a report that conforms to the JSON shape below. The technical reviewer (and Level-3+ auto-merge gates) read this shape; the reviewer rollup table in `walkthroughs/technical.md` is generated from it.

## JSON shape

```json
{
  "$schema": "https://sad.codes/schemas/reviewer-report.json",
  "name": "security",
  "feature": "001-personal-greeting",
  "ran_at": "2026-05-21T13:00:00Z",
  "outcome": "pass",
  "confidence": 0.92,
  "severity": "low",
  "findings": [
    {
      "id": "S-001",
      "severity": "low",
      "title": "auth check inherits from /me",
      "evidence": "app/controllers/me_controller.rb:18",
      "constitution_article": "A1",
      "suggested_action": "accept; no change needed"
    }
  ],
  "notes": "0 critical findings; authz inherits from existing /me middleware."
}
```

## Field reference

| Field | Type | Allowed values | Required | Meaning |
|---|---|---|---|---|
| `name` | string | one of `agents/reviewers/<name>.md` (without extension) | yes | the reviewer persona that produced this report |
| `feature` | string | feature slug, e.g. `001-personal-greeting` | yes | the feature under review |
| `ran_at` | string | ISO 8601 timestamp (UTC) | yes | when the reviewer ran |
| `outcome` | string | `pass` \| `concerns` \| `fail` | yes | pass = no blocking issues; concerns = advisory only; fail = must not merge |
| `confidence` | number | 0.0 to 1.0 | yes | reviewer's confidence in its own verdict — Level-3 auto-merge uses this |
| `severity` | string | `low` \| `medium` \| `high` \| `critical` | yes | worst severity of any finding |
| `findings` | array | each item below | yes (may be empty) | structured per-finding records |
| `notes` | string | free-form | no | one-paragraph human summary |

## Finding shape

| Field | Type | Required | Meaning |
|---|---|---|---|
| `id` | string | yes | reviewer-prefixed local id (e.g. `S-001` for the security reviewer) |
| `severity` | string | yes | same vocabulary as the top-level `severity` field |
| `title` | string | yes | one-line summary |
| `evidence` | string | yes | a file path with optional `:line`, a contract id, or a spec section reference |
| `constitution_article` | string | no | `A1`, `A2`, … if the finding maps to a constitution article |
| `suggested_action` | string | no | concrete next step |

## How tier-routed eval graders use this

Tier graders (under `evals/stakeholder/<tier>/`) read these JSON reports to verify that walkthroughs cite findings correctly. The graders never invent findings — they only check coverage of what the reviewers reported.

## Backward compatibility

Pre-schema reviewer reports (free-form markdown) remain readable by humans but are **not** consumed by Level-3 auto-merge. To opt a reviewer into structured output, ship a sibling `.json` next to its `.md` write.
