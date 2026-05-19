---
name: go
description: Use when the user invokes `/go` or `$go` to continue the current workspace autonomously from the latest goal, continuity, status, or conversation context by planning and executing the next meaningful verified segment. Stop and report a blocker if the goal is missing, unsafe, ambiguous, or conflicts with live state.
---

# GO

`/go` 是接續推進 skill，不是只接一句「下一步」的按鈕。

預設行為：抓住最近主線，自己規劃一個可驗證的大段落，推到 checkpoint，再回報結果與下一段。

## 目的

- 從最近對話、continuity、status、檔案與 live state 找出真正主線。
- 不是只做一個最小 next step，而是規劃並執行一個 `meaningful segment`。
- 每段都要有可驗證結果：檔案、測試、報告、archive、狀態變更、blocker 判定或下一個明確 checkpoint。

## 接續優先順序

依序找最可信的接續點：

1. 使用者最新明確目標或 `$go` 前一輪的下一段建議。
2. 最新 assistant final 裡的具體下一步 / 下一段。
3. 專案內可驗證 continuity / status / `_ctx/INDEX.md` / `docs/memory` / handoff。
4. 目前 workspace 的真實狀態、檔案、terminal、log、process。

若這些互相衝突，以 live state 和專案檔案為準，並指出衝突。

## Segment Mode

`/go` 預設進入 `segment mode`：

1. 先用一句話判斷主線。
2. 產生 3-7 步短計畫，步驟要能在本輪推進。
3. 先講「下一段要做什麼」，然後直接執行。
4. 每完成一個子步驟就更新狀態；不要只在最後一次說全部完成。
5. 遇到 blocker 先止血、驗證、回報，不硬衝。
6. 完成一個 meaningful checkpoint 就停，不無限擴張。

## meaningful checkpoint 定義

以下任一成立就算一段完成：

- 已完成並驗證一個功能、修正、清理、archive、報告、分析或設定。
- 已把 blocker 分類清楚，並拿到可追查證據。
- 已建立下一輪可直接接手的 manifest / plan / report / continuity marker。
- 已跑完必要驗證，且結果能支持下一步決策。
- 已達到使用者明確要求的「這段」完成點。

不算完成：

- 只讀了一些檔案但沒有收斂判斷。
- 只列計畫沒執行。
- 只靠推測說完成。
- 留下未驗證的表面成功。

## 自主範圍

可以主動做：

- 補讀必要檔案、狀態、log、manifest。
- 產生短計畫並照計畫執行。
- 做低風險、可回退、可驗證的檔案修改。
- 跑合理的驗證、dry-run、格式檢查。
- 更新報告、manifest、continuity marker。
- 若任務明確需要，建議使用其他 skill，但不要硬派。

必須停下或先回報：

- 目標不明，無法判斷主線。
- 需要 destructive 操作、production write、金錢、客戶資料、DB 寫入、庫存/訂單異動。
- 需要使用者確認的 scope 擴張。
- live state 和舊對話/文件互相矛盾，且無法用本機證據判斷。
- 下一段會跑超過 10 分鐘，且需要背景 worker / 監看視窗策略。

## 計畫格式

若工作超過單一步驟，先建立短計畫：

```md
目前判斷：...
下一段：
1. ...
2. ...
3. ...
完成標準：...
風險 / 停止線：...
```

計畫不是討論稿；講完就做。除非碰到停止線，不要停在規劃層。

## 執行規則

1. 先看現況，再動手。
2. 用可驗證現況修正舊對話假設。
3. 小步快跑，但一段要推到 checkpoint。
4. 不要把 unrelated refactor 塞進 `/go`。
5. 不要把「下一段」擴成整個專案重建。
6. 若需要新增/修改檔案，先說要改什麼，再改。
7. 完成後留下可追查輸出：路徑、報告、驗證結果或 blocker。

## 回報格式

優先短格式：

```md
目前判斷：...
已完成：...
已驗證：...
待確認 / blocker：...
下一段：...
百分比：...
```

若本輪只完成部分 segment，要明講完成百分比，不要包裝成全案完成。

## 停止條件

遇到以下情況就停：

- 找不到主線或接續點。
- 有多個互斥主線，且沒有足夠證據選一個。
- 需要高風險操作或明確授權。
- 驗證失敗且需要改變策略。
- 已完成一個 meaningful checkpoint，下一段會顯著擴 scope。

## 禁止事項

- 不要只靠上文一句 next step；要看 live state 與專案真相。
- 不要無限執行。
- 不要為了顯得自主而跳過驗證。
- 不要自己補產品決策或高風險授權。
- 不要把阻塞工具問題包裝成任務結論。
