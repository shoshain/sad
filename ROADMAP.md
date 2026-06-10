# SAD Roadmap — gaps between the website (sad.codes) and the v0.1 repo

> Living document. Tracks what the website at <https://sad.codes/> promises vs what the repo at `C:\SAD` ships. Items marked **✅ done** were landed in the implementation pass on 2026-05-21.

Severity tags: **P0** (site implies it works today), **P1** (advertised optional feature), **P2** (documentation drift / polish), **P3** (nice-to-have / speculative).

---

## P0 — site implies it works, repo doesn't ship it

### ✅ P0-1. `requirements.draft.md` template (done)

- **Site claim** (`demo-data.js` phase 03, `lifecycle.js`): `/sad-brainstorm` produces a structured `requirements.draft.md` with Problem, Smallest viable scope, Bounds, Open questions sections.
- **Shipped:** [`.sad/templates/requirements.draft.md`](.sad/templates/requirements.draft.md) with the four canonical sections plus *Out of scope* and *Assumptions captured*. `create-feature.{sh,ps1}` now scaffolds it. [`commands/sad-brainstorm.md`](commands/sad-brainstorm.md) frontmatter references the template and the `--feature <slug>` flag.

### ✅ P0-2. `data-model.md`, `research.md`, `contracts/` templates (done)

- **Site claim** (lifecycle step 07; demo phase 07 terminal): `/sad-plan` produces data-model, contracts, and research artifacts.
- **Shipped:** [`.sad/templates/data-model.md`](.sad/templates/data-model.md), [`.sad/templates/research.md`](.sad/templates/research.md), [`.sad/templates/contracts/README.md`](.sad/templates/contracts/README.md), [`.sad/templates/contracts/example.md`](.sad/templates/contracts/example.md). `create-feature.{sh,ps1}` scaffolds all three + the `contracts/example.md` starter into every new feature folder. `commands/sad-plan.md` frontmatter lists the templates and the `--feature` flag.

### ✅ P0-3. `analysis.md` template (done)

- **Site claim** (demo phase 09 artifact path `specs/001-personal-greeting/analysis.md`): `/sad-analyze` writes a persisted consistency report.
- **Shipped:** [`.sad/templates/analysis.md`](.sad/templates/analysis.md) — the eight-check skeleton matching the demo (spec↔plan, plan↔tasks, EARS testability, A1/A2/A3 spot checks, tier definitions, out-of-scope, impact-forecast coverage, open-question resolution). `commands/sad-analyze.md` references the template and the `--feature` / `--stdout` flags.

### ✅ P0-4. `_archive/` + `LESSONS_INDEX` (done)

- **Site claim** (reference.js, lifecycle background): `/sad-compound-refresh` archives stale lessons and produces an index.
- **Shipped:** [`.sad/memory/lessons/_archive/`](.sad/memory/lessons/_archive/) directory pre-exists with a README documenting the tombstone convention. [`.sad/templates/LESSONS_INDEX.md`](.sad/templates/LESSONS_INDEX.md) template ships. `commands/sad-compound-refresh.md` references both and exposes `--max-age-days` and `--dry-run`.

### ✅ P0-5. `/sad-constitution --template <name>` flag (done)

- **Site claim** (demo phase 02 terminal: `$ /sad-constitution --template library`): the constitution command accepts a CLI flag to skip the interactive starter selection.
- **Shipped:** `commands/sad-constitution.md` frontmatter now exposes `--template <name>` and the prompt instructs the writer to skip the starter prompt when the flag is supplied.

---

## P1 — advertised optional feature, now shipped

### ✅ P1-1. `reference/` MCP-server skeleton (done)

- **Site claim** (Lineage §ii: "reference-application MCP server (optional, for legacy contexts)"; ATTRIBUTION.md line 51: "Optional; recommended for legacy contexts under `reference/`").
- **Shipped:** [`reference/README.md`](reference/README.md) explains the pattern. [`reference/example-server/`](reference/example-server/) contains `README.md`, [`tools.json`](reference/example-server/tools.json) (MCP-shaped JSON-Schema tool descriptor), and [`server.py`](reference/example-server/server.py) (zero-dependency JSON-RPC stub running on stock Python).

