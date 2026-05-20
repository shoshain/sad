<!-- starter:data-pipeline v1 -->
# Project Constitution — Data pipeline / ETL starter

> For projects that read data from upstream sources, transform it, and produce derived outputs. Idempotency and lineage are load-bearing.

## Identity

- **Project name:** [name]
- **Primary users:** downstream data consumers; data-platform operators
- **Risk class:** medium (your bugs poison downstream tables) / high (regulatory / financial reporting)
- **Maturity level (initial):** Level 1 (multi-person teams strongly recommended for data work)
- **AI tier stand-ins active:** none

## Immutable Principles

1. **Idempotency is non-negotiable.** Running the same pipeline job twice with the same inputs produces the same outputs. No "second run accidentally double-counts" failure mode.
2. **Schemas are versioned and immutable.** Once a schema version ships to production, it never silently changes. Schema evolution happens by additive change or by a new version.
3. **Lineage is recorded for every derived output.** Each row (or each batch) carries enough metadata to reconstruct the inputs and the code version that produced it.
4. **Backfills are first-class.** Every job must support a `--backfill <date-range>` invocation; ad-hoc backfill scripts are a code smell.
5. **Personally identifying data has a documented retention window.** Pipelines that touch PII must record the retention class and the deletion path.

## Architecture Boundaries

- **Allowed:** one orchestration framework (Airflow / Dagster / Prefect / `cron` + makefiles); one storage tier per data class (hot, warm, archive); one schema registry.
- **Requires ADR:** any new upstream data source; any schema-breaking change; any new dimension table; any change to the lineage record format.
- **Forbidden:** in-place mutation of immutable storage; ad-hoc backfills outside the orchestrator; pipelines that read directly from production OLTP databases without a documented read replica.

## Evidence of Done

- **Non-technical tier:** EARS criteria phrased in terms of derived-output shape ("the daily revenue table SHALL contain one row per tenant per UTC day"); freshness SLA stated.
- **Semi-technical tier:** Plan names the input schemas, the output schemas, and the lineage record. Sequence diagram shows the orchestrator → job → storage path. Failure-mode table: what happens on partial success, on upstream delay, on downstream consumer reading mid-write.
- **Technical tier:** Tests cover idempotency (run-twice-same-output), schema-evolution (old version still reads), backfill (a 30-day backfill produces the same result as 30 daily runs).

## Stakeholder Approval

Constitution amendments require: data-platform lead + (for any A1–A5 change) one downstream consumer.

## Article Index

| ID | Title |
|----|--------|
| A1 | Idempotency contract |
| A2 | Schema versioning policy |
| A3 | Lineage record format |
| A4 | Backfill mechanics |
| A5 | PII retention class and deletion path |
| A6 | Freshness SLA |
| A7 | Failure-mode catalogue (partial success, upstream delay, downstream concurrency) |

## Tensions to resolve

- **Strictness vs throughput.** Strict schema enforcement is correct but slow; lenient enforcement is fast and creates downstream surprises.
- **Reprocessing cost vs latency.** Cheap to reprocess = you can fix bugs by backfilling; expensive to reprocess = you must be right the first time.
- **Single source of truth vs denormalisation.** Denormalised tables are fast to query and easy to break; normalised stores are correct and slow.
