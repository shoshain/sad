<!-- starter:web-app v1 -->
# Project Constitution — Web app (SaaS) starter

> Copy this file to `.sad/memory/constitution.md` and customise. Pre-filled with the immutable principles and architecture articles that most SaaS / web-app projects need; designed for a small (1–5 engineer) team.

## Identity

- **Project name:** [name]
- **Primary users:** [end users + tenant admins + your support team]
- **Risk class:** medium (handles user data) / high (handles PII or payments — change accordingly)
- **Maturity level (initial):** Level 0 (solo) or Level 1 (small team) — see `MATURITY.md`
- **AI tier stand-ins active:** none (start without; add only after first 5 features)

## Immutable Principles

1. **Authentication is never bypassed in production paths.** Test fixtures and dev shortcuts must be unreachable in the production build artifact.
2. **Persisted user data is encrypted at rest.** No exceptions for "just a feature flag table" — everything that can be linked to a user identity is encrypted.
3. **PII never enters logs.** Logs are public infrastructure; emails, names, tokens, IPs do not belong there. Redact at the logger layer, not the call-site.
4. **Multi-tenant isolation is enforced at the data layer, not at the application layer.** Every tenant-scoped query joins through a tenant filter that the database (RLS, schema, or equivalent) enforces; application code cannot opt out.
5. **No breaking API changes without a deprecation window.** Public API contracts (REST, GraphQL, webhooks) get at least one minor version of deprecation notice; internal APIs get one sprint.

## Architecture Boundaries

- **Allowed:** Postgres / SQLite as primary store; one external auth provider; one transactional email provider; one job queue; one observability provider.
- **Requires ADR:** any new third-party data processor; any new background-job class; any change to the tenant-isolation model; any new public API endpoint.
- **Forbidden:** custom crypto (use the platform's primitives); cross-tenant joins in application code; storing third-party tokens in plaintext.

## Evidence of Done

- **Non-technical tier:** EARS criteria in `feature.spec.md` satisfied; walkthrough demonstrates the user-visible scenarios; demo GIF or screenshot diff in `demo/`.
- **Semi-technical tier:** Plan names the contract change (if any); data-model diff is reviewed; tenant-isolation considerations stated explicitly even when "no impact".
- **Technical tier:** Tests cover EARS criteria + the tenant-isolation cross-cut + at least one negative-path test per public endpoint; reviewer fleet green; eval suite for `architectural-conformance` shows no score-1 findings on shipped articles.

## Stakeholder Approval

Constitution amendments require: lead engineer + product owner + (for any article touching PII or payments) the data-protection lead.

## Article Index (for `architectural-conformance` rubric)

| ID | Title |
|----|--------|
| A1 | Authentication & session lifecycle |
| A2 | Data encryption (at rest + in transit) |
| A3 | PII handling and log redaction |
| A4 | Multi-tenant isolation |
| A5 | API deprecation policy |
| A6 | Observability (metrics, traces, logs naming) |
| A7 | Background-job classes and idempotency |

## Tensions to resolve (write one-sentence resolutions before approving this file)

- **Speed-to-ship vs evidence-rigor.** When the PMF clock is loud and the security review is thorough, which one wins for a feature that does not touch articles A1–A4?
- **Tenant flexibility vs operational simplicity.** Do per-tenant configuration overrides go in the database (flexible, more queries) or in code (simpler, requires deploys)?
- **Build-time vs runtime feature flags.** Build-time = faster + smaller; runtime = lets non-engineers ship safely. Where is the line?
