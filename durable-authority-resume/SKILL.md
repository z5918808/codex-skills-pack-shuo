---
name: durable-authority-resume
description: Resume across sessions by reconciling pointers, checkpoints, memory, process state, and stale artifacts.
---

# Durable Authority Resume

## Overview

接續前先找唯一 state owner，再以可重跑 reader 重建 current truth。Memory、聊天與 filesystem latest 都只能作 evidence，不能升格成 active authority。

**REQUIRED SUB-SKILLS:** 使用 `$check` 做 evidence classification；需要 project memory 時使用 `$project-memory-gate`；已有矛盾時使用 `$reconcile-project-state`。

## Authority Order

| Priority | Source | Rule |
| --- | --- | --- |
| 1 | Live state owner + declared reader | 唯一 current truth |
| 2 | Hash-bound checkpoint / manifest | 必須驗 path、hash、run id |
| 3 | Live files、tests、logs、process output | 驗證 claim，不取代 owner |
| 4 | `_ctx`、status、handoff | 只能導向 owner或保存歷史 |
| 5 | Chat、summary、mtime/latest | 不得決定下一步 |

## Workflow

1. 讀 repo `AGENTS.md` 或等價入口，找 state owner、reader、writer policy。
2. 若有 reader，先執行；非零、hash mismatch、missing ref 或 generation mismatch 一律 fail-close。不要用另一份摘要補過。
3. 驗 reader 指向的 checkpoint／manifest及關鍵 evidence refs。Process existence、HTTP 200、worker closeout都只是 claim。
4. 比對 memory/index。它若複製 active goal、owner、generation或 next action，視為 stale-prone；改成只導向 reader，歷史段落明標 reference。
5. 只有目前 session 是 single writer 且使用者授權時，才更新 mutable pointer。否則只產 steer；不得從 side/review session代寫。
6. 被 path/hash/run_id 引用的檔案禁止原地修改；需改版時建立 fresh artifact，再由 state owner前移 pointer。
7. 回傳唯一 goal、stage、next safe action、forbidden actions、evidence refs與未驗證缺口。仍有安全動作時標 `in-progress`，不要誤稱 blocker。

Repo 沒有 machine-readable owner／reader時，不猜最新檔。先提出最小 repo-local contract：一個 mutable pointer、append-only checkpoint、fail-close reader。

## Example

`ACTIVE_STATE.json` reader 回傳 goal B，但 `_ctx/INDEX.md` 宣稱 goal A：採 goal B；將 `_ctx` 的 active claim 改為 reader routing；不修改被 checkpoint SHA 綁定的 architecture，也不由非 writer session前移 pointer。

## Common Mistakes

- 以「較新 mtime」取代 declared pointer。
- 把 `_ctx` 或長 handoff 當 state owner。
- 為了整理而原地改 hash-bound authority。
- 把 auth green、test green或 process running當 live permission。
- 在沒有 writer authority時替 Main 更新 checkpoint。

## Output

```text
目前判斷：<status + canonical state>
已驗證：<owner / checkpoint / evidence>
矛盾或缺口：<stale source / missing proof>
writer boundary：<may update / steer only>
最小下一步：<one decisive action>
```
