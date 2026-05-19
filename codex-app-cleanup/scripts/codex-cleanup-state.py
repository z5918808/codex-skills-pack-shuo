#!/usr/bin/env python3
"""SQLite state helper for codex-cleanup.ps1.

Keeps file moves and Codex's state database in sync.
"""

from __future__ import annotations

import argparse
import json
import re
import sqlite3
import time
from datetime import datetime, timedelta
from pathlib import Path


def read_text_compat(path: Path) -> str:
    data = path.read_bytes()
    errors: list[str] = []
    for encoding in ("utf-8", "utf-8-sig", "mbcs", "cp950", "big5"):
        try:
            return data.decode(encoding)
        except LookupError:
            continue
        except UnicodeDecodeError as exc:
            errors.append(f"{encoding}: {exc}")
    raise UnicodeDecodeError(
        "cleanup-manifest",
        data,
        0,
        min(len(data), 1),
        "could not decode manifest with utf-8/mbcs/cp950/big5; " + " | ".join(errors),
    )


def read_manifest(path: Path) -> list[dict]:
    rows: list[dict] = []
    if not path.exists():
        return rows
    for line in read_text_compat(path).splitlines():
        if not line.strip():
            continue
        rows.append(json.loads(line))
    return rows


def connect_db(path: Path, readonly: bool) -> sqlite3.Connection:
    if readonly:
        return sqlite3.connect(f"file:{path.as_posix()}?mode=ro", uri=True)
    return sqlite3.connect(path)


def inspect_state(db_path: Path) -> dict:
    if not db_path.exists():
        return {"state_db_exists": False}
    conn = connect_db(db_path, readonly=True)
    conn.row_factory = sqlite3.Row
    out = {"state_db_exists": True}
    tables = [
        row[0]
        for row in conn.execute(
            "select name from sqlite_master where type='table' and name not like 'sqlite_%'"
        )
    ]
    out["tables"] = tables
    if "threads" not in tables:
        conn.close()
        return out

    cols = [row[1] for row in conn.execute("pragma table_info(threads)")]
    out["threads_columns"] = cols
    out["threads_total"] = conn.execute("select count(*) from threads").fetchone()[0]
    if "archived_at" in cols:
        out["threads_archived_at_not_null"] = conn.execute(
            "select count(*) from threads where archived_at is not null"
        ).fetchone()[0]
        out["threads_archived_at_null"] = conn.execute(
            "select count(*) from threads where archived_at is null"
        ).fetchone()[0]
    if "archived" in cols:
        out["threads_archived_flag_1"] = conn.execute(
            "select count(*) from threads where archived=1"
        ).fetchone()[0]
        out["threads_archived_flag_0_or_null"] = conn.execute(
            "select count(*) from threads where archived=0 or archived is null"
        ).fetchone()[0]

    if "rollout_path" in cols:
        rows = conn.execute(
            "select id, rollout_path, archived_at, archived from threads where rollout_path is not null"
        ).fetchall()
        missing = 0
        active_missing = 0
        archived_session_paths = 0
        for row in rows:
            rollout = row["rollout_path"]
            exists = Path(rollout).exists()
            if not exists:
                missing += 1
            if "archived_sessions" in rollout:
                archived_session_paths += 1
            if row["archived_at"] is None and (row["archived"] in (None, 0)) and not exists:
                active_missing += 1
        out["rollout_rows"] = len(rows)
        out["missing_rollout_paths"] = missing
        out["active_missing_rollout_paths"] = active_missing
        out["archived_sessions_rollout_paths"] = archived_session_paths
    conn.close()
    return out


def write_restore_script(path: Path, db_path: Path, manifest_path: Path) -> None:
    path.write_text(
        f'''#!/usr/bin/env python3
import json
import shutil
import sqlite3
from pathlib import Path

manifest = Path(r"{manifest_path}")
db_path = Path(r"{db_path}")
conn = sqlite3.connect(db_path)
conn.execute("pragma busy_timeout=10000")
for line in manifest.read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    rec = json.loads(line)
    thread_id = rec.get("thread_id")
    original = Path(rec.get("original_path", ""))
    archived = Path(rec.get("archive_path", ""))
    if archived.exists() and original:
        original.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(archived), str(original))
    if thread_id:
        conn.execute(
            "update threads set rollout_path=?, archived=0, archived_at=NULL where id=?",
            (str(original), thread_id),
        )
conn.commit()
conn.close()
print("restored sessions from manifest")
''',
        encoding="utf-8",
    )


