# SAD Quickstart — one feature, 30 minutes

> Brand-new to SAD? You are in the right place. This is the shortest path from "clean repo" to "I shipped one feature through the SAD lifecycle and saw the three-tier discipline in action."
>
> Full depth lives in [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) (1357 lines). Read this page first; the guide is for when you want to operate SAD at team scale.

---

## What you will have at the end of this 30-minute walkthrough

- `.sad/` installed in your project (your project, not this repo).
- A real `feature.spec.md`, `feature.plan.md`, and three tier-specific walkthroughs for one toy feature.
- A `reconciliation.md` showing the spec/code coherence check.
- A first lesson recorded under `.sad/memory/lessons/`.
- Working knowledge of *why* SAD differentiates artifacts by tier instead of writing "one spec for everybody."

If that sounds useful, keep reading.

---

## 0. Prerequisites (2 minutes)

- An AI coding assistant: Claude Code, Cursor, Aider, Codex CLI, or Windsurf (any of them).
- Either **Node 18+** (preferred — runs on every OS) or **bash + PowerShell** (the installer works with both).
- A target repo. A fresh `git init` directory is fine for this walkthrough. Alternatively, clone the **[sad-test-repo](https://github.com/shoshain/sad-test-repo)** sandbox and follow [`testing_sad.md`](https://github.com/shoshain/sad-test-repo/blob/main/testing_sad.md) for a full kit validation run (typical local path: `C:\SAD-testing-repo`).

If you have none of those yet, install Node and `git init` a fresh directory — that is all you need.

---

## 1. Install SAD (3 minutes)

From inside the directory where you cloned **this** repo (i.e. `C:/SAD/` or wherever it lives), run the installer against your target project:

```bash
# POSIX (macOS, Linux, WSL, Git Bash on Windows)
./scripts/sad-init.sh /path/to/my-project

# PowerShell (Windows native)
.\scripts\sad-init.ps1 -TargetDir C:\path\to\my-project
```

Add `--persistent` if you want SAD context to load automatically in every new chat with your AI assistant (recommended — see [§ Persistence](#5-make-sad-persistent-in-your-ai-session-1-minute) below).

Add `--minimal` if you only want the bare-minimum footprint for this 30-minute walkthrough. You can always re-run the installer to get more later.

The installer:

1. Copies `.sad/`, `commands/`, `agents/`, `hooks/`, `evals/`, and the top-level reference docs into your project.
2. Auto-detects your AI coding assistant by looking for `.claude/`, `.cursor/`, `.aider*`, `.codex/`, `.windsurf/`, or `AGENTS.md` at your target's root.
3. Writes the matching adapter pack (see [`adapters/`](adapters/) in this repo).
4. Creates a starter `AGENTS.md` at your target's root with the [declared-precedence block](SAD_USER_GUIDE.md#83-declared-precedence).

**You'll know it worked when** running `ls .sad/ commands/ agents/` in your target project shows all three directories.

---

## 2. Bootstrap your constitution (5 minutes)

Pick one of the [domain-specific starter constitutions](.sad/templates/constitutions/) — `web-app.md`, `library.md`, `cli.md`, `data-pipeline.md`, `ml-app.md`, or `regulated.md`.

Copy it over the empty template:

```bash
cp .sad/templates/constitutions/library.md .sad/memory/constitution.md   # POSIX
# or
Copy-Item .sad/templates/constitutions/library.md .sad/memory/constitution.md   # PowerShell
```

Open `.sad/memory/constitution.md` and:

1. Fill in your project name and primary users.
2. Pick a maturity level (default for solo developers: **Level 0**; default for two-or-more-person teams: **Level 1**). See [`MATURITY.md`](MATURITY.md).
3. Read each pre-named **tension** at the bottom of the starter and write a one-sentence resolution. (This is the only manual writing the constitution actually needs.)

**You'll know it worked when** `.sad/memory/constitution.md` has your project's name, at least one immutable principle, and a maturity level line.

---

## 3. Scaffold your first feature (2 minutes)

```bash
# POSIX
./.sad/scripts/create-feature.sh 001 hello-greeting

# PowerShell
.\.sad\scripts\create-feature.ps1 001 hello-greeting
```

This creates `specs/001-hello-greeting/` with all the template files in place.

**You'll know it worked when** `ls specs/001-hello-greeting/` shows `feature.spec.md`, `feature.plan.md`, `tasks.md`, and a `walkthroughs/` directory.

---

## 4. Walk one truncated lifecycle (15 minutes)

> **Shortcut for the impatient:** invoke **`/sad-next`** and let the conductor drive. It reads `.sad/state/sad-state.md`, runs whichever phase command is next, updates state, and stops at the two human gates (walkthrough approvals, reconciliation sign-off) with inline approval prompts. The hand-walked path below is the same lifecycle, exposed step-by-step so you can see what each phase produces. See [`commands/sad-next.md`](commands/sad-next.md) and [`DAEMON.md §0`](DAEMON.md).

For your first feature, **skip** `/sad-brainstorm`, `/sad-clarify`, `/sad-impact-forecast`, `/sad-analyze`, `/sad-tasks`, and `/sad-compound`. They all have their place — the full lifecycle is in [`LIFECYCLE.md`](LIFECYCLE.md) — but they are not the minimum.

Walk this path only:

| Step | Command | What you do |
|------|---------|-------------|
| 1 | `/sad-specify` | Edit `specs/001-hello-greeting/feature.spec.md` — one paragraph of business intent, 2-3 capabilities, 3-4 EARS criteria (`WHEN x THEN the system SHALL y`), explicit out-of-scope items. |
| 2 | `/sad-plan` | Edit `feature.plan.md` — what you'll build, in plain semi-technical language. Skip the impact-forecast section for now. |
| 3 | `/sad-walkthrough` | Generate `walkthroughs/{non-technical,semi-technical,technical}.md` by asking your AI assistant to fill the templates from your spec and plan. |
| 4 | **Tick all three approval boxes yourself.** | At Level 0 / Solo SAD you are all three tiers. The artifact discipline (three differentiated walkthroughs) survives; only the multi-human rubber-stamp protection is traded. See [`MATURITY.md` Level 0](MATURITY.md#level-0-solo-sad). |
| 5 | `/sad-implement` | Write the actual code for your toy feature. |
| 6 | `/sad-reconcile` | Generate `reconciliation.md`. For a brand-new feature with a tiny diff this is usually a one-row "coherent" verdict. |

**You'll know it worked when** all three approval boxes are checked, code compiles/runs, and `reconciliation.md` exists.

---

## 5. Make SAD persistent in your AI session (1 minute)

If you ran the installer with `--persistent`, you're done — your AI assistant will load SAD context automatically every session.

If you didn't, you can wire it in now:

- **Claude Code:** Re-run the installer with `--persistent` or hand-add the `SessionStart` hook from [`adapters/claude-code/settings.json`](adapters/claude-code/settings.json) into your `.claude/settings.json`.
- **Cursor:** Re-run the installer with `--persistent` or set `alwaysApply: true` in the frontmatter of [`adapters/cursor/sad-routing.mdc`](adapters/cursor/sad-routing.mdc).
- **Aider, Codex, Windsurf:** The adapter pack already writes their always-loaded conventions file at install time; nothing extra needed.

That is what "persistent" means in SAD: your AI assistant rehydrates the constitution, the three-tier rules, and the current lifecycle stage at the start of every chat without you re-pasting them.

**SAD does NOT run as a long-lived background daemon.** It is Markdown-first and portable. The AI assistant *is* the daemon — and with `/sad-next`, it actively conducts. Every persistent session now also prints a one-line `SAD next step: /sad-X` nudge at startup (sourced from `.sad/scripts/next-step.{sh,ps1}`), so you never have to ask "where was I?" See [`DAEMON.md`](DAEMON.md) for the full rationale and the one narrow case where a file-watcher does help.

If you want cadence work (drift scans, compound refresh, eval evolution) to run on a schedule too, re-run the installer with `--schedule` / `-Schedule`. It registers cron entries (POSIX) or Task Scheduler tasks (Windows) via `scripts/sad-schedule.{sh,ps1}` — still no daemon, just the OS scheduler.

---

## 6. Confirm everything is healthy

```bash
# POSIX
./.sad/scripts/doctor.sh

# PowerShell
.\.sad\scripts\doctor.ps1
```

This is `/sad-doctor` — a 30-second health check. It reports green/yellow/red on:

- Constitution: filled? articles? maturity-level line present?
- Stakeholders: all three files have real names (or named placeholder roles)?
- Per feature in `specs/`: all six artifacts present? walkthrough approval boxes consistent with stage?
- Helper scripts: executable on this platform?

If you see all green, you have just completed a SAD feature loop. You are now operating at Level 0.

---

## Where to go next

| You want to … | Read |
|---|---|
| See SAD on one screen | [`CHEATSHEET.md`](CHEATSHEET.md) |
| Understand the why behind every primitive | [`MANIFESTO.md`](MANIFESTO.md) |
| Read every file in the kit | [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) §4 |
| Graduate from Level 0 to Level 1 | [`MATURITY.md`](MATURITY.md) |
| Bring SAD to an existing repo (brownfield) | [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) §10 |
| Compare to GitHub Spec Kit, Kiro, Tessl, Compound Engineering | [`ATTRIBUTION.md`](ATTRIBUTION.md) |
