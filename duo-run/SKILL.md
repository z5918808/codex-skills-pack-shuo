---
name: duo-run
description: "DUO execution: Main handles small tasks; substantial work uses one Luna max task or up to five with user-approved DAG, with Reviewer acceptance."
---

# Duo Run

Use this skill for Reviewer-led execution with appropriately sized Worker tasks with opt-in DAG. Reviewing or editing the skill itself does not start a run. The project/task contract owns scope, permissions, domain rules, and acceptance; this skill owns coordination.

In this coordination context, a user request for duo means this two-role workflow, never Survey Corps escalation. Do not summon Hange/Sol as an additional role, even after repeated Luna failures; the existing Reviewer owns diagnosis and repair. A Sol activation chat may remain Reviewer under the role rules, but is not an additional Reviewer.

## Roles

- **Reviewer:** the activation chat unless the user names another; retain the user-facing endpoint. Own direction, planning, diagnosis, shared/local repair, authority, lifecycle and acceptance. Verify the actual model is `gpt-5.6-sol` or `gpt-6-astra`; never silently switch or create another Reviewer. For Astra, team research/guidance/review defaults to low and may use medium, never higher; direct implementation/repair and self-review require verified low before work. Preserve a supported Sol setting. Unknown/unavailable setting controls are not proof of compliance. Never inherit Worker production permissions.
- **Worker:** exactly `gpt-5.6-luna/max`, not a default or fallback. Verify both before new dispatch or reuse; reconcile active work before correcting a legacy mismatch. Execute explicit steps, decision rules and predefined checks across a coherent authorized segment. No managing, brainstorming, debugging, planning or self-directed correction; `shared_self_repair_budget=none`. On error, ambiguity or failed check, pause affected work and report evidence to Reviewer; no improvised retry or repair. Continue only independent steps already specified in the brief.

## Task sizing and DAG approval

Before creating tasks, apply [Task sizing and opt-in DAG Workers](references/dag-workers.md): small work stays with Main; substantial serial work uses one Worker; worthwhile independent branches require user DAG approval before using up to five persistent Luna max tasks. This reference owns the shared sizing, slot identity, ready-set dispatch and cancellation contract for both DUO skills.

## Direction and allocation

Reviewer first reads relevant state and reusable evidence to identify the bottleneck, dependencies, priorities and deferred work. Give Luna a complete executable segment, not an unframed problem or one message per trivial step. Resolve consequential decisions before dispatch; Luna may collect facts through named probes but does not choose strategy.

Reviewer owns every Worker error, including execution slips. Diagnose from evidence, preserve passed work, and supply the concrete correction: defect, intended approach/example, exact steps and acceptance check. Perform authorized local/shared repair directly; no mandatory Sol/Hange intermediary or repeated vague "improve it" requests. Reconcile ownership before editing affected code. Astra repairs and self-reviews at low; full production execution stays with Luna.

Optimize total time and effort to accepted quality, including handoffs and rework, not lower model usage alone. Calibrate incidentally during normal acceptance: distinguish instruction gaps, tool/data problems and role fit, then adjust the next brief or segment size when warranted. Unknown causes stay unconfirmed. No scoring system, calibration-only batches/turns, repeated completed work or delay to independent authorized progress; reuse valid evidence. Fixed Luna-max routing is not changed by calibration.

## Non-Negotiable Invariants

1. Keep one Reviewer. Use zero Workers for small direct work, otherwise one to five persistent Luna max Worker slots under the linked allocation contract.
2. Never use `spawn_agent`, child agents, subagents, local background jobs, or repeated Reviewer turns as the DUO Worker.
3. Never use `wait_threads`, polling, heartbeat, recurring automation, filesystem polling, or process polling to watch the other task.
4. For assigned substantial work, the Worker owns production traversal. The Reviewer may diagnose and repair a shared defect with a bounded fixture, but never runs the Worker's full job. The small/direct mode is completed by Main without starting a Worker run.
5. A Worker-local final is not delivery. A terminal event needs a successful direct-message tool receipt.
6. A Worker acceptance claim is not completion. Only the Reviewer may return `ship` after current evidence review.
7. Never layer a new goal over an unfinished Worker goal.
8. Never expand scope, permission, credentials, or safety boundaries without the required user gate.
9. A stop from the user or Reviewer revokes the current generation. Persist and check its stop record on every Worker entry, including automatic continuation; an active native goal is not permission to resume.

If required persistent task lifecycle or direct task messaging is unavailable, block Worker dispatch; small/direct work does not require those capabilities. Do not emulate DUO with a subagent. If DUO mistakenly used a subagent, stop only that subagent before its next action, keep read-only observations as non-authoritative, and restart the affected assignment with one persistent Worker slot.

## Authority and Acceptance