def read_pinned_thread_ids(codex_home: Path) -> set[str]:
    global_state = codex_home / ".codex-global-state.json"
    if not global_state.exists():
        return set()
    try:
        raw = read_text_compat(global_state)
    except UnicodeDecodeError:
        return set()
    match = re.search(r'"pinned-thread-ids"\s*:\s*\[(?P<items>.*?)\]', raw, re.S)
    if not match:
        return set()
    return set(re.findall(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", match.group("items")))


def write_missing_active_restore_script(path: Path, db_path: Path, manifest_path: Path) -> None:
    path.write_text(
        f'''#!/usr/bin/env python3
import json
import sqlite3
from pathlib import Path

manifest = Path(r"{manifest_path}")
db_path = Path(r"{db_path}")
conn = sqlite3.connect(db_path)
conn.execute("pragma busy_timeout=10000")
for line in manifest.read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    rec = json.loads(line)
    thread_id = rec.get("thread_id")
    if thread_id:
        conn.execute(
            "update threads set archived=0, archived_at=NULL where id=?",
            (thread_id,),
        )
conn.commit()
conn.close()
print("restored missing active thread rows from manifest")
''',
        encoding="utf-8",
    )


def write_rewrite_rollout_restore_script(path: Path, db_path: Path, manifest_path: Path) -> None:
    path.write_text(
        f'''#!/usr/bin/env python3
import json
import sqlite3
from pathlib import Path

manifest = Path(r"{manifest_path}")
db_path = Path(r"{db_path}")
conn = sqlite3.connect(db_path)
conn.execute("pragma busy_timeout=10000")
for line in manifest.read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    rec = json.loads(line)
    thread_id = rec.get("thread_id")
    old_rollout_path = rec.get("old_rollout_path")
    if thread_id and old_rollout_path:
        conn.execute(
            "update threads set rollout_path=? where id=?",
            (old_rollout_path, thread_id),
        )
conn.commit()
conn.close()
print("restored rollout_path prefix rewrite from manifest")
''',
        encoding="utf-8",
    )


def rewrite_rollout_prefix(
    db_path: Path,
    old_prefix: str,
    new_prefix: str,
    apply: bool,
    manifest_path: Path | None,
    restore_script: Path | None,
) -> dict:
    out = {
        "state_db_exists": db_path.exists(),
        "apply": apply,
        "old_prefix": old_prefix,
        "new_prefix": new_prefix,
        "candidate_rows": 0,
        "db_rows_updated": 0,
        "manifest_path": str(manifest_path) if manifest_path else None,
    }
    if not db_path.exists():
        return out

    old_norm = old_prefix.rstrip("\\/")
    new_norm = new_prefix.rstrip("\\/")
    old_norm_lower = old_norm.lower()
    conn = connect_db(db_path, readonly=not apply)
    conn.row_factory = sqlite3.Row
    conn.execute("pragma busy_timeout=10000")
    rows = conn.execute(
        "select id, rollout_path, archived, archived_at from threads where rollout_path is not null"
    ).fetchall()

    candidates: list[dict] = []
    for row in rows:
        rollout_path = str(row["rollout_path"])
        if not rollout_path.lower().startswith(old_norm_lower):
            continue
        suffix = rollout_path[len(old_norm):].lstrip("\\/")
        new_rollout_path = str(Path(new_norm) / suffix) if suffix else new_norm
        candidates.append(
            {
                "thread_id": row["id"],
                "old_rollout_path": rollout_path,
                "new_rollout_path": new_rollout_path,
                "archived": row["archived"],
                "archived_at": row["archived_at"],
            }
        )

    out["candidate_rows"] = len(candidates)
    if manifest_path is not None:
        manifest_path.parent.mkdir(parents=True, exist_ok=True)
        with manifest_path.open("w", encoding="utf-8") as handle:
            for rec in candidates:
                handle.write(json.dumps(rec, ensure_ascii=False) + "\n")

    if apply and candidates:
        for rec in candidates:
            cur = conn.execute(
                "update threads set rollout_path=? where id=?",
                (rec["new_rollout_path"], rec["thread_id"]),
            )
            out["db_rows_updated"] += cur.rowcount
        conn.commit()
        try:
            conn.execute("pragma wal_checkpoint(truncate)")
        except sqlite3.Error as exc:
            out["wal_checkpoint_skipped"] = str(exc)
        if restore_script is not None and manifest_path is not None:
            restore_script.parent.mkdir(parents=True, exist_ok=True)
            write_rewrite_rollout_restore_script(restore_script, db_path, manifest_path)
            out["restore_script"] = str(restore_script)

    conn.close()
    out["post_inspect"] = inspect_state(db_path)
    return out


def archive_missing_active(
    codex_home: Path,
    db_path: Path,
    older_than_days: int,
    apply: bool,
    manifest_path: Path | None,
    restore_script: Path | None,
) -> dict:
    out = {
        "state_db_exists": db_path.exists(),
        "apply": apply,
        "archive_missing_active_older_than_days": older_than_days,
        "candidate_rows": 0,
        "pinned_skipped": 0,
        "db_rows_updated": 0,
        "manifest_path": str(manifest_path) if manifest_path else None,
    }
    if not db_path.exists():
        return out

    cutoff = int((datetime.now() - timedelta(days=older_than_days)).timestamp())
    pinned = read_pinned_thread_ids(codex_home)
    conn = connect_db(db_path, readonly=not apply)
    conn.row_factory = sqlite3.Row
    conn.execute("pragma busy_timeout=10000")
    rows = conn.execute(
        """
        select id, title, cwd, rollout_path, archived, archived_at, updated_at
        from threads
        where rollout_path is not null
          and archived_at is null
          and (archived is null or archived=0)
        """
    ).fetchall()

    candidates: list[dict] = []
    for row in rows:
        thread_id = row["id"]
        updated_at = row["updated_at"]
        if thread_id in pinned:
            out["pinned_skipped"] += 1
            continue
        if updated_at is not None and int(updated_at) >= cutoff:
            continue
        rollout_path = row["rollout_path"]
        if Path(rollout_path).exists():
            continue
        candidates.append(
            {
                "thread_id": thread_id,
                "title": row["title"],
                "cwd": row["cwd"],
                "rollout_path": rollout_path,
                "updated_at": updated_at,
                "reason": "active rollout_path missing and older than cutoff",
            }
        )

    out["candidate_rows"] = len(candidates)
    if manifest_path is not None:
        manifest_path.parent.mkdir(parents=True, exist_ok=True)
        with manifest_path.open("w", encoding="utf-8") as handle:
            for rec in candidates:
                handle.write(json.dumps(rec, ensure_ascii=False) + "\n")

    if apply and candidates:
        now = int(time.time())
        for rec in candidates:
            cur = conn.execute(
                "update threads set archived=1, archived_at=? where id=?",
                (now, rec["thread_id"]),
            )
            out["db_rows_updated"] += cur.rowcount
        conn.commit()
        try:
            conn.execute("pragma wal_checkpoint(truncate)")
        except sqlite3.Error as exc:
            out["wal_checkpoint_skipped"] = str(exc)
        if restore_script is not None and manifest_path is not None:
            restore_script.parent.mkdir(parents=True, exist_ok=True)
            write_missing_active_restore_script(restore_script, db_path, manifest_path)
            out["restore_script"] = str(restore_script)

    conn.close()
    out["post_inspect"] = inspect_state(db_path)
    return out


def sync_manifest(db_path: Path, manifest_path: Path, apply: bool, restore_script: Path | None) -> dict:
    rows = read_manifest(manifest_path)
    out = {
        "manifest_path": str(manifest_path),
        "manifest_records": len(rows),
        "apply": apply,
        "archive_exists": 0,
        "thread_id_records": 0,
        "db_rows_matched": 0,
        "db_rows_updated": 0,
        "skipped_no_thread_id": 0,
        "skipped_archive_missing": 0,
    }
    if not db_path.exists():
        out["state_db_exists"] = False
        return out
    out["state_db_exists"] = True

    conn = connect_db(db_path, readonly=not apply)
    conn.execute("pragma busy_timeout=10000")
    now = int(time.time())
    for rec in rows:
        thread_id = rec.get("thread_id")
        archive_path = rec.get("archive_path")
        if not thread_id:
            out["skipped_no_thread_id"] += 1
            continue
        out["thread_id_records"] += 1
        if not archive_path or not Path(archive_path).exists():
            out["skipped_archive_missing"] += 1
            continue
        out["archive_exists"] += 1
        matched = conn.execute("select count(*) from threads where id=?", (thread_id,)).fetchone()[0]
        out["db_rows_matched"] += matched
        if apply and matched:
            cur = conn.execute(
                "update threads set rollout_path=?, archived=1, archived_at=? where id=?",
                (archive_path, now, thread_id),
            )
            out["db_rows_updated"] += cur.rowcount
    if apply:
        conn.commit()
        try:
            conn.execute("pragma wal_checkpoint(truncate)")
        except sqlite3.Error as exc:
            out["wal_checkpoint_skipped"] = str(exc)
        try:
            conn.execute("pragma optimize")
        except sqlite3.Error as exc:
            out["sqlite_optimize_skipped"] = str(exc)
        if restore_script is not None:
            restore_script.parent.mkdir(parents=True, exist_ok=True)
            write_restore_script(restore_script, db_path, manifest_path)
            out["restore_script"] = str(restore_script)
    conn.close()
    out["post_inspect"] = inspect_state(db_path)
    return out


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--codex-home", required=True)
    parser.add_argument("--manifest")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--inspect", action="store_true")
    parser.add_argument("--restore-script")
    parser.add_argument("--archive-missing-active-older-than-days", type=int)
    parser.add_argument("--missing-active-manifest")
    parser.add_argument("--rewrite-rollout-prefix-old")
    parser.add_argument("--rewrite-rollout-prefix-new")
    parser.add_argument("--rewrite-rollout-prefix-manifest")
    args = parser.parse_args()

    codex_home = Path(args.codex_home)
    db_path = codex_home / "state_5.sqlite"
    if args.inspect:
        print(json.dumps(inspect_state(db_path), ensure_ascii=False))
        return 0
    if args.archive_missing_active_older_than_days is not None:
        restore_script = Path(args.restore_script) if args.restore_script else None
        manifest_path = Path(args.missing_active_manifest) if args.missing_active_manifest else None
        result = archive_missing_active(
            codex_home,
            db_path,
            args.archive_missing_active_older_than_days,
            args.apply,
            manifest_path,
            restore_script,
        )
        print(json.dumps(result, ensure_ascii=False))
        return 0
    if args.rewrite_rollout_prefix_old or args.rewrite_rollout_prefix_new:
        if not args.rewrite_rollout_prefix_old or not args.rewrite_rollout_prefix_new:
            raise SystemExit("--rewrite-rollout-prefix-old and --rewrite-rollout-prefix-new must be used together")
        restore_script = Path(args.restore_script) if args.restore_script else None
        manifest_path = Path(args.rewrite_rollout_prefix_manifest) if args.rewrite_rollout_prefix_manifest else None
        result = rewrite_rollout_prefix(
            db_path,
            args.rewrite_rollout_prefix_old,
            args.rewrite_rollout_prefix_new,
            args.apply,
            manifest_path,
            restore_script,
        )
        print(json.dumps(result, ensure_ascii=False))
        return 0
    if not args.manifest:
        raise SystemExit("--manifest is required unless --inspect is used")
    restore_script = Path(args.restore_script) if args.restore_script else None
    result = sync_manifest(db_path, Path(args.manifest), args.apply, restore_script)
    print(json.dumps(result, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
