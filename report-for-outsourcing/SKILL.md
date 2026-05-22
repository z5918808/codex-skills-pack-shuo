---
name: report-for-outsourcing
description: Use when the user explicitly wants to send a local project, bug, architecture question, architecture stability review, blocker, code review, implementation record, project progress, or research handoff to an external AI or human that cannot access the local machine, repo, terminal, browser, logs, files, or prior conversation.
---

# Report For Outsourcing

產出一份可直接貼給外部 AI / 人類分析者的單一 Markdown 報告 code block。

核心前提：外部 AI 沒有本機權限。它看不到 repo、terminal、browser、log、MemPalace、Codex session、檔案樹或先前對話。報告必須把它需要推理的資料帶出去，而不是叫它「去看專案」。

此 skill 特別適合把「程式設計 / 專案架構 / 目前進度 / 實務紀錄 / 未完成事項 / 風險」寫成詳細 `.md`，交給外部分析者判斷架構穩不穩、下一步該怎麼做、哪些地方需要重構或補驗證。

## 外送前安全門檻

這個 skill 只在使用者明確要外送分析時使用。若只是一般解釋、內部 debug、repo review，不要自動觸發。

輸出前必須做安全門檻：

1. 掃描並遮罩 token、API key、cookie、session、密碼、客戶資料、訂單、金流、個資、內部 URL、production identifiers。
2. 只採最小必要揭露；架構、設計、風險可以詳細，秘密與客戶資料不可以詳細。
3. 若內容涉及 production、資料庫、金錢、客戶資料或商業機密，先在 brief 內明確標示外送限制；必要時停下來請使用者確認可外送範圍。
4. 關鍵未知不可用 `未知` 混過去；若缺少資料會讓外部 AI 無法回答，列為 `Blocking Unknowns`，不要宣稱 ready-to-send。
5. 外部 AI 不能要求本機 access；它只能要求下一步本地 agent 應補查的精確檔案、指令或證據。

## 核心原則

1. 本地 agent 負責蒐集事實；外部 AI 負責更高階推理。
2. 報告不是短摘要，而是 project design document + evidence packet + question packet。
3. 越詳細越好，但詳細的是架構、設計意圖、取捨、實作紀錄、進度與風險；敏感資訊仍要遮罩。
4. 不要只寫「相關檔案：foo.ts」；要附足夠檔案摘錄、架構關係、資料流、實測輸出與為什麼重要。
5. 不要要求外部 AI 檢查本地 repo、跑測試、讀 log、看 branch；它做不到。
6. 明確區分 `已驗證`、`實務紀錄`、`推論 / 假說`、`缺少的資料`。
7. 專案偏好必須進報告：使用者偏好、repo 規則、架構取向、UI/UX 偏好、驗證偏好、不可接受的改法。
8. 每個重要判斷都盡量引用證據編號，例如 `E1`、`F2`、`L3`、`A4`、`R2`。

## 製作流程

1. 釐清 `Decision Needed`：用一句話寫出要外部 AI 判斷什麼，例如「請判斷目前架構是否穩、主要風險在哪、下一步重構優先序」。
2. 讀本地真相：repo docs、`AGENTS.md`、`_ctx/INDEX.md`、status、terminal/log、diff、相關檔案、測試結果、已知規則。
3. 蒐集專案偏好：使用者偏好、repo-specific 約束、設計系統、技術棧偏好、測試/部署/資料安全偏好。
4. 建程式設計圖：入口、資料流、狀態 ownership、模組邊界、interface contract、runtime、dependency、legacy / adapter / generated 邊界。
5. 整理實務紀錄：已完成、已試過、失敗過、為什麼改方向、已驗證與未驗證的地方。
6. 整理進度與缺口：目前進度、正在做、預計要做但未做、已知 blocker、需要外部判斷的設計決策。
7. 建風險清單：架構風險、產品風險、資料風險、安全風險、測試風險、維護風險、交接風險。
8. 選證據：只取會影響判斷的 snippets / logs / commands；每段編號並說明重要性。
9. 設計問題：3-10 題，要求外部 AI 依證據回答，不假設未附程式碼。
10. 自檢：能不能在沒有本機 access 的情況下回答？若不能，補查或列 Blocking Unknowns。

