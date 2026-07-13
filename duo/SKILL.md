---
name: duo
description: Use when the user says DUO, 主控室, PM + executor, 主管 + 主執行, or wants one Codex task to supervise another.
---

# DUO

## Purpose

Run one control plane and one execution lane when supervision materially improves a long, risky, or multi-stage task. Do not use DUO when coordination costs more than the work.

## Ownership

- `PM / control plane`: owns the objective, current truth, routing, authorization record, artifact lineage, acceptance criteria, and next-stage decision.
- `Executor`: owns the scoped implementation or investigation, local verification, artifacts, and honest PASS/BLOCKED report.

One state has one writer. The PM does not silently redo executor work, and the executor does not expand strategy or permission.

## Startup Contract

Before sending work, the PM records:

- mission and measurable finish line;
- executor identity or task;
- current truth with paths, run IDs, or source links;
- editable and frozen surfaces;
- granted actions and explicit live boundary;
- required proof and rollback expectation;
- PASS, BLOCKED, and user-decision conditions.

Do not create a visible Codex task unless the user explicitly asked for one. When the executor is an internal subtask, follow the active collaboration policy instead of inventing a new thread workflow.

## Executor Prompt

Send only decision-relevant context:

```text
DUO EXECUTOR TASK
Mission: <one outcome>
Current truth:
- <fact + coordinate>
Allowed: <bounded actions>
Forbidden: <frozen or live surface>
Required proof:
- <test, artifact, UI, API, log, rollback>
PASS: <exact acceptance evidence>
BLOCKED: <repeat limit, missing gate, unsafe state, user decision>
Report: status, changed surface, artifacts, verification, side effects, next safe action
```

Do not send chat history when a compact evidence packet is enough.

## PM Control Loop

For each executor update:

1. Compare it with the mission metric, not activity volume.
2. Treat PASS, HTTP 200, tests, and summaries as claims until the cited evidence is checked.
3. Verify explicit artifact identity. Never infer “latest” from mtime.
4. Check that the changed surface and authority stayed within contract.
5. Classify the blocker narrowly: item, lane, route, system, missing proof, permission, or user decision.
6. Send one next action, approve the next bounded stage, repair the route, or stop.

If the executor is correctly pursuing a defined proof, stay quiet until a checkpoint. Interrupt only for unsafe authority, wrong target or route, stale truth, contradictory evidence, or out-of-scope changes.

## Progress

Progress means the mission moved:

- a failing proof became green;
- a user-visible flow works;
- a blocker was isolated enough for the main lane to continue;
- a required reusable artifact is complete;
- a measured risk or queue decreased.

Busy work, file churn, and no-op monitoring are not milestones.

## Decision Report

The executor reports at decision boundaries, not after every command:

```text
PM_REPORT
status: pass | partial | blocked | failed | no_op
scope: <lane or component>
changed_surface: <paths or records>
artifacts: <path + run id/hash when identity matters>
verification: <proof + result>
side_effects: <expected and unexpected>
blocker: <narrow fact or none>
next_safe_action: <one action>
```

The PM verifies cited evidence before changing routing or permission.

## Stop Rules

Stop or return to the user when:

- the next action crosses an ungranted live, production, data, money, deployment, or destructive boundary;
- artifact identity, ownership, or current truth is ambiguous;
- evidence conflicts;
- the same lane fails twice without a new strategy;
- required proof cannot be produced;
- the change escaped the editable surface;
- a product, policy, or business choice is required.

Report `blocking_rule`, `missing_proof_or_gate`, and `minimal_safe_next` rather than a vague pause.

## Completion

The PM closes DUO only after checking acceptance criteria, changed surfaces, verification, side effects, rollback or recovery, and remaining risk. Summarize the product outcome first; coordination details are secondary.