### ✅ P1-2. Eval-harness runner (done)

- **Site claim** (Lineage §iii: "continuous online + offline eval harness skeleton"; reference.js lists "Eval graders × 3").
- **Shipped:** [`evals/run.mjs`](evals/run.mjs) — a Node 22+ runner with no third-party dependencies. Discovers every `EVAL.ts` file under `evals/`, dynamic-imports it via `--experimental-strip-types`, and aggregates pass/fail/error/stub/skip with optional `--json` and `--verbose`. [`evals/package.json`](evals/package.json) wires `npm run eval`. [`.github/workflows/sad-evals.yml`](.github/workflows/sad-evals.yml) runs the harness on every PR touching evals / commands / agents / templates.

### ✅ P1-3. Maturity-graduation instrumentation (done)

- **Site claim** (maturity.js bottom: graduation criteria — 4+ weeks green, FP < 10 %, satisfaction > 80 %, < 1 rollback / 20 features).
- **Shipped:**
  - [`.sad/templates/stakeholder-satisfaction-survey.md`](.sad/templates/stakeholder-satisfaction-survey.md) — five-question Likert template per tier.
  - [`.sad/templates/rollback-log.md`](.sad/templates/rollback-log.md) — feature-slug ledger.
  - [`.sad/state/maturity-level.json`](.sad/state/maturity-level.json) (+ [`.sad/templates/maturity-level.schema.json`](.sad/templates/maturity-level.schema.json)) — machine-readable level state.
  - [`.sad/scripts/maturity-report.sh`](.sad/scripts/maturity-report.sh) / [`.sad/scripts/maturity-report.ps1`](.sad/scripts/maturity-report.ps1) — graduation-readiness card with `--json`.
  - [`.github/workflows/sad-maturity-report.yml`](.github/workflows/sad-maturity-report.yml) — monthly cron emitting the report as a CI artifact.

### ✅ P1-4. `/sad-doctor` CI workflow (done)

- **Shipped:** [`.github/workflows/sad-doctor.yml`](.github/workflows/sad-doctor.yml) runs `bash .sad/scripts/doctor.sh` on PR, posts the green/yellow/red summary to the GitHub step summary, and uploads the `--json` output as an artifact.

### ✅ P1-5. CLI flag surface documented (done)

- Every command spec under [`commands/`](commands/) now has an explicit `flags:` block in its frontmatter:
  - `sad-setup` → `--persistent`, `--minimal`, `--dry-run`, `--assistant`
  - `sad-constitution` → `--template`
  - `sad-brainstorm`, `sad-specify`, `sad-clarify`, `sad-impact-forecast`, `sad-plan`, `sad-tasks`, `sad-reconcile`, `sad-demo`, `sad-compound` → `--feature <slug>`
  - `sad-walkthrough` → `--feature`, `--tier`
  - `sad-analyze` → `--feature`, `--stdout`
  - `sad-implement` → `--feature`, `--wave`
  - `sad-review` → `--feature`, `--reviewer`
  - `sad-spec-drift-scan` → `--feature`, `--json`
  - `sad-evolve-evals` → `--suite`, `--tier`
  - `sad-compound-refresh` → `--max-age-days`, `--dry-run`
  - `sad-doctor` → `--json`, `--quiet`
  - `sad-requirements-progress` → full flag passthrough to the Python script

---

## P2 — documentation drift (closed in this pass)

### ✅ P2-1. "Five-Level" → "Six-Level" maturity ladder (done)

- [`NOVEL.md` §6](NOVEL.md) heading and body now read "Six-Level Maturity Ladder", with an explicit note that SAD prefixes Lowgren's five with **Level 0 — Solo SAD**.
- [`ATTRIBUTION.md`](ATTRIBUTION.md) row for Lowgren's CMMM ladder now states the Level 0 prefix and resulting six-level ladder.