## 本地蒐集清單

輸出前先在本機拿到這些資訊；缺什麼就標 `Blocking Unknown`，不要補腦。

1. `Decision Needed`：單一句任務契約，例如「請判斷目前架構穩定性、風險與下一步優先序」。
2. `任務目標`：現在真正要完成什麼，不是表面錯誤。
3. `專案背景`：產品用途、主要使用者、核心 workflow、目前階段。
4. `專案偏好`：使用者偏好、AGENTS/repo 規則、coding style、UI/UX 偏好、驗證標準、禁忌改法。
5. `現況`：做到哪、已完成什麼、卡在哪、目前可用程度。
6. `程式設計`：主要模組、資料流、狀態 ownership、API/interface、錯誤處理、資料模型、background jobs、AI layers。
7. `架構地圖`：入口、執行路徑、外部依賴、adapter/legacy/generated 邊界。
8. `檔案 / 版本 / runtime`：必要檔案樹、branch/diff、package versions、runtime env。
9. `實務紀錄`：已做決策、已試修法、踩過的坑、改方向原因、已驗證證據。
10. `目前進度`：已完成、部分完成、未開始、正在卡住、下一個自然 stage。
11. `預計要做未做`：功能缺口、重構缺口、測試缺口、文件缺口、部署/監控缺口。
12. `風險`：可能壞在哪、blast radius、風險嚴重度、可偵測性、緩解方式。
13. `重現資料`：cwd、command、timestamp、exit code、stdout/stderr 關鍵摘錄。
14. `相關檔案摘錄`：只貼必要片段；每段要有路徑、用途、證據編號。
15. `錯誤 / 症狀 / log`：原文保留關鍵行，不要只 paraphrase。
16. `外部 AI 要回答的問題`：3-10 個，依優先順序。
17. `期望輸出格式`：architecture review、risk register、patch plan、milestone plan、review findings 等。

## 架構地圖最低標準

至少回答：

- 這個系統的入口在哪。
- 使用者操作、事件、request 或 job 如何流到核心模組。
- 相關資料從哪裡來、往哪裡去、誰擁有狀態。
- 哪些檔案是主線，哪些只是測試、adapter、legacy、generated、暫存。
- 核心 interface / API / schema contract 是什麼。
- dependency / runtime / branch / diff 是否影響判斷。
- 目前驗證路徑是什麼，哪些測試或人工檢查能證明主流程穩。
- 現在的 blocker 會卡住哪條主流程。
- 哪些設計選擇是刻意取捨，哪些只是歷史包袱。

如果外部 AI 不知道這些，它的回答多半會飄。

## 專案設計 / 架構穩定性模式

當使用者想「讓外部分析看看架構穩不穩」或「把程式設計寫成 md」時，報告要比 bug brief 更完整。預設產出完整 Markdown，包含：

1. 專案一句話定位。
2. 現在希望外部分析者判斷的架構問題。
3. 專案偏好與不可違反規則。
4. 程式設計總覽：系統邊界、核心模組、資料流、狀態 ownership、interface contracts。
5. 實務紀錄：已做過的實作、調整、驗證、踩雷、改方向原因。
6. 目前進度：完成 / 部分完成 / 未開始 / 卡住。
7. 預計要做未做：按優先序列出。
8. 架構穩定性初評：本地 agent 依證據提出假說，不能偽裝成外部結論。
9. 風險清單：嚴重度、可能性、偵測方式、緩解方式、需要外部判斷的點。
10. 附錄證據：檔案摘錄、log、test、diff、指令輸出。
11. 外部分析問題：要求對方回覆可執行的建議，不要只給泛泛原則。

