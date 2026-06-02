#!/usr/bin/env python3
"""Minimal reference MCP server.

Pattern, not implementation. Single tool ('greet'), zero third-party deps,
JSON-RPC 2.0 over stdin/stdout. Replace with your own contract surface; keep it
small enough to read in five minutes.
"""

from __future__ import annotations

import json
import sys
from typing import Any


GREETING_MIN, GREETING_MAX = 1, 140


def handle_greet(params: dict[str, Any]) -> dict[str, Any]:
    name = params.get("name")
    if not isinstance(name, str):
        raise ValueError("'name' must be a string")
    if len(name) < GREETING_MIN or len(name) > GREETING_MAX:
        raise ValueError(f"'name' must be {GREETING_MIN}..{GREETING_MAX} chars")
    if any(ch in name for ch in ("\n", "\r")):
        raise ValueError("'name' must be a single line")
    return {"greeting": f"Hello, {name}."}


DISPATCH = {"greet": handle_greet}


def handle_request(req: dict[str, Any]) -> dict[str, Any]:
    method = req.get("method")
    params = req.get("params") or {}
    req_id = req.get("id")
    handler = DISPATCH.get(method or "")
    if handler is None:
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": -32601, "message": f"unknown method: {method}"},
        }
    try:
        result = handler(params)
    except ValueError as exc:
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": -32602, "message": str(exc)},
        }
    return {"jsonrpc": "2.0", "id": req_id, "result": result}


def main() -> int:
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except json.JSONDecodeError as exc:
            err = {
                "jsonrpc": "2.0",
                "id": None,
                "error": {"code": -32700, "message": f"parse error: {exc}"},
            }
            print(json.dumps(err), flush=True)
            continue
        resp = handle_request(req)
        print(json.dumps(resp), flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
