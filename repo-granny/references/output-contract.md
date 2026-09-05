# Output Contract

Use this contract only for `audit-report`, `safe-apply`, or explicit run validation. Plain `audit` normally reports in chat and writes no files.

## Inventory

`inventory_workspace.py` emits `repo_granny.inventory.v1` JSON. Important fields:

```json
{
  "schema": "repo_granny.inventory.v1",
  "generated_at": "2026-01-01T00:00:00Z",
  "root": "C:/absolute/scope",
  "options": {"max_depth": 4},
  "coverage": [],
  "projects": [],
  "errors": []
}
```

Each `coverage` entry has `item_id`, `path`, `kind`, `accessible`, and optional `reason`. Each project has stable `item_id`, path, markers, Git facts when available, and names of suspected sensitive files without their contents.

The inventory is observed evidence only. It does not assign lifecycle or decide deletion.

## Summary

Saved summaries use `repo_granny.summary.v1`:

```json
{
  "schema": "repo_granny.summary.v1",
  "run_id": "20260101T000000Z",
  "mode": "audit-report",
  "inventory_root": "C:/absolute/scope",
  "coverage": {
    "discovered": 1,
    "classified": 1,
    "inaccessible": 0,
    "excluded": 0
  },
  "findings": [
    {
      "item_id": "project:example",
      "lifecycle": "ACTIVE_MAINLINE",
      "condition": "HEALTHY",
      "knowledge_value": "REFERENCE_KNOWLEDGE",
      "confidence": "HIGH",
      "priority": "P2",
      "recommended_action": "KEEP",
      "evidence": [
        {
          "strength": "DIRECT",
          "source": "package manifest",
          "claim": "Current package identity exists."
        }
      ],
      "next_proof": "Confirm the active consumer.",
      "recovery": "No change was applied."
    }
  ],
  "actions": [],
  "decision_gate": {
    "question": "Which project should own the shared contract?",
    "recommendation": "Keep both until consumers are confirmed.",
    "reason": "Ownership evidence is incomplete."
  }
}
```

Allowed enum values are defined in `classification-and-evidence.md`.

## Action records

Every action entry contains:

- `action_id`;
- `item_id`;
- `description`;
- `changed` boolean;
- `gate_passed` boolean;
- `destructive` boolean;
- `explicit_authorization` boolean;
- `verification` non-empty list when `changed=true`;
- `rollback` non-empty string when `changed=true`.

In `audit` and `audit-report`, `changed` must always be false. Version 0.1.0 rejects any action with `destructive=true` even if authorization is claimed.

## Coverage rules

- `discovered` equals the number of inventory coverage entries.
- `classified` equals the number of distinct coverage `item_id` values represented in findings.
- `inaccessible` equals coverage entries with `accessible=false`.
- `excluded` equals coverage entries with `kind=excluded`.
- Every accessible, non-excluded coverage entry must have exactly one finding.
- Findings must not reference unknown item IDs.

## Decision gate

There is exactly one `decision_gate` object. It may state that no human choice is currently required, but it must still give one recommended next action. Do not emit a list of scattered approval questions.

## Validator boundary

`validate_run.py` checks schema shape, coverage accounting, enum values, evidence presence, mode/action consistency, verification, rollback, and the destructive-action ban. It cannot prove evidence truth, classification quality, product usefulness, or actual absence of side effects.
