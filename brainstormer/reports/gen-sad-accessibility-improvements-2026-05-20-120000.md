# SAD accessibility improvements — brainstorm

- **Run id:** `gen-sad-accessibility-improvements-2026-05-20-120000`
- **Mode:** genBrainstormer (generic, no project corpus)
- **Date:** 2026-05-20
- **Subject:** Lower the activation energy for adopting SAD v0.1 in a
  real project/repo. Preserve the three-tier audience model (it is the
  central SAD differentiator per [NOVEL.md §1](../../NOVEL.md)).

## Executive summary

SAD's v0.1 kit is complete and internally consistent, but its "time-to-first
observable win" is on the order of **a focused workday**: read ~1400 lines
of guide, author a constitution, name three real reviewers, hand-wire
hooks, then walk a 14-step lifecycle. That cost lands *before* the team
sees any payoff. Three forces compound the friction:

1. **One reading path.** README (59 lines) routes immediately to
   `SAD_USER_GUIDE.md` (1357 lines). There is no five-minute tour, no
   single-page cheatsheet, no `QUICKSTART.md`.
2. **Three-reviewer prerequisite.** Solo developers, OSS maintainers, and
   early-stage teams — the population most likely to *try* a new
   methodology — cannot name three distinct humans for the three tiers.
   [`MATURITY.md`](../../MATURITY.md) Level 1 still demands all three
   approvals.
3. **Cross-platform + cross-assistant gaps.** Every helper script is
   `#!/usr/bin/env bash` (Windows users blocked), hooks are *descriptive*
   JSON rather than turn-key installers for any specific assistant, and
   "copy or submodule this repo" is the canonical Day-1 instruction.

The 12 ideas below attack those three forces. Each idea is concrete enough
to land as one PR. Two of them (B1 and B6) are the highest-leverage
investments; everything else compounds on top of those.

---

## Ideas

### B1 — Ship a real `/sad-setup` (script + npm/pip launcher), not just a prompt

**Problem.** [`commands/sad-setup.md`](../../commands/sad-setup.md) is a
27-line *prompt* asking the assistant to copy directories around. The
user-facing instruction in [README](../../README.md) is "Copy or submodule
this methodology into your codebase." A developer comparing SAD to
`pnpm create vite@latest` or `cargo new` will bounce.

**Proposal.** Add a single command that bootstraps SAD into a target
repo without manual file-copying:

- `npx sad init` (Node-based, ships in `package.json` at repo root) **or**
  `pipx run sad init` (Python). Either works; pick one.
- The launcher copies `.sad/`, `commands/`, `agents/`, `hooks/`, `evals/`,
  `LIFECYCLE.md`, etc. into the target repo (skipping anything present),
  detects the assistant (presence of `.claude/`, `.cursor/`, `AGENTS.md`,
  `.codex/`, `.aider*`), and writes a tailored `AGENTS.md` routing block.
- Includes a one-shot `--minimal` flag that installs only `.sad/memory/`,
  `LIFECYCLE.md`, the four core rules, and one feature template — the
  "SAD-zero" footprint described in B3.

**Evidence in repo.** No installer exists. The closest things are
[`.sad/scripts/create-feature.sh`](../../.sad/scripts/create-feature.sh)
(scaffolds *features*, not the methodology itself) and a 4-step manual
recipe in README §"Using this repo in a project".

**Complexity:** M · **Adoption lift:** high · **Smallest PR:** publish a
shell script `scripts/sad-init.sh` plus a 30-line `bin/sad` Node wrapper
that just shells to `sad-init.sh` on POSIX and `sad-init.ps1` on Windows.
That is the MVP; the npm package can come later.

---

### B2 — Cross-platform helper scripts (PowerShell + bash, or replace with Node/Python)

