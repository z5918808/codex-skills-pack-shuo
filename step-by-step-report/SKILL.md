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

## Required Content For Factory Reports

When explaining a product/content/data factory, cover the whole line:

1 → Raw input

- raw source, product id, crawl data, manager state, front state, existing artifacts

2 → Evidence packaging

- source refs, hashes, screenshots, binary proof, structured tables, current live state

3 → Deterministic hard gate

- schema, row width, source identity, stale generation, protected fields, live side effects

4 → AI semantic review

- title, description, common spec, model table, image identity, commercial language

5 → Target normalization

- AI output becomes structured target; AI never writes live and never marks done

6 → Replay / preview

- no-live preview, field diff, writer route, stable-field expectation

7 → Page pack compiler

- merge components into one product page pack

8 → Shadow owner

- same-generation quality check before live permission

9 → Live-ready queue

- only complete page packs enter; candidates and proposals do not count

10 → Live canary / batch

- explicit product ids, single writer, rollback, manager reload, front QA

11 → Final owner

- only final owner can mark production_ready

12 → Closeout

- counts, links, retractions, blockers, next queue

## Quality Gate Checklist

Mention these gates when relevant:

- source identity proof exists
- image proof uses actual binary / hash / dimensions
- image is not blurry, wrong product, wrong brand, or watermark polluted
- title is commercial Traditional Chinese, not literal bad translation
- brand display matches authority
- vendorChildId is safe or absent when not needed
- common spec is rendered HTML or empty, not JSON / dict / debug text
- model table headers and visible cell values are commercial Traditional Chinese
- table layout is not broken
- catalog is correct, cleared, or not applicable
- category is unchanged
- product is not counted done by HTTP 200 alone
- rollback exists
- same-generation owner passes

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

## Mini Template

結論：這條產線不是把資料丟給 AI 就算完成；每一筆都要從 evidence → target → preview → owner → live QA 才能算 production_ready。

1 → Raw data enters

- 做什麼：收 product id、source、current manager state、current front state
- 產出：input evidence pack
- 門檻：product id / source / generation 對得上
- 擋爛品質：避免拿錯產品或 stale artifact

2 → Deterministic gate

- 做什麼：先用程式擋機械錯
- 產出：pass / blocker
- 門檻：schema、hash、欄位、protected fields 全通過
- 擋爛品質：避免 AI 補洞或 writer 漂移

3 → AI semantic gate

- 做什麼：只判斷語意品質，不寫資料
- 產出：structured target / reject reason
- 門檻：語意正確、商用繁中、source-backed
- 擋爛品質：避免怪翻、錯詞、錯圖

4 → Owner gate

- 做什麼：用同代證據重算是否可上線
- 產出：live_ready_ok 或 blocker
- 門檻：完整商品頁全部通過
- 擋爛品質：避免 partial green 當完成

5 → Live and final QA

- 做什麼：小批 live，前台驗證，rollback 保留
- 產出：production_ready
- 門檻：front QA + stable diff + final owner pass
- 擋爛品質：避免 ON / HTTP 200 被誤當完成
