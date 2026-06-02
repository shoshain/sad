---
contract: POST /me/greeting
kind: http
status: proposed
bc: additive
owner: <team-or-handle>
---

# Contract: POST /me/greeting

> Example HTTP contract template. Copy to `specs/<feature>/contracts/POST_me_greeting.md` and fill in.

## Intent

One paragraph: what does this endpoint do, who calls it, and why does it exist?

## Request

- **Method / path:** `POST /me/greeting`
- **Auth:** session cookie or bearer token (same as `/me`).
- **Headers:** `Content-Type: application/json`.
- **Body schema:**

```json
{
  "greeting": "string (1..140 chars, plain text)"
}
```

## Response

| Status | Body | When |
|---|---|---|
| 200 OK | `{ "greeting": "<echo>" }` | Saved. |
| 400 Bad Request | `{ "error": "Greeting must be 1 to 140 characters." }` | Length violation. |
| 401 Unauthorized | `{ "error": "auth required" }` | Missing or invalid session. |

## Idempotency

- Idempotent? yes / no.
- Replay safe? yes / no.

## Backward compatibility

- Verdict: **additive** (new endpoint; no existing client breaks).
- Consumers affected: list the named clients (mobile, web, partner integration).
- Migration: none required for additive; for `mutating` or `breaking`, describe the rollout.

## Failure modes

- Validation: bounded by request schema.
- Persistence: column write only; no cross-row state.
- Observability: log at the API boundary with request id; do not log greeting body.

## Test points

- Length 0, 1, 140, 141 — boundary tests.
- Auth missing / expired.
- Non-ASCII characters (UTF-8 surrogate handling).

## Related artifacts

- Spec: `feature.spec.md` — AC1.1, AC1.2
- Plan: `feature.plan.md` — §3 Design
- Data model: `data-model.md` — `users.greeting`
