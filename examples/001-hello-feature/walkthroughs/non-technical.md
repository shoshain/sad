# Non-Technical Walkthrough: User can save a personal greeting

## What we built (one paragraph, plain English)
Signed-in users can save a short, plain-text phrase that welcomes them back when they open the app after logging in. They can change that phrase later, and the app remembers only the latest one.

## Who this is for
Product and business stakeholders validating behavior against the agreed acceptance criteria, without reading code.

## Scenario walk-through

### Save a valid greeting
1. The user opens the greeting screen after signing in and types a short message within the allowed length.
2. The system saves the message securely on their profile and shows confirmation that it worked.
3. The user sees a clear success indication and can continue using the app.

**Decision — how we handle length:** We only allow a short plain message so the experience stays predictable on small screens. Longer messages are blocked with a simple explanation so the user knows what to fix.

### See greeting on return visit
1. The user signs in again on a later day.
2. The system looks up their saved greeting.
3. The user sees their greeting on the home screen as soon as they arrive.

### Change the greeting
1. The user enters a new greeting to replace the old one.
2. The system overwrites the previous greeting and confirms the update.
3. The user sees only the new greeting from then on.

## Demo artifacts
- `demo/README.md` — describes what GIFs/screenshots would show in a real project.

## Acceptance criteria coverage

| Criterion | Evidence |
|---|---|
| AC1.1 | Demo: success path within 1–140 characters |
| AC1.2 | Demo: rejection message for too-long input |
| AC2.1 | Demo: greeting visible after login |
| AC3.1 | Demo: replacement confirmation |

## Things that did not change
- No sharing between users. No rich formatting. Not multiple saved greetings.

## Approval
- [x] Non-technical reviewer: Jane Doe, 2026-05-08
- Comments: Example walkthrough for methodology illustration.
