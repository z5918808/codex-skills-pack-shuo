---
name: giga-factory-design-method
description: Design a reusable streaming workflow for repeated multi-stage data work when dependencies, handoffs, verification, or failure recovery need an end-to-end design. Use before scaling or restructuring such work; not for routine batches on an already validated route.
---

# Giga Factory Design Method

把成果、依賴、驗證與恢復設計成可反覆執行的工作流，減少逐筆行政派工。這是設計方法，不啟動產線、不建立 task、不授予外部操作或 authority。角色建立、模型、交接與直接回件依既有協作契約，不在此重複定義。

## Trigger

使用者明示要求此方法時執行限定設計。否則只有以下三項同時成立才採用：

1. 工作包含至少兩個可重複的實質工作單位，或已明確要把成功單位擴大；不是只看資料列數。
2. 單位會經過兩個以上具有依賴、持久化或驗收差異的階段。
3. 尚缺可沿用的整體工作流，或已有具名證據顯示逐筆交接、整批等待、狀態重抄、失敗擴散使擴大受阻。

不觸發：普通問答、一次性小修、已有成熟命令即可完成的資料批次、已驗證工作流的健康續跑、單一商品差異。大量資料但路線已成熟時直接沿用，不為證明資料很大而盤點全量。相同 scope 不每批重新觸發；只有依賴、完成條件、權限、state owner 或有證據的瓶頸改變時重看受影響部分。

## Role Contract

在已授權 TRIO 中，既有 Thinker 先做 bounded workflow proposal；Main 提供最小事實與待決問題，不先完成整套方案再請 Thinker 蓋章。Thinker 僅提出設計、反例與待驗假設，不批准 stage、商品或開工。Main 擁有 authority、設計採納、必要 shared repair、review 及 acceptance；Luna 擁有已授權執行、逐單位閉環與證據。沿用角色，不用 subagent、額外 writer 或輪詢。非 TRIO 任務不因載入本 skill 自動取得協作派工權限。

## Design Steps

1. **固定結果與邊界。** 指出使用者可驗成果、現有 state owner、權限、不能改的契約及正在執行的工作。以小量可定位成功／失敗案例和現有 runner 為依據，不全量重查。
2. **畫出現行依賴。** 量化交易、人工往返、等待及缺口。分開 measured、inferred、unknown；有時間跨度不等於全部是行政浪費。
3. **選 cell。** Cell 是可辨識 input、完成條件、恢復及責任的工作集合；交易單位可小於 cell。列出至少一個被拒的切法及理由。商品、分支、文件或分區由依賴決定，不硬定一列或整批。共用資源只有一個 owner；未完成項目保留於原 cell，不拆批藏掉。
4. **先刪，再融合。** 刪沒有決策價值的重複交接／轉抄；融合可沿用契約的派工與資料投影。保留真實 ID 產生、unknown outcome、語意決策、權限、安全、前台或實際使用者結果、不可逆動作前證明等硬邊界。硬邊界可用可驗條件表達，不自動等於人工往返。
5. **設計 streaming。** 每個 stage 寫 owner、input、output、依賴、gate、批次上限、失敗範圍及下一消費者。依賴齊即前移，不等不相關整批。並行只給已授權且不競爭同一資源的工作；queue／WIP 上限來自 route 與證據，沒有量測就標假設。不讓 Main 逐筆派工，不靠新增 writer 換吞吐。
6. **定義狀態與恢復。** 沿用唯一 canonical owner；packet 與 receipt 是投影／證據，不建立平行 ledger。每個動作需要 fresh identity、允許差異、完整性、回復材料與消費紀錄。未定結果不得盲重試；隔離 exact item 及依賴，但 shared writer／安全狀態未知必須阻止所有相依寫入。不要為了標榜 cell 隔離縮小真正的風險範圍。
7. **整合驗收。** 所有必要內容、圖片及使用者可見結果都進同一 cell 完成條件；逐交易薄驗證即時執行，人工 review 集中在有決策價值的集合。抽驗不能替代必要全量機器驗證；新缺陷可以增加必要驗收，不以固定 review 次數壓低標準。
8. **制定最小遷移與 canary。** 優先重用現有 routes，區分已支持與需 Main 實作的接縫。選一個具名、有代表性且 bounded 的完整 cell；無證據就給一個最便宜 selection query，不猜。目標同時量測結果正確性、首成果、總等待、往返、利用率與 recovery，基線缺失標明，禁止虛報倍速。列出退出／退回既有路徑條件。

## Fixed Thinker Output

用一份既有交付位置的簡潔規格或直接回件，包含以下欄位；有機器消費需求才另做 JSON，不強制新增追蹤文件：

- `outcome_and_scope`：結果、排除項、current owner／active work。
- `evidence_and_bottleneck`：refs、measured facts、hypotheses、unknowns。
- `cell`：input、Done、transaction unit、rejected alternative、shared dependencies。
- `stages[]`：id、owner、input、output、depends_on、gate、cap 及依據、failure_boundary、consumer。
- `remove_or_fuse[]`：原步驟、刪合理由、仍保留證明。
- `hard_boundaries[]`：觸發條件、影響範圍、解除所需證據／owner。
- `state_and_authority`：唯一 owner、packet／receipt 角色、freshness、no-replay、rollback、現有能力與缺口。
- `verification`：每筆證明、集合 review、使用者可見 Done、失敗後重驗範圍。
- `canary_and_migration`：exact cell 或 selection query、caps、measures、active-work 安全交界、implementation gap、退出條件。
- `recommendation`：推薦方案、重要反例、Main 仍須決定事項；沒有就寫 `none`。

## Main Review Rejection Tests

若下列任一成立，Main 要求只修正該設計缺口，不重開全案：

- 只有下一筆工單或泛泛原則，沒有完整 cell Done 與 stage 資料流。
- 把資料量大直接等同增加 agents／writers，或把 Thinker 當每次核准門。
- 仍要求 Main 逐筆派工，或無真正共享依賴卻設 whole-batch barrier。
- 新建第二 state owner、重抄同一 truth，或把未實作 token／gate 寫成已可執行。
- 把 unknown 當 empty／success、無 fresh identity／replay 防護，或 shared writer 未知仍允許另一 cell 寫入。
- 整合後漏掉圖片、protected fields、readback 或必要使用者可見驗收。
- 上限、提速數字或觸發門檻無來源卻當事實；只量 ready 後時間、隱藏 prep 和 repair 成本。
- 沒有 bounded canary／恢復條件，或要以改寫在途契約、另開 profile／task 才導入。

## Active Work

設計可與無關健康執行並行，但不碰它的 browser、writer 或 immutable contract。Main 先保存未來改動；在既有 Worker 回件、effects 與待 review 已處理的 safe boundary，發布同一目標的必要 successor，保留 accepted 前綴，再由同一 Worker 續作。若新指令要求停止，依既有停止協議處理，不能用等待自然邊界繼續違反指令。設計與 skill 編輯本身不等於發布或執行。只有未解依賴受阻，其他已授權工作照常推進。
