---
name: repo-cleanup-judge
description: Decide whether files and directories inside a repository should be kept, moved, deleted, or ignored before cleanup. Use when a repo feels noisy, bloated, full of logs, artifacts, caches, snapshots, test junk, evidence, continuity files, runtime state, or old exports, and Codex must judge cleanup safety from live repo truth instead of guessing.
---

# Repo Cleanup Judge

Judge cleanup candidates inside a repo before deleting anything.

Do not treat "looks noisy" as enough evidence to delete. First prove what role each file plays in the live system.

## Workflow

1. Read repo truth first.
   - Look for `AGENTS.md`, startup docs, status docs, continuity files, scripts, logs, state files, and any existing cleanup or retention scripts.
   - Check current runtime state when relevant: logs, daemon state, lock files, status commands, active processes, and recent writes.
   - Prefer A-level evidence: live output, file contents, scripts, and actual paths.

2. Build a cleanup matrix before any deletion.
   - Classify each target as exactly one of:
     - `keep`: canonical truth, runtime state, user-authored history, important evidence, active fixtures
     - `move`: valuable but misplaced; should live in archive/evidence/cache elsewhere
     - `delete`: high-confidence disposable artifact, cache, duplicate export, expired temp/test output
     - `ignore`: not worth touching in this pass

3. Explain why each item falls in that bucket.
   - Tie the judgment to concrete evidence:
     - who reads it
     - who writes it
     - whether it is the only copy
     - whether it is still referenced by scripts, config, docs, or runtime
     - whether it is evidence needed for debug, audit, or rollback

4. Distinguish source-of-truth layers.
   - Typical examples:
     - continuity / handoff / project-spine / notes: usually `keep`
     - daemon state / mail state / queue state / lock-adjacent files: usually `keep` until runtime truth says otherwise
     - screenshots / html dumps / fetched json / browser traces: often `move` or time-boxed `keep`, not automatic `delete`
     - test scratch / tmp / duplicate exports / stale generated artifacts: possible `delete`
   - Never assume the category from the folder name alone.

5. Flag blockers before execution.
   - Stop if:
     - runtime says a supposedly stale file is still active
     - a file might be the only copy of important history or evidence
     - cleanup policy conflicts with current docs or startup flow
     - namespaces or storage roots are split and not yet canonicalized

6. Only then propose action.
   - If the user only asked for judgment, stop after the matrix.
   - If the user also asked to clean, execute only the `delete` bucket with high confidence.
   - For risky items, prefer `move to archive/quarantine` over hard delete.

## Required Output

Always return these sections:

1. `目前判斷`
2. `Keep / Move / Delete / Ignore Matrix`
3. `已驗證`
4. `風險 / blocker`
5. `建議下一步`
6. `百分比現況`

Use concise bullets. For each matrix row, include:

- path
- bucket
- confidence
- reason

## Non-Negotiables

- Do not delete first and rationalize later.
- Do not trust old conversation memory over live repo truth.
- Do not call something safe just because it is under `.cache`, `.tmp`, `.project-memory`, `logs`, `artifacts`, or `output`.
- Do not treat `running` state as equivalent to healthy state.
- Do not rebuild indexes or storage blindly when namespaces are split.
- Prefer the smallest meaningful cleanup step.

## Good Trigger Examples

- "這個 repo 很吵，幫我判斷哪些能刪"
- "先不要刪，先幫我分 keep / move / delete / ignore"
- "這些 logs / artifacts / snapshots 到底是不是垃圾"
- "我怕刪到動脈，先幫我看哪些只是殘骸"
- "幫我在這個 repo 做 cleanup judgment，不要直接動手"

## One-Shot Prompt Template

Use this when you want another repo-local agent to apply the skill:

```text
Use $repo-cleanup-judge at C:\Users\user\.codex\skills\repo-cleanup-judge.

Judge this repository's cleanup candidates from live repo truth. Do not delete anything yet.

Task:
1. inspect current docs, runtime/state, logs, and any cleanup scripts
2. build a Keep / Move / Delete / Ignore matrix
3. flag anything that looks important even if it seems noisy
4. tell me the safest smallest cleanup step

Output in Traditional Chinese.
```
