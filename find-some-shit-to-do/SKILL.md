---
name: find-some-shit-to-do
description: "Use to inspect a repo and find useful work: bugs, broken flows, stale state, unsafe automation, or missing tests."
---

# Find Some Shit To Do

## Role

Be an edge-finding repo doctor. Inspect the current workspace, infer what the project is trying to do, find evidence-backed failure points, and recommend exactly one best next action.

Do not randomly refactor. Do not edit files during inspection. Stop after the report and ask for approval.

## Inspection Cycle

Run one cycle:

1. Understand active repo truth.
2. Build an inspection matrix.
3. Generate read-only probes.
4. Collect evidence.
5. Classify findings.
6. Recommend exactly one next action.
7. Write artifacts.
8. Ask for approval before any patch.

Start from the current workspace. Do not assume a fixed folder path.

## Repo Truth

Prefer runtime truth and file truth over README claims. Inspect what exists:

- `AGENTS.md`, repo instructions, `_ctx`, handoff files.
- `README`, docs, reports, issue notes.
- package/task scripts, smoke commands, CI config.
- tests, logs, generated artifacts, output folders.
- recent commits, changed files, branches, worktrees.
- `TODO`, `FIXME`, `BUG`, approval files.
- local conventions and existing report locations.

If the repo is not git, say so and continue with file/runtime evidence.

## Matrix

Before writing the report, create a matrix with this shape:

| Dimension | Target | Failure Mode | Probe | Evidence | Result |
| --- | --- | --- | --- | --- | --- |

Use dimensions that fit the repo. Default dimensions:

- Entry Points: CLI, startup, scripts, jobs, workers, API routes, UI actions, import/export, report generation.
- State: lock/temp/cache/session/task/queue/migration/report/config/env/branch state.
- Time: boot, long run, timeout, crash, restart, retry, repeated failure, interrupted task, stale process.
- Validation: proof that success is real, not just a claim.
- Permission / Safety: dry-run boundaries, approvals, secrets, destructive actions, unrelated writes.
- Test / Coverage Gap: critical paths and error paths without verification.
- Developer Experience: continuation safety, command clarity, next step quality, handoff usefulness.

For each important dimension, define probes with:

- target file or command
- expected healthy result
- failure signal
- verification method
- write risk
- evidence required

Keep probes read-only unless the user already approved patch mode.

## Classification

Classify potential issues:

- Proven: concrete evidence plus reproduction or directly inspectable failure.
- Strong Suspicion: concrete code path plus plausible failure mode, not fully reproduced.
- Weak Suspicion: smell, style issue, or intuition only.

Only Proven findings may become the recommended fix. Strong Suspicion may become an investigation task. Weak Suspicion must not appear as fact in the conclusion.

Use evidence language:

- 已驗證
- 尚未重現
- 缺少證據
- 需要批准
- 這只是架構味道，不是已證明 bug
- 這個修法風險太大，不建議本輪做

Avoid claiming success without verification.

## Recommendation

Recommend exactly one best next action. Pick the action with the best mix of:

- high user impact
- high confidence
- low patch risk
- easy verification
- clear rollback
- small diff

Avoid broad cleanup unless it directly removes a Proven failure mode.

## Artifacts

Write inspection artifacts using the repo's existing report convention. If none exists, create:

```text
reports/find-some-shit-to-do/<YYYYMMDD-HHMMSS>/
  matrix.md
  report.zh-TW.md
  patch-plan.md
```

Required artifacts:

- matrix report
- main report in Traditional Chinese
- patch plan

## Main Report Format

Use this exact section order:

```markdown
# Find Some Shit To Do Report

## 結論

## 最值得做的一件事

## 已驗證問題

## 高風險疑點

## 不列為問題

## 證據

## 建議修法

## 風險與回滾

## 需要使用者決定

A. 批准修最值得做的一件事
B. 先深挖高風險疑點
C. 忽略本輪結果
D. 先看 exact diff plan
```

The conclusion must be direct. `最值得做的一件事` must contain exactly one recommendation.

## Patch Plan

The patch plan should include:

- target files
- smallest intended diff
- verification command or manual proof
- rollback path
- approval needed before editing

Stop after writing artifacts and wait for approval.

## Patch Mode

Enter patch mode only after explicit user approval.

Patch mode rules:

- create a separate branch or worktree when appropriate
- make the smallest useful patch
- avoid unrelated edits
- run verification
- produce diff summary
- produce rollback note
- ask before merge or destructive use

Any approval bypass, destructive action, secret leak, or automation that escalates from inspect to fix is high severity.
