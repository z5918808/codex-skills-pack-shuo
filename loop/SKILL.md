---
name: loop
description: "/loop、$loop：限量研究一個目標，安排可驗證階段，依 goal 工具狀態接續執行。"
---

# Loop

Turn a user objective into one evidence-backed decision, a short stage plan, and an executable goal prompt. Explicit `/loop` or `$loop` then enters goal mode in the current task and continues from that prompt unless the user expressly asks to stop at planning. Use the existing goal controller and [long-running-agent](../long-running-agent/SKILL.md) for continuation and stop rules; do not create another controller. Discussing or editing this skill does not invoke the workflow.

## Route

1. Read the relevant parts of [strategic-autoresearch](../strategic-autoresearch/SKILL.md), [prompt-for-goal](../prompt-for-goal/SKILL.md), and [staging](../staging/SKILL.md). Use their current rules for research, goal compression, and stage quality. Read applicable repository instructions and the current authoritative contract before changing project state.
2. Determine the requested scope and any explicit planning-only limit. `/loop` or `$loop` authorizes continuing the scoped goal after planning unless the user expressly asks to stop there. It does not expand authority for live writes, deployment, a new task, or scheduled work.
3. Research the one uncertainty that most affects the outcome. Separate verified evidence, inference, and missing facts. State a success signal, first truth check, editable/frozen surface, and stop condition before a test; use the cheapest decisive evidence. Default to at most two evidence loops, or four when a standard budget is requested, subject to stricter applicable limits. One loop is one hypothesis, one bounded check, and an evidence update; the cap is shared across the source skills. Stop when the first move is supported, the goal is already met, further checks cannot change the decision, or the cap is reached. Do not fill a budget for its own sake.
4. Define one final outcome with observable acceptance evidence, scope and relevant boundaries. Prefer deletion or simplification before adding workflow. If the goal cannot be stated without a material user choice, ask only for that choice and continue independent research.
5. Stage the route with only distinct verification boundaries, normally 1–3 stages. Each stage names its action, output, proof, and stop or pivot condition. End on one next action.
6. Compress the research and stages into one executable goal prompt using [prompt-for-goal](../prompt-for-goal/SKILL.md). For planning-only work, deliver the prompt and stop without changing goal state. Otherwise perform the goal handoff below and immediately continue with its first action in this task. Verify actual outcomes and update the contract only when evidence changes the decision. Do not repeat a stage without new evidence.

### Goal handoff

After the prompt is ready, call `get_goal` before creating anything. Reuse an active goal covering the same outcome. Call `create_goal` only when no goal exists or the previous goal is complete and the requested outcome still needs work; never restart an already satisfied outcome. If an unfinished goal covers a different outcome, preserve it and resolve the conflicting scope without falsely completing it or retrying creation. For paused, blocked, or budget-limited goals, follow the tool's resume rules and the user's current instructions; do not replace them to bypass their state.

Enter [long-running-agent](../long-running-agent/SKILL.md) only after the tool confirms an active goal. Carry forward the prepared prompt as its execution contract; do not ask the user to paste it elsewhere. If activation fails or the tool is unavailable, report the actual state and preserve the prompt rather than claiming goal mode is active.

## Contract ownership

Choose one owner in this order:

1. A repository or task contract explicitly designated by applicable instructions. Update it only through its supported writer and when this task authorizes a durable change.
2. An existing artifact explicitly designated by the user for this task, consistent with governing rules. An existing `task_goal.md` qualifies only when the project or user has designated it; its filename alone gives it no priority.
3. A compact contract in the response for ordinary one-off work. Do not create `task_goal.md`, `_ctx`, or a new spec merely because `/loop` was invoked.

Selecting an artifact does not itself authorize writing it. Revise only permitted fields when an explicit save/update request or an authorized workflow calls for that write; otherwise show the proposed contract in chat. Surface material authority conflicts instead of choosing by filename or modification time. For a genuine cross-session goal or required handoff, route durable state through the applicable project memory or `/goal` contract. Reference existing authority instead of restating it. Distinguish the contract's desired outcome from verified current state and from an unapproved proposed action.

## Output

Keep the result short enough to use immediately:

```text
Research: <first truth check and decisive evidence; key inference or unknown>
Goal: <one outcome and acceptance evidence>
Contract: <authoritative file/link, or "this response"; relevant scope/boundaries>
Stages: <numbered action -> output/proof -> stop/pivot, only as many as needed>
Next: <one executable action or the exact missing decision>
```

Show a pasteable `/goal` block when the user asks for one or the request stops at planning. Otherwise use the prompt to continue directly in this task's goal mode. Report implementation evidence when execution follows. Stop rather than repeat research that adds no information.
