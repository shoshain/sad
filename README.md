# SAD — Stakeholder-Anchored Development

> A composable, AI-native software engineering methodology with a three-tier domain-expert feedback loop at its core, built on the shoulders of giants.

**Website:** <https://sad.codes/>
**Repository:** <https://github.com/shoshain/sad>

SAD is an operational synthesis. Where a primitive is borrowed from a prior methodology, this repository names the source, links to it, and explains how it was adapted. Novel contributions are flagged explicitly in [`NOVEL.md`](NOVEL.md).

## Status

**v0.1 blueprint.** Artifacts are plain Markdown plus structured directories. Slash-command prompts live under [`commands/`](commands/). Agent personas live under [`agents/`](agents/). Adapt hook JSON under [`hooks/`](hooks/) to your agent product (Claude Code, Cursor, Codex, Kiro, Amazon Q).

## Where to start

**Want a 30-minute working tour?** Read [`QUICKSTART.md`](QUICKSTART.md). It installs SAD with one command, walks one toy feature end-to-end, and shows how to make SAD persistent in your AI assistant session.

**Want one page that explains the whole thing?** Read [`CHEATSHEET.md`](CHEATSHEET.md) — lifecycle diagram, command table, three-tier table, maturity ladder, common gotchas. No prose.

**Want the full depth?** Read [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) — a 1357-line walkthrough covering mental models, lifecycle, onboarding for greenfield and brownfield, and integrating SAD with existing toolchains.

| Document | Purpose |
| --- | --- |
| [`QUICKSTART.md`](QUICKSTART.md) | 30-minute tour: install → one feature → reconciliation → persistence |
| [`CHEATSHEET.md`](CHEATSHEET.md) | One-page visual summary of the lifecycle, tiers, and gotchas |
| [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) | In-depth user guide: mental models, lifecycle, onboarding, toolchain integration |
| [`MANIFESTO.md`](MANIFESTO.md) | Principles and federated stakeholder authority |
| [`LIFECYCLE.md`](LIFECYCLE.md) | The numbered loop, phase gates, reconciliation |
| [`ROLES.md`](ROLES.md) | Human tiers and agent personas |
| [`MATURITY.md`](MATURITY.md) | Six-level adoption ladder (Level 0 Solo SAD … Level 5) |
| [`DAEMON.md`](DAEMON.md) | Why SAD does **not** run as a daemon — and how `--persistent` works instead |
| [`ATTRIBUTION.md`](ATTRIBUTION.md) | Full provenance table |
| [`NOVEL.md`](NOVEL.md) | What SAD adds beyond its sources |
| [`GLOSSARY.md`](GLOSSARY.md) | Terminology |
| [`TELEMETRY.md`](TELEMETRY.md) | What `--telemetry on` does (writes a local file; no upload) |
| [`ROADMAP.md`](ROADMAP.md) | Gaps vs the website and the plan to close them |

## Repository layout

```
AGENTS.md       # how coding agents should navigate this methodology repo
QUICKSTART.md   # 30-minute first-feature walkthrough
CHEATSHEET.md   # one-page visual reference
DAEMON.md       # why SAD does not run as a daemon
.sad/           # constitution, lessons, stakeholders, rules, templates (incl. constitutions/ starter pack), scripts, state
commands/       # sad-* slash command specifications (including /sad-doctor)
agents/         # reviewers (incl. tier-stand-in-* for Level 0), walkthrough writers, reconciliation, research
hooks/          # phase and hook taxonomy (adapt to your toolchain)
adapters/       # turn-key per-assistant adapter packs (claude-code, cursor, aider, codex, windsurf)
scripts/        # sad-init.{sh,ps1} — one-command installer
evals/          # stakeholder / spec-conformance / impl-correctness skeleton + Node runner (run.mjs)
examples/       # worked example: 001-hello-feature
reference/      # optional reference-application MCP skeleton (legacy-context pattern)
brainstormer/   # AISCETA deep-research workspace (NOT /sad-brainstorm output)
.github/        # workflows: sad-doctor + sad-evals on PR
specs/          # (in your consuming project) per-feature artifacts — see LIFECYCLE.md
```

## Using this repo in a project

The fast path (recommended):

```bash
# POSIX
./scripts/sad-init.sh --persistent /path/to/your-project

# PowerShell
.\scripts\sad-init.ps1 -TargetDir C:\path\to\your-project -Persistent
```

The installer auto-detects your AI assistant (Claude Code, Cursor, Aider, Codex, Windsurf), copies the methodology files into your target project, writes the matching adapter pack from [`adapters/`](adapters/), and (with `--persistent`) wires SAD context to load at the start of every chat. Add `--minimal` for the lowest footprint; `--dry-run` to preview; `--help` for the full flag list.

If you prefer to do it by hand:

1. Copy or submodule this methodology into your codebase (or cherry-pick `.sad/`, `commands/`, `agents/`).
2. Run **`/sad-setup`** (see [`commands/sad-setup.md`](commands/sad-setup.md)) once to align structure and `AGENTS.md`.
3. Run **`/sad-constitution`** to produce `.sad/memory/constitution.md` and tier definitions. (Use a starter from [`.sad/templates/constitutions/`](.sad/templates/constitutions/) — web-app, library, cli, data-pipeline, ml-app, or regulated.)
4. For each feature under `specs/<feature-slug>/`, follow [`LIFECYCLE.md`](LIFECYCLE.md).

Health check at any time: [`/sad-doctor`](commands/sad-doctor.md) reports green/yellow/red on constitution, stakeholders, hooks, per-feature artifacts, and platform scripts.

Helper scripts: [`.sad/scripts/`](.sad/scripts/) — `.sh` (POSIX) and `.ps1` (Windows) siblings for every script.

## Example feature

See [`examples/001-hello-feature/`](examples/001-hello-feature/).

## License

MIT. Preserve attribution. See [`LICENSE`](LICENSE) and [`ATTRIBUTION.md`](ATTRIBUTION.md).

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Issues tagged **`attribution`** take precedence for provenance corrections.
