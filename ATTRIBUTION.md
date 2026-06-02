# Full Attribution

SAD is a synthesis. Below is every primitive in the methodology with its source, license, and how SAD adapted it.

## Methodologies and Frameworks

| Primitive | Source | License | URL | SAD adaptation |
|---|---|---|---|---|
| `constitution.md` immutable governance file | GitHub Spec Kit (Den Delimarsky et al.) | MIT | github.com/github/spec-kit | Reused verbatim; loaded into every phase |
| `/specify`, `/plan`, `/tasks`, `/implement`, `/analyze` slash-command pattern | GitHub Spec Kit | MIT | github.com/github/spec-kit | Renamed to `/sad-*`; structure preserved |
| Per-feature artifact directory `specs/NNN-slug/` | GitHub Spec Kit + AWS Kiro | MIT, AWS terms | github.com/github/spec-kit, kiro.dev | Reused; added tier-walkthrough subdir |
| `[P]` parallel-safe task tag | GitHub Spec Kit | MIT | (above) | Reused |
| Read-only `/analyze` consistency gate | GitHub Spec Kit | MIT | (above) | Renamed to `/sad-analyze` |
| EARS notation acceptance criteria | AWS Kiro | AWS terms | kiro.dev/docs/specs | Reused; central to non-technical-tier readability |
| Steering files with inclusion modes (`always` / `auto:glob` / `manual`) | AWS Kiro | AWS terms | kiro.dev/docs/steering | Reused under `.sad/rules/` |
| Wave-based task execution (sequential between waves, parallel within) | AWS Kiro | AWS terms | (above) | Reused |
| Spec-as-source bidirectional edits | Tessl (Guy Podjarny) | proprietary framework, conceptual borrow | tessl.io | Pattern reused without proprietary code |
| Capabilities-tests linkage in spec | Tessl | conceptual | (above) | Reused in `feature.spec.md` template |
| Spec drift detection + reconciliation | Tessl + Kinde | conceptual + blog | tessl.io, kinde.com/learn | Operationalized as `/sad-reconcile` step + agent |
| Two-file feature unit (business spec + technical plan) | AIDDbot | open | aiddbot.com | Reused; tied to non-technical vs semi-technical tiers |
| Story file as context capsule | BMAD-METHOD (Brian) | MIT | github.com/bmad-code-org/BMAD-METHOD | Reused under `specs/NNN/stories/` |
| Persona agents with personality + responsibilities + checklists | BMAD-METHOD + Compound Engineering | MIT | (above), github.com/EveryInc/compound-engineering-plugin | Adopted for reviewer fleet and walkthrough writers |
| Sharding step (PRD/architecture broken per-epic) | BMAD-METHOD | MIT | (above) | Optional; available for large features |
| YAML workflow sequences with handoff prompts | BMAD-METHOD | MIT | (above) | Available in `commands/*.md` frontmatter |
| 80/20 inversion (Plan 40 / Work 20 / Review 20 / Compound 20) | Compound Engineering (Every Inc.) | MIT | github.com/EveryInc/compound-engineering-plugin | Adopted as default time-allocation principle |
| Plan → Work → Review → Compound four-step loop | Compound Engineering | MIT | (above) | Extended to five-step loop with explicit Reconcile step |
| Parallel reviewer sub-agents with confidence calibration | Compound Engineering | MIT | (above) | Reused fleet, added `architectural-conformance` reviewer |
| Demo-reel skill (GIFs, terminal recordings, screenshot diffs) | Compound Engineering `/ce-demo-reel` | MIT | (above) | Reused as `/sad-demo`; tier-routed |
| Lesson template (Decision + Lesson) | Compound Engineering | MIT | (above) | Reused under `.sad/memory/lessons/` |
| Compound-refresh ritual | Compound Engineering | MIT | (above) | Reused as `/sad-compound-refresh` |
| `STRATEGY.md` upstream anchor | Compound Engineering | MIT | (above) | Optional; for product-strategy projects |
| Two-tier rule architecture (core always-loaded, details conditionally loaded) | AWS AI-DLC (`awslabs/aidlc-workflows`) | Apache 2.0 | github.com/awslabs/aidlc-workflows | Reused under `.sad/rules/core/` and `.sad/rules/details/` |
| Mob Elaboration / Mob Construction rituals | AWS AI-DLC | Apache 2.0 | (above) | Optional rituals; recommended for cross-team features |
| Bolts replacing sprints | AWS AI-DLC | Apache 2.0 | (above) | Conceptually borrowed; SAD does not prescribe ritual cadence |
| 10–26 human approval gates per Bolt | AWS AI-DLC | Apache 2.0 | (above) | Adapted to tier-routed approval at walkthrough phase |
| Session-continuity marker (`aidlc-state.md`) | AWS AI-DLC | Apache 2.0 | (above) | Reused as `.sad/state/sad-state.md` |
| Reverse-engineering shared assets for brownfield | AWS AI-DLC | Apache 2.0 | (above) | Optional; recommended for legacy projects |
| Documentation-first invariant | AWS AI-DLC | Apache 2.0 | (above) | Adopted; codebase deletion would not destroy intent |
| AI-proposes-human-approves principle | AWS AI-DLC | Apache 2.0 | (above) | Adopted as core principle |

## Hooks and Harness

