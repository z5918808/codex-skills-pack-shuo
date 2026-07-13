#!/usr/bin/env python3
import argparse
import json
from collections import defaultdict
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Find duplicate files using sha256 in MANIFEST.jsonl.")
    parser.add_argument("--manifest", default="_ctx/MANIFEST.jsonl", help="Manifest JSONL with sha256 field.")
    parser.add_argument("--out", default="_ctx/DUPLICATES.json", help="Output JSON report.")
    args = parser.parse_args()

    manifest = Path(args.manifest).resolve()
    out = Path(args.out).resolve()

    if not manifest.exists():
        raise FileNotFoundError(f"Manifest not found: {manifest}")

    groups: dict[str, list[dict]] = defaultdict(list)

    with manifest.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            row = json.loads(line)
            h = row.get("sha256")
            if h:
                groups[h].append(
                    {
                        "id": row.get("id"),
                        "path": row.get("path"),
                        "classification": row.get("classification"),
                    }
                )

    duplicate_groups = []
    for digest, entries in groups.items():
        if len(entries) > 1:
            canonical = entries[0]
            duplicate_groups.append(
                {
                    "sha256": digest,
                    "count": len(entries),
                    "canonical": canonical,
                    "duplicates": entries[1:],
                }
            )

    report = {
        "duplicate_group_count": len(duplicate_groups),
        "groups": duplicate_groups,
    }

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Duplicate groups: {len(duplicate_groups)} -> {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
