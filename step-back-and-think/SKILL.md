---
name: step-back-and-think
description: "用於使用者要求 /step-back-and-think、退一步想、俯瞰架構、由廣至深分析局勢、找關鍵突破點、停止見洞補洞，或為 codebase、工作流、文件、技能系統、營運流程設計最低可用大工廠時。特別適合判斷哪些 visible defects 可以延後，哪些底層 product / factory / verification / interface 設計才是主戰場。"
---

# Step Back And Think

用這個技能把注意力從局部洞口拉回整體賽局：先判斷系統真正輸在哪裡，再看主線瓶頸、反覆失敗的 pattern，最後設計一個「最低可用的大工廠」。

大工廠不是大改造，也不是把每個洞補得更快。它是一個小而穩的可重用機制，能吸收一整類問題，讓同類問題下次更難發生、比較早被發現、比較便宜被驗證，或不再需要人工救火。

不要用可見度排序問題。高可見瑕疵可能只是 fit-and-finish；真正高槓桿的突破點通常在 product architecture、factory architecture、interface、state ownership、verification、release path、debug route、或 workflow operating system。

## 核心判斷

先問：

- 這個問題在整個賽局裡真的重要嗎，還是只是最 visible？
- 它是單點缺口、表面瑕疵，還是底層 factory gap 的症狀？
- 如果只補這一洞，同類問題會不會很快在別處重現？
- 哪個底層機制能吸收一整類問題，而不是讓人每次人工補救？
- 哪個介面可以變小、變穩，讓更多複雜度藏在後面？
- 哪個驗證點可以提前，讓錯誤更早、更便宜、更穩定地被抓到？
- 有沒有需求、流程、步驟、檔案、規則、handoff 或 abstraction 應該先刪掉，而不是優化？

目標不是讓架構看起來漂亮，也不是讓眼前畫面立刻乾淨，而是讓主線進度更穩、更可驗證、更容易交接，並讓同類問題被系統吸收。

## 工作流

### 0. 判斷賽局優先序

先不要修洞。先判斷目前系統真正的主戰場：

- Main outcome：現在最重要的輸出是什麼？
- Strategic bottleneck：哪個瓶頸最限制整體 throughput？
- Recurring failure class：哪一類問題反覆消耗人力？
- Verification bottleneck：哪裡讓完成變得難以證明？
- Interface bottleneck：哪個介面太大、太脆、太難交接？
- Factory bottleneck：哪個流程靠人工補救，而不是被系統吸收？
- Defer candidates：哪些 visible defects 雖然刺眼，但不影響主線、不代表底層 gap、可以延後 fine-tune？

輸出一句話：

```text
Current game board: 目前最重要的不是 <visible issue>，而是 <strategic bottleneck>，因為它限制 <outcome / throughput / verification / reuse>。
```

### 1. 定義高度與 outcome

界定這次要站多高看：

- **局部**：單一檔案、單一流程、單一錯誤類型。
- **模組**：一組檔案、功能、技能、文件、資料流、handoff。
- **系統**：產品主線、repo 架構、agent workflow、營運流程、驗證工廠。

同時定義：

- 使用者真正要的 outcome。
- 什麼算 done evidence。
- 哪些 surface 可以改，哪些必須凍結。
- 是否碰到 production、database、金錢、訂單、庫存、客戶資料、credential、destructive 或 bulk operation；若有，先切到風險預檢。

### 2. 由廣至深掃描

先讀 live truth，再下判斷。可用 evidence 包含 repo、檔案、測試、log、browser、DB preview、文件、腳本、workflow output、使用者提供的 artifact。

建立壓縮系統地圖：

- Inputs：系統吃進什麼。
- Outputs：系統交付什麼。
- Mainline：正常主線怎麼走。
- Decisions：關鍵判斷點在哪。
- State / ownership：狀態住哪裡，誰負責正確。
- Verification：最小證據是什麼。
- Failure / recovery：常見失敗與回復路徑。

只把足以支持下一步決策的 evidence 拉進來。不要為了顯得完整而無限展開。

### 3. First-principles deletion before optimization

在設計任何工廠前，先刪除不該存在的東西。依序問：

- Requirement：這個需求是真的需要，還是歷史殘留？
- Step：這個流程步驟可以刪掉嗎？
- Part：這個模組、文件、規則、handoff、檢查點可以合併或移除嗎？
- Constraint：這個限制是硬限制，還是未驗證假設？
- Interface：這個介面可以縮小嗎？
- State：這個狀態可以少一份來源嗎？
- Human work：這個人工判斷可以被 test、guard、script、type、schema、review gate 或 runbook 吸收嗎？

順序固定：

1. Delete
2. Simplify
3. Stabilize interface
4. Add verification
5. Automate
6. Scale

禁止直接把壞流程自動化。若流程本身不該存在，先刪掉。

### 4. 找 pattern，不追洞口

把觀察到的問題分三層：

- **Symptom**：眼前破洞，例如測試壞、檔案散、流程卡、文件過期。
- **Pattern**：破洞重複出現的形狀，例如 ownership 模糊、驗證太貴、interface 太淺、狀態只在聊天裡。
- **Factory gap**：缺少哪個可重用機制，才導致每次都手修。

常見 factory gap：

- 沒有最小 regression test、fixture、type、schema 或 guard。
- 沒有單一入口 API、command、checklist 或 review route。
- 沒有明確 owner、state file、handoff、done gate 或 recovery path。
- 沒有可重跑的 audit、verification、release 或 debug route。
- 文件、規則、工具輸出彼此矛盾，卻沒有真相來源。

### 5. Fit-and-finish defer test

對每個高可見問題，先判斷它是不是應該延後，而不是自動升級成最高優先權。

