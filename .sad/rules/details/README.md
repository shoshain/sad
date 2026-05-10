# Detailed Rules (Conditional)

> Load these when working in matching contexts (Kiro `auto:glob` / manual inclusion pattern). One topic per file.

## How to add a detail rule

1. Create `SAD-DT-<topic>.md` in this folder.
2. In your agent harness, map globs or manual `@` references so implementers load the right details (e.g. `**/api/**` loads API design rules).

### Example stub

File: `SAD-DT-api-design.md` (create when your project needs it)

```markdown
# API design details
- Errors are problem+json.
- Breaking changes require version bump and contract folder update.
```
