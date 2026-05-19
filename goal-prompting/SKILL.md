---
name: goal-prompting
description: "Legacy compatibility skill. Use only when the user explicitly invokes /goalprompting or asks for a terminal-ready /goal prompt. For goal shaping, staging, or reducing token waste without writing a prompt, use goal-shaping instead."
---

# Goal Prompting

This is a compatibility wrapper around `$goal-shaping`.

Use `$goal-shaping` as the primary workflow. Only add a pasteable `/goal` prompt when the user explicitly asks for a terminal-ready command.

## Behavior

1. Shape the goal first: main goal, current state, success standard, compact stage queue, verification, continuation, stop gates.
2. Keep `stage by stage until done`.
3. Reduce token waste with delta-only reporting.
4. Do not include Outcome Contract, checkpoint cadence, progress %, handoff, or factory output unless the user asks or durable continuation is required.
5. If writing a `/goal` prompt, make it compact and avoid repeating the explanation.

## Compact Prompt Shape

```text
/goal [main goal].
Current state: [known state].
Stages:
1. [stage] - verify by [evidence]
2. [stage] - verify by [evidence]
Work stage by stage. After each stage is verified, continue to the next stage unless there is a real blocker, safety gate, missing external input, or the main goal is complete.
Report delta only: verified stage, changed artifacts, blocker if any, next stage. Do not restate the full roadmap unless it changes.
```
