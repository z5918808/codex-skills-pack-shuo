from __future__ import annotations

import copy
import sys
import unittest
from pathlib import Path


SKILL_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL_ROOT / "scripts"))

import validate_run as validator  # noqa: E402


def valid_documents() -> tuple[dict, dict]:
    inventory = {
        "schema": "repo_granny.inventory.v1",
        "root": str(SKILL_ROOT),
        "coverage": [
            {"item_id": "scope:.", "path": ".", "kind": "scope_root", "accessible": True}
        ],
    }
    summary = {
        "schema": "repo_granny.summary.v1",
        "run_id": "20260824T000000Z",
        "mode": "audit-report",
        "inventory_root": str(SKILL_ROOT),
        "coverage": {"discovered": 1, "classified": 1, "inaccessible": 0, "excluded": 0},
        "findings": [
            {
                "item_id": "scope:.",
                "lifecycle": "ACTIVE_MAINLINE",
                "condition": "HEALTHY",
                "knowledge_value": "REFERENCE_KNOWLEDGE",
                "confidence": "HIGH",
                "priority": "P2",
                "recommended_action": "KEEP",
                "evidence": [
                    {"strength": "DIRECT", "source": "fixture", "claim": "The scope exists."}
                ],
                "next_proof": "Confirm its consumer.",
                "recovery": "No change was applied.",
            }
        ],
        "actions": [],
        "decision_gate": {
            "question": "What should happen next?",
            "recommendation": "Keep the current scope.",
            "reason": "The fixture is healthy.",
        },
    }
    return inventory, summary


class ValidatorTests(unittest.TestCase):
    def test_valid_report_passes(self) -> None:
        inventory, summary = valid_documents()
        self.assertEqual([], validator.validate(inventory, summary))

    def test_missing_classification_fails(self) -> None:
        inventory, summary = valid_documents()
        summary["findings"] = []
        summary["coverage"]["classified"] = 0
        errors = validator.validate(inventory, summary)
        self.assertTrue(any("lack findings" in error for error in errors))

    def test_audit_rejects_changed_action(self) -> None:
        inventory, summary = valid_documents()
        summary["mode"] = "audit"
        summary["actions"] = [
            {
                "action_id": "a1",
                "item_id": "scope:.",
                "description": "Changed a file.",
                "changed": True,
                "gate_passed": True,
                "destructive": False,
                "explicit_authorization": False,
                "verification": ["focused test passed"],
                "rollback": "Revert this patch.",
            }
        ]
        errors = validator.validate(inventory, summary)
        self.assertTrue(any("forbidden in audit mode" in error for error in errors))

    def test_destructive_action_is_always_rejected(self) -> None:
        inventory, summary = valid_documents()
        summary["mode"] = "safe-apply"
        summary["actions"] = [
            {
                "action_id": "a1",
                "item_id": "scope:.",
                "description": "Delete a file.",
                "changed": True,
                "gate_passed": True,
                "destructive": True,
                "explicit_authorization": True,
                "verification": ["file absent"],
                "rollback": "Restore the copy.",
            }
        ]
        errors = validator.validate(inventory, summary)
        self.assertTrue(any("forbidden in v0.1.0" in error for error in errors))

    def test_safe_apply_requires_verification_and_rollback(self) -> None:
        inventory, summary = valid_documents()
        summary["mode"] = "safe-apply"
        action = {
            "action_id": "a1",
            "item_id": "scope:.",
            "description": "Repair a pointer.",
            "changed": True,
            "gate_passed": True,
            "destructive": False,
            "explicit_authorization": False,
            "verification": [],
            "rollback": "",
        }
        summary["actions"] = [copy.deepcopy(action)]
        errors = validator.validate(inventory, summary)
        self.assertTrue(any("verification" in error for error in errors))
        self.assertTrue(any("rollback" in error for error in errors))

    def test_action_boolean_fields_are_required(self) -> None:
        inventory, summary = valid_documents()
        summary["actions"] = [
            {
                "action_id": "a1",
                "item_id": "scope:.",
                "description": "A proposed action.",
                "changed": False,
            }
        ]
        errors = validator.validate(inventory, summary)
        self.assertTrue(any("gate_passed must be a boolean" in error for error in errors))
        self.assertTrue(any("destructive must be a boolean" in error for error in errors))
        self.assertTrue(any("explicit_authorization must be a boolean" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
