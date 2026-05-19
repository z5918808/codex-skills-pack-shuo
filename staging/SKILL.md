---
name: staging
description: Use when the user invokes /staging or $staging, asks to define or freeze the final goal of the current conversation, turn a vague direction into realistic executable stages, create a phased goal list, or decide what staged outcomes must happen before execution. Do not use for staging servers, staging databases, staging deployments, or environment promotion unless the user is explicitly asking to stage goals rather than operate an environment.
---

# Staging

## Purpose

Turn the current conversation into one clear final goal and a realistic, executable stage list. The unit is not a wish, idea, or vague todo; the unit is a staged outcome that can be acted on, verified, and handed off.

## Core Rules

1. Use Traditional Chinese by default.
2. First lock the final goal, then list stages.
3. Base the goal on the current conversation and available live truth. Do not invent project state.
4. If the final goal is unclear but can be reasonably inferred, state the inference and proceed.
5. Ask a question only when a wrong inference would materially change the stage plan.
6. Keep stages realistic: each stage must have a concrete output, verification method, and clear stop condition.
7. Do not start implementation unless the user explicitly asks to execute after staging.
8. Separate `已驗證`, `推論`, and `待確認`.
9. Do not confuse activity with progress. A stage is complete only when its verification evidence exists.

## Workflow

1. Reconstruct the conversation goal.
   - Identify the user's seed request.
   - Identify the real desired end state.
   - Identify constraints, non-goals, and risks.

2. Define the final goal.
   - Write one concise final-goal sentence.
   - Include what success looks like.
   - Include what is explicitly out of scope.

3. Build the stage list.
   - Start with the smallest stage that creates clarity or removes the main blocker.
   - Continue until the final goal is reachable.
   - Prefer 3-7 stages. Use more only when the goal is genuinely large.
   - Avoid fake precision, vague aspirations, and giant "do everything" stages.

4. Add execution reality to every stage.
   - Objective
   - Action
   - Output/artifact
   - Verification
   - Stop gate
   - Risk or dependency
   - Progress percent

5. End with the smallest safe next step.
   - Pick one next action, not a menu of ten.
   - If a blocker exists, name the exact missing evidence or decision.

## Output Format

Use this structure unless the user requests another format:

```markdown
目前判斷：
[用 1-2 句說明最終目標與目前清楚度。進度 X%。]

最終目標：
[一句話定錨。]

邊界：
- 已包含：[scope]
- 不包含：[non-goals]
- 待確認：[only if needed]

階段性目標：
1. [階段名稱] - [進度 %]
   目標：[具體 outcome]
   行動：[可執行動作]
   產物：[檔案、決策、報告、測試結果、PR、部署等]
   驗證：[如何證明完成]
   停止門檻：[看到什麼就停或轉向]
   風險/依賴：[主要風險或前置條件]

下一步：
[最小安全下一手。]
```

## Stage Quality Bar

A valid stage must pass all checks:

- It can be started by an agent without rereading the whole conversation.
- It has a visible output.
- It has a verification method.
- It reduces ambiguity, removes a blocker, creates a durable artifact, or moves toward shipment.
- It is small enough to audit.
- It does not depend on hidden assumptions unless those assumptions are stated.

Reject or rewrite stages that sound like:

- "Improve the project"
- "Make it better"
- "Finish everything"
- "Optimize later"
- "Research more" without a decision artifact
- "Test it" without naming what test or evidence

## Durable Memory

If the user asks to save, continue later, use long-running agents, or hand off work:

- Prefer writing the staged plan into the project memory system if `_ctx/INDEX.md` exists.
- Otherwise write only if the user asks for a file or the project already has an obvious planning file.
- Do not create durable files for a tiny one-off conversation unless it clearly helps.

## Handoff Rule

When staging is complete, a future agent should be able to answer:

1. What is the final goal?
2. What stage are we currently in?
3. What evidence proves prior stages are complete?
4. What is the next executable action?
5. What must not be touched?
