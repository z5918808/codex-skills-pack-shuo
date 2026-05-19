---
name: lilbots-deploy
description: Use when the user wants parallel subagents for either distributed project research or executing an already-approved implementation plan in parallel. Trigger on requests like "/lilbots-deploy", "叫三隻 mini subagents 看專案", "分散式 brainstorm", "找盲點/優化點/創意方向", or when the task is to parallelize execution of the main agent's existing plan.
---

# LILBOTS-DEPLOY

`/lilbots-deploy` 預設是研究型 skill，但可在**任務已經有主 agent 計劃、且子代理只是平行執行該計劃**時切成執行模式。

目標有兩種模式：

## 模式 A：研究模式（預設）

- 由主 agent 派出 **3 隻 `gpt-5.5` low subagents**
- 用不同角度平行檢視目前 workspace
- 回收 findings / evidence / 建議方向
- 由主 agent 去重、比對、排序、收斂成一份研究報告
- 報告回到主 chat，並同步寫回專案 continuity

## 模式 B：計劃執行模式（新增）

- 當主 agent 已有明確主線、設計或 implementation plan
- 可派出多隻 **`gpt-5.5` low** worker subagents
- 每隻子代理只負責主 agent 計劃中的某一段實作
- 主 agent 保留整體排序、分工、review 與整合責任
- 不可把架構決策外包給 worker

## 何時使用

當使用者要你：

- 用三隻小 agent 分頭看專案
- 做分散式 brainstorming
- 找盲點、風險、可優化點、創意方向
- 從不同角度地毯式 review 現有主線

若任務本身只是單一路徑的實作或 bugfix，不要用這個 skill。

若任務是**單純執行主 agent 已寫好的計劃**，而且可以安全切成多段並行工作，改用本 skill 的**計劃執行模式**。

## 核心原則

1. **Codex 決定主線**，subagents 只提供研究輸入。
2. 三隻 agent 角色必須不同，不可都做 generic review。
3. 主 agent 必須先做最小 grounding，再派工。
4. 先檢查目前 thread 裡是否已經有可沿用的 subagents；能沿用就沿用，不要每次重新生三隻。
5. 若現有 subagents 的角色、模型、上下文已合適，優先用 `send_input` / `resume_agent` 續用；只有缺角色或缺能力時才補 spawn。
6. 每個 subagent 的 `agent_type` 要依當下子任務決定；需要探索、比對、找方向時用 `explorer`，需要直接產出或改檔時用 `worker`，不要被模式名稱綁死。
7. 最終輸出必須是單一合成報告，不可把三份原文直接貼回主 chat。
8. 預設同步更新專案 continuity；不要只把結論留在對話裡。
9. 若是計劃執行模式，subagents 只能執行既有計劃，不負責重寫主線。

## 模式切換規則

### 用研究模式

當任務是：

- 找方向
- 查盲點
- 查風險
- 分散式 brainstorm
- 還沒有被批准的主線設計

使用：

- 固定 **3 隻 `gpt-5.5` low**
- 固定三種角色
- `agent_type` 預設偏 `explorer`，但若某個角色需要直接做小段驗證或產出，也可改成 `worker`

### 用計劃執行模式

當任務是：

- 主 agent 已有設計稿或 implementation plan
- 子代理的工作是單純執行計劃
- 工作可切成互不打架的多段
- 目標是加速而不是找方向

使用：

- 多隻 **`gpt-5.5` low** worker
- 依計劃切 disjoint write scope
- 主 agent 自己保留 critical path 決策與整合
- `agent_type` 預設偏 `worker`，但若某個子任務本質仍是前置分析、風險掃描或方案比較，可改派 `explorer`

模型選擇建議：

1. **`gpt-5.5` low**
   - 作為 lilbots 的預設模型：較快、成本較低，但仍使用 5.5 系列能力

2. 若任務需要更高推理深度，改用 `bigbots-deploy` 的 `gpt-5.5` medium 路線

## 研究模式工作流

### 1. 主 agent 先做最小 grounding

先讀：

- repo 根目錄 `AGENTS.md`
- 既有 continuity / campaign / state 真相
- 當前主線與 frontier

不要把整個 repo 都塞給 subagents。
只把影響本輪研究的最小 context 濃縮給他們。

### 2. 先補齊角色，再平行派工

先檢查目前 thread 是否已經有可用 subagents：

- 若已有對應角色且上下文還適合，直接沿用
- 若只有部分角色存在，只補缺的那幾隻
- 若現有 agent 已明顯偏題、關閉、或模型不適合，再新開

新開時一律使用：

- model: `gpt-5.5`
- reasoning_effort: `low`
- `agent_type`: 依該角色當下工作決定，預設 `explorer`

角色固定如下：

#### A. 架構考古官

負責找：

- 現有主線
- 真實耦合
- 技術債
- 過時兼容層
- 命名錯位
- 哪些東西其實已經不該存在

輸出重點：

- 結構問題
- 可刪減項
- 被歷史拖住的地方

#### B. 盲點 / 風險獵人

負責找：

- 隱藏 blocker
- 狀態層與真實行為不一致
- 驗證缺口
- 脆弱點
- 假完成態
- 會在後面炸掉的地方

輸出重點：

- 風險
- 真 blocker
- 哪裡在自欺

#### C. 第一性原理創意官

負責找：

- 不沿用現況假設時，還有沒有更好的做法
- 可大破大立的替代方案
- 更輕量、更簡潔的路徑
- 有創造性但仍可落地的方向