**Problem.** All four scripts under
[`.sad/scripts/`](../../.sad/scripts/) start with `#!/usr/bin/env bash`.
On Windows (and inside Claude Code's Windows-default sandbox, which
exposes only PowerShell), `./create-feature.sh 001 my-feature` cannot run.
A Windows developer following [SAD_USER_GUIDE §9.1 step 8](../../SAD_USER_GUIDE.md#91-step-by-step)
literally cannot proceed.

**Proposal.** Either:

- **Path A — bilingual.** Ship `.sad/scripts/*.ps1` siblings of every
  `.sh` script. Reference both in the user guide. Smallest change.
- **Path B — single runtime.** Replace shell scripts with Node or
  Python entry points (`node .sad/scripts/create-feature.js 001 slug`).
  Removes the `bash`/`grep`/`tr` dependency entirely and lets us validate
  inputs (e.g. reject `001` if a feature already exists at that number).

The deeper win in Path B is that `check-tier-approvals` becomes
testable, the regex for `- [x]` lines becomes auditable, and the
`stakeholder-tier-router` hook becomes a portable function call
across assistants.

**Evidence in repo.** [`.sad/scripts/check-tier-approvals.sh:17`](../../.sad/scripts/check-tier-approvals.sh)
uses bash + `grep -qiE`; portability is zero. Same pattern in
[`create-feature.sh`](../../.sad/scripts/create-feature.sh).

**Complexity:** S (Path A) / M (Path B) · **Adoption lift:** high (unlocks
the Windows half of the developer market) · **Smallest PR:** Path A —
hand-port the four scripts to PowerShell, then a CI matrix run that
exercises both on push.

---

### B3 — Introduce a "SAD-Zero" maturity level for solo developers

**Problem.** [`MATURITY.md`](../../MATURITY.md) Level 1 ("AI-Assisted
Drafting") still requires "all approval gates require manual human review
at every tier." A solo developer or OSS maintainer has *one* human — they
cannot satisfy three tiers. The current methodology rejects them by
construction.

**Proposal.** Add **Level 0 — Solo SAD** before Level 1:

- The same one human approves all three walkthroughs, but each tier still
  produces its own *artifact*. The artifact discipline is what protects
  against the
  [Virk & Liu arXiv 2508.06484](https://arxiv.org/abs/2508.06484)
  failure mode; the *separate-human* discipline is what protects against
  rubber-stamping.
- Solo SAD trades the second protection for the first. Document that
  trade-off explicitly so adopters know what they are giving up.
- Optionally: ship a "AI-plays-non-technical-reviewer" persona that runs
  before the human approves, so the human gets adversarial review of the
  non-technical walkthrough even when they are the only reviewer.

**Evidence in repo.** [`MATURITY.md:9-10`](../../MATURITY.md): "All
approval gates require manual human review at every tier." No exception
exists.

**Complexity:** S · **Adoption lift:** high (entire solo + early-stage
population becomes addressable) · **Smallest PR:** add the Level 0 row to
`MATURITY.md`, add a sentence to `SAD_USER_GUIDE.md §7.1`, optionally add
`agents/reviewers/solo-non-technical-stand-in.md`.

---

### B4 — `QUICKSTART.md`: one page, one feature, 30 minutes

**Problem.** [`README.md:11-14`](../../README.md) says "New to SAD? Read
`SAD_USER_GUIDE.md`." That guide is 1357 lines (~37,000 tokens). The
guide itself, at [§11](../../SAD_USER_GUIDE.md#11-a-full-worked-feature-end-to-end),
gestures at the worked example but the reader is already 1000 lines deep
by then. There is no progressive disclosure.

**Proposal.** Add `QUICKSTART.md` at the repo root, **≤ 250 lines**, that:

1. Installs SAD with `npx sad init --minimal` (B1).
2. Walks one feature end-to-end using a *truncated* loop:
   `/sad-specify` → write a 1-paragraph spec → `/sad-walkthrough` →
   check all three boxes yourself (Level 0) → `/sad-implement` →
   `/sad-reconcile`. Skip `/sad-brainstorm`, `/sad-clarify`,
   `/sad-impact-forecast`, `/sad-analyze`, `/sad-tasks`, `/sad-compound`
   on the first run — they all have their place but they are not the
   minimum viable lifecycle.
3. Ends with: "You just produced three differentiated artifacts and a
   reconciliation report. *That* is SAD. The next 1000 lines of
   `SAD_USER_GUIDE.md` are about making it stick at team scale."
4. Links forward to the full lifecycle.

**Evidence in repo.** README routes to SAD_USER_GUIDE without any
intermediate step. No file named `QUICKSTART`, `TUTORIAL`, `GETSTARTED`,
or similar exists.

**Complexity:** S · **Adoption lift:** high · **Smallest PR:**
`QUICKSTART.md` + a link from `README.md` above the "Where to start"
table.

---

### B5 — Domain-specific constitution starter pack

**Problem.** [`/sad-constitution`](../../commands/sad-constitution.md) is
a 24-line prompt that tells the assistant "Read existing governance,
ADRs, security policies, and coding standards." For a project that *has*
those documents, the command works. For a typical solo OSS Rust crate or
weekend SaaS, those documents do not exist. The constitution template at
[`.sad/memory/constitution.md`](../../.sad/memory/constitution.md) has
three placeholder principles and an empty article index.

**Proposal.** Ship `.sad/templates/constitutions/` with starter
constitutions for common project shapes:

- `web-app.md` (SaaS, auth, payments, data retention)
- `library.md` (semver, public API stability, deprecation policy)
- `cli.md` (UX, exit codes, output stability, plugin API)
- `data-pipeline.md` (idempotency, schemas, lineage)
- `ml-app.md` (model lineage, eval gates, dataset governance)
- `regulated.md` (audit logging, change control, separation of duties)

Each has 5–8 prefilled articles, identity placeholders, and at least one
pre-named "tension" (e.g. for `library.md`: "stability vs ergonomics").
`/sad-constitution` is updated to ask the user which starter to clone
before authoring.

**Evidence in repo.** [`.sad/memory/constitution.md`](../../.sad/memory/constitution.md)
template has 3 placeholder principles and an empty article index. No
starter packs exist anywhere in the tree.

**Complexity:** M (each starter is ~80 lines of curated content) ·
**Adoption lift:** med-high · **Smallest PR:** ship the two highest-volume
shapes first (`web-app.md`, `library.md`).

---

### B6 — One-page visual cheatsheet (cards, not prose)

**Problem.** A new contributor opening the repo on a Monday wants to
*see* the loop on one screen. The loop is currently drawn in mermaid in
[`SAD_USER_GUIDE.md §2.1`](../../SAD_USER_GUIDE.md#21-what-sad-is) and
in text in [`LIFECYCLE.md`](../../LIFECYCLE.md). Both are buried.

**Proposal.** A `CHEATSHEET.md` at repo root containing exactly:

- One mermaid lifecycle diagram (lift the existing one).
- One table: command → artifact → approver → next command.
- One table: the three tiers, what they read, what they don't read.
- One table: maturity levels and their gate-skip rules.
- A "common gotchas" footer (≤ 8 bullets).

No prose. Print-to-PDF ready. Maximum 80 lines of markdown.

**Evidence in repo.** No `CHEATSHEET`, no condensed view, no printable
reference exists. [`SAD_USER_GUIDE §17`](../../SAD_USER_GUIDE.md#17-quick-reference-cheatsheets)
*is* called "Quick-reference cheatsheets" but it is buried at line
~1200 of a 1357-line file.

**Complexity:** S · **Adoption lift:** med (compounds with B4) ·
**Smallest PR:** copy §17 of the guide into a top-level
`CHEATSHEET.md`, trim, add the mermaid diagram.

---

### B7 — `/sad-doctor` health-check command

**Problem.** Once a user has SAD installed, they have no fast feedback
loop telling them "you are following the methodology correctly."
[`/sad-spec-drift-scan`](../../commands/sad-spec-drift-scan.md) and
[`/sad-analyze`](../../commands/sad-analyze.md) exist but they are
per-feature; nothing reports on the *project* level. Silent rot is the
biggest risk in a young SAD adoption.

**Proposal.** Add `/sad-doctor` (mirroring `brew doctor`, `flutter doctor`,
`npm doctor`):

- Constitution: is it non-empty? Are there articles? Is the maturity-level
  line present?
- Stakeholders: are the three files filled or do they still say "TBD"?
- Hooks: are they wired into the detected assistant?
- Per feature in `specs/`: does it have all six artifacts? Are walkthrough
  approval boxes consistent with its lifecycle stage?
- Scripts: do the helper scripts exist and execute on this platform?
- Reports: green/yellow/red per check with one-line remediation pointers.

Visible value in <30 seconds. Cheap to write (most checks are
`Test-Path` + grep). High reward shape (B5/B6 compound it).

**Evidence in repo.** No project-wide health command. The closest is
[`.sad/state/sad-state.md`](../../.sad/state/sad-state.md), but that is a
*session-continuity marker*, not a health report.

**Complexity:** S–M · **Adoption lift:** high (the "compounding payoff"
gets a daily visible avatar) · **Smallest PR:** a Node or Python script
under `.sad/scripts/doctor.{js,py}` plus a `commands/sad-doctor.md`
prompt that just invokes it.

---

### B8 — Ship turn-key adapters for the top 3 assistants

**Problem.** [`SAD_USER_GUIDE §8.6`](../../SAD_USER_GUIDE.md#86-six-generic-integration-patterns)
spends 200+ lines describing six abstract integration "patterns" the
user must implement themselves. The reader becomes a *methodology
integrator* before they get to use the methodology.

**Proposal.** Ship ready-made adapter files for the three highest-share
assistants. `npx sad init --assistant=claude-code|cursor|codex` writes
the right files:

- **Claude Code:** `.claude/settings.json` with hook wiring,
  `.claude/commands/` with each `sad-*` as a slash-command, `AGENTS.md`
  at root with the precedence block.
- **Cursor:** `.cursor/rules/sad-routing.mdc` (always-on),
  `.cursor/commands/` with each `sad-*` as a saved command, `AGENTS.md`
  at root.
- **Codex / Aider / Continue:** the equivalent native idiom for each.

The descriptive `hooks/*.json` files stay as the *canonical*
specification; the adapter packs are derived from them.

**Evidence in repo.** [`hooks/README.md:1-3`](../../hooks/README.md): "SAD
ships **descriptive** hook JSON files. Map them to your agent harness."
That mapping is currently the user's problem.

**Complexity:** M-L (three adapters at ~100 lines each, plus a
verifier) · **Adoption lift:** high · **Smallest PR:** ship the Claude
Code adapter only first; that is the assistant whose user base most
overlaps with SAD's positioning ("AI-native methodology").

---

### B9 — Add 4–5 worked examples covering common feature shapes

**Problem.** [`examples/001-hello-feature/`](../../examples/001-hello-feature/)
is a single CRUD-like example ("save a personal greeting"). A reader
about to apply SAD to a *bug fix*, a *data migration*, a *refactor*, or
a *third-party integration* has no template. The user guide gestures at
adoption granularity ([§10.1 step 8](../../SAD_USER_GUIDE.md#101-step-by-step))
but does not show how the artifacts shape-shift across feature types.

**Proposal.** Add four more examples:

- `examples/002-bug-fix/` — `feature.spec.md` reads as a regression
  reproduction; `reconciliation.md` is the centerpiece.
- `examples/003-data-migration/` — `data-migrations` reviewer leads;
  `impact-forecast.md` carries most of the weight.
- `examples/004-refactor-no-behavior-change/` — out-of-scope dominates;
  EARS criteria are negative ("the system SHALL NOT change behavior").
- `examples/005-third-party-integration/` — contracts directory is real;
  `api-contract` reviewer is central.

Each example is the same size as 001 (≤ ~300 lines total across all
artifacts) so the *delta* from 001 is what the reader learns.

**Evidence in repo.** Only one example exists
([`examples/001-hello-feature/`](../../examples/001-hello-feature/)).

**Complexity:** M (each example ~300 lines) · **Adoption lift:** med ·
**Smallest PR:** ship `002-bug-fix/` first — bug fixes are the modal
"first real feature" for any project bringing SAD in.

---

### B10 — "AI plays the missing tier" pattern, with guardrails

**Problem.** Even at Level 0 (B3), the *quality* of solo SAD suffers
because the one human cannot un-know the technical detail when reviewing
the non-technical walkthrough. The Virk & Liu finding cited in
[`ROLES.md` §"What 'approved' means here"](../../.sad/stakeholders/non-technical.md)
applies recursively here.

**Proposal.** A persona —
`agents/reviewers/tier-stand-in-non-technical.md` (and equivalents for
the other two tiers) — that an assistant adopts when the user explicitly
opts in via maturity-level configuration. The persona reviews the
tier-specific walkthrough adversarially *as if it were that tier's
audience*. Findings appear in the walkthrough as suggestions, not
auto-approvals; the human still ticks the box.

The opt-in is loud. The constitution gains a new line:
"Tier X reviewer is AI-stand-in. Last calibrated against human review
on YYYY-MM-DD." The audit trail is honest.

**Evidence in repo.** No tier-stand-in personas exist.
[`agents/reviewers/`](../../agents/reviewers/) has 17 reviewers, all
technical-tier.

**Complexity:** M · **Adoption lift:** med (only matters once B3 lands) ·
**Smallest PR:** the non-technical stand-in persona only, as a paired
PR with the B3 maturity-level change.

---

### B11 — Worked CI templates (GitHub Actions, GitLab CI)

**Problem.** [`SAD_USER_GUIDE §14`](../../SAD_USER_GUIDE.md#14-eval-strategy)
talks about an eval-suite CI gate ("Stakeholder pass-rate at or above…")
but no `.github/workflows/` or `.gitlab-ci.yml` exists in the repo. The
empty `evals/*/.gitkeep` files are the only sign the eval suites are
*meant* to be wired into CI. A team trying to graduate from Level 1 to
Level 2 has nothing to copy.

**Proposal.** Ship `.github/workflows/sad-checks.yml.example` and
`.gitlab-ci.yml.example`:

- Job 1: `sad-doctor` (from B7).
- Job 2: spec-conformance evals.
- Job 3: stakeholder-tier-approval scan (B2's portable script).
- Job 4: spec-drift sweep (`/sad-spec-drift-scan` in non-interactive
  mode).

Document how to flip them from `.example` to active.

**Evidence in repo.** No CI files exist at any layer. The repo's own
top-level `.markdownlint.json` is the only quality-tooling file.

**Complexity:** S-M · **Adoption lift:** med (drives Level-2 graduation,
which is where the methodology starts to pay back) · **Smallest PR:** a
single GitHub Actions example that runs `sad-doctor` on push.

---

### B12 — Reposition the name and the framing (optional, controversial)

**Problem.** "SAD" is an unfortunate brand for software a team is meant
to enjoy adopting. "Stakeholder-Anchored Development" connotes corporate
review boards more than AI-native rapid iteration. Combined with the
density of the user guide, the framing reinforces "this looks like
process burden" before the reader has met any of the actual primitives.

**Proposal.** Either:

- **Path A — keep the acronym, soften the tagline.** Rewrite the README's
  one-liner from "A composable, AI-native software engineering
  methodology with a three-tier domain-expert feedback loop at its core"
  to something concrete and developer-shaped: *"Three artifacts per
  feature, three tiers of review, one reconciliation report. The kit
  installs in one command and your first feature ships today."*
- **Path B — re-acronym.** "SAD" → "SAD3" (Stakeholder Audience Driven
  Development, three tiers) or rename entirely. Higher cost; this is the
  optional / controversial idea on the list.

Path A is the smallest and probably enough.

**Evidence in repo.** [`README.md:3`](../../README.md) and
[`MANIFESTO.md`](../../MANIFESTO.md) headline framing.

**Complexity:** S (Path A) / L (Path B) · **Adoption lift:** low-med ·
**Smallest PR:** rewrite the README's first paragraph.

---

## Recommended sequencing

If only three of these ship, ship **B1, B4, B6**: a real installer, a
one-page quickstart, and a one-page cheatsheet. Those collapse
time-to-first-win from ~a day to ~an hour without touching the
methodology itself.

If five ship, add **B3 + B7**: open SAD to solo developers, then give
them a daily visible health signal that proves the methodology is
working.

Everything else compounds.

## Method notes

- The genBrainstormer skill's standard boot sequence (bash heredocs for
  schema validation and run-id generation) was not executed: PowerShell
  was denied in this environment and Git Bash was not available. The run
  directory and audit trail were scaffolded with the `Write` tool
  instead. See [`failures.json`](../runs/gen-sad-accessibility-improvements-2026-05-20-120000/failures.json).
- Phases 2 and 3 were skipped per genBrainstormer's generic-mode contract
  (no local corpus). The brainstorm is grounded in 18 SAD repo files
  read directly during Phase 4: `README.md`, `MANIFESTO.md`,
  `LIFECYCLE.md`, `MATURITY.md`, `ROLES.md`, `NOVEL.md`, `AGENTS.md`,
  `SAD_USER_GUIDE.md` (partial — first 945 lines, plus index/structure),
  `commands/sad-setup.md`, `commands/sad-constitution.md`,
  `commands/sad-brainstorm.md`, `.sad/memory/constitution.md`,
  `.sad/scripts/create-feature.sh`, `.sad/scripts/check-tier-approvals.sh`,
  `.sad/templates/feature.spec.md`, `.sad/stakeholders/non-technical.md`,
  `.sad/rules/core/README.md`, `examples/001-hello-feature/feature.spec.md`,
  and `hooks/README.md`.
- No external web research was performed in this run. Most claims are
  internal to the repo; the only external citation (Virk & Liu, arXiv
  2508.06484) was sourced from SAD's own documentation, not a fresh
  fetch.
