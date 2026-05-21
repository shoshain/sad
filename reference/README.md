# Reference application (optional)

> Source: ThoughtWorks Tech Radar Vol. 33 — "reference application" pattern. See [ATTRIBUTION.md](../ATTRIBUTION.md).
>
> **Optional.** SAD does not require this. Add a reference application to your repo when (a) you maintain a legacy codebase with multiple stakeholders who need a working golden path to compare against, or (b) you ship an SDK / library and want to give consumers a canonical example to clone.

## What goes here

A small, working application that exercises every contract your real codebase exposes. Stakeholders point at it during walkthroughs ("the new endpoint should behave like the reference") and `/sad-reconcile` can diff against it instead of the spec text alone.

## What ships in this skeleton

- [`example-server/`](example-server/) — a minimal Node-free, dependency-free reference MCP server that responds to one tool. Use it as the shape, not the implementation.

## What does NOT go here

- Tests of the real code (those live next to the real code).
- Documentation of contracts (those live in `specs/<feature>/contracts/`).
- Stakeholder narratives (those live in `specs/<feature>/walkthroughs/`).

## How `/sad-reconcile` uses this directory (when present)

If `reference/example-server/` is present, the reconciler compares the contract files in `specs/<feature>/contracts/` against the reference server's responses. Discrepancies are flagged as either `spec-update` (reference is right, spec is wrong) or `code-update` (spec is right, reference drifted) — same verdict vocabulary as feature reconciliation.

A consumer-project reference application is **not** the example feature in [`examples/`](../examples/) — that one ships with SAD. This one ships with **your** project.
