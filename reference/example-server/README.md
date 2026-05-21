# example-server — minimal MCP reference

> Pattern, not implementation. Two files, zero dependencies. Replace contents to match your project's contract surface.

A real reference MCP server in a consuming project usually:

1. Implements every contract listed under `specs/*/contracts/` (or a documented subset).
2. Returns deterministic, fixture-backed responses for the canonical test users.
3. Ships with a `tools.json` listing what it exposes — the same shape stakeholders see when running their real client.

## Files

- [`tools.json`](tools.json) — JSON-Schema-style tool descriptor. The reconciler reads this; humans read this; the (hypothetical) MCP harness reads this.
- [`server.py`](server.py) — single-file Python reference implementation of one tool. Run it directly: `python server.py`. It reads JSON-RPC over stdin and writes responses to stdout. No network, no dependencies beyond the standard library.

## Run

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"greet","params":{"name":"Sam"}}' | python reference/example-server/server.py
# → {"jsonrpc":"2.0","id":1,"result":{"greeting":"Hello, Sam."}}
```

## Use as a contract oracle

`/sad-reconcile` (when wired in your harness) can hit the server with each contract's example request and diff the actual response against the documented one. This gives you a working contract truth-source for stakeholders to inspect during walkthroughs.

## What to change first

1. Edit `tools.json` to list your real tools.
2. Replace `server.py` with the simplest possible handler for each tool. **Do not import production code here** — the reference application stays small on purpose. If it's too big to read in five minutes, it stops being a reference.
