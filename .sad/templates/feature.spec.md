# Feature: <name>

**Stage:** spec-first / spec-anchored / spec-as-source (per Tessl maturity ladder)
**Tier audience:** non-technical reviewer
**Status:** draft / in-clarification / approved / superseded
**Intent source:** `feature.intent.md` (when present — goals and constraints live there)

## 1. Business Intent
One paragraph summarizing `feature.intent.md` §Goals. Do not duplicate full intent prose here.

## 2. Capabilities
List capabilities the feature provides. Each capability links to its acceptance criteria below and (later) to its eval cases.

- C1. <capability>
- C2. <capability>

## 3. Acceptance Criteria (EARS notation)
For each capability, one or more EARS statements.

- AC1.1. WHEN <trigger> THEN the system SHALL <response>.
- AC1.2. WHILE <state>, IF <event> THEN the system SHALL <response>.

## 4. Out of Scope
Explicit list of things this feature does *not* do. Prevents scope creep.

## 5. Stakeholder Commitments
What promises does this feature imply to which stakeholders? (Used by `impact-forecaster`.)

## 6. Open Questions
Tracked here until resolved by `/sad-clarify`.

## 7. Approval
- [ ] Non-technical reviewer: <name>, <date>
