---
name: repo-cleanup-judge
description: "以檔案引用、唯一副本與 runtime 證據，判斷 repo 清理候選的保留、搬移、刪除或略過。"
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
- Do not call something safe just because it is under `.cache`, `.tmp`, `.jarvis-memory`, `logs`, `artifacts`, or `output`.
- Do not treat `running` state as equivalent to healthy state.
- Do not rebuild indexes or storage blindly when namespaces are split.
- Prefer the smallest meaningful cleanup step.

需要示範如何提出清理判斷請求時，讀 [請求範例](references/requests.md)。
