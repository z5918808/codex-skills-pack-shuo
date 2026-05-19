---
name: checkpoint
description: "Use when the user wants a serious project checkpoint: organize a large project state, materialize conversation artifacts into project files, archive unnecessary files safely, and leave a durable handoff that a future session can resume from."
---

# Checkpoint

`checkpoint` 是大型專案存點，不是聊天摘要。

目標是把目前工作現場收斂成可接手、可回溯、可清理、可繼續推進的專案狀態。它比 `/save` 重：`save` 只保留輕量接手點；`checkpoint` 要把對話裡的重要產物落回專案、整理現場，必要時封存不需要的檔案。

## 核心哲學

1. 先保存真相，再整理現場。
2. 先把對話裡的可重用內容落成專案檔案，不讓重要東西只留在聊天。
3. 封存優先於刪除；不確定用途的檔案不刪。
4. checkpoint 的成果不是「講清楚了」，而是下一個 agent 能直接從 checkpoint 開工。
5. 不把 cleanup 當表演；只整理會降低未來成本、風險或混亂的東西。
6. 一切以 live truth 為準：檔案、log、status、測試、artifact、git 狀態，而不是記憶。

## 與 Save 的差異

用 `/save` 當使用者只是要：

- 存一下目前狀態
- 留一個 30 秒可讀的接手點
- 保存 last-known-good
- 不需要清理、封存、project index、project library 或檔案落地

用 `/checkpoint` 當使用者要：

- 大型專案整理
- 里程碑 checkpoint
- 換對話前正式交棒
- 把聊天中的 prompt、規格、決策、檔案內容、報告落實進專案
- 封存舊檔、臨時檔、過期 artifacts
- 讓下一個 session 不用翻 raw transcript

## 模式

先選一個模式，不要全部都做。

| 模式 | 何時使用 | 產物 | 封存 |
| --- | --- | --- | --- |
| `checkpoint` | 一般 checkpoint、大型專案交棒 | checkpoint / handoff / status 檔 | 不封存，只列候選 |
| `checkpoint-plus-archive-plan` | 使用者提到整理、封存、不需要的檔案、現場太亂 | checkpoint + archive plan | 只產生計畫，不搬不刪 |
| `checkpoint-plus-archive-execute` | 使用者明確要求執行封存，或確認過 archive plan | checkpoint + archive manifest | 搬到 archive / quarantine，不直接刪 |
| `materialize-only` | 使用者只要把對話內容落成專案檔案 | 建立/更新指定檔案 + 短 checkpoint | 不封存 |

預設：

- 若使用者只說 checkpoint：用 `checkpoint`。
- 若使用者說大型專案整理、封存、archive、不需要的檔案：用 `checkpoint-plus-archive-plan`。
- 只有明確授權才進 `checkpoint-plus-archive-execute`。

## 寫入位置

先遵守專案既有記憶系統。

1. 若 `_ctx/INDEX.md` 存在：
   - 先讀 `_ctx/INDEX.md` 和 `_ctx/WORKSTREAMS.md`。
   - checkpoint 寫到 `_ctx/workstreams/<name>/CHECKPOINT.md` 或既有等價檔。
   - 跨 workstream 事實才寫 repo-level `_ctx` 檔。
2. 若沒有 `_ctx`，但有 `docs/memory/THREAD_INDEX.md`：
   - 寫到 `docs/memory/threads/<thread>/checkpoint.md`。
3. 若沒有既有結構：
   - 寫到 `docs/checkpoints/<YYYYMMDD-HHMM>-<slug>.md`。
   - 封存計畫寫到 `docs/checkpoints/archive-plan-<YYYYMMDD-HHMM>-<slug>.md`。

不要發明多套記憶系統。能更新既有檔就更新既有檔。

## 對話內容落地

checkpoint 要主動檢查聊天中是否有應該落回專案的內容：

- prompt / goal prompt
- 規格、acceptance、workflow、SOP
- 使用者明確給的檔案內容
- 決策、約束、風險、rollback
- 測試結果、驗證指令、known-good 狀態
- 報告、表格、review 結論
- 未來 agent 需要重用的操作真相

落地規則：

