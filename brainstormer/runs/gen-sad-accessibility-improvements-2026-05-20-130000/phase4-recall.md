# Phase 4 — Structured LLM-Internal Recall

## Claim list (provenance: `llm_internal` only; web column filled in Phase 5)

| # | Sub-Q | Claim | Confidence | `prior_art_hint` | Domain |
|---|-------|-------|-----------|-------------------|--------|
| C1.1 | SQ1 | OSS repos with README→1000+ line guide as the only reading path have materially higher bounce than repos with an intermediate quickstart layer. | medium | "developer documentation bounce", "OSS onboarding funnel", "quickstart conversion" | developer_methodology_adoption |
| C1.2 | SQ1 | Bash-only helper scripts in a cross-platform OSS tool lock out ~30–40% of the developer market (Windows native + WSL-averse). | high | "stack overflow developer survey 2025 OS share", "cross-platform OSS scripts Windows" | developer_methodology_adoption |
| C1.3 | SQ1 | Methodologies that hard-require ≥ 2 distinct human reviewers per feature exclude solo developers and small OSS by construction. | high | "agile methodology solo developer", "spec driven development small team" | developer_methodology_adoption |
| C2.1 | SQ2 | Quickstart pages (≤ 30 min to first observable outcome) materially increase first-week retention. | medium | "documentation quickstart conversion", "developer onboarding time-to-first-hello-world" | quickstart_design |
| C2.2 | SQ2 | One-page cheatsheets compound with quickstarts — they give "in-flow reference" once intro is past. | medium | "cheatsheet effectiveness developer onboarding" | quickstart_design |
| C2.3 | SQ2 | Worked examples covering > 1 archetype (CRUD + bug-fix + refactor + migration) reduce time-to-second-feature. | medium | "documentation examples archetype coverage", "sample applications adoption" | developer_methodology_adoption |
| C2.4 | SQ2 | Single-command installers (`npx create-*`, `pipx run`, `curl | sh`) outperform "copy these directories" instructions by a wide margin for OSS trial conversion. | high | "npx create-* install adoption", "OSS installer one-liner conversion" | indie_oss_methodology_packaging |
| C3.1 | SQ3 | Spec-driven methodologies can be adapted to solo use by allowing one human across all tiers *provided each tier still produces its own artifact* — the artifact discipline is the protection, the multi-human protection is the rubber-stamp guard. | medium | "solo developer self-review", "self-review checklists effectiveness" | spec_driven_development |
| C3.2 | SQ3 | AI subagents can play "missing reviewer tier" with opt-in guardrails; risk = AI rubber-stamping degrading into spec-theatre. | medium | "AI as code reviewer", "self-review AI augmented", "Virk Liu 2025 non-programmers AI code review" | ai_coding_assistants |
| C3.3 | SQ3 | Several 2025-2026 spec-driven kits (Spec Kit, Kiro, Aider's spec mode, Tessl) are pushing into solo-first or single-person-team territory. | medium | "github spec kit solo", "kiro solo developer", "aider spec mode 2025" | spec_driven_development |
| C4.1 | SQ4 | Claude Code uses `.claude/settings.json` + `.claude/commands/*.md` + `AGENTS.md` at root + a hooks system (PreToolUse, PostToolUse, etc.). | high | "claude code settings.json hooks 2026", "claude code slash commands" | claude_code |
| C4.2 | SQ4 | Cursor uses `.cursor/rules/*.mdc` with frontmatter + supports commands via `.cursor/commands/`. | high | "cursor rules mdc 2025", "cursor commands directory" | cursor |
| C4.3 | SQ4 | Aider uses `.aider.conf.yml` + `CONVENTIONS.md` + chat-history files; smaller plugin surface than Claude Code / Cursor. | high | "aider conventions file", "aider configuration 2026" | aider |
| C4.4 | SQ4 | Windsurf and OpenAI Codex have native instruction-file conventions but smaller adapter surface than Claude Code / Cursor. | medium | "windsurf .windsurf rules 2026", "openai codex AGENTS.md" | ai_coding_assistants |
| C4.5 | SQ4 | A cross-assistant `AGENTS.md` at the repo root emerged in 2024-2025 as the de-facto entry point; Cursor, Aider, Codex, Continue, and Windsurf all read it (or a near-alias). | high | "AGENTS.md standard 2025 cross-assistant", "agents.md specification" | ai_coding_assistants |
| C5.1 | SQ5 | GitHub repo stars are noisy adoption signals; the cleaner signal is the count of forks/clones that complete a first-feature loop (e.g. a `.sad/memory/lessons/*.md` file appears in a fork). | medium | "github OSS adoption metrics", "telemetry methodology adoption" | indie_oss_methodology_packaging |
| C5.2 | SQ5 | For documentation, the most predictive single signal is time-to-first-non-trivial-PR (median time from clone to first artifact created). | medium | "developer experience metrics time-to-first-commit" | developer_methodology_adoption |
| C5.3 | SQ5 | A 3-question Google Form linked from the README typically converts 5-10% of OSS pageviews into responses — a reasonable cheap falsifiability signal. | medium | "OSS user survey conversion rate" | governance |

## Contradictions (LLM-internal vs LLM-internal)

| ID | Description | Class |
|----|-------------|-------|
| X-1 | C2.4 (installer-first) vs C3.3 (solo founders trust LLM-prompted install). In 2026 some solo founders may prefer "ask Claude to install SAD" over `npx create-sad@latest`. Whether the modal install gesture is still a one-liner or now an LLM prompt is an open empirical question. | empirical + terminological |

## Gap list

| Gap | Type | Description |
|-----|------|-------------|
| G-001 | extrinsic | Cross-platform-script expectation for OSS dev tools in 2025-2026: has Node/Python single-runtime displaced bilingual Bash+PowerShell, or is bilingual still common? |
| G-002 | extrinsic | Published 2025-2026 adoption numbers on `npx create-*` / `pipx run` vs "copy these files" instructions. |
| G-003 | extrinsic | `AGENTS.md` standard status in mid-2026: formalized? Which assistants consume it natively? |
| G-004 | extrinsic | Evidence for solo-developer adaptation patterns in published spec-driven methodologies (Spec Kit, Kiro, Aider, Tessl). |
| G-005 | extrinsic | Published evidence on AI-stand-in reviewer effectiveness vs human-only reviewer for catching non-technical-tier issues. |
| G-006 | extrinsic | Published 90-day OSS-methodology adoption-signal patterns. |
| G-007 | intrinsic | The "right" Level-0 / Solo SAD design that preserves the Virk & Liu protection — a design decision SAD's maintainers own; web cannot close it. |
| G-008 | extrinsic | Claude Code hooks specification in mid-2026 — confirm hook event names + PreToolUse semantics for adapter design. |

## Phase 5 search allocation (cap: 12)

| # | Target | Type | Query draft |
|---|--------|------|-------------|
| S1 | G-001 | gap | "cross-platform shell scripts OSS Windows PowerShell Node Python 2025" |
| S2 | G-002 | gap | "npx create scaffold tool adoption rate 2025 2026" |
| S3 | G-003 | gap | "AGENTS.md standard cross assistant 2026 specification" |
| S4 | G-004 | gap | "GitHub Spec Kit Kiro spec-driven solo developer 2025" |
| S5 | G-004 | gap | "Aider conventions Cursor rules solo developer methodology 2026" |
| S6 | G-005 | gap | "AI code reviewer effectiveness vs human reviewer 2025" |
| S7 | G-006 | gap | "OSS methodology adoption metrics first 90 days" |
| S8 | G-008 | gap | "Claude Code hooks PreToolUse PostToolUse 2026" |
| S9 | candidate-bundle | prior-art | "spec-driven development installer scaffold solo developer 2026" |
| S10 | candidate-bundle | prior-art | "developer documentation quickstart cheatsheet effectiveness research" |
| S11 | candidate-bundle | prior-art | "constitution-as-code starter templates AI agent rules 2026" |
| S12 | candidate-bundle | prior-art | "EARS acceptance criteria notation adoption 2025 spec-driven" |

Total: 12 / cap 12.
