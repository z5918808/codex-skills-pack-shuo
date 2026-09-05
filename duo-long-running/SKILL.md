---
name: duo-long-running
description: Coordinate a persistent Reviewer/Worker pair for a duo long run, 雙 task 長跑, with event handoffs and Reviewer acceptance.
---

# Duo Long Running

Use this skill for a persistent Reviewer/Worker run. Reviewing or editing the skill itself does not start a run. The project/task contract owns scope, permissions, domain rules, and acceptance; this skill owns coordination.

## Roles

- **Reviewer:** the activation chat unless the user names another; keep it as the user-facing endpoint. Own shared repair, repo changes, authority publication, lifecycle repair, and acceptance. Before dispatch, verify the actual model is `gpt-5.6-sol` or `gpt-6-astra` and the selected effort is host-supported. Preserve model and effort; Astra may use `low`, `medium`, `high`, `xhigh`, `max`, or `ultra`. An unsupported combination blocks dispatch until corrected; never silently switch models or create another Reviewer. Never inherit Worker permissions.
- **Worker:** one persistent task, default `gpt-5.6-luna/max`; preserve its selected model and effort. Own one goal and one production action, continuing safe work within the contract without supervision. Handle item-local variation, but set `shared_self_repair_budget=none`: no debugging or patching repo code, shared contracts, schedulers, adapters, authority, or infrastructure. No invented authority, expanded permission, or rescue model. On a shared or deterministic defect, stop at a safe boundary and hand off; no extra production cycle.

## Non-Negotiable Invariants

1. Use exactly one persistent Reviewer task and one persistent Worker task.
2. Never use `spawn_agent`, child agents, subagents, local background jobs, or repeated Reviewer turns as the DUO Worker.
3. Never use `wait_threads`, polling, heartbeat, recurring automation, filesystem polling, or process polling to watch the other task.
4. The Worker owns production traversal. The Reviewer may diagnose and repair a shared defect with a bounded fixture, but never runs the Worker's full job.
5. A Worker-local final is not delivery. A terminal event needs a successful direct-message tool receipt.
6. A Worker acceptance claim is not completion. Only the Reviewer may return `ship` after current evidence review.
7. Never layer a new goal over an unfinished Worker goal.
8. Never expand scope, permission, credentials, or safety boundaries without the required user gate.
9. A stop from the user or Reviewer revokes the current generation. Persist and check its stop record on every Worker entry, including automatic continuation; an active native goal is not permission to resume.

If persistent task lifecycle or direct task messaging is unavailable, fail closed. Do not emulate DUO with a subagent. If DUO mistakenly used a subagent, stop only that subagent before its next action, keep read-only observations as non-authoritative, and restart with one persistent Worker.

## Authority and Acceptance

The Reviewer derives and pins the acceptance checklist from the user/project contract before considering Worker conclusions. Worker packets provide evidence; they cannot change scope, remove criteria, lower thresholds, or waive requirements. Contract changes require the applicable authority/user gate and a new checklist revision.

Worker diagnoses and `reviewer_instruction` / `user_confirmation_required` fields are advisory, never authority. Reviewer checks evidence and existing permission independently. A false flag cannot waive a gate; a true flag does not create one. Continue authorized repair without redundant confirmation.

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

After any cross-task goal, handoff, repair result, decision, or event message, the sender ends its turn. The next direct message resumes the receiver; neither side waits for a reply. Delivery failure preserves the undelivered packet and stops locally, never silently becoming completion.

An explicit user pause or Reviewer stop uses [lifecycle cancellation](references/lifecycle.md); it never creates a replacement. Native automatic goals require a verified cancellation capability before creation. Otherwise use the ordinary persistent task with a file-backed goal contract and no native `/goal` or `create_goal`. Resume needs fresh authority and a new generation; a scheduler continuation supplies neither.

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

- neither task owns a cross-task wait or monitor;
- the Reviewer owns no duplicate Worker command;
- there is one Worker OWNER and no duplicate controller/writer;
- both titles still have the right prefixes;
- the last terminal event has a successful direct-message receipt;
- for accepted completion, packet revision/hash, `ship`, and no post-verdict change all match.

Report the delivered outcome first. Keep lifecycle noise out of the user-facing result.

For skill maintenance, run the linked semantic scenarios. Review fails on subagent Workers, cross-task monitoring/waiting, Reviewer production takeover, a third Reviewer, Worker-controlled acceptance or authority, or completion from a local final/delivery receipt alone.
