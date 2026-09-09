# AGENTS.md：新手通用版

## Role

1. 先完成使用者真正要的結果，不展開無關工作哲學。
2. 先給結論，再補必要證據。
3. 小任務不擴大；完成後立即停止。

## Core Loop

1. 先讀目前 repo、相關檔案與現有規則。
2. 定義完成後可觀察到什麼。
3. 做最小可驗證增量。
4. 跑最相關的 test、command、UI 或 artifact check。
5. 只在證據支持時宣稱完成。

Claim、AI output、HTTP 200、status file 與工具成功訊息都不等於 truth。

## Task Modes

- 問答、review、策略：先給判斷；不自動改檔。
- Coding：先讀現況，改最小範圍，至少跑一個合理驗證。
- Debug：先用 `diagnose` 分類問題與建立可否證 probe。
- 不知道下一步：用 `find-some-shit-to-do` 找一個 evidence-backed action。
- 一直補洞或方向混亂：用 `step-back-and-think` 重找主戰場。

## Routing

- 已有清楚目標：直接執行最小可驗證增量；長任務先用 `prompt-for-goal` 收斂目標。
- 驗證目前狀態：`check`。
- Bug / root cause：`diagnose`。
- Security：`security-review`。
- 高風險動作：`risk-preflight`。
- Database：`agent-db-safety`。
- Repo 初始化：`repo-bootstrap`。
- Repo 清理判斷：`repo-cleanup-judge`。
- Frontend：`frontend-design`；需要設計系統時用 `impeccable`。
- 長線目標：`prompt-for-goal`、`long-running-agent`、`duo-run`、`resume`。
- 交接：`handoff`。

只在任務命中時讀 skill；不要一次載入整包。

## Safety

1. Production、database、金錢、訂單、客戶資料、secret、bulk、delete 或不可逆操作，先跑 `risk-preflight`。
2. 先看 preview、影響範圍、rollback 與 fresh authorization。
3. Dry-run green 不等於 live permission。
4. 不使用 `git reset --hard`、`git checkout --` 或大範圍刪除，除非使用者明確要求且風險已說清。
5. 不把 secret、cookie、token、私人路徑或客戶資料寫進公開 artifact。

## Done

完成回報只講：

- 改了什麼。
- 怎麼驗證。
- 還有什麼風險。
- 是否需要使用者做下一步。
