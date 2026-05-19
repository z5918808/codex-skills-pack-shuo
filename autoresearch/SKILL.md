---
name: autoresearch
description: "Use when a task has uncertainty and benefits from a bounded evidence or experiment loop: code/system investigation, debugging, benchmark, UI/product review, option comparison, workflow improvement, or decision support. Default to a quick 1-2 loop investigation. Use Karpathy-style autonomous experiment loops only when the user explicitly requests it and there is a sandbox, clear metric, fixed editable surface, fixed frozen surface, per-loop budget, and keep/discard ledger."
---

# Autoresearch

Autoresearch is a bounded experiment loop, not generic research mode.

Default behavior: run the lightest loop that turns uncertainty into evidence, a decision, or the next action. Do not maximize analysis. Do not run indefinitely by default.

## Core Contract

Every run must define:

```text
Goal:
Metric / success signal:
Editable surface:
Frozen surface:
Loop budget:
Stop condition:
Artifact / ledger:
```

If the metric, editable surface, frozen surface, or stop condition cannot be stated, do not start an experiment loop. First shape the question or gather the missing evidence.

## When To Use

Use for:

- codebase or system investigation
- debugging or root-cause narrowing
- benchmark / performance comparison
- UI or product review with evidence
- comparing options, vendors, prompts, skills, or workflows
- testing whether a change improves a measurable outcome
- turning uncertainty into a keep / discard / pivot decision

Do not use for:

- simple edits
- direct implementation with a clear spec
- one-shot factual lookup
- tasks where the user only asked for a final artifact
- production, database, money, order, inventory, customer data, or destructive operations before `$risk-preflight`

## Modes

Choose the lightest mode.

| Mode | Default budget | Use when | Output |
| --- | --- | --- | --- |
| Quick evidence loop | 1-2 loops | Direction or cause can likely be found quickly | conclusion, evidence, inference, next |
| Standard loop | 2-4 loops | Multiple files, sources, options, or measurements must be compared | decision, evidence ledger, next action |
| Autonomous experiment loop | explicit budget or until user stops | Sandbox + clear metric + user explicitly asks for autonomous iteration | keep/discard/crash ledger and best current result |

Quick evidence loop is the default.

Standard loop needs a reason.

Autonomous experiment loop is opt-in only.

## Quick Evidence Loop

Use this for most tasks.

```text
Question:
Evidence target:
Action:
Verified:
Inferred:
Decision:
Next:
```

Rules:

- Inspect live truth, not memory.
- Run only the evidence action needed for the decision.
- Stop when the next action is clear enough.
- Do not create files unless the finding is durable or the user asked.

## Standard Loop

Use when one loop is not enough.

Each loop:

```text
Loop N:
Hypothesis:
Action:
Evidence:
Result:
Decision: keep / keep-partial / discard / pivot / stop
Next:
```

Rules:

- One hypothesis per loop.
- Separate verified facts from inference.
- If the loop produces no new information, change method or stop.
- If evidence contradicts the direction, pivot.
- Save an artifact only when findings are durable, reused, or too long for chat.

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

## Surfaces

Editable surface examples:

- one file
- one module
- one prompt/program file
- one benchmark configuration
- one UI page/flow

Frozen surface examples:

- evaluation harness
- data prep
- production config
- public API contract
- user-edited unrelated files
- secrets/tokens/customer data

If the editable/frozen boundary is unclear, ask one short question or reduce scope to read-only investigation.

## Artifact Routing

Do not create artifacts for quick loops.

Create an artifact only when:

- autonomous experiment loop is active
- standard loop findings are durable
- the user asked for handoff/report
- result affects project state
- output is too long or easy to lose

Preferred:

- experiment ledger: `results.tsv`, `experiments.tsv`, or repo-native path
- durable research: `reports/autoresearch-YYYYMMDD-<topic>.md`
- project memory: only through `$project-memory-gate`

Do not create `_ctx` unless long-run/project-memory rules are already active.

## External Facts

For current facts, laws, prices, schedules, product specs, API behavior, companies, public figures, or market conditions:

- inspect live sources
- cite sources
- mark stale or conflicting claims

For local project facts:

- inspect files, logs, tests, commands, or runtime state
- treat memory as a hint only

## Completion Format

Quick loop:

```text
結論：
已驗證：
推論：
決策：
下一步：
```

Standard loop:

```text
狀態：complete / partial / blocked
Metric / stop：
已驗證：
推論：
Decision：keep / keep-partial / discard / pivot / stop
Evidence：
Artifact：path or none
下一步：
```

Autonomous experiment loop:

```text
Best result:
Ledger:
Kept:
Discarded / crashed:
Current blocker:
Next experiment:
Stop reason:
```

## Cost Control

- Default to Quick evidence loop.
- Stop when the answer is clear enough to act.
- Continue only when the next loop has a specific evidence target.
- Do not broaden the lane unless evidence shows the current lane is wrong.
- Do not save artifacts merely to look systematic.
- Never run indefinite autonomous loops without explicit user request and safe experiment gates.
