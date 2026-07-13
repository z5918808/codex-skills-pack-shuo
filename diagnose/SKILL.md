---
name: diagnose
description: Diagnose bugs through bounded reproduction, falsifiable hypotheses, and evidence-based root cause.
---

# Diagnose

找出產品、工具、環境、權限、流程、資料或目標哪一層真的出錯。預設只診斷；除非使用者也要求修復，不直接實作 fix。

## Evidence States

全程分開：

- **observed**：直接看到的症狀或 artifact。
- **candidate hypothesis**：可否證的候選原因。
- **supported**：探針結果提高其可能性，但仍有替代解釋。
- **verified root cause**：能預測 before/after，且決定性 lineage 或獨立路徑排除關鍵替代原因。

不要把單次 log、相關性或「看起來像」寫成 root cause。

## 1. 定義正確症狀

先記錄：使用者看到什麼、預期什麼、時間／環境／身分／資料、影響範圍，以及什麼觀察能區分 before/after。

先分類層級，再選工具：

- 產品 contract／UI；
- client、network、gateway、service；
- cache、queue、database、external provider；
- build、runtime、process、artifact freshness；
- permission、workflow、data 或錯誤目標。

### 2. 找最便宜的決定性 signal

優先順序通常是：既有 artifact → read-only probe → failing test／replay → 隔離 harness → bounded 真實測試。

可用形式：test、HTTP fixture、CLI snapshot、browser flow、captured trace replay、differential run、property test、bisection 或 profiler。Signal 要對準原症狀，不只是「沒 crash」。

穩定 repro 最好，但不是推理的硬門檻。低頻 incident 可用 captured artifact 建暫定假設與探針；沒有第二路徑前不得定根因或開修法。

## 3. 建最小假設集合

只列能由下一個 probe 區分的候選，不固定 3–5 個。每項寫：

```text
If <cause>, then <probe> should produce <observable difference>.
```

先從 payload／單筆／route／family／system 由窄到寬。升級問題層級要有該級證據；不要因一次失敗封整個技術家族。

## 4. 用 probe 區分假設

每個 probe 對應一個預測。主動實驗通常一次改一個變數；低頻事件可在同一次被動觀察收集 request id、版本、cache key、watermark 等關聯欄位，避免丟失事件。

- debugger／REPL 適合單 process；
- targeted boundary logs 適合跨服務與非同步；
- trace、request id、version、cache header 適合分散式系統；
- profiler、query plan、timing harness 適合效能問題。

暫時 instrumentation 用唯一 tag，完成後可搜尋移除。保留 raw、redacted evidence；不要先 parse 到失真。

## 偶發與 Production 邊界

提高 reproduction rate 必須 bounded：限次、限速、唯讀、可停止，且不能干擾真實使用者。不能因難重現就預設 100×、平行流量、注入延遲或 production instrumentation。

若下一個 probe 需要 production write、敏感資料、額外流量或權限，先走 `$risk-preflight`；診斷需求不是授權。

## 修復與 Regression

只有使用者要求修復時：

1. 在能重現真實 defect pattern 的 seam 建 regression test；沒有正確 seam 就明列架構缺口。
2. 先看 test／repro fail，再做最小 fix。
3. 重跑原始 scenario 與相關 regression。
4. 移除 debug instrumentation 與 throwaway artifact。
5. 只有 defect class 重複或 seam 缺失會再發生時，才建議架構調整。

## 換策略與停止

- 同一候選連續兩次沒有資訊增益時，預設換 probe 或問題層級。
- 三次仍卡在同一證據缺口時，通常停止並留下 blocker；若事件影響與下一個 probe 的資訊增益明顯更高，可明講理由後續行。
- 停止也適用於：現有 artifact 無法區分候選、下一步越過權限／安全邊界、成本超過影響、或已取得可預測 before/after 的 root cause。

輸出只需：目前判斷、observed evidence、候選與已排除、root cause 強度、最小下一個 probe、blocked boundary。完成回報再加 regression 與原始 repro 的驗證結果。