輸出重點：

- 新方向
- 可大幅簡化的方案
- 值得試驗的攻擊路線

### 3. 主 agent 合成

主 agent 收到三份輸出後，必做：

1. 去重
2. 衝突比對
3. 按價值 / 風險 / 可行性排序
4. 區分：
   - 已驗證
   - 高機率
   - 待驗證
5. 決定建議主線

禁止：

- 直接把三份輸出原樣貼回來
- 把下一步決策外包給 subagents

## 計劃執行模式工作流

### 1. 主 agent 先確認已有可執行計劃

至少要有以下其中之一：

- 已批准的設計稿
- 已寫好的 implementation plan
- 已切好的 task list / write scope

若沒有，先不要用執行模式。

### 2. 主 agent 切分可並行任務

每個子任務都要：

1. 有清楚目標
2. 有明確檔案責任範圍
3. 不與其他 worker 大量重疊
4. 不要求 worker 自己決定產品主線

### 3. 先檢查可沿用 worker，再平行派工

先看目前 thread 裡是否已有仍可沿用的 worker：

- 若 write scope、任務邊界、模型都還合適，優先續用
- 若只缺部分 worker，就只補缺口
- 若舊 worker 的責任已不相容，先改派或關閉，再補新的

每隻 worker 都要拿到：

1. 該段計劃目標
2. 自己負責的檔案 / 模組
3. 驗證方式
4. 不可亂動其他人範圍的提醒

若某個子任務其實還在找證據、比方案、查 blocker，而不是立即改檔，該 slot 可改用 `explorer`，不要硬塞成 worker。

### 4. 主 agent 回收、review、整合

主 agent 必做：

1. 檢查每隻 worker 是否偏離計劃
2. 檢查互相衝突
3. 做必要修補
4. 以主線整體驗證收尾

禁止：

- 沒有計劃就把執行外包
- 派 worker 去決定核心架構
- 把高度耦合的同一寫入區硬拆給多個 worker
- 因為想熱鬧就亂開很多 agent

## 預設派工模板

每隻 agent 都要拿到：

1. 目前 repo / workspace
2. 這輪主題
3. 只屬於自己角色的工作
4. 明確輸出格式：
   - findings
   - evidence
   - 建議方向

每隻 agent 都要被告知：

- 不要做總結性定案
- 不要做 generic review
- 不要與其他角色重複
- 要用證據綁住判斷

## 主 chat 輸出契約

最終研究報告固定結構：

1. `總判斷`
2. `高價值優化點`
3. `隱藏盲點 / 風險`
4. `創造性方向`
5. `建議主線（1-3 條）`

每點都標：

- `證據層級`：已驗證 / 高機率 / 待驗證
- `影響面`
- `建議優先級`

## continuity 規則

預設除了回主 chat，還要同步把結論寫回專案。

優先更新：

1. 現有 continuity / campaign 檔
2. 若沒有合適位置，寫入：
   - `docs/memory/session_continuity.md`

若工作區是 JARVIS，優先補到既有 campaign / continuity，不要濫開新檔。

## JARVIS 特化

若 cwd 是 `D:\JARVIS`，或明顯是 JARVIS 專案：

- 自動提高以下語境權重：
  - Hermes
  - OpenClaw
  - IronClaw
  - V2 rebuild
  - v3 pivot

最終報告需附一段**百分比現況**，例如：

- `Hermes 50% / OpenClaw 20% / IronClaw 30%`

百分比不是精密度量，而是快速理解目前架構重心。

## 執行提示

- 優先先看能否沿用既有 agent；只有缺口才用 `spawn_agent`
- 沿用既有 agent 時，優先 `send_input`，必要時 `resume_agent`
- 每個 slot 的 `agent_type` 由主 agent 依子任務當下性質決定，不要把整輪任務綁成全 explorer 或全 worker
- 研究模式：三隻 agent 可平行派工
- 計劃執行模式：依可並行 task 數量派多隻 `gpt-5.5` low worker
- 主 agent 不要忙著等待；先整理已有 repo 真相，再回收結果
- 若有適合的 continuity 位置，最後順手更新；若需要，可再配合 [$close-out](<codex-skills-dir>/close-out/SKILL.md) 的原則

## 禁止事項

- 不要只產出 generic brainstorm 廢話
- 不要讓 subagents 決定主線
- 不要把報告做成三份輸出的拼盤
- 研究模式不要偏離固定三隻
- 執行模式不要為了熱鬧多開 agent；只在確實能提速時才多派 worker
- 不要新增 orchestrator / dashboard / metadata 系統

## 完成標準

### 研究模式成功條件

只有在以下條件成立時，才算研究模式 `/lilbots-deploy` 成功：

1. 3 個固定角色都已就位，且優先沿用既有 `gpt-5.5` low subagents；只有缺口才新開
2. 三份輸出有明顯角色差異
3. 主 agent 已合成單一研究報告
4. 報告已回到主 chat
5. 專案 continuity 已同步更新

### 計劃執行模式成功條件

只有在以下條件成立時，才算計劃執行模式成功：

1. 主 agent 已有現成計劃或設計可執行
2. 多隻 `gpt-5.5` low worker 優先沿用既有 agent，缺口才補開，且任務分工清楚
3. 每隻 worker 都有明確 write scope 或責任邊界
4. 主 agent 已完成 review、整合與驗證
5. 最終成果與原計劃一致，且沒有把主線決策外包給 worker