### P2-2. Agent fleet count: 34 vs 37 (open — site-side fix)

- **Status:** documented honestly inside the repo (`commands/sad-review.md` now explains the 18 default + 9 optional + 3 tier-stand-ins split). The website hero stat "Agent fleet: 34" is a `C:\SAD.Codes\hero.js` edit that lives in the **website repo**, not this one — left untouched per "make the repo match the website" scope.

### ✅ P2-3. README GitHub URL (done)

- [`README.md`](README.md) now lists both `Website: https://sad.codes/` and `Repository: https://github.com/shoshain/sad`.

### ✅ P2-4. `brainstormer/` disambiguation (done)

- [`brainstormer/README.md`](brainstormer/README.md) clarifies that this directory is the AISCETA deep-research workspace, **not** `/sad-brainstorm` output. [`README.md`](README.md) repository layout block now flags the directory explicitly.

### ✅ P2-5. CHEATSHEET effort split (done)

- [`CHEATSHEET.md`](CHEATSHEET.md) gained an "Effort split (Compound Engineering default)" section showing the 40 / 20 / 20 / 20 plan · work · review · compound split with attribution.

### ✅ P2-6. TELEMETRY.md (done)

- New [`TELEMETRY.md`](TELEMETRY.md) explains exactly what `--telemetry on` does (writes one local file, no upload), how to opt out, and where the promise is enforced. Linked from [`README.md`](README.md).

### ✅ P2-7. `adapters/claude-code/commands/sad-doctor.md` (done)

- Sample no longer ignored. Both installers (`sad-init.{sh,ps1}`) now prefer any pre-existing `adapters/claude-code/commands/<name>.md` override and fall back to the generated pointer template otherwise. Adapter README updated to document the file as a real override mechanism, not a misleading sample.

---

## P3 — partially landed; remainder is future work

### ✅ P3-1. Reviewer output schema (done)

- [`agents/reviewers/_schema.md`](agents/reviewers/_schema.md) defines the JSON envelope every reviewer report SHOULD emit (`name`, `outcome`, `confidence`, `severity`, `findings[]`). Documented as the basis for Level-3+ auto-merge confidence gating.

### ✅ P3-2. Scheduled background workflows (done)

- [`.github/workflows/sad-spec-drift-scan.yml`](.github/workflows/sad-spec-drift-scan.yml) — weekly Monday 06:00 UTC scan.
- [`.github/workflows/sad-maturity-report.yml`](.github/workflows/sad-maturity-report.yml) — monthly readiness card on the 1st at 07:00 UTC.
- (Compound-refresh and evolve-evals are not auto-scheduled — they are still human-initiated rituals per the source methodologies.)

### ✅ P3-3. Drift report convention (done)

- `commands/sad-spec-drift-scan.md` now declares its canonical output at `.sad/state/drift-report.md` (was ambiguous "docs/drift-report.md" before).

### ✅ P3-4. `.sad/state/maturity-level.json` (done)

- Shipped with `.sad/templates/maturity-level.schema.json`. Read by `maturity-report.{sh,ps1}` and intended for future doctor surface ("you are at Level N").

### P3-5. `/sad-doctor` README badge (open — needs hosted endpoint)

- Out of scope until a hosted SVG endpoint exists. Notes captured for a future drop.

---

## Internal-consistency cleanups (all done)

1. ✅ **NOVEL.md §6** — "Five-Level" → "Six-Level".
2. ✅ **ATTRIBUTION.md** Lowgren row — explicit Level 0 prefix note.
3. ✅ **`commands/sad-review.md`** — lists the full 18 + 9 + 3 reviewer fleet split and pointed at `_schema.md`.
4. ✅ **`adapters/claude-code/README.md`** — already updated in the previous review pass (includes `settings.windows*.json`).
5. ✅ **`hooks/README.md`** — documents the new `windows_command` / `windows_args` field on `stakeholder-tier-router.json` and the Fowler guides-vs-sensors taxonomy.

---

## P4 — Forward-looking: intent-driven substrate (landed 2026-06)

