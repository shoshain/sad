# SAD composition with peer methodologies

SAD defines **intent and stakeholder-routed approval**. Other methodologies qualify
what ships. This page is narrative only — no engine coupling required.

## SAD + FTM (Functional Testing Methodology)

| SAD phase | FTM role |
|-----------|----------|
| After `/sad-implement` | FTM qualifies the build against EARS criteria and contracts |
| Before merge | Working software is **evidence** in technical walkthroughs and demos |
| `/sad-reconcile` | FTM failures route as `code-update`; oracle gaps as `oracle-gap` — never weaken oracles to green a defect |

**Closing the agile gap:** short SAD loops plus FTM proof mean stakeholders approve
behavior they can exercise, not prose they hope someone else interpreted.

## SAD + TAO

TAO supplies precision oracles; SAD supplies who must approve which artifact.
Oracles inform `/sad-analyze` and reviewer-fleet reports; they do not replace tier gates.

## SAD + AIM

AIM produces invention candidates; SAD specifies and ships chosen candidates.
Route AIM dossiers into `/sad-brainstorm` inputs, not directly into `feature.spec.md`.

## Install surface

Consuming projects keep each kit in its own directory (submodule or sibling repo).
Archangel and similar supervisors may register multiple methodology packs; SAD remains
the intent and stakeholder-routing pack.

## Further reading

- [`LIFECYCLE.md`](LIFECYCLE.md) — canonical loop and triage shortcuts
- [`MATURITY.md`](MATURITY.md) — who approves what at each level
- [`commands/sad-gate-status.md`](commands/sad-gate-status.md) — program approval queue
