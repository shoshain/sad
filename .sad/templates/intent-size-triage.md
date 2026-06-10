# Intent size triage: <feature name>

> Written at the end of `/sad-brainstorm`. Routes the feature onto the correct lifecycle path.

## Triage verdict

- **Size:** trivial | bounded | strategic
- **Rationale:** <one paragraph — why this size, not another>
- **Recorded:** <YYYY-MM-DD>
- **Recorded by:** <name or role>

## Path routing

| Size | Lifecycle path | Tier gates |
|------|----------------|------------|
| **trivial** | specify → implement → reconcile → compound | technical reviewer only (reconciliation sign-off) |
| **bounded** | standard 14-step loop | all three tiers at walkthrough + reconcile |
| **strategic** | standard loop + mandatory `/sad-context` before plan | all three tiers + context citation in plan |

## Signals used

- [ ] Single contract surface or none
- [ ] No NFR / compliance posture shift
- [ ] Reversible within one PR
- [ ] No new stakeholder commitments
- [ ] Cross-feature or cross-team blast radius (strategic only)

## Notes

<assumptions the triage relied on; link open questions from requirements.draft.md>
