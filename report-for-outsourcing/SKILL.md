---
name: report-for-outsourcing
description: Use when the user explicitly wants to send a local project, bug, architecture question, blocker, review, or research handoff to an external AI or human that cannot access the local machine, repo, terminal, browser, logs, files, or prior conversation.
---

# Report For Outsourcing

產出一份可直接貼給外部 AI / 人類分析者的單一 code block。

核心前提：外部 AI 沒有本機權限。它看不到 repo、terminal、browser、log、MemPalace、Codex session、檔案樹或先前對話。報告必須把它需要推理的資料帶出去，而不是叫它「去看專案」。

## 外送前安全門檻

這個 skill 只在使用者明確要外送分析時使用。若只是一般解釋、內部 debug、repo review，不要自動觸發。

輸出前必須做安全門檻：

1. 掃描並遮罩 token、API key、cookie、session、密碼、客戶資料、訂單、金流、個資、內部 URL、production identifiers。
2. 只採最小揭露；能用摘要或假名就不要貼原值。
3. 若內容涉及 production、資料庫、金錢、客戶資料或商業機密，先在 brief 內明確標示外送限制；必要時停下來請使用者確認可外送範圍。
4. 關鍵未知不可用 `未知` 混過去；若缺少資料會讓外部 AI 無法回答，列為 `Blocking Unknowns`，不要宣稱 ready-to-send。
5. 外部 AI 不能要求本機 access；它只能要求下一步本地 agent 應補查的精確檔案、指令或證據。

## 核心原則

1. 本地 agent 負責蒐集事實；外部 AI 負責更高階推理。
2. 報告不是摘要，而是 evidence packet + question packet。
3. 不要只寫「相關檔案：foo.ts」；要附足夠檔案摘錄、架構關係、實測輸出。
4. 不要要求外部 AI 檢查本地 repo、跑測試、讀 log、看 branch；它做不到。
5. 明確區分 `已驗證`、`推論 / 假說`、`缺少的資料`。
6. 問題要精準到外部 AI 可以直接回答，不要丟一團 ctx 讓它猜。
7. 每個重要判斷都盡量引用證據編號，例如 `E1`、`F2`、`L3`。

## 製作流程

1. 釐清 `Decision Needed`：用一句話寫出要外部 AI 判斷什麼。
2. 讀本地真相：repo docs、`AGENTS.md`、`_ctx/INDEX.md`、status、terminal/log、diff、相關檔案。
3. 建架構地圖：入口、資料流、模組關係、runtime、dependency、legacy / adapter / generated 邊界。
4. 選證據：只取會影響判斷的 snippets / logs / commands；每段編號。
5. 設計問題：3-7 題，要求外部 AI 依證據回答，不假設未附程式碼。
6. 自檢：能不能在沒有本機 access 的情況下回答？若不能，補查或列 Blocking Unknowns。

## 本地蒐集清單

輸出前先在本機拿到這些資訊；缺什麼就標 `未知` 或 `Blocking Unknown`，不要補腦。

1. `Decision Needed`：單一句任務契約，例如「請判斷 X bug 最可能 root cause 與 patch plan」。
2. `任務目標`：現在真正要完成什麼，不是表面錯誤。
3. `現況`：做到哪、已完成什麼、卡在哪。
4. `架構地圖`：主要模組、資料流、入口、執行路徑、外部依賴。
5. `檔案 / 版本 / runtime`：必要檔案樹、branch/diff、package versions、runtime env。
6. `重現資料`：cwd、command、timestamp、exit code、stdout/stderr 關鍵摘錄。
7. `相關檔案摘錄`：只貼必要片段；每段要有路徑、用途、證據編號。
8. `錯誤 / 症狀 / log`：原文保留關鍵行，不要只 paraphrase。
9. `已試過的修法`：每個嘗試的結果，不要只列動作。
10. `約束`：不能改什麼、production 風險、使用者偏好、時間/權限限制。
11. `外部 AI 要回答的問題`：3-7 個，依優先順序。
12. `期望輸出格式`：root cause、patch plan、review findings、architecture recommendation 等。

## 架構地圖最低標準

至少回答：

- 這個系統的入口在哪。
- 使用者操作或事件如何流到出問題的模組。
- 相關資料從哪裡來、往哪裡去。
- 哪些檔案是主線，哪些只是測試、adapter、legacy、暫存。
- dependency / runtime / branch / diff 是否影響判斷。
- 現在的 blocker 會卡住哪條主流程。

如果外部 AI 不知道這些，它的回答多半會飄。

