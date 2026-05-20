<!-- starter:ml-app v1 -->
# Project Constitution — ML application starter

> For projects where a trained model is part of the production critical path. Model lineage, dataset governance, and eval gates are load-bearing.

## Identity

- **Project name:** [name]
- **Primary users:** end users consuming model output + ML platform operators
- **Risk class:** medium (recommendation / classification) / high (decisioning impacting people)
- **Maturity level (initial):** Level 1 minimum (ML systems exceed the cognitive surface a solo Level-0 reviewer can hold)
- **AI tier stand-ins active:** none (ironic but mandatory — AI cannot self-approve AI behaviour)

## Immutable Principles

1. **Every production model has a manifest.** Manifest names the training data version, the training code version, the eval suite version, and the eval result snapshot.
2. **No model ships without an eval suite gate.** The eval suite is versioned, calibrated against SME labels, and produces deterministic pass/fail.
3. **Training data is governed.** Each dataset has a documented source, licence, PII class, refresh cadence, and deletion path.
4. **Model rollback is one command.** Rolling back to the previous production model takes minutes, not days.
5. **Inference observability is per-tenant and per-prediction class.** Aggregate accuracy is not sufficient; the constitution requires breakdowns by tenant, by prediction class, and by user-facing impact level.

## Architecture Boundaries

- **Allowed:** one training-pipeline orchestrator; one model registry; one inference-serving runtime; one eval-grader framework.
- **Requires ADR:** any new training dataset; any change to the eval suite; any change to the model architecture; any new feature column; any change to the inference SLA.
- **Forbidden:** untracked datasets in training pipelines; eval suites that change without a version bump; deploying a model whose manifest does not link to a green eval run.

## Evidence of Done

- **Non-technical tier:** EARS criteria in user-facing terms ("when a user enters X, the system SHALL return a recommendation within 200 ms with confidence ≥ 0.7"); demo shows the user-visible behaviour change; eval result summary in plain English.
- **Semi-technical tier:** Plan names the model manifest changes; training-data lineage diff; eval-suite changes and their justification; SLA impact.
- **Technical tier:** Eval suite green at the configured threshold; A/B holdout (where applicable) shows no significant regression; model-rollback dry-run succeeded; inference cost shape is within the constitution's cost article.

## Stakeholder Approval

Constitution amendments require: ML lead + data-platform lead + (for any A1–A4 change) the responsible-AI / ethics reviewer.

## Article Index

| ID | Title |
|----|--------|
| A1 | Model manifest schema |
| A2 | Eval suite versioning and gate threshold |
| A3 | Training dataset governance |
| A4 | Model rollback mechanism |
| A5 | Inference observability breakdown |
| A6 | Cost shape (inference + training) |
| A7 | Responsible AI: bias measurement and reporting |

## Tensions to resolve

- **Capability vs latency.** A larger model improves quality and breaks the SLA. Where is the trade?
- **Eval rigour vs ship cadence.** A thorough eval suite slows ship; a thin eval suite ships fast and surprises in production.
- **Centralised model registry vs team autonomy.** One registry is auditable and slow; per-team registries are fast and create lineage gaps.