## 任務類型變體

依任務補上對應資料，不要全部硬塞。但若是架構穩定性 / 專案設計外送，寧可詳細。

| 類型 | 必填補充 |
|---|---|
| Architecture stability / project design | project purpose、preferences、architecture map、state ownership、interface contracts、implementation record、progress、unfinished work、risk register、verification gaps |
| Bug / blocker | expected vs actual、repro command、error/log、recent change、impact |
| Code review | diff / changed files、review goal、risk areas、expected behavior、test result |
| Architecture decision | current architecture、constraints、alternatives considered、decision criteria、migration cost |
| Research / strategy | decision criteria、known sources、candidate options、non-goals、uncertainties |
| Handoff / outsourcing implementation | scope、done/not done、files touched、how to verify、risk zones、next steps |

## 問題設計

問題要讓外部 AI 做推理，不要讓它做本地勘查。

好問題：

- `Based only on A1-A8, F1-F6, and R1-R4, is the architecture stable enough for the next milestone?`
- `Which module boundary or state ownership issue is the highest risk?`
- `Which unfinished item should be done first to reduce future rework?`
- `What extra local evidence would most reduce uncertainty? Ask for exact files/commands.`
- `Give a patch / refactor plan that preserves the stated project preferences and does not assume unseen code.`

壞問題：

- `Can you inspect my repo and fix it?`
- `What is wrong with this project?`
- `Look at the logs and tell me.`
- `Write code based on the architecture` but architecture was not included.

## 預設輸出

預設只輸出一個 fenced code block。除非使用者要求短版，否則架構 / 專案外送報告要詳細：

````md
# External Architecture / Project Analysis Brief

## Read This First
- You cannot access my local machine, repo, terminal, browser, logs, files, prior chat, screenshots, or hidden context unless included below.
- Analyze only the evidence in this brief.
- Cite evidence IDs when making claims.
- Do not assume unseen code, files, logs, branches, credentials, or runtime state.
- If evidence is insufficient, ask for the exact missing local artifacts or commands.

## Decision Needed
- One-sentence decision contract:

## Requested Review Type
- Architecture stability:
- Program design:
- Risk review:
- Next-step prioritization:
- Patch / refactor recommendation:

## Answer Boundaries
- Do not ask for local machine access.
- Do not assume unstated architecture.
- Do not propose production/destructive actions unless explicitly allowed.
- Preserve the project preferences and non-goals below.
- If uncertain, return the most useful next local check.

## Project Summary
- Product / system purpose:
- Primary users:
- Core workflow:
- Current project phase:
- What success looks like:

## Project Preferences / Constraints
- User preferences:
- Repo / AGENTS rules:
- Architecture preferences:
- UI / UX preferences:
- Coding style preferences:
- Verification preferences:
- Security / data handling constraints:
- Non-goals:
- Changes that should be avoided:

## Current Status
- Overall status:
- What works now:
- What is partially done:
- What is blocked:
- What is unverified:
- Latest meaningful evidence:

## Program Design

### System Boundary
- In scope:
- Out of scope:
- External systems / services:

### Entry Points
- User-facing entry points:
- API / route entry points:
- Background jobs / scheduled tasks:
- CLI / scripts:

### Core Modules
- Module:
  - Responsibility:
  - Important files:
  - Inputs:
  - Outputs:
  - Risks / notes:

### Data Flow
1. ...
2. ...
3. ...

### State Ownership
- Source of truth:
- Local UI state:
- Server state:
- Database / persisted state:
- Cache / derived state:
- Known ownership ambiguities:

### Interfaces / Contracts
- API contracts:
- Schema / model contracts:
- Component contracts:
- Event contracts:
- AI layer contracts:
- Error handling contracts:

### Runtime / Dependencies
- Runtime:
- Frameworks:
- Key packages:
- External services:
- Environment assumptions:

