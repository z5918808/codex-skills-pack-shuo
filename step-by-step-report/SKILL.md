---
name: step-by-step-report
description: Use when the user asks for a process, factory, pipeline, quality gate, or handoff in numbered arrow format.
---

# Step-by-step Report

## Purpose

Use this skill when the user wants a clear review-ready process explanation, especially for factory / pipeline / quality gate design.

This is a reporting format. It does not grant permission to run live writes, change data, upload images, enable products, or mutate production state.

## When To Use

Use this skill when the user says or implies:

- `step-by-step report`
- `用 1 → 2 → 3 寫`
- `重頭到尾寫出來`
- `我要拿去 review`
- `raw data 怎麼進產線`
- `過什麼流程 / 門檻`
- `怎麼防止品質爛`
- `設計給外部 review`

Do not use this skill for normal short status updates unless the user asks for process design or review material.

## Output Shape

Default shape:

1. 一句話結論
2. Step-by-step pipeline
3. Quality gates
4. False-green prevention
5. Ownership / authority
6. Stop rules
7. What counts as done

Use this arrow:

`→`

Do not use code blocks unless the user explicitly asks for code-block format.

## Step Format

Each step should be written like this:

1 → Input / state

- 做什麼：一句話
- 產出：具體 artifact / queue / proof / state
- 門檻：什麼條件才可往下一步
- 擋爛品質：這一步會擋掉什麼 false-green

2 → Next stage

- 做什麼：一句話
- 產出：具體 artifact / queue / proof / state
- 門檻：什麼條件才可往下一步
- 擋爛品質：這一步會擋掉什麼 false-green

Keep each step short. If the report gets long, group related steps instead of writing huge paragraphs.

報告涉及商品／內容／資料產線時，先讀 [產線報告契約](references/factory-report.md)，只套用已確認存在的階段與門檻。

## False-green Prevention

Always separate these states:

- candidate
- AI proposal
- replay-ready
- strict/live-ready
- live written
- front verified
- production_ready

Never describe these as final completion:

- HTTP 200
- ON alone
- image candidate alone
- AI target alone
- dry-run green
- no-send green
- old manifest green
- queue membership
- worker completed

If a false-green class exists, name it and say where it is blocked:

- image false-green → fresh front hero image proof + binary visual audit
- common spec debug text → front visible debug text gate
- model table commercial language → header + visible cell AI/mid gate
- brand/vendor drift → pre-live readonly drift check
- stale evidence → same-generation owner

## Style Rules

- Write in Traditional Chinese.
- Start with the conclusion.
- Keep it review-ready, not chatty.
- Use `→` arrows.
- Avoid code blocks unless requested.
- Do not overwhelm with internal script noise.
- If a step is only a claim, label it as claim, not truth.
- If a gate is not implemented yet, say `目前缺 gate` instead of pretending it exists.

需要完整箭頭範例時，讀 [產線報告範例](references/example.md)；將內容換成本次已查證的流程。
