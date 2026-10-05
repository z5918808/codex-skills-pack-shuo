---
name: save
description: "保存當前工作線的精簡接手點；需要 last-known-good 時記錄可重跑的成功證據。"
---

# Save

保存當前工作線的一份精簡接手點。正式交接、跨工作線整理、index 更新、長期資料升級或封存，使用專案指定的 close-out／handoff 流程；`save` 保留目前狀態。

## 位置與範圍

1. 有 `_ctx/INDEX.md`：讀 index 及適用的 `_ctx/WORKSTREAMS.md`，更新 `_ctx/workstreams/<name>/SAVE.md`。
2. 有 `docs/memory/THREAD_INDEX.md`：更新 `docs/memory/threads/<thread>/save.md`。
3. 沒有 thread 結構：更新 `docs/memory/save.md`。

工作線無法確定時，使用對應結構的 `unknown` 存點並標 `needs_routing: true`。沿既有位置原位覆寫成目前狀態；保持工作線獨立。可建立必要目錄，index、repo spine 與外部記憶維持原狀。

## 內容

一般存點保留 `thread`、`session_marker`、`updated_at`、目前焦點、已驗證、風險／未知、一個下一步、關鍵檔案及 handoff prompt。只帶會影響接手的事實，通常控制在 80 行內；使用者要求或必要內容較多時保留完整契約。

使用者說 `save it works`、`這版可以` 或要保存穩點時，加上：

- `works_evidence`：實際成功證據；缺證據就標待確認。
- `verify_command`：下次可重跑的命令或可檢查的路徑。
- `changed_files`、`last_safe_step`、`next_safe_step`：相關變更與安全接續點。

已有 save 格式就沿用；需要範例時讀 [save 格式](references/save-format.md)。有值得保留的重用事實時讀 [候選事實與升級邊界](references/promotion.md)，只記 1–3 條候選，由既有 close-out writer 決定升級。秘密、客戶資料、逐步流水帳與未驗證推測留在其適用受控位置。

## 完成

先看可驗證現況，再選存點類型與位置、更新檔案並讀回。完成須讓下個 session 迅速定位目標、證據、未知與下一步；last-known-good 須含可重跑或可檢查證據。回報位置、類型、已驗證內容與下一步。需要完整外部接手或檔案整理時，交由相應流程處理。
