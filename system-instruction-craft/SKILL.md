---
name: system-instruction-craft
description: Use when the user wants to turn a newly discovered workaround, environment lesson, instruction pattern, or operating rule into durable guidance inside the main AGENTS.md, but only after analysis, section placement, and explicit user approval.
---

# System Instruction Craft

## Overview

Analyze a fresh workaround or instruction idea, decide whether it belongs in the main AGENTS.md and which section it should strengthen, then ask for approval before changing any instruction file.

Never jump straight to editing prompts. First decide whether the discovery is real, reusable, non-duplicative, and worth the token cost.

## Workflow

1. Reconstruct the current discovery from the live session, terminal output, files, and user description. Do not rely on memory alone.
2. State the candidate rule in one blunt sentence.
3. Decide the landing section before editing anything:
   - `角色定位與總目標`
   - `專案哲學與概念錨點`
   - `外部實在與服從順序`
   - `成功定義`
   - `溝通方式`
   - `語氣與個性`
   - `回報格式`
   - `通用工作流`
   - `強制避免空談`
   - `驗證與閉環`
   - `Debug 原則`
   - `PowerShell 原則`
   - `瀏覽器與自動化`
   - `背景程序`
   - `子代理`
   - `檔案、路徑與專案內沉澱`
   - `全域 DESIGN 預設`
   - `收斂原則`
   - `核心能力恢復原則`
   - `禁止事項`
   - `reject`
4. Explain:
   - what problem this rule prevents
   - why the existing AGENTS.md is insufficient
   - which section should change
   - whether this should modify the global AGENTS, the current repo AGENTS, or both
   - the tradeoff in complexity or duplication
5. Ask for explicit approval before editing. No approval, no file changes.
6. After approval, make the smallest meaningful edit only in the correct AGENTS.md file.
7. Summarize the exact change and why it landed there instead of somewhere else.

## Placement Rules

### Put it in the global `AGENTS.md` if most are true

- It changes behavior that is relevant in most sessions
- It is worth paying token cost almost every time
- It defines judgment order, validation discipline, response style, or a repeated operating tactic
- It is not tied to one repo's structure or product logic

### Put it in the repo `AGENTS.md` if any are true

- It depends on repo structure, local scripts, product behavior, or a project-specific design system
- It mentions project-only paths or workflows
- It would be noisy or misleading outside the current repo

### Update both only if all are true

- The rule is globally useful
- The current repo should also keep a local copy to avoid accidental override or drift
- The user explicitly wants both synchronized

### Reject it if any are true

- It is just a one-off fix with no clear reuse
- It duplicates an existing rule without adding a new behavior boundary
- It is a slogan, vibe, or preference with no execution consequence
- It belongs in a log, handoff, or project note rather than an instruction layer

## Required Response Pattern

Before any edit, use the active standard user-facing structure:

1. current judgment
2. recommended landing spot
3. why it does not belong elsewhere
4. files that would change
5. explicit approval request

After approval, report:

1. what changed
2. why it was placed there
3. what was verified
4. what remains unconfirmed

## Guardrails

1. Do not merge multiple unrelated discoveries into one edit unless the user explicitly wants a batch.
2. Do not silently rewrite large instruction files when one line or one paragraph will do.
3. Do not promote project-local lessons into global instructions without a clear cross-project case.
4. Do not keep duplicate wording for style. Keep the sharpest version once.
5. If the discovery is really a temporary workaround, say so and recommend a note instead of polluting the instruction layer.
6. Prefer integrating the rule into the right existing section over inventing a new section.
