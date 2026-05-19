---
name: save
description: Use when the user wants a lightweight checkpoint, says save it works, wants the current verified state preserved for a later session, or needs a quick resume point without full close-out, MemPalace sync, cleanup, or project index maintenance.
---

# Save

`/save` 是輕量 checkpoint。它不是 mini close-out，也不是專案記憶系統。

目標只有一個：把「下一個 agent 30 秒內最需要知道的可驗證接手點」寫到最合適的一份 save 檔。

## 核心原則

1. 預設只更新一份 save 檔。
2. 寫短、寫真、寫可接手；不要貼整段聊天。
3. 只寫已驗證真相；不確定的事要明確標成待確認。
4. `save it works` 要保存 last-known-good 證據，不只寫「可以了」。
5. 同一 repo 可有多條 thread / workstream；不要把不同任務線混進同一份 repo-wide save。
6. 技術事實可列為候選，但不要在 `/save` 階段升級到 repo spine。
7. 需要完整 handoff、跨 thread continuity、project_library、MemPalace 或清理時，用 `/close-out`。

## Routing

先找最小但正確的寫入點。

優先順序：

1. 若 `_ctx/INDEX.md` 存在，先讀 `_ctx/INDEX.md` 和 `_ctx/WORKSTREAMS.md`。
   - 能判斷 active workstream：寫 `_ctx/workstreams/<name>/SAVE.md`。
   - 不能判斷：寫 `_ctx/workstreams/unknown/SAVE.md`，並標 `needs_routing: true`。
2. 若沒有 `_ctx`，但有 `docs/memory/THREAD_INDEX.md`：
   - 能判斷 thread：寫 `docs/memory/threads/<thread>/save.md`。
   - 不能判斷：寫 `docs/memory/threads/unknown/save.md`，並標 `needs_routing: true`。
3. 若沒有 thread 結構，fallback 寫 `docs/memory/save.md`。

規則：

- 檔案存在就覆寫成最新狀態，不無限 append。
- 缺資料夾可以建立，但不要更新 `THREAD_INDEX.md`、`_ctx/INDEX.md`、`project_spine.md` 或 MemPalace。
- 如果本輪明顯跨多條 thread、跨 campaign、或需要正式交接，停下並改用 `/close-out`。

## Save Types

### Standard Save

用於一般「存一下」、「save」、「換對話前留接手點」。

至少包含：

1. `thread`
2. `session_marker`
3. `updated_at`
4. `current_focus`
5. `verified`
6. `risks_or_unknowns`
7. `next_step`
8. `key_files`
9. `handoff_prompt`

### Last Known Good Save

使用者說 `save it works`、`it works`、`這版可以`、`先存這個穩點` 時，優先用這種格式。

除了 standard 欄位，必須多記：

1. `works_evidence`：什麼證明它真的 works。
2. `verify_command`：下次可重跑的指令、瀏覽器檢查、log、截圖或人工驗證路徑。
3. `changed_files`：這個穩點相關檔案。
4. `last_safe_step`：目前可安全回到哪一步。
5. `next_safe_step`：下一步最不容易破壞穩態的是什麼。

不要只寫「works」；沒有證據就寫 `works_evidence: 待確認`。

## Recommended Format

```md
# Save Point

- updated_at: 2026-05-05 16:55 Asia/Taipei
- thread: <thread-or-workstream>
- session_marker: <short-human-title>
- save_type: standard / last-known-good
- needs_routing: false

## Current Focus
- ...

## Verified
- ...

## Last Known Good
- works_evidence: ...
- verify_command: ...
- changed_files: ...
- last_safe_step: ...
- next_safe_step: ...

## Risks / Unknowns
- ...

## Next Step
- ...

## Key Files
- ...

## Facts To Promote Later
- ...

## Handoff Prompt
- 下次先讀這份 save，確認 verified / next_step，再直接做下一步。
```

若不是 `last-known-good`，`Last Known Good` 區塊可省略。

## Facts To Promote Later

`/save` 可以記 1-3 條候選事實，但不負責升級。

可列入：

- 已驗證、未來同 thread 會重用的技術事實。
- 可能跨 thread 成立，但還需要 close-out 判斷的穩定規則。
- 新發現的驗證指令、入口、failure mode。

不可列入：

- 只是本輪流水帳。
- token、secret、cookie、customer data。
- 未驗證推測。
- 長篇架構說明。

升級去處：

- 同 thread 共用事實：由 `/close-out` 放到 thread facts / `_ctx/workstreams/<name>/FACTS.md`。
- 跨 thread 事實：由 `/close-out` 放到 repo spine。

## Workflow

1. 先看最新可驗證現況：檔案、狀態檔、terminal/log、測試、剛完成的改動。
2. 判斷 save type：standard 或 last-known-good。
3. 判斷 thread/workstream；找不到就用 `unknown` 並標 `needs_routing: true`。
4. 壓成短 save：目標是 80 行內，除非使用者明確要更完整。
5. 覆寫目標 save 檔。
6. 回報寫入位置、save type、已驗證內容、下一步。

## Do Not Use Save When

- 需要正式 close-out / handoff。
- 需要保留多個 thread 的獨立脈絡並更新 index。
- 需要同步 MemPalace。
- 需要 project_library 或長期 campaign continuity。
- 需要清理、瘦身、archive、壓縮或刪除。
- 需要給外部 AI / 人類完整接手。

以上情況用 `/close-out` 或對應 skill。

## Completion Standard

只有以下條件成立，才算 `/save` 完成：

1. 最合適的 save 檔已存在且內容是最新的。
2. 下一個 session 不用重讀整段對話也能開工。
3. 內容夠短，沒有變成流水帳。
4. 已區分 `Verified` 與 `Risks / Unknowns`。
5. 若使用者說 `it works`，已保存可重跑或可檢查的 works evidence。
6. 若 thread 無法判斷，已標 `needs_routing: true`，沒有污染主 thread。

