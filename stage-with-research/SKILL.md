---
name: stage-with-research
description: Use when a vague or uncertain goal needs both bounded evidence gathering and a realistic staged execution plan. This skill combines autoresearch-style verification loops with staging-style final-goal locking, phased outcomes, stop gates, and progress percentages. Use for planning execution under uncertainty; do not use for staging servers, staging databases, deployments, or environment promotion unless the user is explicitly staging goals.
---

# Stage With Research

把不清楚的方向，先用最小證據迴圈釐清，再凍結成可執行、可驗證、可交棒的階段計畫。

這不是「多做研究」或「列待辦」。它的目標是：用剛好足夠的證據，選出一個明確 outcome，然後切成能推進主線的 stages。

## 何時使用

使用 stage-with-research 當任務同時具備：

- 目標或現況有不確定性。
- 需要先判斷真實瓶頸，而不是直接照字面執行。
- 需要把方向變成 final goal、階段成果、驗證方式與停止門檻。
- 使用者要 `/goal`、`go`、`繼續`、分階段計畫、執行路線、或在混亂現場中決定下一手。

不要用於：

- 單純研究：改用 `$autoresearch`。
- 單純分階段且現況已清楚：改用 `$staging`。
- staging server、staging database、部署環境升降級，除非使用者是在規劃 goal stages。
- production / database / 金錢 / 訂單 / 庫存 / 客戶資料寫入安全流程；這些先走對應 safety skill。

## 核心原則

1. 先補 live truth，再定 final goal。
2. 每一階段必須有產物、驗證與停止門檻。
3. 不把活動量當進度；只有證據能讓進度上升。
4. 預設用百分比回報每件事的狀態。
5. 不無限研究；證據足夠決策時立刻收斂。
6. 若發現自己前面判斷錯了，先修正 blocker，再繼續。

## Workflow

### 1. 建立 Smart Outcome Contract

用最短格式建立目前任務邊界：

```text
Seed:
Evidence:
Constraint:
Outcome:
Mainline / scale movement:
Batch / appetite:
Verification:
Safety / recovery:
Stop gate / handoff:
Progress:
```

如果 `Evidence`、`Constraint` 或 `Verification` 填不出來，不要硬排 stages；第一階段先變成補證據或建立 decision artifact。

### 2. 跑最小證據迴圈

每個迴圈只回答一個決策問題：

```text
Loop N:
Question:
Action:
Evidence collected:
Verified:
Inferred:
Decision: keep / keep-partial / discard / pivot / stop
Next:
Progress:
```

預設迴圈數：

- Quick：1-2 loops，普通模糊任務。
- Standard：2-4 loops，多來源、多檔案、需要可交棒。
- Deep：4-8 loops，長跑、跨模組、高風險或使用者明確要求。

### 3. 凍結 final goal

證據足夠後，用一句話定錨：

```text
Final goal:
Success means:
Out of scope:
Current confidence:
```

若 final goal 仍不清楚，明講缺哪個證據或決策；不要用漂亮文字掩蓋不確定。

### 4. 切 stages

每個 stage 都要能被另一個 agent 接手：

```text
Stage:
Progress:
Objective:
Action:
Output / artifact:
Verification:
Stop gate:
Risk / dependency:
Recovery:
```

stage 必須推進至少一種主線價值：更可搜尋、可審核、可重用、可出貨、可 scale、覆蓋率更高、召回更大、blocker 更少、或下一棒更容易。

### 5. 決定下一手

最後只選一個最小可執行下一步：

- 如果安全且 scope 明確，直接執行。
- 如果缺 live truth，先收集證據。
- 如果需要人工確認，列出確認點與不確認的風險。
- 如果目前方向低槓桿，pivot 到更能推主線的 outcome。

## 預設輸出格式

```markdown
目前判斷：
[結論 1-2 句。進度 X%。]

Smart Outcome Contract：
- Seed:
- Evidence:
- Constraint:
- Outcome:
- Mainline / scale movement:
- Batch / appetite:
- Verification:
- Safety / recovery:
- Stop gate / handoff:

已驗證：
- ...

推論：
- ...

階段性目標：
1. [stage name] - [進度 %]
   目標：
   行動：
   產物：
   驗證：
   停止門檻：
   風險 / recovery：

下一步：
[最小安全下一手。]
```

## 完成標準

完成前檢查：

- final goal 已鎖定，或 blocker 被明確命名。
- stages 有產物、驗證、停止門檻與百分比。
- 已驗證與推論分開。
- 沒有把記憶、猜測或工具成功當成現況。
- 有下一個最小可執行動作。
- 若建立 durable artifact，路徑清楚且內容可交棒。
