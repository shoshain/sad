# Does SAD need to run as a daemon?

**Short answer: no — and the question's framing reveals something more useful than the answer.**

This page exists because it is a *natural* question to ask. SAD has 14 numbered lifecycle steps, four background-maintenance commands (`/sad-spec-drift-scan`, `/sad-compound-refresh`, `/sad-evolve-evals`, `/sad-requirements-progress`), and a `.sad/state/sad-state.md` file that tracks the current feature and phase. "If you already have state, scheduled tasks, and per-feature directories, why not run it as a daemon?"

## §0. The reframe: the assistant is an *active* conductor, not a passive context loader

The original framing — "the AI coding assistant *is* the daemon" — was correct but understated what the assistant should *do*. Two ergonomic pieces close the gap without introducing a real daemon:

1. **`/sad-next`** (see [`commands/sad-next.md`](commands/sad-next.md)) — the conductor command. The user invokes one command instead of remembering the 14-step chain. `/sad-next` reads `.sad/state/sad-state.md`, dispatches the next non-human phase, updates state, and stops at the next human gate with an inline approval prompt. Internally it relies on [`.sad/scripts/next-step.{sh,ps1}`](.sad/scripts/) — a pure read-only state inspector that maps the `Phase:` enum to the next slash command.
2. **`sad-init --persistent` extended SessionStart hook** — at the start of every chat, the hook prints the constitution head plus a one-line `SAD next step: /sad-X` nudge from the same state inspector. The user no longer has to ask "where was I?"

Both pieces are in-process. No new processes; no file watcher; nothing that survives the assistant session. The conductor stops at every human gate — Level 0 included — and the assistant must never tick approval checkboxes on the user's behalf.

The four-interpretation table below is unchanged; the conductor lives in (c).

The honest answer requires distinguishing four things people mean by "daemon":

| Interpretation | Should SAD do this? | Why |
|---|---|---|
| (a) Long-lived background process that watches files and reacts | **No** | See §1 |
| (b) Scheduled cron-style tasks that run on a cadence (daily drift scan, monthly compound-refresh) | **Yes, but as `cron` / CI jobs, not a SAD-owned daemon** | See §2 |
| (c) Per-session persistence in the AI coding assistant | **Yes — this is what `--persistent` already does** | See §3 |
| (d) Optional file-watcher for tight feedback loops during a session | **Yes, as an opt-in dev-mode utility, not the default** | See §4 |

---

## §1. Why SAD should not run as a long-lived daemon

### Markdown-first portability is a load-bearing promise

SAD's `README.md` status block says: *"Artifacts are plain Markdown plus structured directories."* A daemon — a long-lived process the user must install, configure, start, monitor, and update — directly contradicts that promise. Adopters who pick SAD because it is "just Markdown" would lose the property that made it pickable.

### The methodology has no continuous work to do

Look at what a hypothetical SAD daemon would actually do:

- **Validate that walkthrough approvals are checked before tasks.md is written?** That is what the `stakeholder-tier-router` hook already does, exactly at the moment the write is attempted. A daemon would just race the hook.
- **Run the reviewer fleet whenever code changes?** The reviewer fleet runs at `/sad-review` time. Running it on every save burns the user's AI-assistant budget for no marginal benefit; the review is supposed to be batched at PR boundaries.
- **Watch for spec drift?** `/sad-spec-drift-scan` is explicitly designed as a *scheduled batch* (LIFECYCLE.md "BACKGROUND (scheduled)"). Drift is a long-cycle phenomenon — running the detector continuously misclassifies normal mid-feature changes as drift.
- **Re-emit the constitution into AI context?** That is what the `--persistent` SessionStart hook does — at session start, not continuously.

There is no work that requires a process to be alive when no human is editing the repo.

### Daemons add an operational class SAD's audience does not want

