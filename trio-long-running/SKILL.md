---
name: trio-long-running
description: "Run adaptive Astra/Sol Main, a complementary Thinker, and Luna Worker with event handoffs and Main acceptance."
---

# Trio Long Running

Recommended default setup: Astra Main with Sol-high Thinker. This is a starting preference, not an automatic model switch: preserve the user's actual Main model/effort. If Main is Sol, use Astra Thinker through the adaptive route. The user selects the Main model in the interface; this skill does not set an application default.

Use this skill for a Reviewer/Worker long run with bounded Thinker assistance. Preserve Main's current supported model: Astra Main uses Sol-high Thinker; Sol Main uses Astra Thinker. Follow duo-brainer for the canonical effort selection, work split, and model-switch lifecycle. Luna Worker owns production. Main owns orchestration, standards, and final acceptance without duplicating delegated analysis. Editing this skill does not start a run; the project/task contract owns scope and authority.

## Invocation authorizes the prescribed models

An explicit user request to use TRIO supplies the current task's model authorization for the prescribed adaptive Thinker and Luna Worker, including in-scope follow-ups. Capture the invocation text/date and actual task/role/model/effort in the required gate record; no additional "approve Sol/high Thinker?" question. Keep all actual dispatch gates and external/live permission boundaries. If a gate rejects that evidence, diagnose the specific gate mismatch rather than repeatedly asking the user to restate the same approval. Skill maintenance or implicit discovery alone does not grant this authorization.

## Roles

- **Reviewer / Main:** activation chat unless the user names another; preserve the actual `gpt-6-astra` or `gpt-5.6-sol` model and host-supported effort. Own authority, coordination, standards, final acceptance, and the shared-repair single-writer lane. Use the complementary Thinker for bounded analysis; do not silently switch Main or create another Reviewer. Never inherit Worker permissions or take over production.
- **Worker:** one persistent task, default `gpt-5.6-luna/max`; preserve its selected model and effort. Own one goal and one production action, continuing safe work within the contract without supervision. Handle item-local variation, but set `shared_self_repair_budget=none`: no debugging or patching repo code, shared contracts, schedulers, adapters, authority, or infrastructure. No invented authority, expanded permission, or rescue model. On a shared or deterministic defect, stop at a safe boundary and hand off; no extra production cycle.

- **Thinker:** one independent complementary-model task through [duo-brainer](../duo-brainer/SKILL.md). Astra Main pairs with Sol-high; Sol Main pairs with Astra. Follow that skill for effort, task-bound approvals, question selection, and safe switching between assignments. Thinker advises; it never owns production, shared mutations, or final acceptance. Start only when useful analysis is needed.

## TRIO_GOAL.md only; never Goal mode

`TRIO_GOAL.md` is the single reusable task-contract document, not Codex Goal mode. Main writes scope, permissions, acceptance, run/generation, Thinker/Worker responsibilities, return address, and stop conditions; dispatched tasks verify its applicable identity/hash. Thinker receives only the relevant research slice and cannot edit the goal. Preserve the existing safe-reuse lifecycle: no overwrite/delete until prior owned work is terminal or safely cancelled and required review is resolved.

Never activate native Goal mode for Main, Thinker, or Worker: no `/goal` dispatch trigger, `create_goal`, native-goal continuation, or substitute heartbeat/recurring scheduler. A `goal_mode=file-contract` field in existing packet schemas means this document-only contract and grants no native-mode permission. References to legacy native goals are solely for stopping/reconciling already-existing state, never an allowed execution route. Work continues through direct task result messages; Main ends its turn between actionable events.

## Non-Negotiable Invariants

