---
name: serious-project-cleanup
description: Use when repo clutter, stale agent artifacts, duplicate reports, or unclear canonical state blocks meaningful execution.
---

# Serious Project Cleanup

## Outcome

Reduce the active workspace to a smaller, truthful execution surface while preserving user work, evidence, recovery, and separate workstreams.

This is not ordinary code cleanup. Use only when project clutter itself is the blocker. For a deletion-only judgment use `repo-cleanup-judge`; for `_ctx` compaction use `project-context-compactor`.

## Start Read-Only

Inspect the cheapest decisive evidence:

- repo instructions, current status, and active workstreams;
- git status and existing user changes;
- top-level tree, largest areas, generated-output folders, and known caches;
- references to candidate paths from code, docs, manifests, hashes, and handoffs;
- authorship and workstream ownership where context files are involved.

Do not create a cleanup ceremony before this inventory shows a real action.

## Classification

Assign each candidate one bucket:

| Bucket | Meaning | Default action |
|---|---|---|
| `keep-active` | current truth, active code/data, user work, referenced evidence | leave in place |
| `archive` | superseded but uniquely useful provenance | preserve identity and recovery |
| `quarantine` | value, authorship, ownership, or references are uncertain | isolate only with authorization |
| `delete-candidate` | proven duplicate, disposable generated output, or rebuildable cache | list; delete only when authorized |
| `ignore` | out of scope or low value to touch | leave alone |

“Old,” “large,” and “agent-generated” are not sufficient reasons to move or delete.

## Protected by Default

Do not rewrite, move, or delete without exact authorization:

- user-authored or mixed-authorship notes, specs, drafts, and decisions;
- another active task or workstream’s context and handoff;
- unknown dirty-worktree changes;
- source, tests, manifests, lockfiles, CI, migrations, databases, audit logs, credentials, or production data;
- artifacts referenced by path, run ID, hash, report, or recovery workflow;
- anything whose only remaining copy or writer is unclear.

Unknown ownership means preserve, not delete.

## Workstream and Evidence Boundaries

- Keep separate tasks and workstreams separate; never flatten them into one generic summary.
- A file stale to the current task may still be active elsewhere.
- Do not overwrite an append-only or hash-addressed artifact.
- If an artifact must move, preserve original path, destination, identity, reason, and recovery instruction.
- Archive before removing the active copy when provenance matters.

## Minimal Cleanup Matrix

Record only actionable candidates:

```text
path | owner/workstream | authorship | references | bucket | action | reason | recovery | confirmation
```

If no safe action exists, the matrix and one next probe are enough. Do not manufacture work.

## Execution Rules

1. Resolve the narrowest high-impact clutter first.
2. Verify absolute target paths and scope before recursive move or delete.
3. Preserve existing dirty changes and unrelated files.
4. Prefer reversible archive or quarantine when uncertainty remains.
5. Permanent deletion requires explicit confirmation for the named scope.
6. Create a manifest only when files actually move, archive, quarantine, or delete; do not create one for a read-only review.
7. Do not rewrite user material. For mixed or unclear authorship, create a proposed distilled file instead.
8. Stop when cleanup no longer improves the next execution step.

For every changed item, record:

- original path and disposition;
- owner or workstream;
- reason and evidence;
- destination or deletion authorization;
- recovery path when applicable.

## Verification

After changes:

- compare the same bounded file inventory before and after;
- confirm git status preserved unrelated work;
- confirm canonical files and active handoffs still exist;
- check that referenced paths and manifests still resolve;
- restore or rebuild one representative archived/cache item when that claim matters;
- confirm no permanent deletion exceeded authorization;
- list quarantined or unknown items and their release condition.

Report partial, not done, if recovery, references, ownership, or workstream separation cannot be verified.

## Completion

Return only high-signal results:

- active surface simplified;
- items archived, quarantined, or deleted;
- protected items left untouched;
- verification and recovery evidence;
- remaining ambiguity;
- next execution step unlocked by the cleanup.
