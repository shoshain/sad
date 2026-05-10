# SAD — Stakeholder-Anchored Development

> A composable, AI-native software engineering methodology with a three-tier domain-expert feedback loop at its core, built on the shoulders of giants.

SAD is an operational synthesis. Where a primitive is borrowed from a prior methodology, this repository names the source, links to it, and explains how it was adapted. Novel contributions are flagged explicitly in [`NOVEL.md`](NOVEL.md).

## Status

**v0.1 blueprint.** Artifacts are plain Markdown plus structured directories. Slash-command prompts live under [`commands/`](commands/). Agent personas live under [`agents/`](agents/). Adapt hook JSON under [`hooks/`](hooks/) to your agent product (Claude Code, Cursor, Codex, Kiro, Amazon Q).

## Where to start

**New to SAD?** Read [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) — a complete, self-contained walkthrough that covers everything below in beginner-friendly form, plus step-by-step onboarding for new and existing projects.

| Document | Purpose |
| --- | --- |
| [`SAD_USER_GUIDE.md`](SAD_USER_GUIDE.md) | In-depth user guide: mental models, lifecycle, onboarding for greenfield and brownfield, integrating SAD with existing toolchains and rule systems |
| [`MANIFESTO.md`](MANIFESTO.md) | Principles and federated stakeholder authority |
| [`LIFECYCLE.md`](LIFECYCLE.md) | The numbered loop, phase gates, reconciliation |
| [`ROLES.md`](ROLES.md) | Human tiers and agent personas |
| [`MATURITY.md`](MATURITY.md) | Five-level adoption ladder |
| [`ATTRIBUTION.md`](ATTRIBUTION.md) | Full provenance table |
| [`NOVEL.md`](NOVEL.md) | What SAD adds beyond its sources |
| [`GLOSSARY.md`](GLOSSARY.md) | Terminology |

## Repository layout

```
AGENTS.md       # how coding agents should navigate this methodology repo
.sad/           # constitution, lessons, stakeholders, rules, templates, scripts, state
commands/       # sad-* slash command specifications
agents/         # reviewers, walkthrough writers, reconciliation, research
hooks/          # phase and hook taxonomy (adapt to your toolchain)
evals/          # stakeholder / spec-conformance / impl-correctness skeleton
examples/       # worked example: 001-hello-feature
specs/          # (in your consuming project) per-feature artifacts — see LIFECYCLE.md
```

## Using this repo in a project

1. Copy or submodule this methodology into your codebase (or cherry-pick `.sad/`, `commands/`, `agents/`).
2. Run **`/sad-setup`** (see [`commands/sad-setup.md`](commands/sad-setup.md)) once to align structure and `AGENTS.md`.
3. Run **`/sad-constitution`** to produce `.sad/memory/constitution.md` and tier definitions.
4. For each feature under `specs/<feature-slug>/`, follow [`LIFECYCLE.md`](LIFECYCLE.md).

Helper scripts: [`.sad/scripts/`](.sad/scripts/).

## Example feature

See [`examples/001-hello-feature/`](examples/001-hello-feature/).

## License

MIT. Preserve attribution. See [`LICENSE`](LICENSE) and [`ATTRIBUTION.md`](ATTRIBUTION.md).

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Issues tagged **`attribution`** take precedence for provenance corrections.
