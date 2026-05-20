# Phase 1 — Research plan

## Brief (from /genBrainstormer args)

> "use with @C:\SAD and think what improvements can be made to make SAD
> methodology more accessible to the user so that to incentivize the user to
> use it in his project/repo."

## Frame

SAD (Stakeholder-Anchored Development) v0.1 is positioned as a synthesis
methodology — 20+ Markdown reference docs, 20+ slash-command prompts, 20+
agent personas, four eval suites, a five-step maturity ladder, a tier-routed
approval gate, and a federated-authority manifesto. The kit is *complete*
but it is **dense**. The accessibility problem is therefore not "what is
missing" but "what is the activation energy a curious developer must spend
before they get a first observable win".

Inertia comes from five places, in roughly decreasing order of friction:

1. **Cold-read budget.** README → SAD_USER_GUIDE (1357 lines) → MANIFESTO →
   LIFECYCLE → ROLES → MATURITY → constitution authoring → stakeholder
   files → hooks. A reader cannot reach a working first feature inside
   one focused session.
2. **Stakeholder commitment up front.** The methodology demands three named
   reviewers across three tiers as a precondition. Solo developers, OSS
   maintainers, and early-stage teams cannot satisfy this — yet they are
   exactly the population most willing to try a new methodology.
3. **Conceptual gravity.** Federated authority, 80/20 inversion, bidirectional
   spec invariant, EARS notation, article index, calibrated LLM judges — all
   land at once.
4. **Tool-adapter ambiguity.** "Adapt hook JSON to your agent product" and
   "Pattern A through F" make integration feel like a project the user has
   to design before they can start.
5. **No reward loop until lessons accumulate.** The 80/20 inversion's payoff
   is *next* feature; the first feature feels strictly heavier than
   business-as-usual.

## Research questions

- **RQ1 — Time-to-first-win.** What is the minimum viable subset that
  delivers an observable benefit on feature #1, not feature #5?
- **RQ2 — Solo / small-team viability.** How can SAD adapt when the three
  human tiers collapse into one or two real people?
- **RQ3 — Progressive disclosure.** Which artifacts/commands belong in the
  user's first session, second session, and beyond?
- **RQ4 — Tool wiring.** Can the methodology ship working installers/hooks
  for the top assistants (Claude Code, Cursor, Codex, Aider, Continue),
  removing "adapt to your toolchain" as a Day-1 task?
- **RQ5 — Reward shape.** What loud, low-cost feedback signals can give a
  reader a "this is paying for itself" moment inside the first hour?
- **RQ6 — Naming + framing.** Is "Stakeholder-Anchored Development" itself
  raising the bar? "Stakeholder" connotes corporate review boards.

## Method

- Skip Phases 2 & 3 (generic mode, no local corpus to mine).
- Phase 4 grounds the brainstorm by reading the actual SAD artifacts that
  the recommendations will touch (commands/, templates/, examples/,
  .sad/scripts/) so each idea names a concrete file/diff.
- Phase 5 synthesizes 10–14 ideas, each with: rationale, evidence pointer
  inside the repo, complexity, expected adoption lift, and a smallest-PR
  next step.
- Phase 6 files report.md, .ideas.json, and updates
  ./brainstormer/reports/index.md.

## Out of scope

- Re-litigating SAD's core thesis (three-tier audience model is non-negotiable
  per NOVEL.md §1). Improvements must preserve it.
- Branding / rename suggestions land as one optional idea, not a sweep.
- Anything that requires breaking the v0.1 blueprint's Markdown-first
  portability promise.
