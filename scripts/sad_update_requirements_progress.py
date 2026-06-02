"""Refresh aggregated requirements compliance progress for SAD-tracked specs.

Parses ``Project_Plan/safety_doc_autodoc_requirements_mapping.md`` (pipe tables),
merges optional per-feature ``req-coverage.yaml`` and REQ mentions inside
``feature.spec.md``, and writes ``specs/requirements-compliance-progress.md``.

Designed for AISCETA safety-documentation REQ traceability; reusable from any
repo by passing ``--mapping`` and ``--specs-dir``.
"""

from __future__ import annotations

import argparse
import dataclasses
import json
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

try:
    import yaml  # type: ignore[import-untyped]
except ImportError:
    yaml = None  # type: ignore[assignment]

_REQ_FIRST_CELL = re.compile(
    r"^(?P<id>(?:REQ|NREQ)-DOC-[0-9]+(?:/[0-9]+)*(?:\u2026[0-9]+)?)",
)
_SPEC_REQ_FIND = re.compile(
    r"\b((?:REQ|NREQ)-DOC-[0-9]+(?:/[0-9]+)*)\b",
)
_IMPL_MULTI_SPACE = re.compile(r"\s+")


def normalize_impl_status(raw: str) -> str:
    """Map mapping-table emoji markers to plain-language tokens (JSON/tool friendly).

    Replaces common status glyphs with lowercase words: ``complete``, ``partial``,
    ``not_implemented``. Collapses redundant ``partial partial`` when the prose
    repeated the word after a warning glyph.

    Args:
        raw: Raw status cell from the markdown mapping table.

    Returns:
        ASCII-normalized status description.
    """
    s = raw.strip().replace("\u2026", "...")
    s = (
        s.replace("\u2705", "complete ")
        .replace("\u26a0\ufe0f", "partial ")
        .replace("\u26a0", "partial ")
        .replace("\u274c", "not_implemented ")
    )
    # Literal glyphs if file uses chars directly instead of escapes
    s = (
        s.replace("✅", "complete ")
        .replace("⚠️", "partial ")
        .replace("❌", "not_implemented ")
    )
    s = _IMPL_MULTI_SPACE.sub(" ", s).strip().lower()
    s = re.sub(r"\b(partial)\s+\1\b", r"\1", s)
    return s


@dataclasses.dataclass
class MappingRow:
    """One requirement row extracted from the markdown mapping tables."""

    req_id: str
    summary: str
    impl_status: str
    detail: str


def _split_table_row(line: str) -> list[str]:
    raw = line.strip()
    if not raw.startswith("|"):
        return []
    inner = raw.strip()
    if inner.startswith("|"):
        inner = inner[1:]
    if inner.endswith("|"):
        inner = inner[:-1]
    return [cell.strip() for cell in inner.split("|")]


def _normalize_req_token(first_cell: str) -> tuple[str, str] | None:
    stripped = first_cell.strip()
    if not stripped:
        return None
    if stripped.startswith("``") and "`" in stripped:
        return None
    m = _REQ_FIRST_CELL.match(stripped)
    if not m:
        return None
    rid = m.group("id").replace("\u2026", "...")
    summary = stripped[len(m.group(0)) :].strip()
    return rid, summary


def parse_mapping_markdown(path: Path) -> dict[str, MappingRow]:
    """Parse REQ/NREQ rows from mapping markdown tables."""
    text = path.read_text(encoding="utf-8")
    rows: dict[str, MappingRow] = {}
    for line in text.splitlines():
        cells = _split_table_row(line)
        if len(cells) < 2:
            continue
        if cells[0].startswith("---") or cells[0].lower().startswith("req "):
            continue
        parsed = _normalize_req_token(cells[0])
        if parsed is None:
            continue
        rid, summary = parsed
        if cells[1].strip().lower() == "status":
            continue
        if len(cells) >= 4:
            impl_status = cells[1]
            detail = " | ".join(cells[2:])
        elif len(cells) == 3:
            impl_status, detail = cells[1], cells[2]
        else:
            impl_status, detail = cells[1], ""
        impl_status = normalize_impl_status(impl_status)
        rows[rid] = MappingRow(
            req_id=rid,
            summary=summary,
            impl_status=impl_status,
            detail=detail[:500] + ("…" if len(detail) > 500 else ""),
        )
    return rows


