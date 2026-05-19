---
name: goal-shaping
description: "Use when the user wants to shape a goal, build a forward-looking roadmap, stage work, define milestones, reduce token waste in /goal usage, decide what a goal should include, or prepare staged execution. Default output is a copy-ready conversation brief with roadmap and active stage queue; include a terminal-ready /goal prompt only when explicitly requested."
---

# Goal Shaping

Use this skill to shape a desired outcome into a forward-looking roadmap plus compact staged execution.

The job is not to execute the goal and not primarily to write a prompt. The job is to decide the goal shape: what future state matters, what strategic road should get there, where to start, what evidence proves progress, and when the agent should stop.

## Default Output

Output only the copy-ready brief. Do not add intro, explanation, caveats, or closing notes unless a real blocker must be named.

Default shape:

```markdown
目標：
[one-line main goal]

現況：
[one-line current state or assumption]

完成標準：
- [observable result]
- [verification evidence]

Roadmap：
1. [phase] -> [completion evidence]
2. [phase] -> [completion evidence]
3. [phase] -> [completion evidence]

現在執行：
1. [stage] -> output: [artifact/change] -> verify: [evidence]
2. [stage] -> output: [artifact/change] -> verify: [evidence]

規則：
- Stage by stage until done.
- 每個 stage 驗證後直接進下一個。
- 回報只講 delta：verified / changed / blocker / next。
- 不重述 Roadmap，除非 Roadmap 改變。
- 只有 real blocker / safety gate / missing input / goal complete 才停。
```

This brief should be directly pasteable into a chat window. Keep placeholders out of the final answer; fill them or omit the line.

## Shaping Rules

- Include a forward-looking roadmap by default.
- Use 3-6 roadmap phases by default; each phase is one line.
- Use 2-3 active execution stages by default; these are the only stages that need operational detail.
- Use compressed wording. Prefer arrows and evidence over explanation.
- Roadmap phases should be far enough to show strategy, but sparse enough not to become a contract.
- Active stages must be meaningful, verifiable, and naturally ordered.
- Preserve `stage by stage until done`; reduce token waste by using delta-only reporting.
- Avoid Outcome Contract, progress %, checkpoint cadence, handoff, or factory output unless needed.
- Include factory output only when the user asks, the issue repeats, or a reusable asset clearly emerges.
- Include durable handoff only when crossing sessions or when state loss would hurt the next agent.
- Refresh the roadmap only when evidence changes the plan; do not restate it every update.

## Prompt Mode

If the user explicitly asks for a terminal-ready `/goal` prompt, add one compact block after the shape:

```text
/goal [main goal].
Current state: [known state].
Roadmap:
1. [phase] - evidence: [completion signal]
2. [phase] - evidence: [completion signal]
Stages:
1. [stage] - verify by [evidence]
2. [stage] - verify by [evidence]
Work stage by stage. After each stage is verified, continue to the next stage unless there is a real blocker, safety gate, missing external input, or the main goal is complete.
Report delta only: verified stage, changed artifacts, blocker if any, next stage. Do not restate the full roadmap unless it changes.
```

Do not output both a long explanation and a long prompt. If prompt mode is needed, keep the explanation tiny.

## Heavy Long-Run Add-ons

Add these only when the user asks for `/longrun`, durable handoff, full roadmap, checkpoint cadence, or 持續接力:

- Checkpoint or handoff rules.
- Progress percentage.
- Factory output rule.
- Recovery or stop/handoff location.

Even in heavy mode, keep reports delta-only and do not repeat the whole roadmap after every stage.

## Discovery

Use only enough discovery to avoid fake shaping:

- Desired end state.
- Live or stated current state.
- Current bottleneck.
- Strategic phases from now to done.
- Verification evidence.
- Decision gates that may change the path.
- Safety or dependency gates.

If missing information changes the stage queue, ask one short question. If it is minor, make a bounded assumption and state it.
