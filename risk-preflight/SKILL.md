---
name: risk-preflight
description: "Preflight destructive, production, database, financial, secret, bulk, deployment, or irreversible actions."
---

# Risk Preflight

## Purpose

在高風險操作前建立可檢查的安全閘門。這個 skill 不是長跑流程；它只回答一件事：現在能不能安全執行寫入或破壞性動作。

## Risk Classes

高風險包含：

- production、部署、live theme、公開發布。
- database、migration、bulk update/delete、超過 10 筆資料。
- 金錢、訂單、庫存、預約、通知、客戶資料。
- token、secret、權限、broad-scope credential。
- destructive filesystem 或 git 操作，例如大範圍刪除、批量 move/delete、`git reset --hard`、`git checkout --`。

高風險不自動等於 Long-Run。先進 Safety Gate；只有需要跨 session 或 durable handoff 時才再啟用 long-running workflow。

## Preflight Checklist

執行前必須取得：

1. 目標：要改什麼。
2. 範圍：會影響哪些環境、檔案、資料表、records、使用者或資源。
3. 證據：來自 live truth 的目前狀態，不用記憶猜。
4. Preview：dry-run、diff、plan、affected row count、或等價預覽。
5. Rollback：如何回復；不能回復就明講。
6. Guard：應使用的 script、rules、hook、MCP guard、CLI wrapper 或專門 skill。
7. Confirmation：需要使用者明確確認時，先停下。

## Routing

- Database / migration / bulk data：優先用 `$agent-db-safety` 或 repo guard。
- Vendor commerce / orders / inventory / live storefront：使用對應平台 skill，寫入前先做 preview / diff / plan。
- Browser / UI critical flow：用 browser skill 或專案既有驗證流程。
- Codex CLI sidecar 或 automation：確認不繞過 production、金錢、客戶資料、destructive 限制。
- Git destructive：除非使用者明確要求且風險已說清，否則不要執行。

若 guard script、rules、hook 或專門 skill 不存在，回報缺口；不要用 AGENTS 假裝已經硬性 enforce。

需要盤點哪些保護應該 hardcode 時，讀 `references/hard-guard-gaps.md`。一般 preflight 不必讀。

## Decision

輸出其中一種：

- `Proceed`: 已有 preview、範圍、rollback，且不需額外確認。
- `Need confirmation`: 影響 production、高價值資料、超過 10 筆、不可逆、或使用者需選擇策略。
- `Blocked`: 缺少權限、guard、preview、rollback、或現況證據。
- `Reduce scope`: 先改 staging、少量樣本、read-only audit、或建立 dry-run。

## Completion

回報要短：

- 風險等級。
- 預覽證據。
- 影響範圍。
- rollback / recovery。
- 現在是 proceed、need confirmation、blocked，還是 reduce scope。