def _load_yaml(path: Path) -> dict[str, Any]:
    if yaml is None:
        msg = "PyYAML is required for req-coverage.yaml (pip install pyyaml)."
        raise RuntimeError(msg)
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    if data is None:
        return {}
    if not isinstance(data, dict):
        msg = f"Expected mapping at root of {path}"
        raise ValueError(msg)
    return data


def load_feature_coverage(spec_dir: Path) -> tuple[list[str], str]:
    """Return (req_ids, notes) from req-coverage.yaml or []."""
    cov_path = spec_dir / "req-coverage.yaml"
    if not cov_path.is_file():
        return [], ""
    data = _load_yaml(cov_path)
    ids: list[str] = []
    for item in data.get("requirements") or []:
        if isinstance(item, dict) and item.get("id"):
            ids.append(str(item["id"]).strip())
        elif isinstance(item, str):
            ids.append(item.strip())
    notes = str(data.get("notes") or "").strip()
    return ids, notes


def reqs_from_feature_spec(spec_path: Path) -> set[str]:
    if not spec_path.is_file():
        return set()
    text = spec_path.read_text(encoding="utf-8")
    trace_start = text.find("## Traceability")
    if trace_start != -1:
        next_hdr = text.find("\n## ", trace_start + 3)
        chunk = text[trace_start : next_hdr if next_hdr != -1 else None]
        return set(_SPEC_REQ_FIND.findall(chunk))
    return set(_SPEC_REQ_FIND.findall(text))


def discover_spec_slugs(specs_dir: Path) -> list[Path]:
    if not specs_dir.is_dir():
        return []
    out: list[Path] = []
    for p in sorted(specs_dir.iterdir()):
        if not p.is_dir():
            continue
        if p.name.startswith("."):
            continue
        if (p / "feature.spec.md").is_file():
            out.append(p)
    return out


def build_coverage_index(specs_dir: Path) -> dict[str, list[str]]:
    """req_id -> list of feature slug folder names."""
    idx: dict[str, list[str]] = defaultdict(list)
    for feat in discover_spec_slugs(specs_dir):
        slug = feat.name
        yaml_ids, _ = load_feature_coverage(feat)
        spec_ids = reqs_from_feature_spec(feat / "feature.spec.md")
        merged = sorted({*yaml_ids, *spec_ids})
        for rid in merged:
            idx[rid].append(slug)
    return dict(idx)


def render_progress_markdown(
    *,
    mapping_rows: dict[str, MappingRow],
    coverage: dict[str, list[str]],
    canonical_docx: str,
    mapping_rel: str,
    generated_uri: str,
    specs_dir: Path,
) -> str:
    lines: list[str] = [
        "<!-- AUTO-GENERATED by scripts/sad_update_requirements_progress.py -->",
        "<!-- Do not edit by hand; run the script after mapping or spec changes. -->",
        "",
        "# Requirements compliance progress (SAD + safety-doc mapping)",
        "",
        "## Canonical sources",
        "",
        f"- **Specification (normative):** `{canonical_docx}`",
        f"- **Implementation matrix:** [`{mapping_rel}`](../{mapping_rel})",
        f"- **This report:** `{generated_uri}`",
        "",
        "## How to refresh",
        "",
        "```bash",
        "python scripts/sad_update_requirements_progress.py --repo-root .",
        "```",
        "",
        "Run after each SAD lifecycle step or whenever "
        "`safety_doc_autodoc_requirements_mapping.md` changes.",
        "",
        "## Summary",
        "",
    ]
    total = len(mapping_rows)
    covered_by_spec = sum(
        1 for rid in mapping_rows if rid in coverage and coverage[rid]
    )
    lines.extend(
        [
            f"- **REQ rows parsed from mapping:** {total}",
            f"- **REQ rows referenced by at least one `specs/<slug>/`:** "
            f"{covered_by_spec}",
            "",
            "## Per-requirement rollup",
            "",
            "| REQ ID | Mapping implementation | Active SAD specs | "
            "Summary (mapping col 1) |",
            "| --- | --- | --- | --- |",
        ],
    )
    for rid in sorted(mapping_rows.keys(), key=_sort_req_key):
        row = mapping_rows[rid]
        specs_cell = ", ".join(f"`{s}`" for s in coverage.get(rid, [])) or "—"
        summ = (row.summary or "—").replace("|", "\\|")
        impl = row.impl_status.replace("|", "\\|")
        lines.append(
            f"| `{rid}` | {impl} | {specs_cell} | {summ} |",
        )
    lines.extend(["", "## Spec folders scanned", ""])
    slugs = [p.name for p in discover_spec_slugs(specs_dir)]
    specs_dir_note = ", ".join(f"`{s}`" for s in slugs) or "—"
    lines.append(f"- {specs_dir_note}")
    lines.append("")
    return "\n".join(lines)


