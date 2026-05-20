<!-- starter:library v1 -->
# Project Constitution — Library / SDK / framework starter

> For projects whose primary user is another developer pulling your code as a dependency. Public-API stability is the load-bearing concern.

## Identity

- **Project name:** [name]
- **Primary users:** other developers consuming this library
- **Risk class:** low (your bugs become their bugs)
- **Maturity level (initial):** Level 0 (solo) or Level 1 (small team)
- **AI tier stand-ins active:** none

## Immutable Principles

1. **Semantic versioning is contract.** Major = breaking; minor = additive; patch = behaviour-preserving. Violations get yanked, not patched.
2. **Public API is everything exported from the package entry point.** Anything else is implementation detail and may change without notice.
3. **Deprecation has a fixed clock.** Deprecated APIs ship one minor version with a runtime warning, then are removed in the next major. No silent removals.
4. **Backward compatibility is preserved through one major version.** Users on `N-1` get security patches; older versions are EOL.
5. **No telemetry in the library.** Observability instrumentation is the consumer's call, never the library's.

## Architecture Boundaries

- **Allowed:** zero or near-zero runtime dependencies; one optional peer dependency per "extension point".
- **Requires ADR:** any new runtime dependency; any change to the public API surface; any change to the supported runtime / language versions.
- **Forbidden:** post-install scripts; network calls at import time; reading environment variables outside an explicit `init()` call; global state.

## Evidence of Done

- **Non-technical tier:** README example renders end-to-end; a "before / after" code snippet in the walkthrough shows the user-facing improvement.
- **Semi-technical tier:** Public API diff table in the plan; semver impact (major/minor/patch) explicitly stated and justified.
- **Technical tier:** Type-checker clean; tests on the matrix of supported runtimes; benchmark micro-suite shows no > 5% regression on the hot paths; API extraction tool (e.g. `api-extractor`, `rustdoc --output-format json`) shows no unintended new exports.

## Stakeholder Approval

Constitution amendments require: maintainer + (for any change touching A1–A3) one outside contributor who has shipped a non-trivial PR in the last 90 days.

## Article Index (for `architectural-conformance` rubric)

| ID | Title |
|----|--------|
| A1 | Semantic versioning policy |
| A2 | Public API surface definition |
| A3 | Deprecation lifecycle |
| A4 | Runtime / language version support window |
| A5 | Dependency policy (zero-dep preference) |
| A6 | Performance regression budget |
| A7 | Documentation completeness (every public symbol has a doc-string) |

## Tensions to resolve

- **Stability vs ergonomics.** A more ergonomic API often requires a breaking change. When the next major version is six months away, what is the policy for "we know this API is wrong but it works"?
- **Zero-dep purism vs reinventing wheels.** Where is the line — a 100-line utility, a 1000-line one, a battle-tested third-party library?
- **Type-system strictness vs adoption.** Strict types catch more bugs; permissive types onboard more users. Pick a position.
