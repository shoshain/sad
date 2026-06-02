# Feature: User can save a personal greeting

**Stage:** spec-first
**Tier audience:** non-technical reviewer
**Status:** approved

## 1. Business Intent
A logged-in user can save a short personal greeting that the application displays to them on every login. This personalizes the experience and demonstrates the user's account state is being remembered.

## 2. Capabilities
- C1. Save a greeting (1 to 140 characters).
- C2. Display the saved greeting on login.
- C3. Replace the greeting with a new one.

## 3. Acceptance Criteria (EARS)
- AC1.1. WHEN a logged-in user submits a greeting between 1 and 140 characters THEN the system SHALL save it and confirm the save.
- AC1.2. WHEN a logged-in user submits a greeting longer than 140 characters THEN the system SHALL reject it with the message "Greeting must be 1 to 140 characters."
- AC2.1. WHEN a user logs in AND has a previously saved greeting THEN the system SHALL display the greeting on the home screen.
- AC3.1. WHEN a user replaces their greeting THEN the system SHALL overwrite the previous greeting and confirm the replacement.

## 4. Out of Scope
- Multiple greetings per user.
- Sharing greetings with other users.
- Formatting (markdown, emoji, links).

## 5. Stakeholder Commitments
- Non-technical: greeting is plain text, no formatting; max 140 characters.
- Semi-technical: greeting is stored on the user record; no separate greeting table.
- Technical: GET /me returns greeting field; POST /me/greeting writes it.

## 6. Open Questions
None remaining.

## 7. Approval
- [x] Non-technical reviewer: Jane Doe, 2026-05-08
