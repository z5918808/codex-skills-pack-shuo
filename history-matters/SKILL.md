---
name: history-matters
description: "/history matters, $history-matters, project history review, 不完全相信最新context, goal mode"
---

# HISTORY MATTERS

用專案歷史回顧校正短期 context，找回主線初心，再看未來怎麼走。

這不是一般整理筆記，也不是相信舊 memory。目標是把「最新說法」放回長期證據裡檢查：什麼仍然成立、什麼已經漂移、哪條主線一直沒變、下一步該怎麼用 `/goal` 推進。

## 何時使用

- 使用者要做 project history review、歷史回顧、初心回顧、從歷史看未來。
- 使用者說不要完全相信最新 context、latest handoff 可能漂移、短期 context 可能遮住主線。
- 使用者要更強的 stepback、準備 `/goal`、長跑接力、或想把專案主線重新定錨。

不要用在單純問答、小修檔、一般 code review、或不需要歷史脈絡的短任務。

## 核心規則

1. 最新 context 不是 truth；舊 memory 也不是 truth。兩邊都要被 evidence 校正。
2. 先定義主戰場與「存在證據」：這個專案真正要交付什麼、什麼證據能證明它還在往那裡走。
3. 歷史只讀到足以判斷方向；不要為了完整而翻遍所有檔案。
4. 所有結論分成 `Verified / Inferred / Unknown`。
5. 重要判斷盡量用第二路徑反查；只能單一路徑時標成 weak verification。
6. 發現歷史證據與最新 context 矛盾時，先處理矛盾，不用樂觀摘要蓋過。
7. 不自動改 AGENTS、skills、rules、hooks、memory 或 `_ctx`；除非使用者明確要求。

## 證據優先序

優先讀 live truth，再讀 durable history：

1. Live repo / artifacts / tests / logs / browser / DB preview / current output。
2. Durable state：`_ctx`、`PROJECT_STATUS.md`、session log、ledger、reports、release notes、review notes、handoff、archive manifest。
3. Version history：git log、diff、branch truth、issue / PR / ticket history。
4. Memory：只當索引與舊線索，不當最終事實。
5. Latest chat / latest handoff：當 claim，不當 truth。
6. Inference：只能用來排下一步，不能包裝成已驗證。

## 工作流

### 1. 定義主戰場

先用短句回答：

```text
Current game board: 這次不是要整理所有歷史，而是要確認 <main outcome> 是否仍是主線，並找出 <next strategic move>。
```

同時定義：

- Project surface：這次看哪個 repo、資料夾、產品線、或工作流。
- Existence proof：什麼 evidence 證明主線存在。
- Frozen surface：哪些東西先不碰。
- Risk surface：是否碰到 production、DB、金錢、訂單、客戶資料、credential、destructive、bulk operation；有就先切風險預檢。

### 2. 快速建立歷史時間線

只抓能改變方向的節點：

- Original intent：一開始到底想完成什麼。
- Durable decisions：哪些決策反覆出現，可能是專案核心。
- Turning points：哪幾次改變了路線或 proof 標準。
- Recurring blockers：哪些卡點一直回來。
- Factory gaps：哪些問題每次靠人工補救。
- Stale claims：哪些舊結論可能已過期。
- Latest claims：最新 context 說了什麼，但尚未被證明。

### 3. 校正最新 context

把最新 context 拆成三類：

- Still true：被 live 或 durable evidence 支持。
- Drifted：曾經成立，但現在證據已改變。
- Unproven：看起來合理，但缺少可重跑證據。

不要急著產出大計畫。先確認最新 context 是否把 agent 帶離初心、把 visible issue 當主線、或把舊 blocker 當現況。

### 4. 從歷史看未來

輸出不是預測水晶球，而是 route judgment：

- 哪條主線最穩：因為它被最多 durable evidence 支持。
- 哪條路最容易重蹈覆轍：因為歷史上反覆卡在同一 failure class。
- 哪個最小下一步最有槓桿：因為它能產生存在證據、解除瓶頸、或吸收反覆問題。
- 哪些 visible tasks 要 defer：因為它們不改變主線、驗證、交接、或安全。

### 5. 轉成 goal mode

若使用者明確要 `/goal`、goal mode、長跑接力，或這次回顧的目的就是讓下一位 agent 開工，最後輸出一份可直接貼用的 goal prompt。

格式：

```markdown
/goal [一句話主目標]

Current state:
- Verified: [仍成立的歷史與 live 證據]
- Drifted or unproven: [最新 context 需要校正的點]
- Main bottleneck: [真正限制主線的瓶頸]

Roadmap:
1. [歷史證據校正] - evidence: [可重跑證據]
2. [主線薄片] - evidence: [存在證據]
3. [工廠/驗證補強] - evidence: [同類問題更早被抓到或更便宜被處理]

Rules:
- Do not trust latest context or old memory without evidence.
- Report delta only: verified / changed / blocker / next.
- Stop on evidence conflict, safety gate, missing source, or goal complete.
```

若不需要 terminal-ready `/goal`，只輸出短版：

```markdown
判斷：
[一句話主戰場]

歷史證據：
- Verified: [...]
- Inferred: [...]
- Unknown: [...]

最新 context 校正：
- Still true: [...]
- Drifted: [...]
- Unproven: [...]

未來路線：
1. [...]
2. [...]
3. [...]

下一個最小動作：
[action] -> verify: [evidence]
```

## 停止規則

- 歷史證據與最新 context 矛盾，且無法用 live proof 解開。
- 找不到任何 durable artifact，只能靠聊天記憶推論。
- 任務碰到高風險 surface，但沒有 dry-run、preview、rollback、或確認。
- 回顧開始變成無限考古，卻沒有改變主線判斷。
