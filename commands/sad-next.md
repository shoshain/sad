---
description: SAD conductor — run the next non-human phase, pause at human gates with inline approval prompts. The single command that drives the whole lifecycle.
phase: conductor
inputs:
  - .sad/state/sad-state.md
  - .sad/memory/constitution.md
  - specs/<active>/ (when a feature is in flight)
outputs:
  - whatever the dispatched phase command produces (spec, plan, walkthroughs, tasks, code, reconciliation, lessons)
  - updated .sad/state/sad-state.md
flags:
  - --dry-run       resolve the next step and print it; do not invoke the phase command
  - --feature <slug> override the active feature (otherwise read from state)
  - --max-steps N   advance up to N consecutive non-human steps before stopping (default: 1)
gate: stops at walkthrough and reconcile gates; human-only to advance past them
---

You are running **`/sad-next`** — the SAD conductor.

## What `/sad-next` is

The conductor turns the 14-step lifecycle into a single command. It reads state, decides which phase comes next, dispatches the matching `/sad-<verb>` command, updates state, and either advances or stops at the next human gate. The user invokes `/sad-next` repeatedly (or with `--max-steps`) instead of remembering which slash command comes next.

This is the operational expression of `DAEMON.md`'s "the assistant *is* the daemon" — the assistant is now an *active* conductor, not just a passive context loader. No new processes; no file watcher; nothing that survives the session.

## Your task

### Step 1 — Resolve the next step

Run the bundled inspector:

- POSIX: `./.sad/scripts/next-step.sh --json`
- PowerShell: `.\.sad\scripts\next-step.ps1 -Json`

Parse the JSON. The fields are `kind` (`run` / `gate` / `setup` / `done`), `next` (the slash command or gate name), `slug` (the active feature), `reason` (one-line context), `exit` (numeric code).

If your environment lacks the script (e.g. partial install), perform the equivalent by reading `.sad/state/sad-state.md` directly and matching the `Phase:` value against the enum in that file.

### Step 2 — Act on `kind`

| `kind` | What you do |
|---|---|
| `setup` | The project isn't ready. Print the `next` command and a one-line reason. Do **not** run it automatically — `/sad-setup` and `/sad-constitution` need human authorship of identity, principles, and tiers. Stop. |
| `run` | Read `commands/<next>.md`. Follow its `Your task` / `Discipline` sections exactly to produce that phase's artifact. Then update state (see Step 3). If `--max-steps > 1`, loop and resolve the next step again. |
| `gate` | **Stop.** Surface the inline gate prompt (see "Gate UX" below). Do not auto-approve. Do not advance. |
| `done` | The feature is complete. Acknowledge, suggest `Phase: none` for the next feature, and stop. |

If `--dry-run` is set, print the resolved next step and stop without invoking anything.

### Step 3 — Update state after each phase

After every successfully dispatched phase command, advance `.sad/state/sad-state.md`:

- POSIX: `./.sad/scripts/update-state.sh --phase <new-phase> --last-command <slash-command>`
- PowerShell: `.\.sad\scripts\update-state.ps1 -Phase <new-phase> -LastCommand <slash-command>`

Use the enum from `.sad/state/sad-state.md` (the "Phase enum" table). Map the command you just ran to the phase value it produces — e.g. running `/sad-plan` produces `Phase: plan`, running `/sad-walkthrough` produces `Phase: walkthrough` (which is then gated).

### Step 4 — Loop or stop

If `--max-steps > 1` and the just-finished phase didn't end at a gate, re-run `next-step` and continue. Otherwise, print a one-line summary and stop. The user will invoke `/sad-next` again when they're ready.

## Gate UX (inline chat prompts)

When `kind == "gate"` (`walkthrough` or `reconcile`), do **not** invoke any phase command. Instead, print a focused block:

### For `walkthrough` gate

