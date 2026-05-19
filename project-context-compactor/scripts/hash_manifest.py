#!/usr/bin/env python3
import argparse
import hashlib
import json
from pathlib import Path


def sha256_file(path: Path, chunk_size: int = 1024 * 1024) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description="Fill sha256 for MANIFEST.jsonl entries.")
    parser.add_argument("--root", default=".", help="Project root used for relative paths.")
    parser.add_argument("--manifest", default="_ctx/MANIFEST.jsonl", help="Manifest JSONL input.")
    parser.add_argument("--out", default="", help="Output JSONL path. Default: overwrite --manifest.")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    manifest_path = Path(args.manifest).resolve()
    out_path = Path(args.out).resolve() if args.out else manifest_path

    if not manifest_path.exists():
        raise FileNotFoundError(f"Manifest not found: {manifest_path}")

    rows: list[dict] = []
    hashed = 0
    missing = 0

    with manifest_path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            row = json.loads(line)
            rel = row.get("path")
            abs_path = (root / rel).resolve() if rel else None
            if abs_path and abs_path.exists() and abs_path.is_file():
                row["sha256"] = sha256_file(abs_path)
                hashed += 1
            else:
                row["sha256"] = None
                row["notes"] = (row.get("notes") or "") + " [missing-at-hash-time]"
                missing += 1
            rows.append(row)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", encoding="utf-8") as f:
        for row in rows:
            f.write(json.dumps(row, ensure_ascii=False) + "\n")

    print(f"Hashed: {hashed}, Missing: {missing}, Output: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
