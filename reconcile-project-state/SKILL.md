---
name: reconcile-project-state
description: Use when long-running project state conflicts across handoffs, _ctx, lane/status labels, boundary corrections, or source reconstruction notes; symptoms include stale state, exhausted vs current manager body exhausted, latest correction overriding old status, resume contradictions, or deciding whether to stop a lane.
---

# Reconcile Project State

## Overview

整理長專案中的狀態矛盾：先重建「哪個狀態現在為真」，再決定下一步。核心原則是 evidence > memory，latest explicit correction > older summary，但必須保留舊狀態代表的失效邊界。

## Quick Triage

遇到以下訊號，先停下整理，不要直接續寫或停工：

- 同一 lane / workstream 被不同 handoff 說成不同狀態。
- 舊狀態寫 `exhausted`、`blocked`、`done`，但後續 correction 改寫了邊界。
- 「source exhausted」、「manager body exhausted」、「lane exhausted」、「context exhausted」被混用。
- 最新摘要說要繼續 reconstruct source，但舊摘要說要 stop lane。
- `_ctx`、handoff、checkpoint、terminal log、檔案狀態互相矛盾。

## Evidence Order

用以下順序判斷，並在回報中列出採用哪一層證據：

1. Live repo / actual files / actual command output / browser or DB preview.
2. 最新明確 boundary correction、checkpoint、handoff delta。
3. 同一 workstream 中較新的 `_ctx` 或 repo-local 狀態檔。
4. 舊 handoff / compressed conversation summary。
5. 聊天印象、推測、未驗證 worker claim。

若第 1 層與第 2 層矛盾，先查清 live evidence；若只能用第 2 層，標明 verification weak。

## Boundary Reconstruction

把每個狀態拆成四個欄位，不要用單一字眼吞掉邊界：

| Field | 問題 |
| --- | --- |
| Lane | 哪條 lane / workstream 仍然存在？ |
| Current Body | 目前 manager / source / artifact 哪個 body exhausted？ |
| Source Needed | 下一步需要重建哪個 source、材料、證據鏈？ |
| Stop Condition | 什麼條件才真的 stop lane？ |

範例判斷：

| Old phrase | Corrected reading |
| --- | --- |
| lane exhausted | 不足以停 lane；先問 exhausted 的是 lane、manager body、context，還是 source。 |
| current manager body exhausted | manager body 用盡，但 lane 可續；下一步通常是 source reconstruction。 |
| source reconstruction needed | 不要補原 manager body；先重建 source，再恢復下一步。 |

## Workflow

1. 收集衝突句：摘出互相矛盾的原句或檔案位置。
2. 標時間與來源：標明 old / latest / live evidence，不用聊天記憶補空洞。
3. 拆 boundary：用 Lane、Current Body、Source Needed、Stop Condition 四欄重寫狀態。
4. 選 canonical state：採用最新明確 correction，除非 live evidence 反駁。
5. 決定下一步：只做能驗證 canonical state 的最小下一步。
6. 回報殘餘風險：若 source 未重建、驗證不足、或 stop condition 未滿足，明講。

## Output Shape

回報要短，先給結論：

```text
結論：不要停 lane；舊狀態把 exhausted 邊界講錯。最新 canonical state 是 current manager body exhausted，下一步是重建 MISUMI source。

採用證據：
- old: ...
- latest correction: ...
- live verification: ...

整理後 boundary：
- Lane: ...
- Current Body: ...
- Source Needed: ...
- Stop Condition: ...

下一步：...
剩餘風險：...
```

## Common Mistakes

- 不要把 `exhausted` 當成單一全域 stop flag。
- 不要因為舊 handoff 比較長，就讓它蓋過最新 boundary correction。
- 不要只說「以最新為準」；要說最新修正了哪個邊界。
- 不要把 source reconstruction 誤當成從舊 manager body 繼續補。
- 不要在 evidence 不足時做大範圍 cleanup、刪檔、停止 workstream。
