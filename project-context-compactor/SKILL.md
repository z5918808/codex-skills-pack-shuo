---
name: project-context-compactor
description: "/ctx: slim active project context while preserving routing, provenance, and recoverability."
---

# Project Context Compactor

讓未來 agent 更快找到有效狀態。預設只整理 active retrieval，不自動做磁碟清理、搬移、打包、去重或刪除。

## 先分模式

- **Logical compaction（預設）**：縮短 active context、分開 workstream、修正 routing、保留來源座標。
- **Disk cleanup**：只有使用者明確要求整理磁碟／archive／pack／dedupe 才進入。
- **Permanent deletion**：獨立高風險 gate；必須明示具體 scope，不能由「變瘦」推定。

若使用者說「先不要刪」，也不要偷渡 move 或 pack；路徑改變本身可能破壞引用。

## Truth Sources

先讀 repo `AGENTS.md` 與既有 `_ctx/INDEX.md`。`_ctx` 不存在只代表 repo-local retrieval layer 尚未建立，不代表專案沒有 memory。

只檢查會改變判斷的來源：

- 既有 `_ctx/`、`ctx/`、`.ctx/`。
- status、handoff、continuity、session、decision、architecture 文件。
- repo 內 legacy memory／archive／import manifest。
- 使用者或 repo 明確指定的外部 memory。

不要硬編碼某台機器的 palace、wing 或全域路徑。外部來源不可用時，記錄 recovery hint，不假裝已查證。

## 預設流程

### 1. Read-only inventory

找出：

- 活躍 workstreams 與各自 state owner。
- 當前入口、status、決策、facts、open questions。
- 重複、過時、混合多工作流或沒有 provenance 的 active context。
- dirty worktree、未知檔案與不能安全分類的內容。

選最小範圍；不要因一次 compaction 掃完整磁碟。

### 2. Classify

每個來源只需落入足以決策的類別：

- `active_source`
- `summarize_or_index`
- `archive_candidate`
- `generated_or_delete_candidate`
- `unknown_preserve`

未知就保留。只有 exact hash 可直接稱 duplicate；近似內容仍需人工／語義判斷。

### 3. Compact active retrieval

優先修改既有 `_ctx`，不要預建空架構。最小可用形狀通常是：

```text
_ctx/
  INDEX.md
  workstreams/<name>/STATUS.md
```

只有資料量或追溯需求真的需要時，才加 manifest、facts、decisions 或 file map。每份內容都回答：現在是什麼、證據在哪、下一步是什麼。

若 `_ctx` 本身有未提交變更，先看 diff 並保留使用者內容；不能用整理版覆蓋未知修改。

`INDEX.md` 只放 routing：workstream、入口、state owner、來源與恢復位置。`STATUS.md` 只放 current state、已驗證、待辦、blocker、最後更新與 provenance。

### 4. Preserve provenance

重要 claim 附最便宜可恢復座標：原始路徑、章節／行、run id、hash 或外部查詢提示。不要為了 schema 完整，替每個普通檔案填十幾個空欄位。

需要 manifest 時採 append-only 精簡記錄，例如：

```json
{"id":"M001","source":"docs/old.md","current":"docs/old.md","workstream":"billing","status":"indexed","sha256":"...","note":"decision history"}
```

### 5. Verify and stop

用 3–5 個真實 lookup 問題驗證：

- 新 agent 從哪裡開始？
- 當前主線與 owner 是什麼？
- 最近一個重要決策的來源在哪？
- 未完成與 blocker 在哪？
- 原文如何恢復？

入口可用、工作流未混線、重要 claim 可追溯後立即停止。

## Disk Cleanup Gate

只有使用者明示後，才提出 bounded move／archive／pack／dedupe plan。執行前列出：來源、目的地、引用風險、預估節省、rollback、驗證方式。

- Dirty worktree 與 active source 原位保留。
- Archive 先複製／驗證再考慮移除舊位置。
- Pack 後驗證可列出並解開；失敗就保留兩份。
- Dedupe 只處理 exact hash，保留 canonical copy 與 recovery record。
- Generated output 也先列 candidate；永久刪除另問授權。

## 停止與輸出

先給判斷，再列已驗證、改了哪些 routing／status、未動的候選與下一個需要授權的動作。若現有 context 已夠瘦，直接停止；不要為了使用 skill 製造新架構。
