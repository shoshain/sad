# Contracts templates

> Templates copied into `specs/<feature>/contracts/` by `/sad-plan`. One contract per file.
>
> This README itself is **not** copied — it documents the convention.

`/sad-plan` populates `specs/<feature>/contracts/`. `/sad-walkthrough` (semi-technical tier) reads from it. `/sad-reconcile` diffs the implemented contract against the file before merge.

## Files in this directory

- [`example.md`](example.md) — minimal HTTP endpoint contract. Copy it, rename to the contract identifier (e.g. `POST_me_greeting.md`), and fill in.

## Conventions

- One file per contract. Filename uses underscores so it works on every filesystem.
- Each file's frontmatter holds the **backward-compatibility verdict** (`additive` / `mutating` / `breaking`) so the reconciler can read it without parsing prose.
- If a contract was removed, set `status: removed` in the frontmatter with a one-line tombstone — do not delete history.
