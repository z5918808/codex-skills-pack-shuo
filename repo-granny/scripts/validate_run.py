#!/usr/bin/env python3
"""Validate Repo Granny inventory and summary contracts."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path
from typing import Any


LIFECYCLES = {
    "ACTIVE_MAINLINE",
    "ACTIVE_SIDEQUEST",
    "PARKED",
    "COMPLETED",
    "REFERENCE",
    "RAW_ARCHIVE",
    "DEAD_CANDIDATE",
    "QUARANTINE",
}
CONDITIONS = {
    "HEALTHY",
    "INCOMPLETE",
    "BLOCKED",
    "DUPLICATE_CANDIDATE",
    "ORPHANED",
    "UNSUPPORTED",
    "GENERATED",
    "CONTRADICTORY",
}
KNOWLEDGE_VALUES = {
    "MEMORY_KERNEL",
    "BREAKTHROUGH_CLUE",
    "REJECTED_PATH",
    "CONTRADICTION",
    "REFERENCE_KNOWLEDGE",
    "TRANSIENT",
}
CONFIDENCE = {"HIGH", "MEDIUM", "LOW"}
PRIORITIES = {"P0", "P1", "P2", "P3"}
ACTIONS = {
    "KEEP",
    "PROMOTE",
    "COMPLETE",
    "CONSOLIDATE",
    "DEMOTE",
    "PARK",
    "ARCHIVE_PLAN",
    "QUARANTINE",
    "DELETE_CANDIDATE",
}
EVIDENCE_STRENGTH = {"DIRECT", "STRONG", "WEAK"}
MODES = {"audit", "audit-report", "safe-apply"}


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def nonempty_string(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def normalized_path(value: str) -> str:
    return os.path.normcase(os.path.abspath(value))


def validate(inventory: Any, summary: Any) -> list[str]:
    errors: list[str] = []
    if not isinstance(inventory, dict):
        return ["inventory must be a JSON object"]
    if not isinstance(summary, dict):
        return ["summary must be a JSON object"]

    if inventory.get("schema") != "repo_granny.inventory.v1":
        errors.append("inventory.schema must be repo_granny.inventory.v1")
    if summary.get("schema") != "repo_granny.summary.v1":
        errors.append("summary.schema must be repo_granny.summary.v1")
    if not re.fullmatch(r"\d{8}T\d{6}Z", str(summary.get("run_id", ""))):
        errors.append("summary.run_id must use YYYYMMDDTHHMMSSZ")

    mode = summary.get("mode")
    if mode not in MODES:
        errors.append(f"summary.mode must be one of {sorted(MODES)}")

    inventory_root = inventory.get("root")
    summary_root = summary.get("inventory_root")
    if not nonempty_string(inventory_root) or not nonempty_string(summary_root):
        errors.append("inventory.root and summary.inventory_root must be non-empty")
    elif normalized_path(inventory_root) != normalized_path(summary_root):
        errors.append("summary.inventory_root does not match inventory.root")

    coverage = inventory.get("coverage")
    if not isinstance(coverage, list):
        coverage = []
        errors.append("inventory.coverage must be a list")
    coverage_ids: list[str] = []
    accessible_required: set[str] = set()
    inaccessible = excluded = 0
    for index, item in enumerate(coverage):
        if not isinstance(item, dict):
            errors.append(f"coverage[{index}] must be an object")
            continue
        current_id = item.get("item_id")
        if not nonempty_string(current_id):
            errors.append(f"coverage[{index}].item_id must be non-empty")
            continue
        coverage_ids.append(current_id)
        if item.get("accessible") is False:
            inaccessible += 1
        if item.get("kind") == "excluded":
            excluded += 1
        elif item.get("accessible") is True:
            accessible_required.add(current_id)
    if len(coverage_ids) != len(set(coverage_ids)):
        errors.append("inventory.coverage item_id values must be unique")

    findings = summary.get("findings")
    if not isinstance(findings, list):
        findings = []
        errors.append("summary.findings must be a list")
    finding_ids: list[str] = []
    for index, finding in enumerate(findings):
        prefix = f"findings[{index}]"
        if not isinstance(finding, dict):
            errors.append(f"{prefix} must be an object")
            continue
        current_id = finding.get("item_id")
        if not nonempty_string(current_id):
            errors.append(f"{prefix}.item_id must be non-empty")
        else:
            finding_ids.append(current_id)
            if current_id not in set(coverage_ids):
                errors.append(f"{prefix}.item_id is not present in inventory coverage")
        enum_checks = (
            ("lifecycle", LIFECYCLES),
            ("condition", CONDITIONS),
            ("knowledge_value", KNOWLEDGE_VALUES),
            ("confidence", CONFIDENCE),
            ("priority", PRIORITIES),
            ("recommended_action", ACTIONS),
        )
        for field, allowed in enum_checks:
            if finding.get(field) not in allowed:
                errors.append(f"{prefix}.{field} has an invalid value")
        evidence = finding.get("evidence")
        if not isinstance(evidence, list) or not evidence:
            errors.append(f"{prefix}.evidence must be a non-empty list")
        else:
            for evidence_index, item in enumerate(evidence):
                evidence_prefix = f"{prefix}.evidence[{evidence_index}]"
                if not isinstance(item, dict):
                    errors.append(f"{evidence_prefix} must be an object")
                    continue
                if item.get("strength") not in EVIDENCE_STRENGTH:
                    errors.append(f"{evidence_prefix}.strength is invalid")
                for field in ("source", "claim"):
                    if not nonempty_string(item.get(field)):
                        errors.append(f"{evidence_prefix}.{field} must be non-empty")
        for field in ("next_proof", "recovery"):
            if not nonempty_string(finding.get(field)):
                errors.append(f"{prefix}.{field} must be non-empty")

    if len(finding_ids) != len(set(finding_ids)):
        errors.append("summary.findings item_id values must be unique")
    missing = sorted(accessible_required - set(finding_ids))
    if missing:
        errors.append(f"accessible coverage entries lack findings: {missing}")

    coverage_summary = summary.get("coverage")
    if not isinstance(coverage_summary, dict):
        errors.append("summary.coverage must be an object")
    else:
        expected_counts = {
            "discovered": len(coverage),
            "classified": len(set(finding_ids)),
            "inaccessible": inaccessible,
            "excluded": excluded,
        }
        for field, expected in expected_counts.items():
            if coverage_summary.get(field) != expected:
                errors.append(
                    f"summary.coverage.{field} must be {expected}, got {coverage_summary.get(field)!r}"
                )

    actions = summary.get("actions")
    if not isinstance(actions, list):
        actions = []
        errors.append("summary.actions must be a list")
    action_ids: list[str] = []
    for index, action in enumerate(actions):
        prefix = f"actions[{index}]"
        if not isinstance(action, dict):
            errors.append(f"{prefix} must be an object")
            continue
        action_id = action.get("action_id")
        if not nonempty_string(action_id):
            errors.append(f"{prefix}.action_id must be non-empty")
        else:
            action_ids.append(action_id)
        if action.get("item_id") not in set(coverage_ids):
            errors.append(f"{prefix}.item_id is not present in inventory coverage")
        if not nonempty_string(action.get("description")):
            errors.append(f"{prefix}.description must be non-empty")
        for field in ("changed", "gate_passed", "destructive", "explicit_authorization"):
            if not isinstance(action.get(field), bool):
                errors.append(f"{prefix}.{field} must be a boolean")
        changed = action.get("changed") is True
        if mode in {"audit", "audit-report"} and changed:
            errors.append(f"{prefix} changes are forbidden in {mode} mode")
        if action.get("destructive") is True:
            errors.append(f"{prefix} destructive actions are forbidden in v0.1.0")
        if changed:
            if mode != "safe-apply":
                errors.append(f"{prefix} changed action requires safe-apply mode")
            if action.get("gate_passed") is not True:
                errors.append(f"{prefix}.gate_passed must be true for a changed action")
            verification = action.get("verification")
            if not isinstance(verification, list) or not verification:
                errors.append(f"{prefix}.verification must be non-empty for a changed action")
            if not nonempty_string(action.get("rollback")):
                errors.append(f"{prefix}.rollback must be non-empty for a changed action")
    if len(action_ids) != len(set(action_ids)):
        errors.append("summary.actions action_id values must be unique")

    gate = summary.get("decision_gate")
    if not isinstance(gate, dict):
        errors.append("summary.decision_gate must be one object")
    else:
        for field in ("question", "recommendation", "reason"):
            if not nonempty_string(gate.get(field)):
                errors.append(f"summary.decision_gate.{field} must be non-empty")
    return errors


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", required=True)
    parser.add_argument("--summary", required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    try:
        inventory = load_json(Path(args.inventory))
        summary = load_json(Path(args.summary))
    except (OSError, json.JSONDecodeError) as exc:
        print(json.dumps({"schema": "repo_granny.validation.v1", "valid": False, "errors": [str(exc)]}))
        return 2

    errors = validate(inventory, summary)
    print(
        json.dumps(
            {
                "schema": "repo_granny.validation.v1",
                "valid": not errors,
                "errors": errors,
            },
            ensure_ascii=False,
            indent=2,
            sort_keys=True,
        )
    )
    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main())