1. Use exactly one persistent Reviewer task and one persistent production Worker task. The acceptance brainstorming hook may add at most one bounded independent complementary Thinker task, never another Reviewer or production Worker; see the role-scoped exception below.
2. Never use `spawn_agent`, child agents, subagents, local background jobs, or repeated Reviewer turns as the TRIO Worker.
3. Never use `wait_threads`, polling, heartbeat, recurring automation, filesystem polling, or process polling to watch the other task.
4. The Worker owns production traversal. The Reviewer may diagnose and repair a shared defect with a bounded fixture, but never runs the Worker's full job.
5. A Worker-local final is not delivery. A terminal event needs a successful direct-message tool receipt.
6. A Worker acceptance claim is not completion. Only the Reviewer may return `ship` after current evidence review.
7. Never layer a new goal over an unfinished Worker goal.
8. Never expand scope, permission, credentials, or safety boundaries without the required user gate.
9. A stop from the user or Reviewer revokes the current generation. Persist and check its stop record on every Worker entry, including automatic continuation; an active native goal is not permission to resume.

If persistent task lifecycle or direct task messaging is unavailable, fail closed. Do not emulate TRIO with a subagent. If TRIO mistakenly used a subagent, stop only that subagent before its next action, keep read-only observations as non-authoritative, and restart with one persistent Worker.

## Acceptance brainstorming

For either supported Reviewer model, acceptance may use [duo-brainer](../duo-brainer/SKILL.md) to delegate a substantive unresolved research/analysis question to one independent complementary Thinker task. Invoke it only when current evidence leaves such a question; skip redundant analysis. Keep the production Worker, shared repair ownership, pinned checklist, no-monitor event protocol, and Reviewer-only verdict unchanged. Thinker is neither a subagent nor a replacement Worker/Reviewer. This bounded analytical task is the sole exception to the two-task count, not an exception to model approval, permission, delivery, or acceptance gates. Keep the activation Reviewer and derive Thinker routing from its current model; never silently switch Main or create a replacement Reviewer.

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

An explicit user pause or Reviewer stop uses [lifecycle cancellation](references/lifecycle.md); it never creates a replacement. TRIO uses one reusable `TRIO_GOAL.md` at a fixed workspace path, with no native `/goal` or `create_goal`. The Reviewer may overwrite or delete it only after the prior Worker is safely stopped and required review is resolved; see [goal file lifecycle](references/lifecycle.md). Do not create a separate goal file per run or generation. Native-mode procedures cover already-existing native goals, not new TRIO dispatches. Resume needs fresh authority and a new generation; a scheduler continuation supplies neither.

## Main yields while delegated work runs

- Main delegates substantive thinking to Thinker and production to Worker, then ends its current turn after the dispatch receipt. While either is running, do not keep Main sampling, sleep/wait, poll, monitor, issue filler status turns, or duplicate its analysis/execution. This applies to Astra Main and Sol Main alike. Ending the turn is the requested pause/disconnect; it does not mean closing the App, terminating user processes, or cancelling the delegated task.
- Thinker and Worker deliver their bounded result, blocker, or terminal event directly to Main with a successful tool receipt, then end their own turn. Main resumes from that event, checks current generation and evidence, decides the next eligible assignment or verdict, dispatches if needed, and ends again. A routine progress event with no decision needed does not justify more Main work.
- Preserve dependency ordering: accept Thinker input before assigning dependent Worker work. Do not start dependent production merely to keep both tasks busy. Existing independent authorized Worker work may continue while Thinker analyzes a separate question.
- A user message may resume Main for a decision, status request, or stop; handle only that request and any genuinely ready event, then yield again if delegated work remains. An automatic continuation without a new actionable event must end immediately, not restart or duplicate work. User stop/revocation always overrides event continuation.
- This long run advances by direct task events, never by keeping Main awake or adding a scheduler. Verify actual messaging capability before dispatch; missing delivery cannot be replaced by polling or claimed as completion. Do not claim zero tokens, billing suspension, or reliable wake-up without runtime evidence.

## Status Reads

Normal TRIO work uses no cross-task reads after dispatch. Exceptions:

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

End TRIO only when:

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
