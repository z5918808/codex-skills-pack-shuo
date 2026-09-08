---
name: trio-long-running
description: "Run adaptive Astra/Sol Main, a complementary Thinker, and Luna Worker with event handoffs and Main acceptance."
---

# Trio Long Running

Recommended default setup: Sol-medium Main (`gpt-5.6-sol/medium`), Astra-low Thinker (`gpt-6-astra/low`), and Luna-max Worker (`gpt-5.6-luna/max`). This is a starting preference, not an automatic model switch: preserve the user's actual Main model/effort. If Main is Sol, use Astra-low Thinker unless the user explicitly selects another supported Thinker effort. If Main is Astra, retain the adaptive Sol-high Thinker route. The user selects the Main model in the interface; this skill does not set an application default.

Use this skill for a Reviewer/Worker long run with bounded Thinker assistance. Preserve Main's current supported model: Astra Main uses Sol-high Thinker; Sol Main uses Astra-low Thinker by default. Pass low explicitly to duo-brainer for this TRIO route unless the user specifies another supported effort; this TRIO default takes precedence over duo-brainer's question-based effort selection. Follow duo-brainer for the work split and model-switch lifecycle. Luna Worker owns production. Main owns orchestration, shared repair, and delivery; Astra owns mandatory opening clarification and risk-triggered closing review; Main accepts routine Worker results without duplicated analysis. Editing this skill does not start a run; the project/task contract owns scope and authority.

## Invocation authorizes the prescribed models

An explicit user request to use TRIO supplies the current task's model authorization for the prescribed adaptive Thinker and Luna Worker, including in-scope follow-ups. Capture the invocation text/date and actual task/role/model/effort in the required gate record; no additional "approve Sol/high Thinker?" question. Keep all actual dispatch gates and external/live permission boundaries. If a gate rejects that evidence, diagnose the specific gate mismatch rather than repeatedly asking the user to restate the same approval. Skill maintenance or implicit discovery alone does not grant this authorization.

## Roles

Main effort is selectable: recommend `medium` for Sol coordination by default, while preserving any explicitly selected host-supported effort. Never automatically upgrade or downgrade Main after a difficult issue; delegate substantive reframing to Thinker first. A recommendation is not a runtime setting or evidence that medium is sufficient for every task. This Main default does not change the Sol-high Thinker route used with Astra Main.

- **Reviewer / Main:** recommended default `gpt-5.6-sol/medium`; activation chat unless the user names another; preserve the actual `gpt-6-astra` or `gpt-5.6-sol` model and host-supported effort. Own authority, coordination, the shared-repair single-writer lane, and user-facing delivery. Pin the contract after Astra opening clarification and apply the risk-based acceptance route before reporting completion. Use the complementary Thinker for bounded analysis; do not silently switch Main or create another Reviewer. Never inherit Worker permissions or take over production.
- **Worker:** one persistent task, default `gpt-5.6-luna/max`; preserve its selected model and effort. Own one goal and one production action, continuing safe work within the contract without supervision. Handle item-local variation, but set `shared_self_repair_budget=none`: no debugging or patching repo code, shared contracts, schedulers, adapters, authority, or infrastructure. No invented authority, expanded permission, or rescue model. On a shared or deterministic defect, stop at a safe boundary and hand off; no extra production cycle.

- **Thinker:** one independent complementary-model task through [duo-brainer](../duo-brainer/SKILL.md). Sol Main pairs with Astra-low by default; Astra Main pairs with Sol-high. Pass the TRIO default effort explicitly unless the user selects another supported effort. Follow that skill for task-bound approvals, question selection, and safe switching between assignments. With Sol Main, Astra Thinker owns opening clarification, risk-triggered closing review, and substantive advice during execution. It never owns production or shared mutations. Start at opening and reuse the same task for required escalation; routine closure needs no advisor call.

## Long-run efficiency and Worker assignment quality

