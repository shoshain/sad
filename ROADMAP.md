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

## P4 — Forward-looking: intent-driven substrate (post-v0.1)

> **Source:** Kapil Viren Ahuja, *"Spec-Driven Development Isn't Broken. It will collapse."* (May 2026). The article argues that SDD failures trace to a single root cause — one document carrying three layers (intent / spec / implementation). SAD already separates the *audience* dimension (three tiers) and the *time* dimension (`/sad-reconcile`), but still collapses the *layer* dimension inside `feature.spec.md` + `feature.plan.md`. These five items operationalize the layer split and push SAD from Level 2.5 toward Level 3 on Ahuja's substrate stack.

### P4-1. Split `feature.spec.md` into `feature.intent.md` + `feature.spec.md`

- **Today:** `feature.spec.md` jams **intent** (goals, NFRs, scale, success/failure conditions) and **spec** (EARS criteria, contracts) into one artifact. `feature.plan.md` then jams non-functional reasoning (still intent-shaped) with architecture choice (system-owned).
- **Change:**
  - `feature.intent.md` — goals, constraints (scale, latency, compliance posture), success/failure conditions, NFRs that drive architecture. NT-owned. New template under `.sad/templates/`.
  - `feature.spec.md` — narrows to what's convertible to an eval. Test-shaped. Every line must be EARS-form or contract-shaped.
  - `feature.plan.md` — stays system-owned (architecture chosen against intent + lessons).
  - `/sad-analyze` gains a rule: flag any implementation noun ("microservice", "queue", "lambda") that appears in `intent.md` or `spec.md`. That's Ahuja's "pre-locked architecture in the spec" leak.
- **Touches:** `.sad/templates/feature.intent.md` (new), `.sad/templates/feature.spec.md` (revise), `commands/sad-specify.md`, `commands/sad-clarify.md`, `commands/sad-analyze.md`, `.sad/scripts/create-feature.{sh,ps1}`.

### P4-2. Promote Context to a numbered phase: `/sad-context` between impact-forecast and plan

- **Today:** Lessons (`.sad/memory/lessons/`) and prior reconciliation verdicts are read at compound-time, not at plan-time. `/sad-impact-forecast` consults the lessons store but its output is forecast-shaped, not context-bundle-shaped.
- **Change:** Insert `/sad-context` as step 6.5. It reads (a) lessons relevant to the intent's domain, (b) prior reconciliation verdicts on overlapping contract surfaces, (c) constitution articles the intent triggers, and emits `context.md` — a citation-bearing decision-support bundle the plan phase consumes. This is Ahuja's "Context Crafting" craft made operational. Without it, `/sad-plan` is architect guesswork; with it, the system has empirical memory at the moment of architectural choice.
- **Touches:** `commands/sad-context.md` (new), `.sad/templates/context.md` (new), `LIFECYCLE.md` (renumber), `CHEATSHEET.md` (mermaid + table), `commands/sad-plan.md` (add context.md as input).

### P4-3. Extend drift detection to intent↔spec (not just code↔spec)

- **Today:** `/sad-reconcile` and `/sad-spec-drift-scan` check code↔spec. Ahuja's "system woke up on a different date with no memory of where it was standing" is exactly an intent-drift failure that code-vs-spec reconciliation cannot catch.
- **Change:** Add intent↔spec checks: has the spec acquired EARS criteria that don't trace to an intent constraint? Has an intent constraint vanished from the spec without an explicit `intent-update` verdict? New verdict types: `intent-update`, `spec-tightening`, `intent-orphan`. Surfaced in `reconciliation.md` and `drift-report.md`.
- **Touches:** `agents/reconciliation/spec-drift-detector.md`, `commands/sad-reconcile.md`, `commands/sad-spec-drift-scan.md`, `.sad/templates/reconciliation.md`.

### P4-4. Right-size at the front door (the Ira case)

- **Today:** SAD runs the full 14-step loop for everything. Ahuja's Ira story is exactly the SAD failure mode for a 5-minute bug fix: methodology tax on small work, vibe rebellion follows.
- **Change:** Add an intent-size triage as `/sad-brainstorm`'s first move (or `/sad-next`'s gating call):
  - **Trivial** (bug fix, copy change, dep bump): collapse to intent → implement → reconcile. Single-tier (T) approval. Auto-fill commit envelope so audit trail survives.
  - **Bounded** (feature ≤ 1 contract surface, no NFR shift): standard 14-step.
  - **Strategic** (new contract, NFR shift, cross-tier change): standard + mandatory `/sad-context` + adversarial pre-mortem.
- **Touches:** `commands/sad-brainstorm.md` (add triage), `commands/sad-next.md` (route by size), new `.sad/templates/intent-size-triage.md`, `CHEATSHEET.md` (document the three paths).

### P4-5. Substrate diagnostic in `/sad-doctor`

- **Today:** Doctor is green/yellow/red on artifacts. Maturity-report.{sh,ps1} reports graduation-readiness counters. Neither tells a team whether their *substrate* matches the maturity level they claim. Ahuja's Confession #2 — "we're at Level 2.5, not Level 3" — is exactly this honesty gap made measurable.
- **Change:** Add a substrate readout to `/sad-doctor`:
  - Lessons-store depth: count, last refresh date, citation rate at plan-time (how many plans actually cite a lesson).
  - Reconciliation verdict distribution: `code-update` vs `spec-update` vs `intent-update` ratio — drift signal.
  - Eval coverage trendline: pass rate over last N runs.
  - Output: "claimed Level N / substrate suggests Level M, gap: {reasons}."
- **Touches:** `.sad/scripts/doctor.{sh,ps1}`, `.sad/scripts/maturity-report.{sh,ps1}` (cross-reference), `commands/sad-doctor.md` (new section in the spec).

### P4 — what compounds first

P4-1 and P4-2 are load-bearing — everything else gets cheaper once the layer split exists and context is a phase. P4-3 only makes sense after P4-1 (you need a separate intent artifact to drift against). P4-4 and P4-5 are independent and can land in any order.

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
| Cleanups | 5 / 5 | 0 |
| **Total** | **25 / 27** | **2** (both require work outside this repo) |

Every promise the site's lifecycle + demo screens make about per-feature artifacts, the install footprint, the eval harness, and the maturity ladder is now backed by a real file in this repo.
