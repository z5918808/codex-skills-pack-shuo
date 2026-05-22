---
name: thermo-nuclear-work-quality-review
description: "非純代碼的高強度工作品質與複雜度審查。用於 review plans、prompts、AGENTS.md、handoffs、docs、dashboards、SOP、agent workflows、factory outputs、project memory、research pipelines、verification routes、long-running workstreams 等非代碼或半代碼工作系統。目標是刪除複雜性而不是搬移它，標記薄層 wrapper、洩漏的邏輯、過大的 artifact、含糊的 source of truth，以及那些能運作但會讓系統更難維護的流程。"
---

# thermo-nuclear-work-quality-review

## Purpose

用這個 skill 審查「工作系統」的品質，而不是只審 code。它把 code review 的嚴格 maintainability lens 套到非代碼產物：計畫、prompt、handoff、AGENTS、docs、dashboard、狀態檔、agent workflow、factory output、verification path、研究管線、長跑任務與接力流程。

核心目標：

- 刪除複雜性，而不是移動它。
- 拒絕「能運作，但讓下次更難運作」的成果。
- 把散落在聊天、文件、腳本、人工記憶裡的邏輯抓出來。
- 讓下一位 Agent 或人類用更小介面、更少上下文、更穩驗證接手。

## Operating Boundary

- 這是 review lens，不是自動重構模式。
- 啟用後先輸出審查判斷，不自動改主線、不自動改檔、不自動刪檔。
- 若建議刪除、合併、改 AGENTS、改 skill、改 memory、改 workflow、改 production process，先列 evidence、風險與確認點。
- 若使用者明確要求修，才做最小可驗證改動。
- 不把「更有秩序的包裝」誤認為「複雜度下降」。如果只是搬家，仍然要標出。

## When to Use

使用於：

- review 長 prompt、長 handoff、長 AGENTS.md、長 README、長專案狀態檔。
- review agent 長跑流程、durable continuation、handoff、checkpoint、project memory。
- review factory output、scripts / hooks / rules / skills 的分工是否變胖。
- review dashboard、report、status board 是否只是重複資訊。
- review research pipeline 是否在用更多文件掩蓋缺少驗證。
- review SOP / workflow 是否把人工判斷藏在步驟裡。
- review 多 agent / multi-thread 工作線是否 source of truth 混亂。
- review 「可以跑，但接手成本越來越高」的成果。

不使用於：

- 使用者只要快速答案，不需要系統品質審查。
- 需求還沒定義清楚，無法判斷複雜度是否必要。
- 單一小修小補，沒有流程、文件、狀態或接力成本問題。
- 純美感、品牌、商業、法律或主觀偏好決策。

## Review Principles

1. Delete complexity, do not relocate it

   先問「這個 artifact / step / rule / prompt / wrapper 是否能消失？」再問要放去哪裡。把混亂從 chat 搬到 doc、從 doc 搬到 checklist、從 checklist 搬到 skill，不算改善。

2. Thin wrappers are guilty until proven useful

   只轉述、改名、包一層、聚合但不降低決策成本的文件、腳本、agent、dashboard、index 都是薄層 wrapper。保留前必須證明它減少查找、驗證或恢復成本。

3. Logic must have one executable or canonical home

   規則不能同時散落在聊天、AGENTS、README、script、worker log、memory、人工習慣裡。若邏輯會影響執行，優先放到 test / guard / script / verifier / source-of-truth doc，而不是散文。

4. Working is not enough

   能跑完但讓下一次更難判斷、更難驗證、更難 rollback、更難交接的工作，品質仍不合格。

5. Size is a smell, not proof

   長文件、長 prompt、長 state file、超大 dashboard、超多 reports 不一定錯，但必須證明它們被索引、可查找、可驗證、可裁剪。

## Review Checklist

### Complexity

- 是否有步驟只是為了修補前一個壞步驟？
- 是否能刪掉 requirement、artifact、handoff、report、wrapper，而不是再包一層？
- 是否把一個問題拆成太多人工協調點？
- 是否有重複的狀態檔、重複的摘要、重複的 dashboard？
- 是否有「每次都要讀很多上下文才敢動」的設計味道？

### Source of Truth

- 目前真正 source of truth 是哪一個檔案、命令、DB、log、artifact 或 report？
- 是否存在多個互相矛盾的 truth source？
- 是否有聊天印象、AI summary、closeout claim 被當成 truth？
- 是否能從 index 追到原始 evidence？
- 下一位 Agent 是否能不用讀整條聊天就恢復主線？

### Wrappers

