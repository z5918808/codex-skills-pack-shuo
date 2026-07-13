---
name: bigbots-deploy
description: "/bigbots-deploy or /lilbots-deploy: bounded multi-agent sidecars with root-owned synthesis."
---

# Bigbots Deploy

只在使用者明確要求 `/bigbots deploy`、bigbots、平行 agents 或 delegation 時使用。這份 skill 提供派工邊界；實際參數以目前可用 collaboration tool schema 為準，不捏造 model、effort 或 agent type。

## 啟動 Gate

派工前確認：

1. 主 agent 要留在本地處理的 critical path。
2. 至少兩個不互相等待、也不會重複本地主線的 sidecar。
3. 每個 sidecar 有單一產出、明確讀寫範圍與驗證方式。
4. 主 agent 仍擁有產品、架構、風險與完成判斷。

少於兩個真正獨立的 sidecar 就不要為了湊數 spawn；直接本地完成並說明原因。

## 選擇模式

### Research / Review

適合多角度查證、風險掃描或方案比較。常用角色：

- **Architecture Archaeologist**：結構、耦合、陳舊層、可刪複雜度。
- **Blind-Spot / Risk Hunter**：驗證缺口、脆弱假設、fake-complete state。
- **First-Principles Explorer**：更簡單且可執行的替代路線。

只填有用角色，不固定三個。所有角色都回傳 findings、evidence、風險／機會與建議下一步；不替主 agent 下最後決策。

### Plan Execution

只有在已有具體計畫、清楚 acceptance criteria、可分離 write scope 時使用。每個 worker 只拿一個責任區；若會寫相鄰檔案，先改成順序執行或重新切界。

## 派工流程

1. 用 `list_agents` 看現有 agents。
2. 合適且 idle 的 agent 用 `followup_task` 重新派工；執行中的 agent 只用 `send_message` 補充，不假設它會立即重啟。
3. 缺少的角色才用 `spawn_agent` 建立。
4. `fork_turns` 只給任務真正需要的上下文：
   - `none`：prompt 已含完整零背景 context。
   - 少量最近 turns：只需局部對話。
   - `all`：高度依賴整段歷史，且成本值得。
5. 主 agent 不空等；繼續不重疊的 critical-path 工作。
6. 用 `wait_agent` 收件；需要修正才用 `followup_task`，不是重開同一份工作。
7. 去重、處理衝突、反查高風險 claim，最後由主 agent 整合與驗證。

若槽位不足，改成重用、順序執行或本地完成；不要假裝已平行。Sidecar 偏題時只做一次 bounded 修正，仍無有效證據就中止。

不要在 prompt 使用當前 tool schema 沒有的欄位。若工具能力改變，先讀實際 schema，再決定路由。

## Sidecar Prompt Contract

每個任務至少包含：

```text
Workspace: <absolute path>
Goal: <shared outcome>
Your bounded task: <one task>
Read scope: <paths/systems>
Write scope: <none or exact paths>
Do not: <important boundary>
Evidence required: <file:line / command / run id / artifact>
Return: findings or changed paths, verification, blockers
```

需要獨立觀點時，用零背景 prompt 明列必要事實；需要共享 repo 決策脈絡時才 fork context。不要只丟角色名稱，讓 agent 自己猜任務。

## 單一 Writer

- 同一狀態、檔案或決策只有一個 writer。
- Read-only reviewers 可重疊讀，但要有不同問題。
- Worker 不回退其他人的變更，也不擴張 write scope；有必要先回報。
- 主 agent 負責整合後的測試、衝突處理與 artifact lineage。
- Prompt 的 `write scope: none` 不是 sandbox；只讀任務後仍要反查工作區是否被意外改動。

## 綜合與驗證

主 agent 必須：

1. 去除重複 finding。
2. 把衝突列成「觀察、證據、待決定問題」。
3. 用便宜的第二路徑反查關鍵 claim。
4. 明分 verified、high-confidence、needs verification。
5. 只把與原任務有關的結果放進 final；不貼 agents 原始報告。
6. 需要延續時，更新正確 workstream／status，不建立平行真相來源。

## 停止條件

完成於：所有有用 sidecars 已回傳或被明確中止、主 agent 已處理衝突、原 acceptance criteria 有證據、沒有未擁有的寫入。Agent 數量、固定角色、百分比報告或特定模型名稱都不是完成條件。
