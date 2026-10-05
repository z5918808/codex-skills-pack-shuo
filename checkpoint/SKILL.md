---
name: checkpoint
description: "保存大型專案的可接手狀態與對話產物；依要求規劃或執行可回復的封存。"
---

# Checkpoint

將大型專案現況與本輪重要產物寫成可驗證的接手點。只要輕量存點或 last-known-good 時使用 `save`；正式 checkpoint 同時核對內容是否已落回正確的專案檔案。

## 模式與權限

| 模式 | 產物 | 檔案整理 |
| --- | --- | --- |
| `checkpoint`，預設 | checkpoint／handoff／既有 status | 只列候選 |
| `checkpoint-plus-archive-plan` | checkpoint 與 archive plan | 提到整理或封存時先規劃，保留原檔 |
| `checkpoint-plus-archive-execute` | checkpoint、封存及 manifest | 使用者明確要求執行，或已核准計畫 |
| `materialize-only` | 指定產物與短 checkpoint | 只落檔 |

計畫與執行封存前讀 [封存契約](references/archive.md)。先確認 resolved absolute paths、保護項目、restore path 及 manifest；永久刪除仍需要使用者二次明確確認。Checkpoint 本身不授權停止或重啟 active worker。

## 選擇寫入位置

先遵守專案既有記憶契約及指定 writer。

1. 有 `_ctx/INDEX.md`：讀 index 及適用的 `_ctx/WORKSTREAMS.md`，更新對應工作線的 `CHECKPOINT.md` 或等價檔。Repo 層只記確實跨工作線成立的事實。
2. 有 `docs/memory/THREAD_INDEX.md`：更新對應 thread 的 checkpoint。
3. 沒有既定位置：使用 `docs/checkpoints/<YYYYMMDD-HHMM>-<slug>.md`；封存計畫置於同一目錄的 `archive-plan-<YYYYMMDD-HHMM>-<slug>.md`。

已存在的產物原位更新。使用者指定的檔名與位置優先；可重用的規格、prompt、SOP、決策或驗證指令才拆到專案既有對應文件。不確定能否成為正式文件時，在 checkpoint 標成待落地／待確認。

## 建立與驗證

1. 核對目前檔案、git 狀態、對應 runtime、測試及 artifact，分開已驗證、推論與待確認。只讀本工作線所需資料。
2. 選模式並落地可重用產物。秘密及敏感資料沿受控設定保存；原始 transcript／外部記憶只作線索。
3. 寫入工作線、時間、phase、主線、已驗證事實、落地檔案、封存狀態、阻礙／風險、一個下一步、關鍵檔案／驗證及 handoff prompt。沒有既定格式時參考 [checkpoint 欄位](references/checkpoint-format.md)。
4. 依選定模式產生計畫或執行封存，再讀回 checkpoint、落地檔案及 plan／manifest。執行後確認可還原、active state 與必要入口仍完整；腳本或格式有變更時跑相關檢查。

完成須能讓下一位 agent 從接手點定位原始證據並開始工作。短報告列模式、實際寫入／封存、驗證結果、未完成項目及下一步；工具成功與聊天摘要本身不足以驗收。
