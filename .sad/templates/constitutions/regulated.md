<!-- starter:regulated v1 -->
# Project Constitution — Regulated / safety-critical starter

> For projects subject to external regulation (HIPAA, PCI-DSS, GDPR Article 25, FDA SaMD, ISO 26262, SOC 2, etc.). Auditability and change control are load-bearing.

## Identity

- **Project name:** [name]
- **Primary users:** end users + regulators + auditors + your compliance team
- **Risk class:** high or regulated (set explicitly per the governing regime)
- **Maturity level (initial):** Level 1 minimum; **Level 0 (Solo SAD) is not permitted** for regulated work — separation of duties cannot be satisfied by a single human.
- **AI tier stand-ins active:** none permitted. AI stand-in reviewers violate separation-of-duties principles in every regulatory regime SAD's maintainers have surveyed. Use this starter with named human reviewers per tier.
- **Governing regulation(s):** [list — e.g. HIPAA + SOC 2 Type II]
- **Lead regulatory point of contact:** [name + role]

## Immutable Principles

1. **Every change has a documented author + reviewer + approver, all three distinct humans.** Version control records satisfy this; commits without a separately signed approval are deployment-blocked.
2. **Audit logs are append-only and tamper-evident.** Logs that can be edited cannot be evidence. WORM storage or cryptographic chaining required.
3. **Production access is need-to-know.** Engineering access to production data requires a documented request, a documented grant, a time-limited window, and an audit trail.
4. **Incident response is rehearsed, not improvised.** Tabletop exercises happen at the regulatory cadence (default: quarterly).
5. **The constitution itself is part of the audit surface.** Every amendment is a change-controlled event with its own author + reviewer + approver trio and a regulatory-impact statement.
6. **Presence in the loop, not approval at the gate only.** Intent owners stay engaged during `/sad-implement` via recorded checkpoints; tier gates and separation of duties are not weakened.

## Architecture Boundaries

- **Allowed:** one identity provider with MFA + audit logs; one secret manager; one observability provider with audit logs; one access-management system.
- **Requires ADR:** any new sub-processor; any new data-processing geography; any new data-class introduction; any change to the audit-log schema.
- **Forbidden:** production data in non-production environments; shared accounts; ad-hoc access grants without an audit trail; auto-deployed changes without the author-reviewer-approver trio.

## Evidence of Done

- **Non-technical tier:** EARS criteria reference the relevant regulatory clauses; walkthrough names the regulatory impact ("affects HIPAA §164.312(c)") even when "no impact".
- **Semi-technical tier:** Plan names the audit-log additions; data-class catalogue diff; access-management impact; sub-processor impact.
- **Technical tier:** Tests cover audit-log emission per security-relevant event; access controls tested with deny cases; reviewer fleet includes `security-sentinel` and `data-migrations` at minimum; eval suite confirms no PII appears in non-PII log streams.

## Stakeholder Approval

Constitution amendments require: lead engineer + compliance officer + (for any A1–A5 change) external auditor consultation noted.

## Article Index

| ID | Title |
|----|--------|
| A1 | Separation of duties (author / reviewer / approver) |
| A2 | Audit log schema, retention, and tamper-evidence |
| A3 | Production-access governance |
| A4 | Incident-response cadence |
| A5 | Constitution amendment as audited event |
| A6 | Sub-processor management |
| A7 | Data-class catalogue and geography controls |
| A8 | Regulatory-clause traceability (every change cites the affected clause) |
| A9 | Presence in the loop during `/sad-implement` (checkpoints; gates remain mandatory) |
| A10 | Tier-routed walkthrough gate (three artifacts; pending-async allowed, not fake approval) |
| A11 | Deferred approval discipline (pending blocks tasks; external acceptance records allowed) |

## Tensions to resolve

- **Velocity vs evidence.** Audit-grade evidence collection slows every change. Where is the threshold below which evidence is skipped?
- **Internal observability vs minimum-necessary access.** Engineers want production telemetry to debug; regulators want need-to-know access. Build the synthetic-data + redaction pipeline that resolves this.
- **Self-certification vs external attestation.** When does a self-attested control require an external auditor?
