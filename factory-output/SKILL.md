---
name: factory-output
description: "Make repeated work reusable as a skill, script, rule, hook, verification route, or handoff."
---

# Factory Output

## Purpose

把值得重複使用的做法沉澱成可重跑資產。這個 skill 不是每次任務完成都要用；它只在沉澱能明顯改善下一次工作時啟用。

## Gate

啟用條件：

- 使用者明確說保存流程、沉澱、factory output、做成 skill、做成 script、加 rules、加 hooks。
- 同類問題第二次出現。
- 已形成穩定的 test command、debug route、preflight、handoff、verification loop。
- 不沉澱會讓後續任務明顯更危險、更慢、或更難恢復。

不要啟用：

- 一次性小修。
- 純問答、策略討論、prompt review。
- 還沒有驗證過的臨時 workaround。
- 只是「看起來可以整理」但沒有實際重複價值。

## Choose The Asset

優先選能被機器執行或被明確觸發的形式：

1. `scripts/`：固定、可重跑、需要可靠執行的流程。
2. `rules/`：命令級 allow / prompt / forbidden 類限制。
3. `hooks/`：生命週期檢查，例如 pre-tool、post-tool、stop、session start。
4. `skills/`：需要判斷、分流、或多步驟工作流，但不適合常駐在 AGENTS。
5. repo docs / `_ctx`：專案狀態、handoff、決策紀錄。
6. `AGENTS.md`：只放最小 routing hint 或重複踩雷的 repo convention。

若能用 script / rule / hook 解決，不要只寫成 AGENTS 偏好。

## Workflow

1. 先確認要沉澱的是已驗證流程，不是未證實想法。
2. 判斷這是 user-level、repo-level，還是 project memory。
3. 選最小資產類型。
4. 建立或更新資產。
5. 跑基本驗證：格式、可執行性、或至少 dry-run。
6. 回報觸發條件、資產位置、驗證結果、剩餘缺口。

## Stop Conditions

停止並回報，不硬寫：

- 沒有明確重複價值。
- 需要 production token、客戶資料、或 destructive 操作才能驗證。
- 應該由 CI、pre-commit、MCP guard、或外部系統 enforce，但目前沒有該系統。
- 使用者只是要快速完成主線，沒有要求沉澱。

## Completion

完成回報只講：

- 沉澱成什麼。
- 放在哪裡。
- 什麼情境會觸發。
- 驗證了什麼。
- 哪些 enforcement 還只是軟性提示。
