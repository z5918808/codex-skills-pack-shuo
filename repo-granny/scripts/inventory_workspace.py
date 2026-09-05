#!/usr/bin/env python3
"""Deterministic, read-only workspace inventory for Repo Granny."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Any, Iterable


SCHEMA = "repo_granny.inventory.v1"
PROJECT_MARKERS = {
    ".git",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "package.json",
    "pnpm-workspace.yaml",
    "Cargo.toml",
    "go.mod",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "Gemfile",
    "composer.json",
    "mix.exs",
    "__manifest__.py",
}
PROJECT_SUFFIXES = {".sln", ".csproj", ".fsproj", ".xcodeproj"}
EXCLUDED_DIRS = {
    ".git",
    ".mypy_cache",
    ".pytest_cache",
    ".ruff_cache",
    ".tox",
    ".venv",
    "__pycache__",
    "node_modules",
    "venv",
}
SENSITIVE_PATTERNS = (
    re.compile(r"^\.env(?:\..+)?$", re.IGNORECASE),
    re.compile(r"^(?:id_rsa|id_ed25519)$", re.IGNORECASE),
    re.compile(r".*\.(?:pem|key|p12|pfx)$", re.IGNORECASE),
    re.compile(r"^(?:credentials?|secrets?)(?:\..+)?$", re.IGNORECASE),
)


def utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace(
        "+00:00", "Z"
    )


def relative_path(path: Path, root: Path) -> str:
    if path == root:
        return "."
    return path.relative_to(root).as_posix()


def item_id(path: Path, root: Path) -> str:
    rel = relative_path(path, root)
    return "scope:." if rel == "." else f"path:{rel}"


def safe_scandir(path: Path) -> tuple[list[os.DirEntry[str]], str | None]:
    try:
        with os.scandir(path) as iterator:
            return sorted(iterator, key=lambda entry: entry.name.casefold()), None
    except OSError as exc:
        return [], f"{exc.__class__.__name__}: {exc}"


def detect_markers(entries: Iterable[os.DirEntry[str]]) -> list[str]:
    markers: list[str] = []
    for entry in entries:
        name = entry.name
        if name in PROJECT_MARKERS or Path(name).suffix.lower() in PROJECT_SUFFIXES:
            markers.append(name)
    return sorted(set(markers), key=str.casefold)


def looks_sensitive(name: str) -> bool:
    return any(pattern.fullmatch(name) for pattern in SENSITIVE_PATTERNS)


def find_sensitive_names(root: Path, max_depth: int = 2) -> list[str]:
    found: list[str] = []

    def walk(current: Path, depth: int) -> None:
        if depth > max_depth:
            return
        entries, _ = safe_scandir(current)
        for entry in entries:
            entry_path = Path(entry.path)
            if entry.is_symlink():
                continue
            if entry.is_file(follow_symlinks=False) and looks_sensitive(entry.name):
                found.append(relative_path(entry_path, root))
            elif (
                entry.is_dir(follow_symlinks=False)
                and entry.name not in EXCLUDED_DIRS
                and depth < max_depth
            ):
                walk(entry_path, depth + 1)

    walk(root, 0)
    return sorted(set(found), key=str.casefold)


def redact_remote(value: str) -> str:
    value = value.strip()
    value = re.sub(r"(://)[^/@\s]+@", r"\1<redacted>@", value)
    if "://" in value:
        value = value.split("#", 1)[0].split("?", 1)[0]
    return value


def git_command(root: Path, *args: str) -> tuple[str | None, str | None]:
    env = os.environ.copy()
    env["GIT_OPTIONAL_LOCKS"] = "0"
    try:
        run = subprocess.run(
            ["git", "-C", str(root), *args],
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            env=env,
        )
    except OSError as exc:
        return None, f"{exc.__class__.__name__}: {exc}"
    if run.returncode != 0:
        message = (run.stderr or run.stdout).strip()
        return None, message or f"git exited {run.returncode}"
    return run.stdout.strip(), None


def inspect_git(root: Path) -> dict[str, Any]:
    result: dict[str, Any] = {"available": False, "errors": []}
    inside, error = git_command(root, "rev-parse", "--is-inside-work-tree")
    if error or inside != "true":
        if error:
            result["errors"].append(error)
        return result

    result["available"] = True
    commands = {
        "root": ("rev-parse", "--show-toplevel"),
        "head": ("rev-parse", "HEAD"),
        "tree": ("rev-parse", "HEAD^{tree}"),
        "branch": ("branch", "--show-current"),
        "last_commit_at": ("log", "-1", "--format=%cI"),
        "origin": ("remote", "get-url", "origin"),
    }
    for key, command in commands.items():
        value, command_error = git_command(root, *command)
        if command_error:
            if key not in {"origin", "head", "tree", "last_commit_at"}:
                result["errors"].append(f"{key}: {command_error}")
            result[key] = None
        else:
            result[key] = redact_remote(value) if key == "origin" else value or None

    status, status_error = git_command(
        root, "status", "--porcelain=v2", "--branch", "--untracked-files=normal"
    )
    counts = {"staged": 0, "unstaged": 0, "untracked": 0, "conflicted": 0}
    ahead = behind = 0
    upstream = None
    if status_error:
        result["errors"].append(f"status: {status_error}")
    else:
        for line in status.splitlines():
            if line.startswith("# branch.upstream "):
                upstream = line.removeprefix("# branch.upstream ").strip() or None
            elif line.startswith("# branch.ab "):
                match = re.search(r"\+(\d+)\s+-(\d+)", line)
                if match:
                    ahead, behind = int(match.group(1)), int(match.group(2))
            elif line.startswith("? "):
                counts["untracked"] += 1
            elif line.startswith("u "):
                counts["conflicted"] += 1
            elif line.startswith(("1 ", "2 ")) and len(line) >= 4:
                xy = line[2:4]
                if xy[0] != ".":
                    counts["staged"] += 1
                if xy[1] != ".":
                    counts["unstaged"] += 1

    result.update(
        {
            "upstream": upstream,
            "ahead": ahead,
            "behind": behind,
            "status_counts": counts,
            "dirty": any(counts.values()),
        }
    )

    worktrees, worktree_error = git_command(root, "worktree", "list", "--porcelain")
    result["worktree_count"] = (
        sum(1 for line in worktrees.splitlines() if line.startswith("worktree "))
        if worktrees is not None
        else None
    )
    if worktree_error:
        result["errors"].append(f"worktrees: {worktree_error}")
    return result


def make_coverage(
    path: Path,
    root: Path,
    kind: str,
    accessible: bool = True,
    reason: str | None = None,
) -> dict[str, Any]:
    entry: dict[str, Any] = {
        "item_id": item_id(path, root),
        "path": relative_path(path, root),
        "kind": kind,
        "accessible": accessible,
    }
    if reason:
        entry["reason"] = reason
    return entry


def build_inventory(root: Path, max_depth: int = 4) -> dict[str, Any]:
    root = root.resolve(strict=True)
    if not root.is_dir():
        raise ValueError(f"Scope is not a directory: {root}")

    coverage_by_id: dict[str, dict[str, Any]] = {}
    projects_by_id: dict[str, dict[str, Any]] = {}
    errors: list[dict[str, str]] = []

    def add_coverage(entry: dict[str, Any]) -> None:
        existing = coverage_by_id.get(entry["item_id"])
        if existing is None:
            coverage_by_id[entry["item_id"]] = entry
            return
        if entry["accessible"] is False:
            coverage_by_id[entry["item_id"]] = entry
            return
        if entry["kind"] == "project" and existing["kind"] in {
            "top_level_directory",
            "scope_root",
        }:
            upgraded = dict(existing)
            upgraded["kind"] = "project" if existing["kind"] != "scope_root" else "scope_root"
            coverage_by_id[entry["item_id"]] = upgraded

    def add_project(path: Path, markers: list[str], kind: str) -> None:
        project_id = item_id(path, root)
        git = inspect_git(path) if ".git" in markers else {"available": False, "errors": []}
        projects_by_id[project_id] = {
            "item_id": project_id,
            "path": relative_path(path, root),
            "kind": kind,
            "markers": markers,
            "git": git,
            "sensitive_file_names": find_sensitive_names(path),
        }

    def walk(current: Path, depth: int, top_level: bool = False) -> None:
        entries, scan_error = safe_scandir(current)
        current_kind = "scope_root" if current == root else "project"
        if scan_error:
            add_coverage(make_coverage(current, root, current_kind, False, scan_error))
            errors.append({"path": relative_path(current, root), "error": scan_error})
            return

        markers = detect_markers(entries)
        if current == root:
            add_coverage(make_coverage(current, root, "scope_root"))
        elif markers:
            add_coverage(make_coverage(current, root, "project"))
        if markers:
            add_project(current, markers, "repository" if ".git" in markers else "project_unit")

        if depth >= max_depth:
            return

        for entry in entries:
            path = Path(entry.path)
            rel_depth = depth + 1
            try:
                is_symlink = entry.is_symlink()
                is_dir = entry.is_dir(follow_symlinks=False)
                is_file = entry.is_file(follow_symlinks=False)
            except OSError as exc:
                reason = f"{exc.__class__.__name__}: {exc}"
                add_coverage(make_coverage(path, root, "inaccessible", False, reason))
                errors.append({"path": relative_path(path, root), "error": reason})
                continue

            if is_symlink:
                add_coverage(
                    make_coverage(path, root, "symlink", True, "not followed by default")
                )
                continue

            if is_dir and entry.name in EXCLUDED_DIRS:
                if current == root or top_level:
                    add_coverage(
                        make_coverage(
                            path,
                            root,
                            "excluded",
                            True,
                            "default dependency/cache boundary",
                        )
                    )
                continue

            if current == root:
                kind = "top_level_directory" if is_dir else "top_level_file"
                add_coverage(make_coverage(path, root, kind))

            if is_dir:
                walk(path, rel_depth, top_level=(current == root))
            elif is_file and current != root:
                continue

    walk(root, 0)
    coverage = sorted(coverage_by_id.values(), key=lambda item: item["path"].casefold())
    projects = sorted(projects_by_id.values(), key=lambda item: item["path"].casefold())
    return {
        "schema": SCHEMA,
        "generated_at": utc_now(),
        "root": str(root),
        "options": {"max_depth": max_depth, "follow_links": False},
        "coverage": coverage,
        "projects": projects,
        "errors": sorted(errors, key=lambda item: item["path"].casefold()),
    }


def render_markdown(inventory: dict[str, Any]) -> str:
    lines = [
        "# Repo Granny Inventory",
        "",
        f"- Root: `{inventory['root']}`",
        f"- Generated: `{inventory['generated_at']}`",
        f"- Coverage entries: {len(inventory['coverage'])}",
        f"- Detected projects: {len(inventory['projects'])}",
        f"- Access errors: {len(inventory['errors'])}",
        "",
        "| Path | Kind | Accessible | Project markers |",
        "|---|---|---:|---|",
    ]
    projects = {item["item_id"]: item for item in inventory["projects"]}
    for item in inventory["coverage"]:
        markers = ", ".join(projects.get(item["item_id"], {}).get("markers", []))
        lines.append(
            f"| `{item['path']}` | {item['kind']} | {str(item['accessible']).lower()} | {markers} |"
        )
    lines.append("")
    return "\n".join(lines)


def write_utf8(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding="utf-8", newline="\n")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", required=True, help="Exact workspace scope")
    parser.add_argument("--max-depth", type=int, default=4, choices=range(1, 9))
    parser.add_argument("--output", help="Optional JSON output path")
    parser.add_argument("--markdown", help="Optional Markdown coverage output path")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    try:
        inventory = build_inventory(Path(args.root), args.max_depth)
    except (OSError, ValueError) as exc:
        print(f"inventory error: {exc}", file=sys.stderr)
        return 2

    payload = json.dumps(inventory, ensure_ascii=False, indent=2, sort_keys=True) + "\n"
    if args.output:
        write_utf8(Path(args.output), payload)
    else:
        sys.stdout.write(payload)
    if args.markdown:
        write_utf8(Path(args.markdown), render_markdown(inventory))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
