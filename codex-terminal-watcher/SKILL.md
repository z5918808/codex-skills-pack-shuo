---
name: codex-terminal-watcher
description: Use when the user invokes /codex-terminal-watcher or wants Codex to inspect the latest terminal state, judge whether work is still on track, and correctly interpret running, stopped, blocked, failed, stale, or completed terminal output.
---

# Codex Terminal Watcher

`codex-terminal-watcher` 是 Codex App terminal 的狀態判讀器。

使用者通常會在兩種情境叫它：

- terminal 還在跑：要判斷事情是否在正軌、是否有進展、是否卡住。
- terminal 停了：要判斷是正常完成、失敗停止、等待輸入、已經 stale，還是其實只是看起來停。

它不是自動接手執行器。除非使用者明確要求繼續工作，先只做觀察、判讀、回報下一手。

## Primary Rule

先看最新 terminal 狀態，再做判斷。

優先用 `read_thread_terminal`。如果工具讀不到，但使用者貼了 terminal 文字或截圖，使用貼文/截圖當證據並標明來源。

不要讓舊 sidecar log、舊 screenshot、舊對話記憶蓋過最新 terminal。

## Evidence Order

1. 使用者最新訊息、貼上的 terminal、截圖。
2. Codex App thread terminal via `read_thread_terminal`。
3. workspace 狀態與 artifacts：`AGENTS.md`、`_ctx/INDEX.md`、`PROJECT_STATUS.md`、`GOAL.md`、`PROGRESS.md`、`SESSION_LOG.md`、latest logs / reports / generated artifacts。
4. 若 terminal 提到 native Codex CLI、`/goal`、sidecar、或 active CLI process，再查 CLI status helper：

```powershell
& "<codex-skills-dir>\check\scripts\Check-CodexCliStatus.ps1" -Workspace "<workspace>" -Detailed
```

5. generic Codex CLI sidecar logs under `%LOCALAPPDATA%\CodexCliSidecars\codex-cli\<run>\`：`last-message.md`、`stdout.log`、`prompt.md`、`exit-code.txt`。
6. process scan 只能當弱證據。process 存在不代表有進展；process 消失也不代表成功。

## Status Classification

每次都要明確歸類成一個主要狀態：

- `running_on_track`：仍在跑，最近輸出有新進展，沒有明顯錯誤或等待輸入。
- `running_suspect`：仍在跑，但輸出長時間重複、卡同一步、無新 evidence、或可能 busy-loop。
- `waiting_for_input`：terminal 明確等確認、選項、密碼、登入、權限、互動輸入。
- `stopped_success`：已停止且有可驗證完成證據，不只 exit 0。
- `stopped_failed`：已停止且有錯誤、測試失敗、exception、non-zero exit、或明確 aborted。
- `stopped_blocked`：已停止，原因是缺資料、缺權限、缺環境、需人工決策或安全 gate。
- `stale_or_unknown`：輸出太舊、讀不到、證據不足、或無法判斷 terminal 是否仍代表現在狀態。
- `completed_unverified`：看起來完成，但缺測試、artifact、reload、count、screenshot 或其他驗證。

不要把 `idle prompt`、`exit code 0`、`Done`、`Goal achieved`、或「沒有紅字」單獨當成功。

## On-Track判讀

判斷是否正軌時看：

- 最近輸出是否對應目前目標。
- 是否有新 artifact、count、test、log、stage progress。
- 是否正在處理下一個合理 stage，而不是偏到無關工作。
- 是否反覆重跑同一步且沒有新增 evidence。
- 是否出現 prompt waiting、auth waiting、approval waiting、Open With、PowerShell 紅字、selector 卡住、timeout、或無限 retry。
- terminal 最後一段是否有明確下一步或 stop gate。

如果還在跑但狀態良好，回報「繼續監看」而不是打斷。

如果停了但完成未驗證，回報應做的最小驗證，不要宣稱完成。

如果停了且失敗，先分清楚是工具、環境、資料、權限、流程、還是目標系統問題。

## What To Extract

只抽 evidence-backed facts：

- terminal/session 來源。
- workspace / objective。
- 主要狀態分類。
- 是否仍在正軌。
- 進度百分比，如果有足夠 evidence。
- 最後有效輸出。
- 已驗證：tests、artifact paths、counts、screenshots、reloads、logs、exit code 加上可判讀內容。
- 未驗證 / 風險：缺什麼證據。
- blocker：如果有，分類為工具、環境、權限、流程、資料或目標系統。
- 下一個最小動作：繼續等、補驗證、修工具、請使用者輸入、或接手執行。

## Output Shape

用繁體中文，短而準。預設格式：

```text
目前判斷：
狀態分類：
進度：
terminal 是否正軌：
已驗證：
待確認 / 風險：
blocker：
下一步：
/Explain：
```

若 terminal 還在跑：

- 說明是否應繼續等。
- 說明下一個值得觀察的訊號。
- 若看起來卡住，說明多久或哪個 pattern 讓它可疑。

若 terminal 停了：

- 說明停在什麼狀態。
- 區分成功、失敗、blocked、或完成但未驗證。
- 給一個最小可執行下一步。

## Hard Rules

- 不靠記憶判斷 terminal 現況。
- 不把舊輸出當最新狀態。
- 不因為 process 存在就說正軌。
- 不因為 terminal 停了就說完成。
- 不自動重啟、停止、輸入密碼、按確認或接手執行，除非使用者明確要求。
- 需要高風險操作、production write、database、金錢、訂單、庫存、客戶資料時，只回報 gate，不繞過確認。