Solo developers and OSS maintainers — the population [`MATURITY.md` Level 0](MATURITY.md#level-0-solo-sad) and [`QUICKSTART.md`](QUICKSTART.md) optimize for — explicitly do not want another long-lived process to manage. A daemon means: starting it, surviving reboots, choosing a process supervisor, logging to somewhere, rotating those logs, upgrading the binary, debugging when it hangs. None of that is what a methodology-adopter signed up for.

### The AI coding assistant *is* the daemon

This is the central observation. In 2024–2026, every adopter of SAD already has a long-lived AI assistant process — Claude Code, Cursor, Aider, Windsurf, Codex — running for hours at a time, watching files, reading context, executing commands, receiving keystrokes. That process is, functionally, the daemon SAD would otherwise need to be.

The right design choice is to put SAD's continuous responsibilities **inside the assistant's session**, via:

- A `SessionStart` hook (Claude Code) or `alwaysApply: true` rule (Cursor) that loads the constitution + the four core rules + the current state file at every chat start.
- The skill in `.claude/skills/sad/SKILL.md` that auto-activates when the user mentions SAD concepts.
- Always-loaded routing files (`AGENTS.md`, `CONVENTIONS.md`, `.windsurf/rules/sad-routing.md`) that the assistant sees on every session by default.

That is what `sad-init --persistent` wires up. It is the closest thing SAD will ever have to a daemon, and it costs zero new processes.

---

## §2. The cron-style cadence cases

Three SAD commands are explicitly *scheduled* per `LIFECYCLE.md`:

- `/sad-spec-drift-scan` — daily or weekly
- `/sad-compound-refresh` — monthly
- `/sad-evolve-evals` — after incidents or repeated reviewer findings

These need to run on a cadence, but **they do not need a SAD-owned daemon to run them.** The right home for cadence work is:

- **`cron` / Task Scheduler / launchd** on a developer machine for solo / small-team setups.
- **GitHub Actions / GitLab CI scheduled workflows** for teams (see `SAD_USER_GUIDE.md §14.3` and the worked CI templates that I-006 / I-001 unlock).
- **The team's existing observability cadence** (weekly ops review, sprint retrospective) for the human-side of compound-refresh.

A SAD-shipped CI workflow template — `.github/workflows/sad-checks.yml.example` — is a natural ship target for the next minor release of the kit. It runs `/sad-doctor` on every push and the three scheduled commands at their stated cadences. That is the *right* shape of "scheduled SAD" — pinned to existing infrastructure the team already operates.

### `sad-init --schedule` / `-Schedule`

For developer machines, the kit now ships [`scripts/sad-schedule.sh`](scripts/sad-schedule.sh) (cron) and [`scripts/sad-schedule.ps1`](scripts/sad-schedule.ps1) (Windows Task Scheduler). They are invoked automatically when `sad-init` is run with `--schedule` / `-Schedule`, or you can run them standalone:

```bash
# POSIX
./scripts/sad-schedule.sh install   /path/to/project
./scripts/sad-schedule.sh uninstall /path/to/project
./scripts/sad-schedule.sh list      /path/to/project

# Windows
.\scripts\sad-schedule.ps1 -Action install   -TargetDir C:\path\to\project
.\scripts\sad-schedule.ps1 -Action uninstall -TargetDir C:\path\to\project
.\scripts\sad-schedule.ps1 -Action list      -TargetDir C:\path\to\project
```

What it installs:

| Cadence command | Runs | What the scheduled job actually does |
|---|---|---|
| `/sad-spec-drift-scan` | daily 09:00 | Executes `.sad/scripts/drift-scan.{sh,ps1}` unattended; appends findings to `.sad/state/scheduled-reminders.log` |
| `/sad-compound-refresh` | monthly | Writes a reminder line to `.sad/state/scheduled-reminders.log` — the actual work happens *inside* the next AI assistant session when the human invokes the slash command |
| `/sad-evolve-evals` | weekly Monday | Same pattern as compound-refresh — a scheduled reminder, not a substitute for the in-session command |

Why the latter two are reminders rather than full executions: curating lessons and evolving evals requires the AI assistant's reasoning loop, which the OS scheduler cannot host. The right shape is a nudge that the user picks up on their next session. This preserves the "no long-lived SAD process" promise — the cron/Task-Scheduler entries are owned by the OS and can be removed with `sad-schedule uninstall`.

---

## §3. The session-persistence case (already implemented)

When the user runs:

```bash
./scripts/sad-init.sh --persistent /path/to/project
# or
.\scripts\sad-init.ps1 -TargetDir C:\path\to\project -Persistent
```

…the installer wires the matching adapter to load SAD context at the start of every AI-assistant session:

| Assistant | Persistence mechanism |
|---|---|
| Claude Code | `SessionStart` hook in `.claude/settings.json` (variant `settings.persistent.json`) — runs `cat AGENTS.md .sad/rules/core/README.md .sad/state/sad-state.md` and head of the constitution on every session start |
| Cursor | `.cursor/rules/sad-routing.mdc` with `alwaysApply: true` (variant `sad-routing.persistent.mdc`) — Cursor auto-injects this rule into every chat and agent session |
| Aider | `CONVENTIONS.md` at repo root — Aider auto-loads this on every chat (persistence is the default; `--persistent` is a no-op for Aider) |
| Codex | `AGENTS.md` at repo root — Codex auto-loads this (persistence is the default; `--persistent` is a no-op for Codex) |
| Windsurf | `.windsurf/rules/sad-routing.md` — Windsurf auto-loads files under `.windsurf/rules/` (persistence is the default; `--persistent` is a no-op for Windsurf) |

This is what people *actually want* when they say "make SAD persistent in my Claude Code session" or "in my Cursor chat." They want SAD context to rehydrate without re-pasting. The session-start hook gives them exactly that, on the existing process, without introducing a new one.

**As of the conductor release**, the SessionStart hook also runs [`.sad/scripts/next-step.{sh,ps1}`](.sad/scripts/) and prints one extra line — `SAD next step: /sad-X` — so the user starts every session knowing exactly which slash command (or `/sad-next`) to invoke. See §0 above.

---

## §4. The one narrow case where a file-watcher does help

There is one — exactly one — scenario where running a long-lived watcher genuinely helps, and even that should be opt-in:

**Tight-loop development inside a single session.** When the user is mid-feature, repeatedly editing `feature.spec.md` and code in alternation, they might want `/sad-doctor` to re-run automatically and surface red findings as they emerge. A file-watcher on `specs/<active>/**/*.md` + the constitution that runs `/sad-doctor --json --quiet` on change and surfaces only delta findings to the chat is a reasonable opt-in.

This is **not** a daemon. It is:

- Per-session (lives as long as the assistant session does, not longer).
- Opt-in (off by default; enabled via `sad-init --dev-watch` or a `/sad-watch` slash command).
- Bounded (watches one feature directory, not the whole repo).
- Reads only — surfaces findings, never modifies state.

The MVP shape is a 50-line Node or PowerShell script that wraps `chokidar` / `Register-ObjectEvent` and `/sad-doctor --json`. We have not built it yet — it is **idea I-006 extended**, deferred until adopter feedback says the session-start hook is insufficient.

If you want this today, you can hand-roll it:

```bash
# POSIX (requires entr)
ls specs/<active>/**/*.md .sad/memory/constitution.md | entr -c .sad/scripts/doctor.sh
```

```powershell
# PowerShell (built-in)
$watcher = New-Object System.IO.FileSystemWatcher 'specs\<active>', '*.md'
$watcher.EnableRaisingEvents = $true
Register-ObjectEvent $watcher Changed -Action { & .\.sad\scripts\doctor.ps1 } | Out-Null
```

---

## Decision summary

| Question | Answer |
|---|---|
| Does SAD ship a long-lived daemon? | No. |
| Does SAD have continuous responsibilities? | No — work happens at session boundaries, command invocations, and scheduled cadences. |
| How does SAD persist in an AI session? | Via assistant-native mechanisms — SessionStart hooks (Claude Code), `alwaysApply: true` rules (Cursor), auto-loaded conventions (Aider, Codex, Windsurf). The `sad-init --persistent` flag wires whichever applies; the hook also prints the next-step nudge. |
| How do I avoid remembering 14 commands in order? | Invoke **`/sad-next`** (the conductor). It reads state, runs the next non-human phase, and stops at the next human gate with an inline approval prompt. See §0. |
| How do scheduled tasks run? | `cron` / Task Scheduler / launchd / CI scheduled workflows — owned by the user's existing infrastructure, not by SAD. `sad-init --schedule` wires the OS scheduler for you via [`scripts/sad-schedule.{sh,ps1}`](scripts/). |
| Is there a file-watcher mode? | Optional dev-mode utility, opt-in, per-session-scoped — not yet shipped; hand-rolled snippet provided above. |

**The principle that resolves every case:** *The AI coding assistant is the daemon SAD would otherwise need to be — and `/sad-next` is how it actively conducts.* Every continuous responsibility lives inside the assistant session via SessionStart hooks, always-loaded rules, and the conductor. Every periodic responsibility lives inside the user's existing scheduler. SAD itself stays Markdown.

---

## See also

- [`commands/sad-next.md`](commands/sad-next.md) — the conductor command.
- [`.sad/scripts/next-step.sh`](.sad/scripts/next-step.sh) / [`next-step.ps1`](.sad/scripts/next-step.ps1) — read-only state inspector used by the conductor and SessionStart hook.
- [`scripts/sad-schedule.sh`](scripts/sad-schedule.sh) / [`sad-schedule.ps1`](scripts/sad-schedule.ps1) — install/uninstall OS-level cron / Task Scheduler entries for the cadence commands.
- [`MATURITY.md`](MATURITY.md) — Level 0 (Solo SAD), where this lightweight stance matters most.
- [`adapters/`](adapters/) — per-assistant adapter packs that implement session persistence.
- [`scripts/sad-init.sh`](scripts/sad-init.sh) / [`sad-init.ps1`](scripts/sad-init.ps1) — the installer with `--persistent` and `--schedule`.
- [`LIFECYCLE.md`](LIFECYCLE.md) "BACKGROUND (scheduled)" — the three commands that benefit from cadence.