### Legacy / Adapter / Generated Boundaries
- Mainline code:
- Legacy code:
- Adapter layer:
- Generated code:
- Temporary code:

## Architecture Map
- High-level structure:
- Request / event path:
- Data persistence path:
- Validation / authorization path:
- Error / recovery path:
- Verification path:

## Implementation Record
- Date / stage:
- What changed:
- Why it changed:
- Evidence:
- Result:
- Follow-up:

## Progress

### Done
- ...

### Partially Done
- ...

### Not Started
- ...

### Planned But Not Yet Done
- ...

### Known Blockers
- ...

## Risk Register

| ID | Risk | Area | Severity | Likelihood | Evidence | Detection | Mitigation | External input needed |
|---|---|---|---|---|---|---|---|---|
| R1 | ... | architecture | high/med/low | high/med/low | A1/F2/E3 | ... | ... | ... |

## Architecture Stability Initial Assessment From Local Agent
- Stable areas:
- Fragile areas:
- Suspected over-complexity:
- Suspected missing abstraction:
- Suspected bad ownership boundary:
- Verification gaps:
- Migration / refactor risk:
- Confidence level and why:

## Evidence Index
- A1: architecture fact
- F1: file snippet
- E1: command / log / runtime evidence
- D1: diff / recent change
- R1: risk evidence
- P1: project preference evidence

## Verified Facts
- [A1] ...

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

## Questions For GPT-5.5 Pro / External Analyst
1. Based only on the included evidence, is this architecture stable enough for the next milestone? Why?
2. What are the highest-risk architecture or state ownership issues?
3. Which unfinished item should be prioritized first to reduce rework and risk?
4. What design simplification would improve maintainability without violating project preferences?
5. What verification gap most threatens confidence?
6. What exact additional local evidence would reduce uncertainty the most?

## Requested Output Format
- Executive judgment:
- Architecture stability score and rationale:
- Highest-risk issues:
- Evidence used:
- Assumptions made:
- Recommended next steps:
- Patch / refactor plan:
- Verification plan:
- Risks:
- Most useful next local check:
- Additional evidence needed:
````

## 選材規則

1. 單一 code block，方便直接貼。
2. 優先順序：決策問題 > 專案偏好 > 程式設計 > 架構地圖 > 進度 > 風險 > 可重跑證據 > relevant snippets > 已試結果 > 假說。
3. 寧可貼少量高價值 snippet，不貼整份大檔。
4. 每段 snippet / log 都要有「為什麼重要」。
5. 若會爆長，保留核心 evidence，其他列成「可補資料」。
6. 若缺架構，就先補架構地圖，不要直接外包。
7. 若缺專案偏好，就讀 AGENTS / README / package / 使用者明確訊息；仍不足就列 Blocking Unknown。
8. 若缺進度，就用 git status、diff、test/log、最近紀錄重建；不能重建就明講。
9. 若缺 log，就貼精準 log；不要只說「有錯」。
10. 若是 code review，要附 diff 或 relevant snippets；外部 AI 沒有 git。
11. 若是策略/研究，要附已知資料與決策標準；外部 AI 不知道你的偏好。
12. 若涉及安全、資料庫、金錢、客戶資料或 production，明確寫出禁止操作與確認門檻。

## 最後自檢

送出前逐項檢查：

1. 外部 AI 不需要本地權限也能開始分析。
2. 報告包含專案偏好、程式設計、架構地圖、實務紀錄、目前進度、未完成事項、風險與精準問題。
3. 證據有編號，問題可引用證據。
4. 關鍵未知已列為 blocker，沒有偽裝成完整。
5. 敏感資訊已遮罩或取得使用者明確可外送範圍。
6. 問題是可回答的，不是叫外部 AI 自己查本機。
7. 已把本地 agent 的假說和外部 AI 要判斷的問題分開。
8. 使用者可以直接整段貼出去，不需要二次整理。
