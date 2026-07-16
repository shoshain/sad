# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-06-10

### Added

- `requirements.draft.md` template with four canonical sections plus Out of scope and Assumptions captured (`.sad/templates/requirements.draft.md`)
- `data-model.md`, `research.md`, `contracts/README.md`, `contracts/example.md` templates scaffolded by `create-feature` scripts (`.sad/templates/`)
- `analysis.md` template with eight-check consistency skeleton matching the demo artifact (`.sad/templates/analysis.md`)
- `_archive/` directory with tombstone README and `LESSONS_INDEX.md` template for compound refresh (`.sad/memory/lessons/_archive/`, `.sad/templates/LESSONS_INDEX.md`)
- `--template <name>` flag for `/sad-constitution` to skip interactive starter selection (`commands/sad-constitution.md`)
- `reference/README.md`, `reference/example-server/` with `tools.json` and `server.py` MCP skeleton (`reference/`)
- `evals/run.mjs` zero-dependency Node runner with `--json`/`--verbose` and CI workflow (`.github/workflows/sad-evals.yml`)
- Maturity graduation instrumentation: stakeholder survey, rollback log, maturity-level state, report scripts, monthly cron (`.sad/templates/`, `.sad/scripts/`, `.github/workflows/sad-maturity-report.yml`)
- `/sad-doctor` CI workflow running doctor on PR with step summary and JSON artifact (`.github/workflows/sad-doctor.yml`)
- Explicit `flags:` frontmatter blocks for all commands under `commands/`
- Reviewer output schema defining JSON envelope for reviewer reports (`agents/reviewers/_schema.md`)
- Scheduled background workflows: weekly spec-drift scan and monthly maturity report (`.github/workflows/sad-spec-drift-scan.yml`, `.github/workflows/sad-maturity-report.yml`)
- Drift report canonical output path at `.sad/state/drift-report.md` (`commands/sad-spec-drift-scan.md`)
- `.sad/state/maturity-level.json` with schema template (`.sad/templates/maturity-level.schema.json`)
- `feature.intent.md` template split from `feature.spec.md` with updated `sad-specify` and create-feature scripts (`.sad/templates/feature.intent.md`, `.sad/templates/feature.spec.md`)
- `/sad-context` command with `context.md` template and lifecycle routing via `next-step` scripts (`commands/sad-context.md`, `.sad/templates/context.md`)
- Intent↔spec drift detection in `sad-analyze` and reconciliation verdict types (`commands/sad-analyze.md`, `.sad/templates/reconciliation.md`)
- `intent-size-triage.md` template and trivial/strategic routing in `sad-brainstorm` and `next-step` scripts (`.sad/templates/intent-size-triage.md`, `commands/sad-brainstorm.md`)
- Substrate diagnostic in `/sad-doctor` via extended doctor scripts (`.sad/scripts/_sad-doctor-extended.sh`, `commands/sad-doctor.md`)
- Async stakeholder approval flow: deferred approval block, stakeholder report, gate status scripts (`commands/sad-stakeholder-report.md`, `commands/sad-gate-status.md`, `.sad/scripts/gate-status.sh`)
- Presence-in-the-loop artifacts: `checkpoint.md` template, updated `sad-implement`, MATURITY.md Level 0 articles A9–A11 (`.sad/templates/checkpoint.md`, `commands/sad-implement.md`, `MATURITY.md`)
- FTM composition narrative document (`COMPOSITION.md`)

### Changed

- NOVEL.md §6 heading and body: "Five-Level" → "Six-Level" with explicit Level 0 — Solo SAD note (`NOVEL.md`)
- ATTRIBUTION.md Lowgren row updated with Level 0 prefix and six-level ladder note (`ATTRIBUTION.md`)
- `commands/sad-review.md` lists full 18 default + 9 optional + 3 tier-stand-in reviewer fleet and references `_schema.md` (`commands/sad-review.md`)
- `adapters/claude-code/README.md` updated with Windows settings files (`adapters/claude-code/README.md`)
- `hooks/README.md` documents `windows_command`/`windows_args` fields and Fowler guides-vs-sensors taxonomy (`hooks/README.md`)

### Fixed

- README.md now lists both `Website: https://sad.codes/` and `Repository: https://github.com/shoshain/sad` (`README.md`)
- `brainstormer/README.md` clarifies AISCETA workspace vs `/sad-brainstorm` output; README layout block flags directory (`brainstormer/README.md`, `README.md`)
- CHEATSHEET.md adds "Effort split (Compound Engineering default)" section with 40/20/20/20 attribution (`CHEATSHEET.md`)
- New TELEMETRY.md documents `--telemetry on` behavior (local file only, no upload), opt-out, and enforcement (`TELEMETRY.md`, `README.md`)
- `adapters/claude-code/commands/sad-doctor.md` no longer ignored; installers prefer existing adapter overrides (`.sad/scripts/sad-init.sh`, `.sad/scripts/sad-init.ps1`, `adapters/claude-code/README.md`)

### Known limitations

- Agent fleet count discrepancy: repo documents 18 default + 9 optional + 3 tier stand-ins (37 total); website hero.js shows "34" — fix requires website repo edit (`C:\SAD.Codes\hero.js`)
- `/sad-doctor` README badge requires hosted SVG endpoint; not implemented in this repo (needs external badge service)