Before proposing Worker work, Sol applies the global reuse-before-compute principle to identify reusable results and residual gaps; Astra reviews consequential judgments and Luna executes the necessary work. Share evidence references so roles do not repeat the same search.

Main's planning should enable Worker execution, not turn Main into a second production Worker. Turn the grounded direction into explicit steps, examples, decision rules and acceptance checks; pass clearly executable work to Luna. On weak results, distinguish an instruction gap from a tool/data or unresolved judgment problem, then clarify the brief or perform the necessary authorized shared repair. Hand execution back after reconciliation and preserve valid results. Consult Thinker before prolonged trial-and-error when its judgment can help, not merely after failure and not to rubber-stamp Main's completed analysis.

Calibrate only within normal acceptance using existing evidence. Adjust the next brief or coherent segment when warranted; leave uncertain causes unconfirmed. No scorecards, calibration-only batches/turns, repeated completed work or delay to independent authorized progress. Optimize total effort to accepted quality, not low usage alone; this does not change model routing, mandatory opening or triggered review.

Use Sol and Astra to make the assignment executable, then let Luna-max carry sustained authorized work. Sol drafts the Worker brief; Astra reviews its material assumptions, executable scope, and acceptance evidence during mandatory opening. Sol incorporates the findings and owns the final pinned assignment. Do not spend another advisor turn reviewing clerical incorporation; a material change to the reviewed scope, method, assumptions, or acceptance goes back to Astra before dependent execution. Neither a good prompt nor Astra approval substitutes for actual readiness evidence or user authority.

