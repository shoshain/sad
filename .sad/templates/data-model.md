# Data model: <feature name>

> Output of `/sad-plan` (semi-technical tier). Documents the persistence and in-memory shapes the feature touches.
> Reviewed alongside `feature.plan.md` and `contracts/`.

**Tier audience:** semi-technical reviewer

## Entities added or changed

| Entity | Field | Type | Nullable | Default | Notes |
|---|---|---|---|---|---|
| users | greeting | varchar(140) | yes | NULL | example row — replace |

## Relationships

- Describe new foreign keys or join shapes, or "None — additive column on existing table".

## Migration plan

- **Direction:** additive / mutating / both.
- **Backward compatible at runtime?** yes / no.
- **Rollback:** how to revert without data loss.
- **Lock or downtime expected?** state worst case.

## Invariants

- One bullet per "this MUST always be true after a write".
- Used by `/sad-reconcile` to detect drift between code and intent.

## Open questions

- Anything you need the technical reviewer to answer before merge.