> **Source:** Kapil Viren Ahuja, *"Spec-Driven Development Isn't Broken. It will collapse."* (May 2026).

### ✅ P4-1. Split `feature.spec.md` into `feature.intent.md` + `feature.spec.md`

- **Shipped:** [`.sad/templates/feature.intent.md`](.sad/templates/feature.intent.md), revised [`feature.spec.md`](.sad/templates/feature.spec.md), updated [`commands/sad-specify.md`](commands/sad-specify.md), `create-feature.{sh,ps1}` scaffolds intent.

### ✅ P4-2. Promote Context to `/sad-context` between impact-forecast and plan

- **Shipped:** [`commands/sad-context.md`](commands/sad-context.md), [`.sad/templates/context.md`](.sad/templates/context.md), `next-step.{sh,ps1}` routes strategic triage through context phase, [`LIFECYCLE.md`](LIFECYCLE.md) updated.

### ✅ P4-3. Extend drift detection to intent↔spec (preview in analyze + reconciliation verdicts)

- **Shipped:** [`commands/sad-analyze.md`](commands/sad-analyze.md) intent leak checks; [`reconciliation.md`](.sad/templates/reconciliation.md) verdict types `intent-update`, `spec-tightening`, `intent-orphan`.

### ✅ P4-4. Right-size at the front door (intent-size triage)

- **Shipped:** [`.sad/templates/intent-size-triage.md`](.sad/templates/intent-size-triage.md), [`commands/sad-brainstorm.md`](commands/sad-brainstorm.md), `next-step.{sh,ps1}` trivial/strategic routing.

### ✅ P4-5. Substrate diagnostic in `/sad-doctor`

- **Shipped:** [`.sad/scripts/_sad-doctor-extended.{sh,ps1}`](.sad/scripts/_sad-doctor-extended.sh) — theater + substrate checks; [`commands/sad-doctor.md`](commands/sad-doctor.md) documents new rows.

### ✅ P4-6. Async stakeholder + gate queue (from field experience)

- **Shipped:** deferred approval block on walkthrough templates; [`commands/sad-stakeholder-report.md`](commands/sad-stakeholder-report.md); [`commands/sad-gate-status.md`](commands/sad-gate-status.md); [`gate-status.{sh,ps1}`](.sad/scripts/gate-status.sh); updated [`check-tier-approvals.{sh,ps1}`](.sad/scripts/check-tier-approvals.sh).

### ✅ P4-7. Presence in the loop (Article A11)

- **Shipped:** [`.sad/templates/checkpoint.md`](.sad/templates/checkpoint.md), [`commands/sad-implement.md`](commands/sad-implement.md), [`MATURITY.md`](MATURITY.md), regulated constitution starter articles A9–A11.

### ✅ P4-8. FTM composition narrative

- **Shipped:** [`COMPOSITION.md`](COMPOSITION.md).

---

## Out of scope (website-side)

The website at <https://sad.codes/> has two internal inconsistencies that need edits in `C:\SAD.Codes\`, **not** in this repo:

- `compare.js` says "5 levels" while `maturity.js` shows six.
- `hero.js` says "Agent fleet: 34" while the repo ships 37 (18 default + 9 optional + 3 tier stand-ins). Either bump the count to 37 with a 7th group, or keep 34 and call the tier stand-ins out separately.

Both are five-line edits in the website repo; flagged here for ownership tracking.

---

## Summary

| Bucket | Done | Open |
|---|---|---|
| P0 | 5 / 5 | 0 |
| P1 | 5 / 5 | 0 |
| P2 | 6 / 7 (P2-2 is site-side) | 1 (P2-2, website edit) |
| P3 | 4 / 5 | 1 (P3-5, needs hosted badge endpoint) |
| P4 | 8 / 8 | 0 |
| Cleanups | 5 / 5 | 0 |
| **Total** | **33 / 35** | **2** (both require work outside this repo) |

Every promise the site's lifecycle + demo screens make about per-feature artifacts, the install footprint, the eval harness, and the maturity ladder is now backed by a real file in this repo.
