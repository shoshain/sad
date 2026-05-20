<!-- starter:cli v1 -->
# Project Constitution — Command-line tool starter

> For projects whose primary surface is a `$ your-tool` invocation. The Unix philosophy and good exit-code hygiene are the load-bearing concerns.

## Identity

- **Project name:** [name]
- **Primary users:** developers and operators running this tool interactively or in scripts
- **Risk class:** low (composable into pipelines) / medium (if the tool writes to remote systems)
- **Maturity level (initial):** Level 0 or Level 1
- **AI tier stand-ins active:** none

## Immutable Principles

1. **Exit codes are contract.** `0` = success, `1` = generic error, `2` = misuse (usage error), `>= 64` = specific error classes (BSD `sysexits.h`). Scripts depend on these.
2. **Output is split: stdout = data, stderr = diagnostics.** Stdout must be machine-parseable (or at least pipe-safe); stderr carries human-readable progress and warnings.
3. **Interactive prompts never fire in non-TTY mode.** If `stdout` is a pipe or `stdin` is not a terminal, fail with a clear message rather than hang.
4. **Long-running operations emit progress to stderr at a bounded rate.** Default: at most one line per second; quiet mode silences this.
5. **No silent destructive action.** Operations that delete, overwrite, or mutate persistent state require either an explicit flag (`--force`, `--yes`) or an interactive confirmation.

## Architecture Boundaries

- **Allowed:** one config file (`~/.config/your-tool/config.{toml,yaml}`); one cache directory (`~/.cache/your-tool/`); standard env vars (`YOUR_TOOL_*` namespace).
- **Requires ADR:** any subcommand that writes outside the current working directory + the cache directory; any new external-network call.
- **Forbidden:** auto-update on launch; phone-home telemetry without explicit `--telemetry=on` opt-in; reading user files by glob without explicit path arguments.

## Evidence of Done

- **Non-technical tier:** `your-tool --help` output shows the new command; man page (or `--help` deep section) updated; one example invocation works on a fresh install.
- **Semi-technical tier:** Exit-code table in the plan; argument-parser diff in the plan; backward compatibility for existing scripts stated.
- **Technical tier:** Tests cover the new command's success + failure + edge cases (empty input, missing file, permission denied); fuzz / property-based tests where the input surface is unbounded.

## Stakeholder Approval

Constitution amendments require: maintainer + (for changes to A1, A2, A5) one operations-leaning user who scripts with the tool.

## Article Index

| ID | Title |
|----|--------|
| A1 | Exit-code contract |
| A2 | stdout / stderr separation |
| A3 | TTY-aware interactive behaviour |
| A4 | Progress-output rate limit |
| A5 | Destructive-action confirmation |
| A6 | Configuration locations |
| A7 | Telemetry posture (off by default) |

## Tensions to resolve

- **Ergonomics vs script-stability.** A friendly default (auto-confirm on Y) helps interactive users and breaks scripts.
- **Help text length.** Verbose `--help` is great for new users and noise for veterans. Where is the line?
- **Config-file format choice.** TOML (no objects-in-objects ergonomics), YAML (sharp edges around types), JSON (no comments). Pick one and commit.
