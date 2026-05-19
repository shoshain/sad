<!-- markdownlint-disable-file MD041 MD007 MD032 -->

---
description: Regenerate aggregated REQ/NREQ compliance progress from external mapping + specs.
phase: per-feature
inputs:
  - Path to mapping markdown (pipe tables with REQ-DOC / NREQ-DOC rows), via --mapping
  - specs/*/feature.spec.md
  - specs/*/req-coverage.yaml (optional)
outputs:
  - specs/requirements-compliance-progress.md (default)
  - specs/safety-documentation-requirements/registry.snapshot.json (optional path)
gate: none
---

You are running **SAD Requirements Progress**.

## Your task

From the **repository root**, run:

```bash
python scripts/sad_update_requirements_progress.py --repo-root .
```

Override paths when the mapping lives outside `Project_Plan/`:

```bash
python scripts/sad_update_requirements_progress.py \
  --repo-root . \
  --mapping path/to/mapping.md \
  --specs-dir specs \
  --output-md specs/requirements-compliance-progress.md
```

## Discipline

- Treat generated markdown as **read-only** for humans; edit sources (`mapping.md`,
  `feature.spec.md`, `req-coverage.yaml`) instead.
- Run after **every** lifecycle iteration when requirements traceability matters.

## Output

Commit refreshed artifacts whenever REQ coverage or mapping status changed.
