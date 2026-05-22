---
name: thermo-nuclear-agent-harness-feedback-loop
description: "通用工程診斷哲學與可選分析模式。用於 Codex 面對可驗證問題、反覆失敗、證據矛盾、長線工作接力、worker 或 verifier 不可信時，先判斷是否適合建立 Agent 可操作的 Harness 與 Observability，再用 Hypothesis / Test / Result / Adjustment 的 Feedback Loop 分析 Root Cause 與 Fix。此 skill 不應自動改變專案主線、升級策略、擴大 scope、或執行高風險行動；主線變更前必須先確認。"
---

# thermo-nuclear-agent-harness-feedback-loop

## Purpose

這是一套通用工程診斷哲學，不是每次都必用的硬流程。遇到可驗證的工程問題時，不要直接猜答案，也不要把 Agent 當成一次性問答工具。先判斷這個問題是否適合建立 Agent 能操作的 Harness；若適合，再讓 Agent 看得見真實輸出、跑得動命令、查得到證據、驗證得了修正，透過 Feedback Loop 定位問題、驗證 Hypothesis、收斂到 Root Cause 與 Fix。

核心句：

Stop solving the problem yourself. Build the harness. Drop the agent into the loop.

## Operating Boundary

- 先做適用性判斷，再決定是否啟用完整 loop。
- 預設作為分析 overlay，不自動改變專案主線、roadmap、active workstream、策略方向或完成標準。
- 若分析結果暗示需要改主線、停掉原計畫、升級 factory、改 guard、改 verifier、改 production 設定、接 live/order/API/DB，先輸出 evidence、tradeoff、建議，再等使用者確認。
- 中途可以啟用；中途啟用時先整理目前已知 evidence、claim、缺口、可重跑指令與下一個最小可驗證動作。
- 小型、低風險、已有明確測試的單點修正，不必強行套完整 Harness；只需保留最低限度驗證。
- 這個 skill 不能把「分析建議」偽裝成「已確認決策」。

## When to Use

使用於可透過 log、test、command、metric、artifact、browser、DB preview 或 platform inspect 驗證的工程問題，例如：

- 同一類錯誤第二次出現。
- worker / script / AI / HTTP 200 / closeout 的 claim 與實際結果可能不一致。
- detail/search/listing、local/cloud、manager/front、test/live output 彼此矛盾。
- 長線工作中途接力，需要先分清已驗證事實與聊天印象。
- build cache 異常。
- deployment 變慢或部署行為改變。
- Docker / CI / Vercel / Next.js / Turborepo 問題。
- migration / schema / integration 問題。
- performance regression。
- 環境、設定、runtime、cache、lockfile、dependency 或 artifact 導致的可重現問題。

不使用於：

- 沒有可驗證結果的純主觀問題。
- 需求本身還沒定義清楚。
- 只能靠人工決策、法務、商業判斷的問題。
- 缺乏執行權限，且無法建立任何觀測管道的問題。
- 使用者只要求快速說明、review、策略討論，且沒有要求改檔或執行驗證。
- 問題已經有單一明確測試與小 patch，套完整 loop 只會製造流程成本。

## Core Principles

1. Stop trying to solve the problem yourself

   不要自己當 debug 英雄，也不要把 Agent 當成只會回答「可能原因」的工具。人的工作是設計跑道、觀測點、限制條件與驗證方式，讓 Agent 能用 evidence 推進。

2. Build a harness for agents to take control

   Harness 是讓 Agent 像真實工程師一樣能看得見、跑得動、查得到、驗證得了的工具集合。Harness 至少要提供：可執行命令、可讀 log、可重現步驟、可比較輸出、可回復或最小變更路徑。

3. Drop it in its own feedback loop until solved

   Agent 必須重複執行：

   Hypothesis → Test → Result → Adjustment

   直到 Root Cause 被驗證、修正被驗證，且結果穩定。若資訊不足，先補 Harness，不要先補腦。

## Harness Checklist

### Local Harness

- 檢查 repo 結構，找出實際入口、package、workspace、apps、packages、scripts。
- 檢查 package manager 與 lockfile，例如 npm / pnpm / yarn / bun 與對應 lockfile。
- 讀取相關 config，例如 `package.json`、`turbo.json`、`next.config.*`、Dockerfile、CI config、Vercel config、TS config。
- 檢查 env var 來源與差異；只讀必要資訊，避免輸出 secret。
- 找出 build / test / lint / typecheck / dev / deploy 相關指令。
- 找出 dry-run 或 inspect 指令，例如 `turbo run build --dry-run`、framework-specific inspect、CI dry-run。
- 檢查 `git status` 與 `git diff`，避免覆蓋無關變更。
- 檢查 log / cache / artifact / trace / coverage / bundle output。
- 建立最小重現步驟，讓每輪測試可重跑、可比較。

### Cloud Harness

- 取得 deployment logs。
- 取得 build logs。
- 使用 env pull / env inspect 比對遠端環境設定。
- 建立或讀取 preview deployment。
- 取得 cache hit / miss、build cache key、artifact restore/save 資訊。
- 使用 platform-specific inspect command，例如 Vercel / GitHub Actions / Docker / cloud provider CLI。
- 檢查 remote config / secret / runtime / region / framework inference / build image 設定。
- 檢查 error monitoring、metrics、trace、latency、resource usage。

### Observability