| Primitive | Source | License | URL | SAD adaptation |
|---|---|---|---|---|
| Hook taxonomy (PreToolUse, PostToolUse, SessionStart, Stop, etc.) | Anthropic Claude Code | Anthropic terms | code.claude.com/docs/en/hooks | Reused; mapped to SAD phase events |
| Feed-forward / feed-back classification (Guides vs Sensors) | Martin Fowler | blog, public | martinfowler.com/articles/harness-engineering.html | Adopted as core taxonomy |
| LLM-optimized error messages | Martin Fowler + OpenAI | blog | (above) | Required of all SAD harness components |
| Scheduled "garbage-collection" agents | OpenAI (Ryan Lopopolo) | blog | cited via Fowler | Operationalized as `/sad-spec-drift-scan` |
| AGENTS.md as foundational harness | Mitchell Hashimoto | open standard | github.com/Ghostty | Reused; standard cross-tool format |
| Sub-agent as context firewall | Anthropic + HumanLayer | blog | humanlayer.dev | Reused for parallel reviewers and walkthrough writers |
| Reference-application MCP server | ThoughtWorks Tech Radar Vol. 33 | blog | thoughtworks.com/radar | Optional; recommended for legacy contexts under `reference/` |

## Eval Layer

| Primitive | Source | License | URL | SAD adaptation |
|---|---|---|---|---|
| Capability evals graduating to regression evals | Anthropic | blog | anthropic.com/engineering/effective-context-engineering-for-ai-agents | Adopted; lifecycle managed via `/sad-evolve-evals` |
| `pass@k` and per-dimension scoring | Anthropic | blog | (above) | Default metrics |
| Three grader types (deterministic, LLM-judge, human) | Anthropic | blog | (above) | All three available; tier-routed |
| Hidden test files until validation | vercel-labs/agent-eval | MIT | github.com/vercel-labs/agent-eval | Reused; eval files hidden from agent during gen |
| AI-native flywheel (failing prompts → eval set) | Vercel | blog | vercel.com/blog/eval-driven-development-build-better-ai-faster | Reused as `/sad-evolve-evals` |
| Evaluations Driven Development naming and discipline | Anaconda | blog | (cited via ZenML) | Adopted as discipline; SAD's eval layer is EDD-compatible |
| SME-calibrated LLM-judge rubrics | Snorkel AI | blog | snorkel.ai/blog/scaling-trust-rubrics | Reused for stakeholder-tier eval graders |
| Continuous online + offline eval | Azure-Samples eval-driven-agents | MIT | github.com/Azure-Samples/eval-driven-agents | Eval harness skeleton compatible |
| Look-at-the-data → annotate → write-eval discipline | Eugene Yan, Pydantic AI / Ben O'Mahony O'Reilly EDD | blog, course | eugeneyan.com/writing/eval-process | Adopted as discipline |

## Stakeholder-Reporting Layer

| Primitive | Source | License | URL | SAD adaptation |
|---|---|---|---|---|
| Step-decomposition + alternatives-per-decision in non-technical reports | Virk & Liu (UC Davis) | academic | arXiv 2508.06484 | Required of `walkthrough-writer-non-technical` |
| Specification by Example / Given-When-Then | Gojko Adzic | book | gojko.net/2020/03/17/sbe-10-years.html | Combined with EARS as alternative format |
| Living Documentation principles (reliable, low-effort, collaborative, insightful; in-situ; machine-readable; stigmergy) | Cyrille Martraire | book | leanpub.com/livingdocumentation | Adopted as core philosophy of SAD's documentation discipline |
| PR walkthrough auto-generation | CodeRabbit, Greptile, Qodo Merge, Cursor BugBot, Devin Review, What The Diff | various | (vendor sites) | Inspirational; SAD generates equivalents for non-technical and semi-technical tiers |

## Enterprise-Architecture Pillars (LinkedIn synthesis)

| Primitive | Source | URL | SAD adaptation |
|---|---|---|---|
| **Federated Stakeholder Authority** (three-pillar framing: ground rules + governance + collaboration) | Vidar Furuholt, *Three Enduring Pillars of Enterprise Architecture in the Age of AI* | LinkedIn, April 15, 2026 | Reused wholesale, scaled down from enterprise-architecture to feature-level governance |
| Reference Architecture as real-time decision support, not after-the-fact compliance | Vidar Furuholt | (same) | Adopted; constitution loaded into every phase |
| Trust-based decentralization ladder | Vidar Furuholt | (same) | Synthesized into Maturity Levels 1 to 5 |
| AI Agent Capability Maturity Levels (5-level CMMM-style) | Jesper Lowgren, *Enterprise Architecture 4.0* | LinkedIn, Feb 18, 2025 | Adopted as scaffolding for `MATURITY.md`; SAD prefixes Lowgren's five levels with a **Level 0 — Solo SAD** entry point, yielding a six-level ladder. Levels 4 and 5 remain marked speculative per source. |
| Predictive Impact Assessment | Balaji Ramarajan, *Generative AI: Powering the Future of Enterprise Architecture* | LinkedIn, June 24, 2024 | Operationalized as `/sad-impact-forecast` and `impact-forecaster` agent |
| Architecture Review Board augmentation | Balaji Ramarajan | (same) | Operationalized as `architectural-conformance` reviewer in the fleet |

## Academic and Research

| Primitive | Source |
|---|---|
| Non-programmers struggle to verify AI code even with structured explanations | Virk & Liu, arXiv 2508.06484 |
| Spec-Driven Development as code-to-contract paradigm | arXiv 2602.00180 |
| Vibe coding qualitative study | arXiv 2509.12491 (Pimenova et al.) |
| Human-In-the-Loop Software Development Agents (HULA) | arXiv 2411.12924 (Atlassian) |
| Vibe Coding vs Agentic Coding survey | arXiv 2505.19443 |
