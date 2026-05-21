# brainstormer/ — AISCETA deep-research artifacts

> **Not** the output of [`/sad-brainstorm`](../commands/sad-brainstorm.md).
>
> `/sad-brainstorm` is a per-feature interactive Q&A that produces `specs/<slug>/requirements.draft.md`. This directory is a separate workspace for the AISCETA deep-research skill (driven by [`deep_research_prompt.json`](../deep_research_prompt.json)) — multi-phase research reports about SAD itself.

## Layout

- `runs/` — one folder per research run; intermediate artifacts (plan, audit log, subagent transcripts, failures).
- `reports/` — final synthesized reports plus a top-level `index.md`.

## When this directory matters

- Methodology authors evolving SAD use it to brainstorm and record research for repo-level changes (new commands, new lineage sources, accessibility passes, etc.).
- Consumers of SAD installing it into their projects can safely ignore the contents.

The installer does **not** copy this directory to consumer projects.
