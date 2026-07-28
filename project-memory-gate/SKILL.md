---
name: project-memory-gate
description: "Route /resume, /longrun, /goal, _ctx, durable handoff, and named workstreams to project memory."
---

# Project Memory Gate

## Purpose

控制何時讀 `_ctx` 與 project memory。這個 skill 的目標是讓接續任務真的接得上，同時避免每個小任務都展開歷史脈絡。

## Gate

只有命中下列任一條件才讀 project memory：

- 使用者明確輸入 `/resume`、`/longrun`、`/goal`、持續接力、接續前次狀態、交棒。
- repo `AGENTS.md` 明確指定目前 workstream 或 memory file。
- 任務需要 durable handoff，否則下一個 session 會失去關鍵狀態。
- 使用者指定 `_ctx`、workstream、handoff、PROJECT_STATUS、PROGRESS 等檔案。

未命中時，不讀 `_ctx`，不建立 project memory。

## Read Order

1. 先看 live truth：目前工作目錄、repo 狀態、相關檔案、terminal/log/test 輸出。
2. 若需要 memory，先只讀 `_ctx/INDEX.md`。
3. 只有 index 或使用者明確指向某個 workstream 時，才讀 `_ctx/workstreams/<name>/`。
4. 不一次展開所有 workstreams、sessions、archive、manifest。
5. 摘要不是 source of truth；重要判斷要能追到原始檔、log、test、artifact 或 manifest 指向的來源。

## Write Rules

只在以下情況寫 project memory：

- Long-Run Mode 已啟用。
- 使用者要求保存上下文、交棒、handoff、resume pack。
- repo workflow 指定必須更新狀態檔。
- 任務跨 session，且不寫會讓下一手無法安全接續。

寫入時保持最小：

- 目前目標
- 已驗證證據
- 已改狀態
- blocker 與風險
- 下一個可執行步驟

不要把聊天長文、歷史敘事、完整 log 直接塞進 memory；需要保留時放 artifact，再在 memory 裡連到它。

## Completion

完成時回報：

- 讀了哪些 memory 檔案。
- 寫了哪些 memory 檔案。
- 哪些結論來自 live truth。
- 下一個 session 可以從哪裡接。