把問題標成 `defer`，如果多數條件成立：

- 它主要是 polish、presentation、local cleanup 或一次性修補。
- 它不阻塞 main outcome。
- 它不會造成不可逆風險。
- 它不是反覆 failure class 的根源。
- 它不會讓驗證、交接、release 或 debug 顯著變貴。
- 它的修復不會產生可重用機制。
- 它會消耗本來應該投入 factory / architecture 的注意力。

不要忽略 defer 問題；把它們記下來，但不要讓它們主導工作順序。polish 可以排序，不能自動支配排序。

### 6. 選關鍵突破點

不要用聲量、可見度或最近一次錯誤排序。用賽局槓桿排序。

優先選擇能改善以下項目的突破點：

1. Strategic bottleneck：解除主線 throughput 最大瓶頸。
2. Failure class absorption：吸收一整類反覆問題。
3. Verification gain：讓完成更早、更便宜、更客觀地被證明。
4. Interface shrink：讓使用者或 agent 面對的表面變小、變穩。
5. State simplification：減少多來源狀態、隱性 ownership 或同步成本。
6. Product / factory architecture：改善底層設計，而不是只修表面 defect。
7. Migration locality：能小步落地，不需要一次性大爆改。
8. Risk reduction：降低不可逆風險、release 風險或 debug 風險。

降級處理：

- 只改善外觀但不改善主線者，defer。
- 只修單點但不吸收 failure class 者，defer 或局部修。
- 需要大規模制度但缺少 evidence 者，縮小成 first useful version。
- 自動化壞流程者，先回到 deletion / simplification。

列出 3-7 個候選，但只推薦 1 個先做。若最高槓桿候選也太大，切出第一個能獨立驗證的薄片。

### 7. 設計最低可用大工廠

對選中的突破點，產出一個小規格：

- Factory name：這個機制叫什麼。
- Game-board role：它改善哪個主戰場瓶頸。
- Job：它替人或 agent 承擔哪個重複工作。
- Failure class absorbed：它吸收哪一類反覆問題。
- Interface：使用者只需要知道哪些 input、output、command、文件、或規則。
- Hidden work：哪些複雜度被藏到裡面。
- Deleted / simplified：先刪掉或簡化了什麼。
- Owner / state：誰維護，狀態住哪裡。
- First useful version：最小可用版本是什麼。
- Verification：怎麼證明它真的降低重複成本、提前發現錯誤，或縮短 debug / review / release。
- Stop rule：什麼情況下不要繼續擴建。

偏好順序：

1. Delete / simplify requirement、step、part、state、interface
2. Product architecture / module boundary / state ownership
3. Verification point：test / guard / schema / type / assertion
4. Script / command / reusable route
5. Review gate / checklist / release gate
6. Runbook / debug route / recovery path
7. Skill / handoff / agent workflow
8. AGENTS 或 global rule

原則：先刪除，再簡化，再穩定介面，再驗證，再自動化。不要替壞流程蓋工廠。

### 8. 用證據迴圈收斂

用最小 evidence loop 驗證方向：

```text
Question:
Evidence target:
Action:
Verified:
Inferred:
Decision:
Next:
```

如果 evidence 支持，進入設計或實作。若 evidence 反駁，換突破點。若 evidence 不足，縮小問題，不要用信心補空白。

### 9. 審查到沒有可接受問題

在提出方案或完成改動前做一次反向審查：

- 這是不是被 visible issue 帶走，而不是在解 strategic bottleneck？
- 這是不是把單點問題過度架構化？
- 第一版是否真的最低可用？
- 是否先刪除或簡化，再工廠化？
- 驗證是否獨立於自己的主觀判斷？
- 是否碰到高風險 surface 卻沒預檢？
- 是否有更小、更靠近 ownership 的機制？
- 剩餘風險是否明講？

如果審查發現可接受且 actionable 的問題，修正後再審查一次。停止於沒有值得接受的問題，而不是追求完美。

## 輸出格式

```text
目前判斷：
[一句話結論：局勢、最大摩擦、建議突破點。]

System map：
- Main outcome:
- Mainline:
- Inputs:
- Outputs:
- Key interfaces:
- State / ownership:
- Verification:
- Failure / recovery:

Verified vs inferred：
- Verified:
- Inferred:
- Missing evidence:

Game-board priority：
- Current strategic bottleneck:
- Visible issues to defer:
- Why this ordering:

Pattern / factory gap：
| Symptom | Pattern | Factory gap | Evidence |
|---|---|---|---|

Breakthrough candidates：
| Candidate | Strategic leverage | Failure class absorbed | Verification gain | Migration cost | Risk | Rank |
|---|---:|---:|---:|---:|---:|---:|

Recommended minimum viable factory：
- Factory name:
- Game-board role:
- Job:
- Failure class absorbed:
- Interface:
- Hidden work:
- Deleted / simplified:
- Owner / state:
- First useful version:
- Verification:
- Stop rule:

First implementation move：
- Smallest useful edit:
- Evidence expected:
- What not to do yet:
```

## 硬規則

- 先判斷賽局，再看洞口；不要用可見度排序問題。
- 高可見問題不自動等於高優先權。
- 先刪除，再簡化，再穩定介面，再驗證，再自動化。
- 禁止把壞流程直接自動化。
- Claim 不等於 truth；完成要有 evidence。
- 把已驗證與推論分開。
- 小任務不要膨脹成大制度。
- 大工廠必須最低可用，能被驗證，能小步落地。
- 大工廠要吸收一類問題，不只是更快補單一洞。
- 如果使用者只要策略或 review，不自動改檔。
- 如果使用者要實作，先做最小可驗證增量。
- 高風險操作先做風險預檢，不靠文字承諾代替 guard。
