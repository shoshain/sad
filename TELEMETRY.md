# Telemetry

> Short answer: SAD does **not** phone home. The `--telemetry on` flag on the installer writes a single local file and nothing else.

## What `--telemetry on` does today

When you run the installer with `--telemetry on`, SAD writes one file:

```text
<target>/.sad/state/telemetry.json
```

The contents are exactly:

```json
{"telemetry": "opt-in", "installed": "2026-05-21T12:34:56Z"}
```

That file is created locally inside your repo. **Nothing is uploaded anywhere.** No URL is contacted; no analytics service is wired in. The flag exists today as a forward-compatible opt-in marker: if SAD ever ships a real telemetry endpoint, only repos that have already set `--telemetry on` would participate, and the endpoint addition would arrive via a documented breaking-change notice.

## What `--telemetry off` (the default) does

Nothing. No file is written, no flag is set, and there is no implicit opt-in elsewhere.

## What this file tracks

This document is the canonical promise. If the behavior changes, the change happens **here first** and in `scripts/sad-init.{sh,ps1}` second. The promise above (no upload) is auditable in those two scripts — the only code that touches the telemetry file lives in `Apply-Adapter` / `apply_adapter`.

## What you should do

- If you do not want a telemetry file in your repo, omit the flag (it is off by default) or delete `.sad/state/telemetry.json` after installing.
- If you would like to participate in future telemetry, run with `--telemetry on`. You will be no worse off than today; you will simply be opted in to whatever the future endpoint surface looks like, with the announcement that introduces it.

## Removing telemetry

```bash
rm .sad/state/telemetry.json
```

The next installer run will not recreate the file unless you pass `--telemetry on` again.