## 任務類型變體

依任務補上對應資料，不要全部硬塞。

| 類型 | 必填補充 |
|---|---|
| Bug / blocker | expected vs actual、repro command、error/log、recent change、impact |
| Code review | diff / changed files、review goal、risk areas、expected behavior、test result |
| Architecture | current architecture、constraints、alternatives considered、decision criteria |
| Research / strategy | decision criteria、known sources、candidate options、non-goals、uncertainties |

## 問題設計

問題要讓外部 AI 做推理，不要讓它做本地勘查。

好問題：

- `Based only on E1-E5 and F1-F3, what is the most likely root cause?`
- `Which invariant is being violated, and where should the fix live?`
- `What extra local evidence would most reduce uncertainty? Ask for exact files/commands.`
- `Give a patch plan that preserves the stated constraints and does not assume unseen code.`

壞問題：

- `Can you inspect my repo and fix it?`
- `What is wrong with this project?`
- `Look at the logs and tell me.`
- `Write code based on the architecture` but architecture was not included.

## 預設輸出

預設只輸出一個 fenced code block：

````md
# External Analysis Brief

## Read This First
- You cannot access my local machine, repo, terminal, browser, logs, files, prior chat, screenshots, or hidden context unless included below.
- Analyze only the evidence in this brief.
- Cite evidence IDs when making claims.
- Do not assume unseen code, files, logs, branches, credentials, or runtime state.
- If evidence is insufficient, ask for the exact missing local artifacts or commands.

## Decision Needed
- One-sentence decision contract:

## Answer Boundaries
- Do not ask for local machine access.
- Do not assume unstated architecture.
- Do not propose production/destructive actions unless explicitly allowed.
- If uncertain, return the most useful next local check.

## Goal
- ...

## Current Status
- ...

## Architecture Map
- Entry points:
- Data flow:
- Key modules:
- Runtime / dependency versions:
- Branch / diff context:
- What is legacy / adapter / generated / runtime state:

## Evidence Index
- E1: command / log / runtime evidence
- F1: file snippet
- D1: diff / recent change
- A1: architecture fact

## Verified Facts
- [A1] ...

## Blocker
- ...

## Blocking Unknowns / Missing Evidence
- Unknown:
- Why it blocks analysis:
- Exact local artifact or command needed:

## Expected vs Actual
- Expected:
- Actual:
- Impact:

## Symptoms / Evidence
```text
E1:
paste exact error/log/output excerpts here
```

## Relevant Files / Snippets

### F1: path/to/file.ext
Why this matters:

```language
small relevant snippet
```

## Tried Already
- Attempt:
- Result:
- Evidence:

## Hypotheses From Local Agent
- Hypothesis:
- Evidence for:
- Evidence against / uncertainty:

## Constraints / Non-goals
- ...

## Questions For GPT-5.5 Pro / External Analyst
1. ...
2. ...
3. ...

## Requested Output Format
- Root cause:
- Confidence:
- Evidence used:
- Assumptions made:
- Patch / recommendation plan:
- Risks:
- Most useful next local check:
- Additional evidence needed:
````

## 選材規則

1. 單一 code block，方便直接貼。
2. 優先順序：決策問題 > 架構地圖 > 可重跑證據 > relevant snippets > 已試結果 > 假說。
3. 寧可貼少量高價值 snippet，不貼整份大檔。
4. 每段 snippet / log 都要有「為什麼重要」。
5. 若會爆長，保留核心 evidence，其他列成「可補資料」。
6. 若缺架構，就先補架構地圖，不要直接外包。
7. 若缺 log，就貼精準 log；不要只說「有錯」。
8. 若是 code review，要附 diff 或 relevant snippets；外部 AI 沒有 git。
9. 若是策略/研究，要附已知資料與決策標準；外部 AI 不知道你的偏好。
10. 若涉及安全、資料庫、金錢、客戶資料或 production，明確寫出禁止操作與確認門檻。

## 最後自檢

送出前逐項檢查：

1. 外部 AI 不需要本地權限也能開始分析。
2. 報告包含架構地圖、已驗證事實、證據摘錄、限制與精準問題。
3. 證據有編號，問題可引用證據。
4. 關鍵未知已列為 blocker，沒有偽裝成完整。
5. 敏感資訊已遮罩或取得使用者明確可外送範圍。
6. 問題是可回答的，不是叫外部 AI 自己查本機。
7. 已把本地 agent 的假說和外部 AI 要判斷的問題分開。
8. 使用者可以直接整段貼出去，不需要二次整理。