```
SAD walkthrough gate — feature <slug>

Three tier approvals are required before /sad-analyze can run.

  Non-technical reviewer
    Artifact: specs/<slug>/walkthroughs/non-technical.md
    Summary:  <one paragraph from the file's "what this feature does" section>
    Approve? [yes | changes | no]

  Semi-technical reviewer
    Artifact: specs/<slug>/walkthroughs/semi-technical.md
    Summary:  <one paragraph covering plan + contract changes>
    Approve? [yes | changes | no]

  Technical reviewer
    Artifact: specs/<slug>/walkthroughs/technical.md
    Summary:  <one paragraph covering PR-level scope + eval notes>
    Approve? [yes | changes | no]
```

For each tier the user marks `yes`:

1. Tick the matching approval checkbox in `walkthroughs/<tier>.md`. The line shape is `- [ ] <Tier-name> reviewer approval` → `- [x] <Tier-name> reviewer approval`. The exact line your edit must produce is the one that `.sad/scripts/check-tier-approvals.{sh,ps1}` recognizes (case-insensitive match on `^- *\[x\].*<tier>.*reviewer`).
2. Run `check-tier-approvals.{sh,ps1}` on `specs/<slug>/` to confirm. If all three pass, update state to `walkthrough-approved` and (only if the user said so) re-invoke `/sad-next` to continue.

For `changes`, prompt the user for the requested change, record it under "Recent decisions" in the state file, and stop. The user fixes the artifact and re-invokes `/sad-next` later.

For `no`, route back to the appropriate earlier phase per `LIFECYCLE.md §"Tier-Routed Approval Gate"`:

- Non-technical rejects → `/sad-clarify` (set `Phase: specify`)
- Semi-technical rejects → `/sad-plan` (set `Phase: impact-forecast`)
- Technical rejects → `/sad-plan` with a technical-feedback annotation (same phase reset)

### For `reconcile` gate

```
SAD reconcile gate — feature <slug>

The reconciliation verdicts in specs/<slug>/reconciliation.md need
semi-technical sign-off before /sad-compound can run.

Verdict rows:
  <row 1: spec-update | code-update | both-update — one-line rationale>
  <row 2 …>

Approve all verdicts? [yes | revise | no]
```

On `yes`: tick the semi-technical approval line in `reconciliation.md`, set `Phase: reconcile-approved`. On `revise` or `no`: record the requested change and stop.

## Discipline

- **Never approve on behalf of a human, even at Level 0.** Maturity Level 0 lets *one human* tick all three boxes; it does not let the assistant tick any. Approval is a literal human keystroke.
- **One phase per `/sad-next` invocation by default.** `--max-steps > 1` is opt-in and must still stop at the first gate.
- **State is the source of truth.** If the state file disagrees with what is on disk (e.g. `Phase: plan` but no `feature.plan.md` exists), stop and surface the discrepancy. Suggest `/sad-doctor`. Do not "fix" the state silently.
- **Read the canonical prompt before dispatching.** Open `commands/<next>.md` and follow its discipline — do not improvise the phase from the conductor's mental model.
- **Use sub-agents where the phase command says to.** `/sad-walkthrough` and `/sad-implement` already specify sub-agent dispatch. The conductor inherits that, it does not override it.
- **No file watcher, no daemon.** The conductor lives only inside the assistant session that invoked it.

## Output

After each invocation, end with one line:

```
[sad-next] <phase> -> <slash-command run> -> next: <whatever next-step.sh now reports>
```

If you hit a gate, end with:

```
[sad-next] STOPPED at <gate-name> gate for feature <slug>. Re-run /sad-next after the approvals are recorded.
```

## See also

- `LIFECYCLE.md` — the canonical 14-step loop and gate routing.
- `DAEMON.md` — why the conductor is a command, not a process.
- `MATURITY.md` Level 0 — the one-human-three-tier-boxes rule.
- `.sad/scripts/next-step.{sh,ps1}` — the state inspector this command wraps.
- `.sad/scripts/check-tier-approvals.{sh,ps1}` — the canonical approval-checkbox verifier.
