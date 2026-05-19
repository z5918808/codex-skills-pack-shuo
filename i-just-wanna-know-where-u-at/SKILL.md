---
name: i-just-wanna-know-where-u-at
description: Use when the user invokes /i-just-wanna-know-where-u-at, asks "where we at", or wants a quick explain-style status reset with verified facts, current blocker, progress, and next step.
---

# I Just Wanna Know Where U At

Use this as a fast status reset. The user is asking: "where are we right now?"

## Behavior

1. Reconstruct the current mainline from live evidence when available: files, logs, terminal output, artifacts, test results, browser state, or the latest verified conversation state.
2. Separate `已驗證`, `推論`, and `待確認 / blocker`.
3. Include progress percentages when useful.
4. Keep it short. Do not replay the whole history.
5. Do not start a new plan or implementation unless the user explicitly asks to continue.
6. If the true state is unclear, name the exact missing evidence and the smallest check needed.

## Output

```markdown
一句話版：
[目前主線與狀態。進度 X%。]

目前在哪：
- 已驗證：
- 推論：
- 待確認 / blocker：

下一步：
[最小合理下一手。]
```

End with enough context that the user can re-enter the work without rereading the thread.