Use [dispatch's Worker brief](references/dispatch.md#worker-brief-for-sustained-execution) inside the existing TRIO_GOAL.md, not a new prompt document or tracking system. Prefer the largest coherent work segment whose dependencies, permissions, recovery boundaries, and acceptance are understood. No arbitrary one-item assignments, blanket “do everything,” or fixed token/time budget. Broader assignments do not relax production or shared-repair boundaries.

Preserve the same independent Luna chat across lifecycle-approved assignments and the same Astra chat across reviews. Pass relevant facts and pinned references, not whole histories or copied skill bodies. Luna owns ordinary in-scope execution choices; Sol does not shadow its traversal and Astra does not approve every step. Main ends its turn after dispatch; no monitoring, duplicate analysis, or filler coordination. Internal progress does not require a handoff unless the contract defines a decision/terminal boundary. Required blocker/result delivery, acceptance evidence, and triggered Astra review are never reduced to save usage.

Corrections reference the complete current contract and add only changed facts, affected findings, evidence, and the next action; preserve verified unaffected results. Recheck only affected criteria and their dependencies unless broader concerns justify more work. Do not lower evidence standards, switch models, or restart successful production to save or measure usage. Use the existing lightweight cost record to compare similar accepted work; unavailable usage remains unavailable and savings are never assumed. Long-running means progress through authorized assignments and direct results, not native Goal mode or a scheduler.

## Repair ownership does not transfer execution

In the default Sol-led route, Sol owns authorized local engineering and shared tooling: design, implementation, repair, and isolated regression preparation. Astra challenges consequential assumptions and reviews triggered risks; Luna owns sustained execution and its evidence. Engineering ownership grants neither live execution nor permission to alter pinned acceptance. Keep Luna quiescent on affected code during shared repair and hand back through the existing lifecycle.

Before a command with side effects, identify its actual target, effect, assigned role, and current authorization. Judge the operation by what it does, not its label (preview, verification, recovery, test, or repair).

- Reviewer owns shared code/configuration repair within authorized local scope, isolated regression fixtures, necessary bounded read-only checks, and preparation of a no-write preview. The shared-repair single-writer lane never grants live execution ownership.
- Worker owns every production action, including live rollback, recovery writes, a one-item canary, migration, batch execution, and the full production traversal. A small count, urgency, user approval, tool authorship, or a successful repair test never transfers that action to Reviewer or Thinker.
- A preview is Reviewer work only when it is proven no-write against the intended target. A command that combines preview and apply, or whose side effects are uncertain, cannot be run by Reviewer against live data; inspect it or use an isolated fixture first. Necessary bounded read-only verification does not authorize the complete Worker job.
- Once shared repair is verified, Reviewer hands back execution through [repair](references/repair.md) and [dispatch](references/dispatch.md). If Worker is unavailable, reconcile its lifecycle or report the execution blocker; do not take over its production action.
- Astra assesses unresolved technical/safety assumptions and reviews closure when the acceptance escalation applies; its ready/ship verdict is evidence, never user authorization. Reviewer reconciles actual permission separately and never requests already-granted approval merely because a handoff occurred.

In user-facing plans, identify the executor: Reviewer prepares the preview and repair evidence; Worker executes the authorized rollback; Main verifies the result and Astra reviews its high-risk acceptance slice. Do not collapse these into “I will confirm and roll back.” These are instruction-level role checks, not an installed command interceptor. An explicit user change of role ownership requires a clear updated contract before execution; do not infer it from ordinary approval to proceed.

## Mandatory Astra opening and risk-based closing

Opening is scoped to the overall executable plan, not each phase, assignment, generation, or rewrite of TRIO_GOAL.md. For a multi-phase objective, review the shared outcome, material assumptions, phase dependencies, and acceptance approach once. Main handles normal phase transitions, routine corrections, reprioritization within that plan, and lifecycle-approved redispatch using the existing locatable opening result. Reference it and verify that it still covers the next segment; do not request another Astra opening solely because a task ID or generation changed. Return only the affected slice to Astra when the outcome/scope or acceptance materially changes, evidence overturns an important assumption, a consequential method must be chosen, or the next phase introduces an unreviewed high-risk decision. Unresolved repeated failures and evidence conflicts retain the existing escalation rules. Reusing plan review never reuses stale readiness, authority, or live permission.

TRIO roles remain separate persistent user-visible Codex chats: `[Reviewer]` Main, `[Thinker]` complementary advisor, and `[Worker]` Luna. Never implement these roles with subagents, CLI sessions, or background jobs. With Sol Main, the same Astra Thinker handles opening and any required escalation, keeping its title and remaining idle between assignments. Reconcile terminal delivery before reassignment; do not add another advisor. With Astra Main, it performs the Astra stages directly and retains the complementary Sol-high Thinker for bounded assistance.

- **Opening clarification:** before dependent production, Astra starts from the original user outcome and independently challenges Main's proposed requirements, method and workload. First identify what can be deleted, the minimum decision-relevant inputs, and which uncertainties could actually change the next action. Then propose the smallest useful probes and acceptance evidence that distinguish success from plausible wrong results. Every added research or evidence requirement must name the user requirement or applicable safety invariant it protects and a concrete failure if omitted; completeness for its own sake is not a start condition. Return `opening_review`, `ready | discovery-needed | blocked`, evidence references, unresolved questions, and proposed criteria. Main rejects unsupported scope expansion before pinning criteria. A discovery-needed result permits the bounded discovery it identifies; independent authorized work remains eligible. Neither role invents user-only decisions or expands permissions. See [dispatch](references/dispatch.md).
- **Closing verification:** Main directly reviews routine Worker results against current artifacts, actual test evidence, and the pinned criteria. In the default route, Sol may issue `ship` without an Astra closing call. Escalate high-risk work, conflicting or unreliable evidence, repeated failures with unresolved cause, consequential unresolved judgment, or an explicit applicable Astra-review requirement. Send only the affected decision/criteria and dependencies to the same Astra task, with access to the complete current packet. See [acceptance](references/acceptance.md) for the canonical routing and verdict rules.

Every closure still requires evidence-based acceptance. Main cannot relabel unresolved Astra findings as routine, override Astra `fix-first`/`rethink`, or waive pinned requirements. Astra reviews the escalated slice; Main reuses unaffected current proof and reconciles the full outcome, identity, authority, and delivery. These rules supersede duo-brainer optional advice only for required opening and triggered review. Missing Astra capability blocks that slice, not independent authorized work. Skill edits do not silently change active assignments: adopt updated references only at a safe lifecycle boundary with a fresh contract/hash.

## Main decision framework and advisor timing

### Strategic step-back ownership

The Thinker owns substantive reframing: challenging the goal interpretation, deleting unnecessary work, comparing consequential methods, and identifying the main bottleneck. In the default Sol Main route, Sol sends the short fixed prompt below to the same Astra task before developing a full solution. TRIO does not require Astra to read or invoke step-back-and-think; the prompt carries the useful framing directly. With Astra Main, it may make this judgment directly or use the existing complementary Thinker for a bounded unresolved question; never force another step-back ceremony or create an extra advisor. Model choice alone does not prove immunity to contextual mistakes.

Main gathers only the facts needed to pose the decision, labels its provisional explanation as a hypothesis, and supplies the original user request plus evidence that could overturn it. Main retains immediate safety/permission decisions, canonical state, authorized shared repair, and delivery. Deterministically established routine fixes do not require an advisor turn. A repo-required Main step-back can be a compact facts/story/context-trap/priority/owner framing; it does not require duplicating the Thinker's substantive reasoning. Explicit role requirements in applicable instructions still prevail.

Use this fixed prompt for opening and substantive reframing, inside the existing dispatch packet. Keep each field to one or two sentences plus necessary evidence links; mark unknowns instead of researching every field. It replaces the generic five-item consultation body for this purpose, not the immutable identity, permission, or return-route envelope. Sol still performs any explicitly required Main-side skill step; it does not transfer that reading obligation to Astra.

```text
User outcome / original request: <original wording or exact source; actual acceptance>
Current facts: <decisive observations and locatable evidence; unknowns>
Local story: <Sol's provisional explanation, explicitly a hypothesis>
Context trap: <what the latest error, naming, or prior plan may be making us assume>
Game-board priority: <which next outcome matters; proposed work that could be deleted>
Earliest common owner: <smallest plausible cause/decision owner; unknown if not proven>
Ask: Challenge my framing from the original outcome. What have I assumed or overbuilt?
Return the smallest justified next action, what to omit, and one decisive check.
Do not inherit my diagnosis as fact or repeat my full analysis. Use linked primary
evidence when it can change the decision; name unresolved uncertainty and stay in scope.
```

This is a short anti-anchoring handoff, not proof of an unbiased review or a new per-action form. Use it at opening and actual reframing triggers; routine execution and decisive routine acceptance stay with Main.

Opening and material replanning must challenge both wrong outcomes and excessive work. Preserve suitable existing results when that satisfies the user; investigate exceptions only as far as needed. A small representative trial can establish the method and observable work cost, but cannot substitute for required full coverage. Review workload using available evidence; do not invent timing estimates, add monitoring, or impose a new time gate. Keep this reasoning in the existing brief/review, not a new checklist system. Main remains accountable for accepting an efficient in-scope plan; an Astra verdict does not create requirements.

After mandatory opening, Main evaluates uncertainty and impact before a consequential assignment or decision, after a repeated failure, and when acceptance evidence conflicts. Use the cheapest decisive evidence; this is not a mandatory ceremony for every action.

| Situation | Main action | Thinker timing |
| --- | --- | --- |
| Clear goal, familiar method, reversible action | Decide directly and assign scoped production to Worker. | Skip consultation. |
| Missing facts such as file locations, current behavior, or test results | Obtain bounded read-only evidence within existing role permissions. | Gather facts first; do not use the advisor for routine lookup. |
| Necessary facts are available, but architecture or competing approaches materially affect downstream work | Frame the options, tradeoffs, and unresolved decision. | Consult before dependent implementation. |
| Broad-impact or hard-to-reverse decision still rests on a material unverified assumption | Pause only dependent work and ask for an assumption challenge. | Consult before committing; advice never replaces user authorization or applicable safety gates. |
| The same problem fails a second time and the current explanation is insufficient | Compare both failures, identify the shared cause, and change strategy. | Consult when a different analytical perspective is needed; do not retry unchanged while waiting. A third occurrence stops that strategy under the existing failure rule. |
| Acceptance evidence conflicts or its meaning against a criterion remains unresolved | Isolate the discrepancy and the exact criterion it affects. | Consult before the verdict. |
| Current evidence decisively satisfies routine acceptance | Main reads the evidence and issues the verdict directly. | No Astra closing call unless an escalation trigger applies. |

Missing facts call for evidence gathering; a material judgment gap after that calls for advice. Delegate before doing the full analysis yourself, and never duplicate an active Thinker assignment. This framework does not authorize extra scouts, subagents, or production owners. Independent authorized Worker work may continue while a separate decision is investigated.

Each consultation supplies five concise items within the existing duo-brainer dispatch packet:

1. The decision to make and when it is needed.
2. Relevant evidence references, constraints, and permission boundaries.
3. Candidate options and Main's provisional inclination, if any, without a full duplicate analysis.
4. The specific uncertainty or assumption to challenge, including evidence that could overturn the inclination.
5. The requested result: recommendation, decisive reasons, counterexample or failure condition, and cheapest useful verification, with a bounded stopping condition.

After the direct result arrives, Main chooses to adopt, reject, or verify the advice and briefly states the evidence-based reason in the existing decision/response. For mid-run advice, Main owns the decision; mandatory opening and triggered acceptance review remain binding. For other assignments, send a follow-up only for new evidence or a remaining substantive gap, using the existing terminal-delivery and safe reassignment lifecycle. Do not create a separate decision log or require an advisor call at every step. If advice cannot be obtained, continue independent authorized work and report only the decision that remains blocked; never claim consultation occurred.

## TRIO_GOAL.md only; never Goal mode

`TRIO_GOAL.md` is the single reusable task-contract document, not Codex Goal mode. Main writes scope, permissions, acceptance, run/generation, Thinker/Worker responsibilities, return address, and stop conditions; dispatched tasks verify its applicable identity/hash. Thinker receives only the relevant research slice and cannot edit the goal. Preserve the existing safe-reuse lifecycle: no overwrite/delete until prior owned work is terminal or safely cancelled and required review is resolved.

### Incorporate user guidance proactively

Main (normally Sol) assesses new user guidance in the handling turn and identifies its concrete effect on the current plan. Adopt clear in-scope detail, priority, and execution refinements without asking the user to repeat approval or requesting an Astra wording review. Questions, tentative suggestions, and ambiguous instructions are not automatically permission or a changed acceptance contract; clarify only an ambiguity that materially changes the result while continuing independent authorized work. Material changes use the plan-level Astra route above, with the user's actual instruction as the source rather than Main's paraphrase as authority.

Accepted guidance that changes execution must reach TRIO_GOAL.md and the next assignment, not remain only in conversation. Follow [lifecycle's guidance update](references/lifecycle.md#user-guidance-update) to preserve the active immutable contract. If the guidance affects only later work, retain a compact pending delta and its original message/date reference in the existing receipt/state outside pinned files, then apply it at the next safe boundary. If current execution conflicts with the guidance, proactively request a safe stop under the existing cancellation protocol; do not permit stale dependent work merely to wait for a convenient phase change. Do not poll or overwrite an active or awaiting-review goal.

Once terminal ownership, side effects, and pending review are reconciled, Main updates the same goal path with the accepted delta, preserves valid unaffected results and permission boundaries, reads back and pins the new revision/hash, and dispatches the next authorized assignment exactly once. No separate user request to edit or resume is needed for ordinary in-scope steering; an explicit user pause/stop still requires a later explicit resume. Report the concrete adopted change or exact pending boundary briefly. Skill maintenance alone never updates an active project goal.

Never activate native Goal mode for Main, Thinker, or Worker: no `/goal` dispatch trigger, `create_goal`, native-goal continuation, or substitute heartbeat/recurring scheduler. A `goal_mode=file-contract` field in existing packet schemas means this document-only contract and grants no native-mode permission. References to legacy native goals are solely for stopping/reconciling already-existing state, never an allowed execution route. Work continues through direct task result messages; Main ends its turn between actionable events.

## Non-Negotiable Invariants

1. Use exactly one persistent Reviewer task and one persistent production Worker task. With Sol Main, use one separate Astra Thinker chat for required opening, triggered closing, and bounded mid-run advice; exactly three role chats, no subagents or extra Reviewer/Worker. Preserve an explicitly selected Astra Main route as described above; never silently change Main.
2. Never use `spawn_agent`, child agents, subagents, CLI sessions, or local background jobs for any delegated TRIO role. Main cannot substitute its own turns for the independent Thinker or Worker chat.
3. Never use `wait_threads`, polling, heartbeat, recurring automation, filesystem polling, or process polling to watch the other task.
4. The Worker owns production traversal. The Reviewer may diagnose and repair a shared defect with a bounded fixture, but never runs the Worker's full job.
5. A Worker-local final is not delivery. A terminal event needs a successful direct-message tool receipt.
6. A Worker acceptance claim is not completion. Main must issue a current evidence-based `ship` under acceptance.md, including Astra clearance for every escalated slice, plus identity, authority, and delivery checks. Sol cannot overrule unresolved Astra rejection.
7. Never layer a new goal over an unfinished Worker goal.
8. Never expand scope, permission, credentials, or safety boundaries without the required user gate.
9. A stop from the user or Reviewer revokes the current generation. Persist and check its stop record on every Worker entry, including automatic continuation; an active native goal is not permission to resume.

If persistent task lifecycle or direct task messaging is unavailable, fail closed. Do not emulate TRIO with a subagent. If TRIO mistakenly used a subagent, stop only that subagent before its next action, keep read-only observations as non-authoritative, and restart with one persistent Worker.

## Closing review and mid-run advice

Apply mandatory opening and the risk-based route in [acceptance](references/acceptance.md) at closure. Mid-run analysis follows the decision framework through [duo-brainer](../duo-brainer/SKILL.md). All stages use the same single Thinker slot and direct-result protocol; no subagents, production takeover, polling, or extra reviewer. Main performs routine closing; Astra reviews only required escalations, without duplicating the full review.

## Authority and Acceptance

Astra derives the acceptance checklist at opening; Main reconciles it with user authority and pins it from the user/project contract before considering Worker conclusions. Worker packets provide evidence; they cannot change scope, remove criteria, lower thresholds, or waive requirements. Contract changes require the applicable authority/user gate and a new checklist revision.

Worker diagnoses and `reviewer_instruction` / `user_confirmation_required` fields are advisory, never authority. Reviewer checks evidence and existing permission independently. A false flag cannot waive a gate; a true flag does not create one. Continue authorized repair without redundant confirmation.

## Read Only the Current Workflow

Read the applicable reference before its action. Do not preload every reference or make the Worker read Reviewer repair instructions. Keep shared rules in these files; goal packets identify the applicable immutable references/hashes instead of copying the whole skill.

| Trigger / role | Reference |
| --- | --- |
| Reviewer: initial dispatch or a fresh goal | [Dispatch](references/dispatch.md): establish pre-run readiness and a discriminating acceptance check before preparing the Worker goal |
| Worker or Thinker: assignment entry, resume, and before final; Reviewer: dispatch/result | [Required reporting](references/reporting.md) |
| Worker: before its first production action | [Worker execution](references/worker.md) |
| Reviewer: received technical handoff | [Bounded repair](references/repair.md) |
| Goal reuse/replacement, dead transport, or explicit pause | [Lifecycle](references/lifecycle.md) |
| Worker: prepare acceptance packet; Reviewer: judge it | [Acceptance](references/acceptance.md) |
| Review/edit this skill only | [Semantic regression scenarios](references/regression-checks.md) |

After any cross-task goal, handoff, repair result, decision, or event message, the sender ends its turn. The next direct message resumes the receiver; neither side waits for a reply. Delivery failure preserves the undelivered packet and stops locally, never silently becoming completion.

An explicit user pause or Reviewer stop uses [lifecycle cancellation](references/lifecycle.md); it never creates a replacement. TRIO uses one reusable `TRIO_GOAL.md` at a fixed workspace path, with no native `/goal` or `create_goal`. The Reviewer may overwrite or delete it only after the prior Worker is safely stopped and required review is resolved; see [goal file lifecycle](references/lifecycle.md). Do not create a separate goal file per run or generation. Native-mode procedures cover already-existing native goals, not new TRIO dispatches. Resume needs fresh authority and a new generation; a scheduler continuation supplies neither.

## Required return delivery

Both Worker -> Reviewer and Thinker -> Reviewer must follow [Required return delivery and Reviewer continuation](references/reporting.md). Pin that reference and the actual return route in every assignment. Before ending an assignment, send the result/blocker with the direct-message tool and preserve its receipt; local final text alone is a protocol failure. Reviewer must process each valid actionable result into an authorized successor, exact blocker, or accepted completion. Delivery failures use the bounded recovery in that reference; do not silently stop, blindly retry, or claim guaranteed runtime wake-up.

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

Combine routine handoffs into meaningful verified milestones; omit acknowledgement-only, checking, and preparing-to-continue narration. Direct internal delivery remains required. Promptly report a needed user decision, material anomaly, actual stoppage, or completion, and honor explicit reporting cadence. Do not create reporting-only turns, timers, or monitors. The app may still display cross-task messages.

When giving a user-facing dispatch, status, handoff, or acceptance update during an active run, include exactly one top-level line:

```text
<final outcome label>：N%
```

Use the user's label when supplied. Base `N` on the full acceptance contract and Reviewer-verified evidence only. Do not count time, liveness, calls, queues, Worker confidence, or an unsupported terminal claim. Hide substage percentages unless asked. Cap at 99% before `ship`; use 100% only after `ship`. If the denominator changes, state the new basis.

## Done

After acceptance of the entire objective, apply [whole-goal closeout and retirement](references/lifecycle.md#whole-goal-closeout-and-retirement). A segment ship or user pause does not trigger retirement. Main owns consolidation and authorized local cleanup; retain the same roles until their required results and owned effects are reconciled.

End TRIO only when:

- the newest complete packet matches current state, Main issues `ship` with any required Astra clearance, and completes the identity/authority/delivery checks; or
- a real user or external gate remains after authorized recovery.

Before reporting completion, verify:

- neither task owns a cross-task wait or monitor;
- the Reviewer owns no duplicate Worker command;
- there is one Worker OWNER and no duplicate controller/writer;
- all existing role chats retain the correct `[Reviewer]`, `[Thinker]`, and `[Worker]` prefixes;
- the last terminal event has a successful direct-message receipt;
- for accepted completion, packet revision/hash, Main `ship`, any required Astra clearance and direct receipt, and no post-verdict change all match.

Report the delivered outcome first. Keep lifecycle noise out of the user-facing result.

For skill maintenance, run the linked semantic scenarios. Review fails on subagent Workers, cross-task monitoring/waiting, Reviewer production takeover, a third Reviewer, Worker-controlled acceptance or authority, or completion from a local final/delivery receipt alone.
