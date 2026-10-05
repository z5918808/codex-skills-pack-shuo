---
name: thermo-nuclear-work-quality-review
description: "審查提示、文件、狀態與工作流程的複雜度、唯一權威、驗收及接手成本。"
---

# Work Quality Review

審查工作系統的維護與接手成本：提示、計畫、文件、狀態、dashboard、SOP、研究與 agent 工作流。快速問答、單一小修或純主觀偏好直接處理。

預設唯讀，提出 findings。使用者要求修復才做最小可驗證變更；審查本身保留主線、檔案及權限。刪除、合併或改契約的建議須有證據、風險及需要的授權。

## 審查判準

先刪除與簡化，再考慮搬移、分拆或自動化。規則需要一個可執行或 canonical owner。Wrapper 只有降低查找、決策、驗收或恢復成本才值得保留；純重包裝標成搬移而非複雜度下降。能跑完仍需能驗證、還原並讓下一位接手。

| 面向 | 要查證的問題 |
| --- | --- |
| 複雜度 | 修補前一步的額外步驟、人工協調點、重複狀態／摘要／dashboard，哪些可刪除或合併？ |
| 唯一權威 | 誰擁有目前事實與意圖，哪些只是 cache／報告？Index 能否指向原始證據並恢復主線？ |
| Wrapper | 是否減少實際成本，還是遮住執行邏輯並造成 stale state 誤判？ |
| 規則接線 | 規則是否散落在 prompt、script、worker 或人工記憶？文字提醒與真正執行 gate 分別在哪？ |
| 產物大小 | 是否混入多個任務層級？Status、history、decision、debug、handoff 是否各有適用 owner 與 retention／superseded 路由？ |
| 運作品質 | 需要的 preview、canary、rollback、驗收與 closeout 是否成立？失敗能否分類並修共享原因？ |

長度是線索。超過 1k 行須說明必要性，超過 2k 行檢查分拆或索引；保留必要契約與證據。Claim、摘要及 worker closeout 要追到實際驗收。

## Findings 與修正

每項 finding 附問題、原始證據、影響與具體處理，依嚴重度排序：

- P0：錯誤執行、資料破壞、正式事故、資金／客戶風險。
- P1：誤判主線、claim 當真相、重複執行。
- P2：顯著增加接手、驗收、恢復或除錯成本。
- P3：命名、格式或重複內容造成摩擦。

新增 script、rule、hook 或 skill 前，說明既有 owner 或直接簡化為何不足。高風險流程指出 preview、rollback 與結果驗證的具體缺口；缺測試、guard 或 verifier 的名稱與接線證據就標未實作。

## 完成

回報 verdict、關鍵 findings、優先刪除／合併、規則應回到的 owner、最小修正順序及剩餘風險。只有實際改動才報已修改；移動內容及增加文件的預期效果標成預期，不冒充成本實測。

需要判斷多份狀態檔與 dashboard 的例子時讀 [審查範例](references/example.md)。完成須讓讀者能定位問題、判斷嚴重度並選下一步，報告篇幅不作驗收。
