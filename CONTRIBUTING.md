# Contributing to SAD

Thank you for helping improve Stakeholder-Anchored Development.

## Principles

- **Provenance matters.** If you add a primitive, document it in [`ATTRIBUTION.md`](ATTRIBUTION.md). If it is novel to SAD, summarize it in [`NOVEL.md`](NOVEL.md).
- **Plain Markdown first.** Prefer portable artifacts over vendor-specific formats unless clearly isolated under `hooks/` or `evals/`.
- **Small, reviewable changes.** One logical change per pull request when possible.

## Reporting issues

- Use **`attribution`** when crediting or licensing for a cited source is wrong or incomplete.
- Describe your toolchain (Claude Code, Cursor, etc.) when reporting hook or command integration bugs.

## Development workflow

1. Fork the repository.
2. Create a branch for your change.
3. Enable repo git hooks (strips Cursor `Co-authored-by` trailers):

   ```bash
   git config core.hooksPath .githooks
   ```

4. If you use **Cursor**, turn off commit co-author attribution in Cursor settings
   (so `Co-authored-by: Cursor <cursoragent@cursor.com>` is never injected).
5. Update relevant docs and, if applicable, [`GLOSSARY.md`](GLOSSARY.md).
6. Open a pull request with a clear summary of what changed and why.

## Code of conduct

Be constructive and specific. Disagreement about methodology is expected; personal attacks are not.
