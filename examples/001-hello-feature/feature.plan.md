# Technical Plan: User can save a personal greeting

**Tier audience:** semi-technical reviewer
**Status:** approved

## 1. Summary
Persist a single plain-text greeting (1–140 characters) on the authenticated user profile. Expose read via `GET /me` and write via `POST /me/greeting`. On login, surface the greeting on the home screen client using data from `/me`.

## 2. Scope mapping

| Capability | Deliverable |
|------------|-------------|
| C1 | API validation + persistence on user record |
| C2 | Client home screen reads greeting from session/bootstrap |
| C3 | Update path overwrites prior value with confirmation UX |

## 3. Design
- **Data:** `users.greeting` nullable varchar(140) (or product-specific user entity).
- **API:** `POST /me/greeting` body `{ "greeting": string }` returns 400 with standardized message on length violation.
- **Auth:** Same session/JWT as existing `/me`.

## 4. Dependencies & integration
- Depends on existing authentication and `/me` contract. If `/me` lacks `greeting`, extend response shape as additive field.

## 5. Risks & mitigations
- **Migration:** additive column with default null — backward compatible.
- **XSS:** plain text only; escape on render in client framework.

## 6. Verification strategy
- Contract tests for length validation and success path.
- UI/E2E: login shows stored greeting; replacement confirms overwrite.

## 7. Approval
- [x] Semi-technical reviewer: Sam Chen, 2026-05-08