def _sort_req_key(rid: str) -> tuple[int, int, str]:
    m = re.search(r"(\d+)", rid)
    num = int(m.group(1)) if m else 0
    prefix = 1 if rid.startswith("NREQ") else 0
    return prefix, num, rid


def write_registry_snapshot(
    path: Path,
    mapping_rows: dict[str, MappingRow],
    *,
    canonical_docx: str,
    mapping_rel: str,
) -> None:
    payload = {
        "canonical_docx": canonical_docx,
        "mapping_md": mapping_rel,
        "impl_status_legend": {
            "complete": (
                "Met or satisfied for the scoped toolchain "
                "(mapping table formerly used a check mark)."
            ),
            "partial": (
                "Partially met or caveat noted "
                "(mapping table formerly used a warning mark)."
            ),
            "not_implemented": (
                "Not implemented in the scoped stack "
                "(mapping table formerly used a cross mark)."
            ),
            "_note": (
                "impl_status uses plain words (complete, partial, "
                "not_implemented) instead of emoji so JSON stays grep-friendly."
            ),
        },
        "requirements": [
            dataclasses.asdict(row)
            for row in sorted(
                mapping_rows.values(),
                key=lambda r: _sort_req_key(r.req_id),
            )
        ],
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path.cwd(),
        help="Repository root (default: cwd).",
    )
    parser.add_argument(
        "--mapping",
        type=Path,
        default=None,
        help="Path to safety_doc_autodoc_requirements_mapping.md",
    )
    parser.add_argument(
        "--specs-dir",
        type=Path,
        default=None,
        help="Specs directory (default: <repo-root>/specs).",
    )
    parser.add_argument(
        "--output-md",
        type=Path,
        default=None,
        help="Progress markdown output "
        "(default: <specs-dir>/requirements-compliance-progress.md).",
    )
    parser.add_argument(
        "--registry-json",
        type=Path,
        default=None,
        help="Optional JSON snapshot of parsed mapping rows.",
    )
    parser.add_argument(
        "--canonical-docx",
        type=str,
        default="Project_Plan/Generating Safety Documentation - Requirements.docx",
        help="Display path for normative DOCX (informational in markdown).",
    )
    args = parser.parse_args(argv)

    root = args.repo_root.resolve()
    mapping = (
        args.mapping.resolve()
        if args.mapping
        else root / "Project_Plan/safety_doc_autodoc_requirements_mapping.md"
    )
    specs_dir = (
        args.specs_dir.resolve()
        if args.specs_dir
        else root / "specs"
    )
    output_md = (
        args.output_md.resolve()
        if args.output_md
        else specs_dir / "requirements-compliance-progress.md"
    )

    if not mapping.is_file():
        sys.stderr.write(f"mapping file not found: {mapping}\n")
        return 1

    mapping_rows = parse_mapping_markdown(mapping)
    if not mapping_rows:
        sys.stderr.write(f"no REQ rows parsed from {mapping}\n")
        return 1

    specs_dir = specs_dir.resolve()
    coverage = build_coverage_index(specs_dir)

    mapping_rel = mapping.relative_to(root).as_posix()
    generated_uri = output_md.relative_to(root).as_posix()

    body = render_progress_markdown(
        mapping_rows=mapping_rows,
        coverage=coverage,
        canonical_docx=args.canonical_docx,
        mapping_rel=mapping_rel,
        generated_uri=generated_uri,
        specs_dir=specs_dir,
    )
    output_md.parent.mkdir(parents=True, exist_ok=True)
    output_md.write_text(body, encoding="utf-8")

    reg_path = args.registry_json
    if reg_path is None:
        reg_path = (
            specs_dir / "safety-documentation-requirements/registry.snapshot.json"
        )
    reg_path = reg_path.resolve()
    write_registry_snapshot(
        reg_path,
        mapping_rows,
        canonical_docx=args.canonical_docx,
        mapping_rel=mapping_rel,
    )
    print(f"Wrote {output_md}")
    print(f"Wrote {reg_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
