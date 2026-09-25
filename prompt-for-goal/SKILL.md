---
name: prompt-for-goal
description: Draft, audit, or revise executable /goal prompts and readiness packages when the user asks to work on a goal prompt.
---

# Prompt for Goal

把意圖壓成下一位 agent 可直接執行的短目標。只定義 outcome、current truth、路線、權限與停止條件；不重述施工史。

## 模式

- `design`：建立新 goal。
- `audit`：只列會讓 goal 失效的缺口。
- `revise`：預設只輸出必要 delta，不重寫全文。
- `terminal-ready`：只輸出一個可貼上的 `/goal` block，無前言或解釋。

依使用者意圖選模式，不只看關鍵字。要求檢查這個 skill 或既有 goal 時採 `audit`；要求「直接貼／可貼用的 goal」時採 `terminal-ready`。不要混用模式。

## 必留內容

每份 goal 從以下五件事挑出執行所需內容，不為了湊格式補空欄位：

1. `Outcome`：一句話說明完成後多出什麼結果。
2. `Existence`：足以判定完成的可觀察證據，含必要的整合或安全驗證。
3. `Current`：第一個查證命令或動作，加必要的 authority refs；有 durable reader 時不重抄歷史。
4. `Roadmap`：依獨立 exit evidence 列 1–3 步，每步包含 action 與 evidence。
5. `Rules`：適用的 state owner、live／destructive boundary、rollback、strategy-change、stop。

先核對既有授權與適用的安全 gate；缺少必要 gate 時，把查證放在 Roadmap 第 1 步。dry-run green 不能自行擴張 live 授權，也不會取消已有授權。

## 壓縮規則

- 一般 goal 以 8–18 行為參考；factory／long-run 以 15–30 行為參考。長度由必要內容決定，不為了行數刪除關鍵條件。
- 最多 5 個區塊、3 個 Roadmap steps；只有獨立 exit evidence 才增加一步，無需湊滿。
- 一行只表達一個決策；刪除形容詞、理由重複、完整施工史與已完成 blocker。
- Repo、release 或 checkpoint 已定義的 contract 只引用，不重抄。
- Current truth 只寫目前 authority 與第一個未驗證階段；關鍵來源須可定位，必要時附 run ID、版本或 hash。較新的摘要不得直接取代釘選規則或原始證據；舊 generation、舊 release、舊失敗留在 artifact。
- Model topology、KPI、checkpoint cadence、完整禁令清單只在會改變本 goal 執行時保留。
- 不把同一 gate 同時寫進 Outcome、Roadmap、Rules。
- 不附重複摘要、注意事項、解釋段或「為什麼這樣設計」。
- `revise` 若只改 current truth 或下一步，輸出 replacement delta，不重印完整 goal。

## 有效性檢查

輸出前確認接手者能在 10 秒內回答：

- 要完成什麼？
- 第一個 command／action 是什麼？
- 什麼 evidence 才算過關？
- 若有 authoritative state，誰能寫？
- 哪個適用邊界前必須停？
- 何時換策略或結束？

回答不了才補字；回答得了就停止。短不是刪 safety，而是刪重複 context。

## Terminal-ready 模板

```text
/goal <一句 outcome>
Existence:
- <可觀察成果>
- <整合／安全證據>
Current:
- First: <truth command>
- <最新 authority；若較新 reader 存在則採較新 truth>
Roadmap:
1. <第一個未驗證動作> -> evidence: <signal>
Rules:
- <適用的 state owner；授權／rollback；strategy-change；stop>
```

只有後續步驟有獨立 exit evidence 時，才在模板中加入第 2、3 步；無 durable state 或 live mutation 時，刪除不適用的欄位。

只有連 Outcome 或安全 scope 都無法定義時輸出：

```text
GOAL_READINESS: BLOCKED
missing_proof_or_gate: <決定性缺口>
minimal_safe_next: <最小取證動作>
```
