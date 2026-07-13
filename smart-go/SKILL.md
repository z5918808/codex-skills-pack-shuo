---
name: smart-go
description: Use for /smart-go or $smart-go when the user wants a bounded research pass followed by evidence-driven execution.
---

# Smart Go

## Purpose

Research only enough to choose the right execution segment, then act to a rerunnable proof. Smart Go is not native Codex Goal and must not shadow or recreate it.

## Entry Gate

Use only for explicit `/smart-go`, `$smart-go`, or a clear request for research-first execution. For ordinary continuation use `go`; for long native Goal work use the app goal and `long-running-agent` route.

## Quick Evidence Pass

Before editing, answer:

1. What is live truth now?
2. Which uncertainty changes the next action?
3. What is the cheapest decisive probe?
4. What proof distinguishes improvement from activity?
5. What may change, and what stays frozen?

Stop research once one driver is justified. Do not present several options when evidence supports one.

Use `autoresearch` only when the uncertainty needs more than one bounded probe. Use `project-memory-gate` only when continuity or `_ctx` is explicitly required.

## Structure Before Finish

Classify the next work:

| Class | Meaning | Priority |
|---|---|---|
| Foundation | goal, scope, truth, safety, architecture, harness, recovery | first if unstable |
| Frame | thin end-to-end path, main pipeline, state machine, verification spine | first working slice |
| Integration | adapters, schemas, manifests, routing, resumability | connect the frame |
| Inspection | tests, UI, API, logs, dry-run, recovery proof | required for progress |
| Finish | naming, prose, micro-refactor, visual polish, optimization | after structure is green |

Finish work may jump the queue only when the user asked for it or it directly unblocks proof, review, or handoff.

## Experiment Contract

For non-trivial work, define:

```text
Baseline: <rerunnable current result>
Metric / success evidence: <what must change>
Editable surface: <bounded paths or state>
Frozen surface: <must not change>
Budget: <one probe plus up to three experiments by default>
Keep: <evidence that justifies preserving the change>
Discard / pivot: <evidence that rejects the route>
Stop: <safety, repeated failure, missing proof, or user decision>
```

Do not change the metric or fixture mid-run to make a result look better.

## Execution Loop

1. Establish the baseline.
2. Choose the smallest structural change or decisive experiment.
3. Apply only that scoped change.
4. Rerun the same proof.
5. Classify the result:
   - `keep`: proof improved or equal quality became simpler;
   - `keep-partial`: reusable evidence or a narrower blocker remains;
   - `discard`: no gain or complexity exceeds benefit;
   - `crash`: the experiment did not produce a valid result;
   - `pivot`: evidence rejects the chosen driver;
   - `blocked`: permission, safety, or user decision stops work.
6. Continue only when another safe experiment can change the decision.

Fix a trivial crash once or twice. If the idea is wrong, discard it; do not turn crash repair into the mission.

## Safety and Scope

Use `risk-preflight` before production, database, destructive, financial, customer-data, deployment, or irreversible action. A green dry-run or artifact is not live permission.

Stop when evidence conflicts, the editable surface keeps expanding, the proof cannot be defined, or the same lane fails twice without a new strategy.

## Completion

Report briefly in Traditional Chinese:

- chosen driver and structural class;
- baseline and proof result;
- kept, discarded, or pivoted change;
- changed surface and remaining risk;
- next smallest structural action.

Do not create a report unless durable findings, changed project state, a real handoff, or the user requires one.
