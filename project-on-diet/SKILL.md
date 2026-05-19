---
name: project-on-diet
description: 'Use when a repo or project needs an intentional cleanup diet: noisy artifacts, logs, screenshots, stale exports, temp files, duplicate docs, old experiments, or attention-draining clutter should be archived to E:\CODEX AECHIEVE while preserving the essential project core.'
---

# Project On Diet

讓專案有感瘦身，但不切掉動脈。預設做法是「搬去封存」而不是永久刪除；只有在使用者明確要求且證據充足時，才做真正刪除。

## 核心契約

- 先看 live repo state，不用聊天印象判斷檔案價值。
- 先定義「精華」再處理噪音：source、設定、lockfile、測試、必要文件、schema/migration、fixtures、目前 runtime state、重要 debug/evidence、使用者手寫脈絡通常先保留。
- 預設封存根目錄是 `E:\CODEX AECHIEVE`。若 E 碟或目錄不可用，停下回報，不要偷偷改放 repo 內。
- 封存資料夾格式：`<project-name>__YYYY-MM-DD_HHMMSS__project-on-diet`，保留原始相對路徑。
- 大量搬移、刪除、production、database、金錢、訂單、庫存、客戶資料、token、secret 都是高風險；先做 preview、影響範圍、rollback plan，取得明確確認後再動。
- 不自動修改 AGENTS、skills、rules、hooks、`_ctx`，除非使用者明確要求或 repo workflow 指定。

## 搭配技能

- **REQUIRED SUB-SKILL:** 使用 `repo-cleanup-judge` 判斷 cleanup candidates，特別是 keep / move / delete / ignore 的證據。
- **REQUIRED SAFETY:** 如果牽涉高風險或大批量動作，使用 `risk-preflight`；若該技能不可用，手動輸出 dry-run、影響範圍、rollback plan、確認點。

## 工作流程

1. 盤點專案真相。
   - 讀 root listing、`git status`、`AGENTS.md`、README、package/build/test config、`.gitignore`、scripts、最近修改時間、最大資料夾。
   - 找出誰會讀或寫候選檔案：程式碼引用、設定引用、文件引用、測試引用、runtime state、產物輸出。

2. 定義保留精華。
   - 列出必保留核心：入口檔、source、設定、lockfile、測試、schema/migration、assets/fixtures、部署設定、目前工作中的文件、必要 project state。
   - 對不確定的檔案先標 `defer`，不要靠檔名猜。

3. 建立 Diet Matrix。
   - `keep`: 專案動脈、唯一真相、目前仍被引用、重要證據或使用者手寫內容。
   - `archive`: 有價值但會吸注意力；例如舊輸出、截圖、trace、log、一次性研究、重複 export、過期草稿、舊實驗。
   - `delete-after-confirmation`: 高信心可重建或完全無價值的 cache/temp/build artifact；仍需使用者明確同意才永久刪除。
   - `defer`: 證據不足、可能是唯一副本、可能含敏感資料、可能被 runtime 使用。
   - 每列至少包含 path、bucket、confidence、reason、bytes。

4. Preview 後再動。
   - 先輸出將保留、封存、刪除、延後的清單與總大小。
   - 建立 rollback plan：封存根目錄、如何搬回、manifest 路徑。
   - 若使用者已在同一請求明確要求「直接整理 / go / 不用再問」，仍要先停在 preview，只在低風險、少量、非 source-controlled 且可回復的 archive 動作上可繼續。

5. 封存執行。
   - 建立封存資料夾與 manifest。
   - 使用保留相對路徑的搬移方式；避免字串拼接造成路徑錯誤，Windows 上使用 `-LiteralPath` 類型操作。
   - 不封存 `.git`、secret、token、production data、database、唯一使用者資料，除非使用者明確要求且風險已說清。

6. 驗證。
   - 確認封存檔案存在於 `E:\CODEX AECHIEVE`，原位置已移除或如預期保留。
   - 跑至少一個合理驗證：測試、build、lint、啟動檢查、或最小 repo health check。不能跑就明講。
   - 檢查 `git status`，區分本次搬移與既有變更，不回復使用者原本的修改。

## 注意力噪音候選

優先尋找這些，但仍需證據：

- `dist/`、`build/`、`.next/`、`out/`、`coverage/`、`.cache/`、tmp、可重建產物。
- logs、trace、screenshots、browser dumps、HTML/JSON fetch dumps、debug snapshots。
- old exports、duplicate reports、one-off drafts、過期 experiments、未引用 sample。
- 大型媒體、錄影、壓縮檔、安裝包，若不是產品必要 assets。
- 生成過程留下的中間檔、失敗嘗試、已被新版本取代的副本。

## 預設保護

沒有明確證據前先保留：

- source、tests、fixtures、package/config/lockfiles、deployment files。
- README、AGENTS、handoff、project-spine、目前工作流或 repo 指定的 `_ctx`。
- migrations、schemas、database dumps、runtime state、queues、locks、daemon state。
- `.env*`、keys、tokens、客戶資料、訂單/庫存/金流資料。
- 唯一副本、使用者手寫筆記、仍被文件或程式碼引用的檔案。

## 完成輸出

用繁體中文，保持短而高信號：

1. `瘦身結果`: 搬移/刪除/保留數量與估計大小。
2. `保留精華`: 目前專案核心留下什麼。
3. `封存位置`: archive folder 與 manifest。
4. `驗證`: 跑了什麼、結果如何；沒跑就說未驗證。
5. `剩下風險`: defer 項目、需要人判斷的檔案、下一個最小清理步驟。
