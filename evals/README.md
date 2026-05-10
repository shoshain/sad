# SAD eval harness (skeleton)

This directory mirrors patterns from [`vercel-labs/agent-eval`](https://github.com/vercel-labs/agent-eval) and Anthropic-style eval discipline. **Wire your own runner** (TypeScript, Python, or CI) — files here are templates.

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
