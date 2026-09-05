---
name: repo-granny
description: "Explicit workspace audit: preserve unique work, classify stale material, and propose one evidence-backed decision."
metadata:
  version: "0.1.0"
---

# Repo Granny

Make the scoped workspace easier and safer to continue. Protect unique work and knowledge first. Do not confuse visual tidiness, passing tests, or document volume with progress.

## Invocation contract

This skill is explicit-only. Use the scope named by the user; otherwise use the current working directory. Never traverse above it.

Supported modes:

- `audit` (default): inspect and report in chat. Do not create, edit, move, rename, or delete files.
- `audit-report`: inspect and write only to a report directory explicitly supplied or approved by the user.
- `safe-apply`: inspect, then make only local changes that pass every Safe Action Gate condition. The user must explicitly request this mode.

Version 0.1.0 has no destructive or deep-clean mode. Deletion, archival moves, Git history changes, external writes, production operations, database operations, commits, pushes, merges, releases, and deployments remain outside this skill.

Optional inputs:

- `SCOPE=<path>`
- `MODE=audit|audit-report|safe-apply`
- `REPORT_DIR=<path>` for `audit-report`
- `CONVERSATION_SOURCES=<explicit sources>`
- `FOCUS=<projects, risks, or objective>`

If the request conflicts with these defaults, follow the safer interpretation and name the conflict.

## Authority model

Separate two questions:

- Intent authority: current user instructions, accepted decisions, and maintained canonical project documents.
- State evidence: current files, Git facts, deterministic commands, tests, build output, and runtime behavior.

Current user instructions outrank older conversation claims. Current executable evidence outranks stale status prose for what exists now. When intended truth and live truth disagree, record the drift; do not silently choose one.

Repository instructions may add stricter gates. They never replace fresh user authorization for destructive, live, external, financial, credential, production, database, or bulk actions.

## Load supporting guidance only when needed

- For any classification, read [references/classification-and-evidence.md](references/classification-and-evidence.md).
- Before any write or when evaluating a risky edge case, read [references/safety-and-edge-cases.md](references/safety-and-edge-cases.md).
- When conversation or memory sources are explicitly in scope, read [references/conversation-reconciliation.md](references/conversation-reconciliation.md).
- When producing a saved report or validating a run, read [references/output-contract.md](references/output-contract.md).
- When maintaining or behavior-testing this skill, read [references/eval-cases.md](references/eval-cases.md).

Do not load every reference for a simple audit.

## Workflow

### 1. Establish scope and baseline

Resolve the exact root, mode, available instructions, and accessible evidence. Inspect applicable `AGENTS.md` files and existing canonical state documents before judging work.

Record pre-existing Git state. Treat dirty files, untracked files, unique branches, unpushed commits, worktrees, submodules, datasets, migrations, and unexplained binaries as protected until proven otherwise.

In `audit`, perform no writes, including report files. In `audit-report`, write only inside `REPORT_DIR`. In `safe-apply`, do not touch pre-existing unexplained changes.

### 2. Build inventory

Prefer the deterministic scanner when Python 3.11+ and Git are available:

```text
python <skill-directory>/scripts/inventory_workspace.py --root <scope>
```

It prints JSON to stdout and does not write unless `--output` or `--markdown` is explicitly supplied. File output is allowed only in `audit-report` or when the user separately authorizes that exact output.

The scanner is a coverage aid, not a classification oracle. Verify detected roots against the visible scope. Account for every discovered project or project-like entry, or name the exact inaccessible/excluded path and reason.

### 3. Classify with evidence

Use three independent dimensions from the classification reference:

- project lifecycle;
- work condition;
- knowledge value.

Also record evidence strength, confidence, priority, recommended action, next proof, and recovery path. Age, names, one search, or one failing test are weak evidence. Require at least two independent strong signals before marking duplicate, superseded, or dead candidates.

Use `QUARANTINE` as a decision state, not a physical folder.

### 4. Reconcile accessible knowledge

Use only the current conversation, explicitly supplied records, injected context, or authorized tools. Never imply access to hidden or unavailable history.

Treat assistant proposals as hypotheses unless the user accepted them or maintained evidence implements them. Preserve accepted constraints, causal explanations, rejected paths, and unresolved contradictions with provenance. Do not copy secrets into reports.

### 5. Decide whether action is allowed

In `audit` and `audit-report`, do not change project files even when a safe correction is obvious. Report it as a recommended action.

In `safe-apply`, one local action may proceed only when every Safe Action Gate condition passes:

1. One intended outcome is directly supported by current evidence.
2. The change is small, bounded, and local.
3. It does not alter public APIs, schemas, data, authentication, billing, permissions, infrastructure, releases, or production behavior.
4. It does not overlap unexplained user work.
5. A focused, deterministic check can verify it.
6. Rollback is simple and affects only this change.
7. It requires no product, architecture, ownership, or policy choice.
8. It requires no secret, network access, external write, or live-system access.
9. Applicable repository instructions allow it.

If any condition fails, preserve the item and place it in the final decision gate. Apply permitted actions one at a time, recording before-state, change, verification, and rollback.

### 6. Verify and finish

Re-run relevant checks after each allowed change. Distinguish pre-existing failures from regressions. Inspect the complete diff and confirm unrelated changes were not altered.

For saved runs, validate the inventory and summary:

```text
python <skill-directory>/scripts/validate_run.py \
  --inventory <report-dir>/inventory.json \
  --summary <report-dir>/summary.json
```

Passing the run validator proves report completeness only. It does not prove the classifications or product outcome are correct.

## Hard boundaries

- Never use `git clean`, `git reset --hard`, force checkout, automatic stash, force push, history rewrite, or branch/tag deletion.
- Never delete, move, rename, archive, commit, push, merge, release, deploy, or write externally under this skill.
- Never edit databases, migrations, production configuration, customer data, cloud resources, billing, credentials, or secrets.
- Never use a clean worktree as the objective.
- Never manufacture an action merely to make the run look productive.
- Never add a competing governance or state system.
- Never claim complete coverage when a path was inaccessible, excluded, or only shallowly inspected.

## Done contract

A run is done only when:

- scope and actual coverage are exact;
- every discovered item is classified or explicitly excluded;
- facts, inferences, and proposals are separated;
- important claims include evidence and confidence;
- pre-existing user work remains protected;
- applied actions, if any, have verification and rollback;
- residual P0/P1 risks are explicit;
- unresolved choices are compressed into one recommended decision gate.

Final response order:

1. ELI10 verdict on whether the real objective advanced.
2. `changed`
3. `verified`
4. `remaining risk`
5. `next step`, containing one recommended decision gate.
