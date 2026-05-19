#!/usr/bin/env python3
import argparse
import json
from pathlib import Path


DEFAULT_IGNORES = {
    ".git",
    "node_modules",
    ".next",
    ".venv",
    "__pycache__",
}


def should_skip(path: Path, ignores: set[str]) -> bool:
    return any(part in ignores for part in path.parts)


def classify(path: Path) -> str:
    name = path.name.lower()
    suffix = path.suffix.lower()
    parts = {p.lower() for p in path.parts}

    if "_archive" in parts:
        return "archive-original"
    if "_ctx" in parts:
        return "extract-canonical-context"
    if "logs" in parts or suffix in {".log", ".tmp", ".cache"}:
        return "generated-artifact"
    if name.startswith("tmp") or name.endswith(".bak"):
        return "safe-deletion-candidate"
    if suffix in {".md", ".txt", ".rst", ".json", ".yml", ".yaml"}:
        return "keep-active"
    return "unknown-preserve"


def main() -> int:
    parser = argparse.ArgumentParser(description="Create read-only inventory JSONL for context compaction.")
    parser.add_argument("--root", default=".", help="Project root to scan.")
    parser.add_argument("--out", default="_ctx/MANIFEST.jsonl", help="Output JSONL path.")
    parser.add_argument(
        "--ignore",
        action="append",
        default=[],
        help="Extra directory names to ignore (repeatable).",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    out = Path(args.out).resolve()
    ignores = DEFAULT_IGNORES.union({x.strip() for x in args.ignore if x.strip()})

    files: list[Path] = []
    for p in root.rglob("*"):
        if p.is_dir():
            continue
        if should_skip(p.relative_to(root), ignores):
            continue
        files.append(p)

    files.sort()
    out.parent.mkdir(parents=True, exist_ok=True)

    with out.open("w", encoding="utf-8") as f:
        for i, file_path in enumerate(files, start=1):
            rel = file_path.relative_to(root).as_posix()
            stat = file_path.stat()
            entry = {
                "id": f"M{i:04d}",
                "path": rel,
                "classification": classify(Path(rel)),
                "source_type": "unknown",
                "size_bytes": stat.st_size,
                "mtime_epoch": int(stat.st_mtime),
                "sha256": None,
                "duplicate_of": None,
                "session_id_or_date": None,
                "confidence": 0.5,
                "notes": "",
            }
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    print(f"Wrote {len(files)} entries to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
