# Impact Forecast: User can save a personal greeting

> Example artifact for the worked feature. Synthetic predictions for illustration.

## Inputs Consulted
- `feature.spec.md` (this example)
- `.sad/memory/lessons/` (none in methodology repo)

## Predicted Effects

### On stakeholder commitments
| Affected feature | Affected commitment | Severity (1–5) | Rationale |
|---|---|---|---|
| — | Plain-text-only display | 2 | Client must not interpret markdown |

### On contracts (API, schema, event)
| Contract | Type of change | Backward compatible? | Migration required? |
|---|---|---|---|
| GET /me | Additive `greeting` field | Yes | No (nullable) |
| POST /me/greeting | New endpoint | Yes (new) | No |

### On capabilities
| Capability | Effect |
|---|---|
| C1–C3 | Localized to user profile service |

### On performance / security / reliability envelopes
| Envelope | Predicted change | Confidence |
|---|---|---|
| API latency | + negligible | high |

### On lessons applicability
| Lesson | Applies? | How |
|---|---|---|
| — | — | — |

## Risks Surfaced
- Uncaught validation gaps could allow empty string if not aligned with AC1.1 — enforce min length 1 in API.

## Approval
- [x] Semi-technical reviewer: Sam Chen, 2026-05-08
