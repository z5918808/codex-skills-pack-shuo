---
name: long-running-agent
description: "/longrun, /goal, /resume"
---

# Long-Running Agent

## Purpose

把真正需要跨 milestone、跨 session、或 durable handoff 的任務收斂成可驗證的長跑流程。這個 skill 是重型 lane；未明確命中 gate 時，回到一般 coding/debug 流程。

## Activation Gate

只有下列情況啟用：

- 使用者明確輸入 `/longrun`、`/goal`、`/resume`、`go long`、持續接力。
- repo workflow 明確要求 durable handoff 或 long-run pack。
- 任務必須跨 session 延續，且不寫 durable state 會讓下一手無法安全接續。
- 任務已被拆成 3 個以上可獨立驗證 milestone，且使用者接受長跑模式。

不要因為「多檔案」、「看起來複雜」、「debug」、「部署」就自動啟用。高風險任務先走 `$risk-preflight`；需要 project memory 時才走 `$project-memory-gate`。

## Outcome Contract

啟動時只建立一次 compact contract：

- `Seed`: 使用者原始目標。
- `Evidence`: 目前 live truth，包含檔案、log、test、UI、API 或 artifact。
- `Constraint`: 最窄 blocker 或不確定性。
- `Outcome`: 本輪要達成的一個可驗證結果。
- `Milestones`: 3 個以內的近期 milestone；更遠的只留方向。
- `Verification`: 每個 milestone 的驗證方式。
- `Safety / recovery`: guard、rollback、no-write zone、確認點。
- `Stop / handoff`: 何時停、交棒檔在哪、下一手做什麼。

時鐘、早上、晨報或預定驗收時間不是 goal stop condition，除非使用者明確要求時間邊界。預設 stop 只允許：acceptance criteria 完成、真 blocker、safety/permission boundary、或使用者干預。

若 `Evidence`、`Constraint`、`Verification` 填不出來，下一步是補證據，不是開始實作。

## Memory

需要讀或寫 durable memory 時使用 `$project-memory-gate`。

原則：

- 先看 live truth，再讀 memory。
- 只讀 `_ctx/INDEX.md` 與命中的 workstream。
- 不一次展開所有 sessions、archives、manifest。
- 沒有 project memory 時，只建立最小 handoff pack。

## Milestone Loop

每個 milestone 都要小到可驗證、可回退、可交棒。

流程：

1. 選下一個最小 milestone。
2. 說明本步要改什麼與怎麼驗證。
3. 實作 scoped change。
4. 跑驗證；不能跑就標明未驗證。
5. 更新 delta checkpoint。
6. 決定繼續、縮 scope、repair、handoff、或停止。

只要 acceptance criteria 未完成、仍有安全且已授權的下一步、也沒有使用者干預，就自動進入下一個 milestone；不要為了等早晨驗收而提早 closeout。

Allowed status：

- `Verified`
- `Partially verified`
- `Blocked`
- `Needs user decision`
- `Out of scope`

不要用努力程度標記完成。

## Scheduling

- `/goal` 預設在目前執行鏈持續到完成或使用者干預，不建立 cron、reminder、晨間驗收或定時 closeout。
- 只有使用者明確要求某個時間點或 recurring schedule 時才建立 automation；取消後不得用 goal 文字暗藏同一排程。
- 狀態報告可以在 milestone 產生，但 report time 不得成為停止主線的理由。

## Checkpoints

checkpoint 只更新 delta，最多三行：

- 新證據
- 新狀態
- 下一步

不要重貼完整 Outcome Contract。不要每次都寫 factory output。

## Factory Output

只有在以下情況使用 `$factory-output`：

- 使用者要求沉澱。
- 同類問題第二次出現。
- 已形成可重跑 script、test command、debug route、handoff、rule、hook、skill。
- 不沉澱會影響後續安全、效率、或可恢復性。

沒有新的 factory asset 時，不硬寫。

## Pivot Gate

若 30 分鐘內沒有新證據、可逆改動、測試結果、artifact、縮小後 blocker、或排除路徑，停止原路線並重估。

若 60 分鐘內沒有主線推進，做 Pivot Review：

- 具體 blocker。
- 問題類型：產品 / 工具 / 環境 / 權限 / 流程 / 資料 / 目標定義。
- 已失敗路徑。
- 下一條更高槓桿路徑。
- 是否縮 scope、隔離 incident、改 repair lane、或先建立驗證工具。

## Completion

結束時回報：

- Product output。
- Verification。
- Factory output，若有。
- 未解風險。
- durable handoff 或下一步。

不要因為單一測試通過就宣稱整體 goal 完成；要對照 acceptance、changed files、驗證結果與未解假設。
