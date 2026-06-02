---
description: Project-wide SAD health check (green/yellow/red per check).
phase: maintenance
inputs:
  - the consuming project's .sad/, specs/, hooks/, AGENTS.md
outputs:
  - human-readable health report (default) or JSON (--json)
flags:
  - --json     emit structured JSON instead of text
  - --quiet    exit code only (useful in hooks)
exit_codes:
  - 0: no red findings
  - 1: at least one red finding
---

You are invoking **`/sad-doctor`** — a 30-second project-wide health check that reports on whether SAD is *installed correctly*, *configured*, and *being used*.

## Your task

1. Run the bundled script:
   - POSIX: `./.sad/scripts/doctor.sh`
   - PowerShell: `.\.sad\scripts\doctor.ps1`
2. If your environment does not have the script (e.g. partial install), perform the equivalent checks inline using your file-reading tools and produce the same green/yellow/red report.

## What the script checks

| Group | Check | Red means | Yellow means | Green means |
|---|---|---|---|---|
| constitution | `exists` | `.sad/memory/constitution.md` missing | — | file present |
| constitution | `identity` | `[name]` / `[who]` placeholders unfilled | — | identity filled |
| constitution | `articles` | — | article index empty (A1, A2 ...) | ≥ 1 article |
| constitution | `maturity` | no `Maturity level` line | — | maturity declared |
| stakeholders | `non-technical`, `semi-technical`, `technical` | file missing | "TBD" / `[List people` placeholders | named reviewers |
| hooks | `present` | — | `hooks/` directory missing | hook descriptors found |
| features | `any` | — | `specs/` empty or missing | at least one feature directory |
| features | `<name>.artifacts` | — | feature missing one of the seven required artifacts | all seven present |
| scripts | `platform` | — | < 4 platform-specific scripts | full script set installed |

## Discipline

- **Doctor reads, never modifies.** This command must not edit `.sad/memory/`, `specs/`, or any persistent state.
- **Hints are short and actionable.** Each yellow / red carries a one-line remediation pointer the user can act on without re-reading the user guide.
- **No `--fix` flag.** SAD is artifact-driven; auto-fix would erode the discipline that makes the methodology work. The user fixes things themselves.

## Output

- Default: human-readable list with `[OK]` / `[WARN]` / `[FAIL]` tags.
- `--json`: machine-readable JSON for CI piping.
- `--quiet`: exit code only (useful in hooks).

## When to run

- Once after `/sad-setup` to confirm the install is healthy.
- After `/sad-constitution` to confirm the constitution is filled.
- Before merging a feature, to catch missing artifacts before review.
- In CI, as the first job of the `sad-checks` workflow.
- Whenever the user is unsure "did I configure this right?".
