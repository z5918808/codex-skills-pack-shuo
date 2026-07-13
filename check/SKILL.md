---
name: check
description: "/check: inspect current workspace evidence, classify status, and name the smallest verification step."
---

# Check

`/check` 是只讀 evidence gate：判斷目前做到哪、哪些只是 claim、缺哪個最小 proof。它不自動續跑 goal、開 worker 或修復問題。

## Evidence Ladder

只讀會改變判斷的最便宜來源，順序通常是：

1. 使用者同一則訊息貼出的 output。
2. 目前 workspace 的 named status、artifact、test、log、run id。
3. 目前 terminal、worker、monitor 或 process 的可讀輸出。
4. 與目前 workspace、run id 明確相符的 sidecar／CLI metadata。
5. 需要時才查舊 transcript 或請使用者貼精確缺口。

Current workspace 優先。不要靜默使用另一個 workspace 的 `last-run`、mtime-latest、舊 sidecar 或 chat memory。

`STATUS=complete`、agent closeout、HTTP 200 與 process existence 都只是 claim。完成需要與任務相符的可重跑 proof。

## 最小檢查

先回答：

- target 是什麼；
- authoritative state／artifact 是哪個；
- 最新 verified checkpoint；
- acceptance criteria 還缺哪個 evidence；
- 下一個動作是否越過 write、live 或 permission 邊界。

只有 repo guidance 要求時才讀 `AGENTS.md`／`_ctx`；只有 native CLI 與任務相關時才查 CLI sidecar。不要把工具 inventory 當固定儀式。

## 狀態分類

選最接近的一個，必要時加一個 secondary note：

- `complete-and-verified`：結果存在，相關 proof 通過，安全邊界成立。
- `progress-made-verification-missing`：output 存在，但關鍵測試／稽核缺失。
- `blocked-by-missing-evidence`：缺口使下一步無法安全決定，且本機無法恢復。
- `blocked-by-safety-boundary`：下一步需要未授權的 live／destructive／敏感操作。
- `running-with-readable-output`：與 target 相符的工作仍在跑，且輸出顯示有進展。
- `stale-or-ambiguous-state`：artifact、workspace、run id、process 或 writer 對不上。
- `output-unavailable`：知道可能有 run，但沒有可讀 transcript／log；不能猜內容。
- `pivot-recommended`：證據顯示現路線沒有攻擊真正瓶頸。

舊 metadata 不得推翻較新的 project evidence。另一個 workspace 的 `running` 只能標 stale，不是目前 target 的狀態。

## Terminal 與 Process 邊界

- Terminal 開著不代表 Codex child 還在跑。
- Process 結束不代表成功；要讀 exit marker、transcript 或 artifact。
- 沒有 transcript 只代表該 evidence path 不可用，不一定是主線 blocker。
- `pending_user_paste` 不代表命令已執行。

Native CLI 真正相關時，可用現有 helper：

```powershell
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1"
```

需要指定 workspace／run 時先看 helper 支援參數；不要預設跨 workspace 的 global latest。

## 決策

- 有 verified completion：回報完成與 proof，停止。
- 有 output、缺驗證：跑或指出最相關的一個驗證。
- 本機可恢復 evidence：先恢復，不問使用者。
- 無法恢復：只索取精確缺失 output，不要求整段歷史。
- 現路線錯：說明哪個 evidence 推翻它與最小 pivot。
- 遇 safety boundary：列 blocking rule、missing gate、minimal safe next。

## 輸出

保持短：

```text
目前判斷：<status + 一句結論>
已驗證：<evidence coordinate>
未驗證：<material gap>
blocker：<none or boundary>
最小下一步：<one decisive action>
```

只在使用者要求細節時列候選 artifact／run。`/check` 的完成標準是讓狀態可判斷，不是列完所有可能來源。
