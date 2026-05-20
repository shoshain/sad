# Constitution starter pack

Pick the closest starter for your project's shape, copy it over `.sad/memory/constitution.md`, fill in identity placeholders, and resolve the **tensions** at the bottom. Each starter is a *starting point*, not a finished document.

| Starter | Use when | Maturity floor |
|---------|----------|---------------|
| [`web-app.md`](web-app.md) | SaaS, multi-tenant, web frontend + API + DB | Level 0 (solo) / Level 1 (team) |
| [`library.md`](library.md) | Library, SDK, framework — primary user is another developer | Level 0 / Level 1 |
| [`cli.md`](cli.md) | Command-line tool composed into pipelines or scripts | Level 0 / Level 1 |
| [`data-pipeline.md`](data-pipeline.md) | ETL, batch transformations, derived datasets | Level 1 |
| [`ml-app.md`](ml-app.md) | Trained model on the production critical path | Level 1 |
| [`regulated.md`](regulated.md) | HIPAA, PCI-DSS, GDPR Art 25, FDA SaMD, ISO 26262, SOC 2 | Level 1 |

Each starter:

- Names 5 **immutable principles** as a baseline.
- Names 5–8 **architecture articles** the `architectural-conformance` reviewer can score against.
- Names 2–3 **tensions** the adopter must explicitly resolve before approving the constitution. The tensions are the point — they force the conversation that distinguishes a real constitution from a generic checklist.

If none of the starters fit, copy the closest match and edit heavily, or write from scratch using `.sad/memory/constitution.md`'s plain template. **Do not edit the starters in this directory in-place** — that breaks portability with future upstream changes.

## Provenance marker

Each starter begins with an HTML comment marker — e.g. `<!-- starter:web-app v1 -->`. Keep that marker in your derived `.sad/memory/constitution.md` so that the `/sad-doctor` health check can report whether your constitution still resembles the published starter (useful for spotting drift in long-lived projects).
