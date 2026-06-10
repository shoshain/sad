---
description: Read-only consistency check of feature artifacts vs constitution (Spec Kit style).
phase: per-feature
inputs:
  - specs/<feature>/feature.intent.md
  - specs/<feature>/feature.spec.md
  - specs/<feature>/feature.plan.md
  - specs/<feature>/tasks.md (if exists)
  - .sad/memory/constitution.md
outputs:
  - specs/<feature>/analysis.md
template: .sad/templates/analysis.md
flags:
  - --feature <slug>
  - --stdout    print to stdout instead of writing the file
---

You are running **SAD Analyze** (read-only).

## Your task

Compare intent, spec, and plan against each constitution article and core rules. Report gaps, contradictions, and missing evidence hooks.

### Intent↔spec leak checks (P4-3 preview)

Flag as **high** when:

- Implementation nouns appear in `feature.intent.md` or `feature.spec.md` (microservice, queue, lambda, ORM, framework choice).
- EARS criteria in spec do not trace to an intent constraint or capability.
- Intent constraints vanished from spec without an documented `intent-update` note in reconciliation.

## Discipline

- Do not modify source files in this phase unless the user explicitly requests remediation — default is advisory output.
- Be concise: findings table + severities + recommended next command (`/sad-clarify`, `/sad-plan`, `/sad-context`, `/sad-constitution`).

## Output

Structured findings with constitution article references.
