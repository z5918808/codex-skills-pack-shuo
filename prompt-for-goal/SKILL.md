---
name: prompt-for-goal
description: Use /prompt for goal to compile, audit, or rewrite a concise executable /goal prompt and readiness package.
---

# Goal Compiler

把意圖壓成下一位 agent 可直接執行的短目標。只定義 outcome、current truth、路線、權限與停止條件；不重述施工史。

## 模式

- `design`：建立新 goal。
- `audit`：只列會讓 goal 失效的缺口。
- `revise`：預設只輸出必要 delta，不重寫全文。
- `terminal-ready`：只輸出一個可貼上的 `/goal` block，無前言或解釋。

不要混用模式。使用者要求「prompt for goal／精簡 goal／直接貼」時，採 `terminal-ready`。

## 必留內容

每份 goal 只保留五件事：

1. `Outcome`：一句話說明完成後多出什麼結果。
2. `Existence`：2–4 個可觀察完成證據。
3. `Current`：第一個 truth command，加最多 3 個必要 authority refs；有 durable reader 時不重抄歷史。
4. `Roadmap`：預設 3 步，每步包含 action 與 exit evidence。
5. `Rules`：state owner、live／destructive boundary、rollback、strategy-change、stop。

缺少安全 gate 時，把它放在 Roadmap 第 1 步；dry-run green 不等於 live permission。

## 壓縮規則

- 一般 goal 預設 8–18 行；factory／long-run 預設 15–30 行；超過 40 行須使用者明確要求。
- 最多 5 個區塊、3 個 Roadmap steps；只有獨立 exit evidence 才能增加一步。
- 一行只表達一個決策；刪除形容詞、理由重複、完整施工史與已完成 blocker。
- Repo、release 或 checkpoint 已定義的 contract 只引用，不重抄。
- Current truth 只寫目前 authority 與第一個未驗證階段；舊 generation、舊 release、舊失敗留在 artifact。
- Model topology、KPI、checkpoint cadence、完整禁令清單只在會改變本 goal 執行時保留。
- 不把同一 gate 同時寫進 Outcome、Roadmap、Rules。
- 不附重複摘要、注意事項、解釋段或「為什麼這樣設計」。
- `revise` 若只改 current truth 或下一步，輸出 replacement delta，不重印完整 goal。

## 有效性檢查

輸出前確認接手者能在 10 秒內回答：

- 要完成什麼？
- 第一個 command／action 是什麼？
- 什麼 evidence 才算過關？
- 誰能寫 authoritative state？
- 哪個邊界前必須停？
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
2. <主線推進> -> evidence: <signal>
3. <整合／canary／closeout> -> evidence: <signal>
Rules:
- <state owner；permission／rollback；strategy-change；stop>
```

只有連 Outcome 或安全 scope 都無法定義時輸出：

```text
GOAL_READINESS: BLOCKED
missing_proof_or_gate: <決定性缺口>
minimal_safe_next: <最小取證動作>
```
