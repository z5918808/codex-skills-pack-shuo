## Autonomous Experiment Loop

This mode is Karpathy-style: fixed experiment loop, measurable metric, keep/discard, repeat.

Only enter this mode when all gates are true:

1. User explicitly asks for autonomous iteration, overnight run, Karpathy-style autoresearch, or loop-until-stopped behavior.
2. Work is in a sandbox, throwaway branch/worktree, or repo workflow designed for experiments.
3. There is one primary metric or clear success signal.
4. There is a fixed command or procedure to measure the metric.
5. Editable surface is narrow and explicit.
6. Frozen surface is explicit and must not be modified.
7. Each loop has a time or iteration budget.
8. Keep/discard/crash/blocked ledger location is defined.
9. Discard path is safe and will not erase unrelated user work.

If any gate is missing, do not run autonomous mode. Output the missing gate and the smallest setup step.

### Experiment Loop Shape

```text
Experiment N:
Hypothesis:
Editable change:
Metric command:
Result:
Decision: keep / discard / crash / blocked
Ledger:
Next experiment:
```

### Keep / Discard Rules

- `keep`: metric improved or success condition met without unacceptable complexity or risk.
- `discard`: metric same/worse, evidence weak, or complexity cost exceeds improvement.
- `crash`: run failed; fix only if the failure is a small implementation bug. Otherwise log and move on.
- `blocked`: missing dependency, permission, unsafe state, or no valid discard path.

Do not use `git reset --hard`, `git checkout --`, or destructive cleanup unless the user explicitly authorized it and the work area is proven isolated. Prefer branch/worktree discipline, reverse patches, or repo-provided experiment scripts.