The Reviewer derives and pins the acceptance checklist from the user/project contract before considering Worker conclusions. Worker packets provide evidence; they cannot change scope, remove criteria, lower thresholds, or waive requirements. Contract changes require the applicable authority/user gate and a new checklist revision.

Worker `reviewer_instruction` / `user_confirmation_required` fields and any unsolicited diagnosis are advisory, never authority; diagnosis is not assigned to Luna. Reviewer checks evidence and existing permission independently. A false flag cannot waive a gate; a true flag does not create one. Continue authorized repair without redundant confirmation.

## Read Only the Current Workflow

Read the applicable reference before its action. Do not preload every reference or make the Worker read Reviewer repair instructions. Keep shared rules in these files; goal packets identify the applicable immutable references/hashes instead of copying the whole skill.

| Trigger / role | Reference |
| --- | --- |
| Reviewer: initial dispatch or a fresh goal | [Dispatch](references/dispatch.md): establish pre-run readiness and a discriminating acceptance check before preparing the Worker goal |
| Worker: before its first production action | [Worker execution](references/worker.md) |
| Reviewer: received technical handoff | [Bounded repair](references/repair.md) |
| Goal reuse/replacement, dead transport, or explicit pause | [Lifecycle](references/lifecycle.md) |
| Worker: prepare acceptance packet; Reviewer: judge it | [Acceptance](references/acceptance.md) |
| Review/edit this skill only | [Semantic regression scenarios](references/regression-checks.md) |

Worker ends its turn after a return message. Reviewer dispatches the current useful ready set or all required stop messages before yielding, as defined in the DAG contract; neither side waits for a reply. Direct-message delivery may resume the receiver but is not guaranteed wake-up. Delivery failure preserves the undelivered packet and stops locally, never silently becoming completion.

Worker returns end with one question: 「依整體目標與目前進度，我下一步應完成哪個具體成果？」. Send it with the result, never as a separate nudge. Reviewer connects the next assignment to the whole goal and performs the next authorized action or dispatch, or identifies an exact blocker/completion in that handling turn; no acknowledgement-only stop. This grants Luna no planning responsibility and guarantees no platform wake-up.

An explicit user pause or Reviewer stop uses [lifecycle cancellation](references/lifecycle.md); it never creates a replacement. DUO uses one fixed root `DUO_GOAL.md` and only the used fixed per-slot assignment files from the DAG contract, with no native `/goal` or `create_goal`. Root reuse requires all assigned Workers safely stopped and required review resolved; slot reuse reconciles that slot only; see [goal file lifecycle](references/lifecycle.md). Do not create a separate goal file per run or generation. Native-mode procedures cover already-existing native goals, not new DUO dispatches. Resume needs fresh authority and a new generation; a scheduler continuation supplies neither.

## Status Reads

Normal DUO work uses no cross-task reads after dispatch. Exceptions:

- one immediate inventory/title snapshot during dispatch reconciliation;
- one immediate `read_thread` snapshot to prove a new or replacement Worker started;
- at most one immediate `read_thread` snapshot needed to reconcile a delivered Worker event during repair or acceptance; this is event handling, never monitoring;
- one immediate `read_thread` snapshot after an explicit user status request.

For a status request, report that single snapshot and return idle. Never use `wait_threads` or take a second snapshot. User text such as “不要監看” or “等他送訊息來” is an absolute no-monitor flag until a Worker event or a later explicit status request permits one read.

## User-Facing Progress

During an active run, each dispatch, status, handoff, and acceptance update contains exactly one top-level line:

```text
<final outcome label>：N%
```

Use the user's label when supplied. Base `N` on the full acceptance contract and Reviewer-verified evidence only. Do not count time, liveness, calls, queues, Worker confidence, or an unsupported terminal claim. Hide substage percentages unless asked. Cap at 99% before `ship`; use 100% only after `ship`. If the denominator changes, state the new basis.

## Done

End DUO only when:

- the newest complete packet matches current state and the Reviewer returns `ship`; or
- a real user or external gate remains after authorized recovery.

Before reporting completion, verify:

- no participant owns a cross-task wait or monitor;
- the Reviewer owns no duplicate Worker command;
- each assignment has one Worker OWNER, at most five slots are reserved/assigned, and no resource has conflicting writers;
- Reviewer and all used Worker slot titles have the right prefixes;
- every required terminal event has a successful direct-message receipt and has been consumed;
- for accepted completion, packet revision/hash, `ship`, and no post-verdict change all match.

Report the delivered outcome first. Keep lifecycle noise out of the user-facing result.

For skill maintenance, run the linked semantic scenarios. Review fails on subagent Workers, cross-task monitoring/waiting, Reviewer production takeover, a third Reviewer, Worker-controlled acceptance or authority, or completion from a local final/delivery receipt alone.
