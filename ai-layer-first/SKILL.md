---
name: ai-layer-first
description: Use when a workflow needs AI semantic judgment for translation, classification, mapping, generation, or assessment.
---

# ai-layer-first

## Purpose

把資料處理系統拆成兩層：

1. `AI Semantic Target`：處理語意判斷，產出結構化目標。
2. `Deterministic Safety Shell`：處理證據、schema、安全、權限、寫入、回讀、QA、rollback、ledger。

這是架構 skill，不是模型呼叫器。它要求系統真的有 model call path、prompt、schema、artifact、routing hook；不能只把規則輸出命名成 AI layer。

## Core Flow

任何符合此 skill 的 workflow，都要能說清楚這條線：

```text
Evidence
-> AI Semantic Target
-> Contract Validation
-> No-Execute Replay
-> Permission Gate
-> Bounded Execution
-> Reload / QA / Rollback
-> Append-Only Ledger
```

大改前先做 thin vertical slice：一筆或一小批資料，完整跑過 evidence、AI output、validator、no-execute、reload/QA 的最短鏈。

## Decision Boundary

先把每個問題分類：

```text
semantic_decision
deterministic_validation
permission_or_safety
```

AI 可以決定：

- 意義、語氣、翻譯、分類
- entity / source 是否相同
- 欄位、標題、文件、圖片的語意品質
- 多來源資料誰比較可信
- proposed target 應該長什麼樣

Deterministic code 才能決定：

- schema 是否有效
- lineage / hash / artifact freshness 是否成立
- 哪些欄位允許改
- 是否允許 writer 執行
- reload 是否等於 target
- protected fields 是否漂移
- rollback、ledger、accounting 是否完整

AI output 永遠不是 execution permission。

## Required AI Evidence

每個 AI 結果至少要留下：

```json
{
  "model_call_attempted": true,
  "model": "...",
  "model_tier": "low|stronger|critic",
  "prompt_version": "...",
  "input_ref": "...",
  "raw_output_ref": "...",
  "validated_output_ref": "...",
  "evidence_refs": [],
  "confidence": {},
  "unknowns": [],
  "fields_to_change": [],
  "fields_to_preserve": [],
  "validators_required": []
}
```

如果 `model_call_attempted=false`，只能標成 rules-only 或 placeholder，不能標成 AI-layer-complete。

## Structured Output

AI 必須回結構化資料，不要只回自然語言，也不要直接回可執行 SQL、API payload、writer call 或權限判斷。

通用輸出形狀：

```json
{
  "decision": "repair|preserve|degrade|escalate|business_decision",
  "target": {},
  "confidence": {},
  "supporting_evidence": [],
  "contradicting_evidence": [],
  "unknowns": [],
  "fields_to_change": [],
  "fields_to_preserve": [],
  "validators_required": [],
  "needs_higher_tier": false
}
```

## Final States

語意任務不能只輸出 `BLOCKED`、`HOLD`、`UNKNOWN`。

必須落到其中一種：

- `ai_target_ready`
- `repair_ready`
- `preserve_current`
- `degraded_reviewable`
- `needs_higher_tier`
- `business_decision_pack`
- `true_hard_block`

只有安全、權限、缺外部 authority、或無法取得必要 evidence，才可進 `true_hard_block`。進 block 時要回報：

```text
blocking_rule
missing_proof_or_gate
minimal_safe_next
```

## Escalation

預設從專案設定的低成本 semantic model 開始。不要在通用 skill 寫死特定模型名稱。

遇到以下情況才升級 stronger model 或 independent critic：

- model 自己要求升級
- 高影響欄位信心低於門檻
- evidence 互相矛盾
- 專業術語或 source identity 不明
- 圖片品質或商品/文件 identity 不明
- deterministic replay 拒絕 AI target
- 同一缺陷 retry 一次後仍存在
- AI proposal 會造成大量批次變更

Critic 用在高影響或 unresolved cases，不是每筆預設雙模型。

## No-Execute Contract

No-execute 可以驗：

- route readiness
- target diff
- payload shape
- rollback materialization
- protected-field preconditions

No-execute 不能宣稱 live apply 成功，也不能要求 post-submit reload 或 live-after proof 才算 no-execute 自己通過。

## Required Artifacts

至少保留：

- `semantic_inputs.jsonl`
- `prompts/`
- `raw_ai_outputs/`
- `validated_targets.jsonl`
- `validation_results.jsonl`
- `replay_results.jsonl`
- `execution_results.jsonl`
- `qa_results.jsonl`
- `rollback_results.jsonl`
- `ledger.jsonl`
- `summary.json`

AI 結果只存在聊天裡，等於沒有可重跑證據。

## Regression Proof

新增或重構這類 workflow 時，至少補一個 fixture、test、或 replay case，證明系統不會退回：

- regex / replacement list 冒充語意判斷
- `model_call_attempted=false` 卻標成 AI layer
- semantic task 只留下 bare hold
- AI output 落檔但沒有 downstream consumer

## Safety

AI 不得：

- apply changes
- upload files
- enable products or categories
- override validators
- mark production-ready without reload and QA proof
- invent facts unsupported by evidence
- bypass permission gates with confidence

Live write / upload / delete / enable / production action 仍需要 explicit authorization、fresh proof gate、bounded scope 三者同時成立。

## Anti-Patterns

看到這些設計要打回：

- 用越來越長的 regex list 模擬語意品質
- 每遇到一個 wording defect 就加 one-off replacement
- deterministic hold 被當成最終語意判斷
- rules-only output 被標成 AI
- AI result 沒 artifact，只留在 chat
- AI confidence 繞過 safety gate
- row 被 drop 但沒有 durable final state
- sample-ready 被說成 production-ready
- project-specific rule 被塞進通用 skill

## Review Output

Review 或重構這類系統時，先列問題，不先寫漂亮摘要。至少檢查：

- 哪些 semantic decisions 還寫在 hard logic 裡
- 是否有 fake / missing model call
- AI output 是否有 downstream consumer
- evidence、prompt、raw output、validated target 是否可重跑
- replay、permission gate、writer、reload、QA、rollback 是否接上
- 是否還有 bare hold
- completion metrics 是否高估品質
- 專案 contract 是否另有清楚邊界