- 這個文件、script、skill、index、dashboard 是否只是在重包裝別處內容？
- wrapper 有沒有減少 token、查找、執行或驗證成本？
- wrapper 是否隱藏了真正執行邏輯？
- wrapper 失效時，是否會讓人誤信 stale state？

### Leaked Logic

- 規則是否散落在 AGENTS、README、prompt、script、worker、manual habit 裡？
- 執行條件是否只能靠人記得？
- safety gate 是否只是文字提醒，而不是 test / guard / script？
- verifier 是否能代表真實完成，還是只代表某個 claim？

### Artifact Size

- 單一檔案是否過大到難以掃描？參考警戒線：超過 1k 行要 justify，超過 2k 行要拆或建立索引。
- 單一 prompt / handoff 是否包含多個不同任務層級？
- dashboard 是否同時承擔 status、history、decision、debug、handoff？
- report 是否有明確 retention / archive / superseded 規則？

### Operational Quality

- 這套流程是否有 dry-run、canary、rollback、verification、closeout？
- 失敗是否會留下可分類 reason code？
- 重複失敗是否會修 worker / verifier / guard，而不是逐筆補洞？
- 完成定義是否區分 claim、evidence、verification、remaining risk？

## Severity Rubric

- P0: 會造成錯誤執行、高風險操作、資料破壞、production 事故、資金或客戶資料風險。
- P1: 會讓 Agent 或人類誤判主線、錯把 claim 當 truth、重複執行錯流程。
- P2: 會顯著增加接手、驗證、恢復、debug 成本。
- P3: 命名、格式、文件結構或重複資訊造成摩擦，但不阻塞決策。

## Required Behavior

- 先列 findings，按嚴重度排序。
- 每個 finding 都要說明：問題、證據、影響、建議處理。
- 優先建議 delete / simplify，再建議 move / split / automate。
- 不准只說「整理一下」；要指出哪個 artifact / step / logic 應該消失或搬到 canonical home。
- 不准把更多文件當成預設解法。
- 不准自動改主線或改檔；除非使用者明確要求修。
- 若建議新增 script / rule / hook / skill，必須說明為什麼比刪除或簡化更好。
- 對高風險流程，必須標出 dry-run、preview、rollback、verification 缺口。

## Output Format

【Verdict】
一句話判斷：這套工作系統是 clean、manageable、bloated、fragile、還是 unsafe。

【Findings】

| Severity | Area | Problem | Evidence | Impact | Recommendation |
| --- | --- | --- | --- | --- | --- |
| P1 |  |  |  |  |  |

【Delete First】
列出應優先刪除、合併、停止使用、降級或封存的東西。

【Canonical Homes】
列出哪些邏輯應該回到 test / guard / script / verifier / source-of-truth doc。

【Do Not Add】
列出不應再新增的 wrapper、doc、dashboard、agent、流程或抽象。

【Minimal Repair Path】
列出最小修復順序；先刪除與簡化，再補 guard / script / skill。

【Remaining Risk】
列出即使照建議做，仍然存在的風險。

## Anti-patterns

- 把聊天摘要當 project memory。
- 建更多 dashboard 來掩蓋沒有 source of truth。
- 用新 skill 包住壞流程。
- 用 handoff 重述所有歷史，而不是指向 evidence。
- 每次失敗都加一條規則，但不刪舊規則。
- 把 stale report 放在首頁。
- 讓 Agent 每次都靠讀長文重新推理，而不是跑 checkpoint。
- 用「流程很完整」掩蓋沒有 verification。
- 把 high-risk guard 寫成提醒，而不是 executable gate。
- 為了降低焦慮增加文件，結果提高接手成本。

## Example

輸入：一個長跑 agent 專案有 5 個 status docs、3 個 handoff、2 個 dashboard、1 個 AGENTS 規則、1 個 worker closeout，但每次接手仍要讀整條聊天才知道能不能繼續。

審查結果：

- P1: source of truth 洩漏。status docs 與 dashboard 都宣稱 current state，但沒有單一 checkpoint command。建議保留一個 `current_state` report，其他改成 archive/provenance。
- P1: closeout claim 被當 truth。worker closeout 沒有 independent verifier。建議完成定義改成 closeout + verifier + artifact evidence。
- P2: handoff 過大。handoff 包含歷史敘事、下一步、規則、debug route。建議拆成 `INDEX`、`CURRENT`、`MANIFEST`，並刪除重複段落。
- P2: wrapper 過多。dashboard 只是重包裝 status docs，沒有降低決策成本。建議停止更新 dashboard，直到有明確 decision gate。

不是新增第 6 個狀態檔，而是刪到只剩一個可刷新狀態入口、一個 provenance index、一個 verifier。