1. 使用者給了明確檔名或位置，就寫到那裡。
2. 專案已有對應檔案，就更新既有檔，不另存 v2 / final / new。
3. 沒有指定位置時，優先寫入 checkpoint 檔；若內容會被重用，再拆到 `docs/`、`prompts/`、`reports/` 或既有專案結構。
4. 不確定是否該寫成正式檔案時，先放進 checkpoint 的 `Materialized / To Materialize` 區塊並標待確認。
5. 不把未驗證推測寫成專案真相。

## 封存原則

封存不是刪除。

可封存候選：

- 過期 scratch / temp / debug output
- 被新版 artifact 取代的舊 HTML / report / screenshot
- 舊 run 的大型中間產物
- 已驗證可重建的生成物
- 重複、失敗、已不再服務主線的 pilot output

不可封存，除非使用者明確確認：

- active run / state / manifest / log
- source input、不可重建資料
- 使用者手動檔案
- 目前腳本按固定路徑依賴的檔案
- credentials、token、customer data
- 不確定用途的檔案

封存執行規則：

1. 先產生 archive plan：root、keep、candidates、reason、risk、restore path。
2. 執行前確認每個 target 的 resolved absolute path 位於專案 root 或使用者指定 root 之下。
3. 預設搬到 `archive/<YYYYMMDD-HHMM>-<slug>/` 或專案既有 archive / quarantine 位置。
4. 保留相對路徑與 manifest，讓檔案可還原。
5. 驗證 archive 可列、大小合理、manifest 存在後，才回報完成。
6. 不做不可逆刪除，除非使用者二次明確確認。

## 工作流程

1. 看 live truth
   - 讀 `_ctx` / memory / status / handoff / project docs。
   - 看 git status、重要檔案、artifact、log、worker 狀態。
   - 分清楚已驗證、推論、待確認。

2. 選模式
   - 判斷是 `checkpoint`、`checkpoint-plus-archive-plan`、`checkpoint-plus-archive-execute` 還是 `materialize-only`。
   - 明確說出模式與原因。

3. 落地對話產物
   - 把本輪可重用 prompt、規格、決策、檔案內容、驗證指令寫進專案。
   - 若內容只適合保存，不適合正式檔案，寫進 checkpoint。

4. 建立 checkpoint
   - checkpoint 至少包含：
     - thread / workstream
     - updated_at
     - current phase
     - mainline
     - verified facts
     - materialized files
     - archived / archive candidates
     - blockers / risks
     - next step
     - key files and verification commands
     - handoff prompt

5. 封存或產生封存計畫
   - 沒有授權就只產生 plan。
   - 有授權才搬移到 archive / quarantine。
   - 永遠保留 manifest。

6. 驗證
   - checkpoint 檔存在且內容可接手。
   - materialized files 存在且位置正確。
   - archive plan / manifest 存在。
   - 若搬移檔案，確認 active state 沒被破壞。
   - 若改了腳本或文件格式，做最低限度檢查。

7. 回報
   - 短回報即可：
     - 模式
     - 寫入哪些檔案
     - 封存了什麼或產生哪份 plan
     - 已驗證
     - blocker / 下一手

## Checkpoint 格式

```md
# Project Checkpoint

- updated_at: <time and timezone>
- mode: checkpoint / checkpoint-plus-archive-plan / checkpoint-plus-archive-execute / materialize-only
- thread: <thread-or-workstream>
- current_phase: <phase>
- progress: <percent if useful>

## Mainline
- ...

## Verified Facts
- ...

## Materialized Files
- path:
  source:
  purpose:
  verified:

## Archive
- status: none / plan-only / executed
- plan:
- manifest:
- candidates:
- archived:

## Blockers / Risks
- ...

## Next Step
- ...

## Key Files / Verification
- ...

## Handoff Prompt
- ...
```

## 禁止事項

- 不把 checkpoint 降級成純聊天摘要。
- 不只把重要內容留在對話裡。
- 不在沒有 plan 的情況下封存、搬移或刪除。
- 不刪除不確定用途的檔案。
- 不把不同 thread 的狀態混進同一份 checkpoint。
- 不更新 repo-wide spine，除非事實真的跨 workstream 成立。
- 不把 MemPalace、外部記憶或 raw transcript 當唯一真相。
- 不因為 checkpoint 就停止或重啟 active worker，除非使用者明確要求。