- Agent 必須能看到真實輸出，而不是靠猜。
- 每個 Hypothesis 都要對應一個可驗證指令或觀測來源。
- 每次 Test 都要留下 Result 摘要，包含關鍵輸出與判讀。
- 不允許把「看起來應該是」當成結論。
- 若輸出彼此矛盾，先處理矛盾，再繼續修正。
- 若觀測成本太高，先設計更小的替代觀測，不要跳到大範圍修改。

## Feedback Loop Protocol

### Loop Step Format

每一輪都要輸出：

1. Hypothesis
   目前假設是什麼。

2. Why this is plausible
   為什麼這個假設值得測；引用具體 evidence 或缺口。

3. Test
   準備執行什麼命令、讀什麼檔案、看什麼 log、比較什麼 metric。

4. Expected Result
   如果 Hypothesis 成立，應該看到什麼。

5. Actual Result
   實際看到什麼；保留足夠摘要，必要時引用檔案、命令或 log 位置。

6. Decision
   Hypothesis 成立、排除、部分成立，或需要拆成下一個 Hypothesis。

7. Next Minimal Action
   下一個最小、可驗證、可逆的動作。

## Required Behavior

- 啟用後先判斷「是否值得套完整 Harness」，不要直接改變工作模式。
- 不准因為 skill 啟用就自動改主線、換 roadmap、擴 scope、開長跑、改 project memory 或改 factory output。
- 不准直接猜 Root Cause。
- 不准一次改很多地方再測。
- 不准把「可能」寫成「已確認」。
- 每次修改前要先說明被哪個觀測結果支持。
- 每次修改後都要跑對應驗證。
- 如果測試失敗，要回到 loop，而不是硬凹。
- 如果資訊不足，要先補 Harness，不要先補腦。
- 優先採取最小可逆變更。
- 避免破壞性操作；若涉及刪除、重置、資料庫改動、production 設定，必須明確標示風險並要求人工確認。
- 若分析建議改變主線，最後只能寫「建議改主線」與 evidence；不能直接宣布主線已改。
- 最後輸出必須區分：
  - 已驗證事實
  - 被排除假設
  - Root Cause
  - Fix
  - Verification
  - Remaining Risk

## Output Format

Skill 啟用後，回覆使用以下格式；Root Cause 只有在被 Test 支持後才可填入：

【適用性判斷】
本次是否值得套完整 Harness / Feedback Loop；若不值得，說明原因並使用最小驗證。

【目標】
本次要解決的問題。

【主線影響】
預設寫「不改主線，只做分析」。若建議改主線，列出 evidence、tradeoff、需要使用者確認的決策。

【目前 Harness】
已可用的觀測與執行工具。

【缺少的 Harness】
目前還需要補上的觀測點、權限、指令或資料來源。

【Loop Log】

| Round | Hypothesis | Test | Result | Decision | Next Action |
| --- | --- | --- | --- | --- | --- |
| 1 |  |  |  |  |  |

【Root Cause】
只有在被測試支持後才填入；否則寫「尚未驗證」。

【Fix】
列出實際修改內容；若尚未修改，寫「尚未修改」。

【Verification】
列出跑過哪些驗證、結果是什麼。

【Recommendation】
若需要改工作流、主線、factory、guard、verifier、production 設定或高風險行動，只能在這裡提出建議與確認點。

【Handoff】
留下下一位 Agent 或人類可以接續的摘要，包含已驗證事實、被排除假設、剩餘風險與下一個最小動作。

## Anti-patterns

- 只靠直覺猜 bug。
- 一次改十個地方。
- 沒看 log 就下結論。
- 沒有 dry-run 就動 production。
- 看到第一個錯誤就停止思考。
- 修改後沒有驗證。
- 把模型能力當重點，忽略 Harness。
- 人類一直 prompt Agent，而不是讓 Agent 自己跑 loop。
- 把 transient failure 當永久 Root Cause，沒有重跑或交叉驗證。
- 把 platform claim、HTTP 200、AI summary 當成 evidence，而沒有看實際輸出。

## Example

問題：部署從 34 秒變成 3 分 22 秒。

Loop：

| Round | Hypothesis | Test | Result | Decision | Next Action |
| --- | --- | --- | --- | --- | --- |
| 1 | env var 污染 cache hash | 檢查 `turbo run build --dry-run` 與 `globalEnv` | 發現 `NEXT_PUBLIC_VERCEL_URL` 進入 `globalEnv` | 部分成立 | 移除或隔離該 env var 後重測 |
| 2 | 移除 env var 可恢復 cache hit | 重跑 dry-run 與 preview deployment | local hash 改善，但 cloud build 仍 miss cache | 部分成立 | 檢查 platform framework inference |
| 3 | Next.js framework inference 重新注入 env var | 檢查 Vercel build logs、env inspect、framework 設定 | build logs 顯示 deployment URL 仍影響 build input | 成立 | 調整設定並限制 build-time env |
| 4 | 修正後部署時間回復 | 重跑 preview deployment 並比較 cache hit / duration | cache hit 回復，部署回到 34 秒 | Fix 已驗證 | 記錄 Root Cause、Fix、Verification |

重點不是 Agent 一開始就知道答案，而是 Harness 讓它能查、能測、能比較、能排除錯誤 Hypothesis，最後收斂到被 evidence 支持的 Root Cause。

主線邊界：

- 這個結果可以支持「建議調整 deployment/cache 診斷主線」。
- 但除非使用者或 repo workflow 明確確認，不自動把專案主線改成 cache rewrite、platform migration 或大規模 refactor。
