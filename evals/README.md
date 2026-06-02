# SAD eval harness

Patterns from [`vercel-labs/agent-eval`](https://github.com/vercel-labs/agent-eval) plus Anthropic-style eval discipline.

A minimal Node-based runner ships in [`run.mjs`](run.mjs); requires Node 22+ (uses `--experimental-strip-types` so it can load `EVAL.ts` directly with no third-party dependencies). Replace with vitest / jest / pytest in a real project; the file conventions below are what stays the same.

## Run

```bash
# from repo root
node --experimental-strip-types evals/run.mjs            # green/yellow/red text
node --experimental-strip-types evals/run.mjs --json     # structured JSON
node --experimental-strip-types evals/run.mjs --verbose  # show per-case detail
# exit 0 = all pass (stubs OK); exit 1 = any fail or error
```

Or via the package script:

```bash
cd evals && npm run eval
```

## Suites

| Directory | Purpose |
| --- | --- |
| `stakeholder/` | Tier-specific quality (narrative clarity, jargon violations, EARS coverage evidence) |
| `spec-conformance/` | Contracts, capabilities, acceptance criteria vs artifacts |
| `impl-correctness/` | Behavioral correctness (often hidden tests) |
| `architectural-conformance/` | SME calibration snippets for the architectural reviewer |

## Conventions

- Each case folder may include `PROMPT.md` (agent input), `ground-truth.json` (labels), and `EVAL.*` (grader script) once you pick a stack.
- Keep **hidden** evaluation assets out of agent context during generation (agent-eval pattern).

## CI gate (example policy)

Configure per `MATURITY.md`. Example:

- Stakeholder pass-rate ≥ target
- Spec-conformance critical cases = 100%
- Impl-correctness ≥ target

## Evolving evals

Use `/sad-evolve-evals` (`commands/sad-evolve-evals.md`) after incidents or repeated reviewer findings.
