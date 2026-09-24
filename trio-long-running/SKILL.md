---
name: trio-long-running
description: Run explicit long-lived TRIO work with Main, Astra Thinker, and Luna Worker roles.
---

# Trio Long Running

Recommended default setup: Sol-high Main (`gpt-6-sol/high`), Astra-medium Thinker (`gpt-6-astra/medium`), and Luna-max Worker (`gpt-5.6-luna/max`). This is a starting preference, not an automatic Main-model switch: preserve the user's actual Main model/effort. The Thinker is always a separate independent `gpt-6-astra` task, defaulting to medium unless the user explicitly selects another supported Astra effort, regardless of Main's model or effort. The user selects the Main model in the interface; this skill does not set an application default.

Use this skill for a Reviewer/Worker long run with bounded Thinker assistance. Preserve Main's current supported model, but always launch or reuse one separate independent Astra Thinker task following references/dispatch.md and references/reporting.md. Main being Astra never satisfies, replaces, or removes the Thinker task. All three TRIO roles use persistent user-visible tasks. Luna Worker owns production and may use the bounded internal sub-driven DAG in `C:\Users\user\.codex\harness_docs\16_subagent_ban.md`; Main and Thinker never spawn. Reviewer/Main owns orchestration, shared repair, every review decision, acceptance, and delivery. The independent Astra Thinker is support-only: it supplies analysis and challenges assumptions but never owns opening readiness, closing review, clearance, or a verdict. Editing this skill does not start a run; the project/task contract owns scope and authority.

TRIO always keeps its three persistent user-visible roles; native children never occupy or replace them. An explicit TRIO execution invocation includes the Luna/max Worker child envelope, so Luna does not ask again before mechanically splitting eligible in-scope execution. It stays local for small or serial work and never layers children onto an explicit `multi-workers` run. Thinker and Worker must have stable task IDs that resolve through an exact-ID task read with the expected role and workspace. The ordinary task list is a bounded discovery surface: a matching entry is positive identity evidence, but omission alone does not prove absence, archival, or invalidity and never authorizes replacement.

Reuse is the symmetric default for both roles: preserve the same persistent Thinker and the same persistent Worker across assignments, phases, and generations whenever each prior assignment is terminal, delivered, ingested, and its effects are reconciled. A fresh goal revision, question, generation, idle state, or task-list omission is not a reason to create a fresh role task. Replace either role only through the same lifecycle criteria when its exact ID cannot support the next assignment; never replace one role merely because the other role changed.

## Invocation authorizes the prescribed models

An explicit user request to use TRIO supplies the current task's model authorization for the prescribed independent Astra Thinker and Luna Worker, the Luna/max Worker's bounded internal child envelope, and in-scope follow-ups. Capture the invocation text/date and actual task/role/model/effort in the required gate record; no additional "approve Astra Thinker?" or child-DAG question. Keep all actual dispatch gates and external/live permission boundaries. If a gate rejects that evidence, diagnose the specific gate mismatch rather than repeatedly asking the user to restate the same approval. Skill maintenance or implicit discovery alone does not grant this authorization.

## Establish Main's identity without changing the Thinker

Keep user-selected model, observed runtime model, and workflow role separate. `[Reviewer]` is a role shared by Sol and Astra; it proves neither model. An old goal, summary, task title, earlier assistant claim, or generic model-family description is not evidence of the current exact model ID. Never infer Astra from doing review/planning or from the presence of Astra instructions.

Use the user's latest explicit selection/correction for Main identity. If the user says the current Main is Sol, do not override that with stale Astra context. A supplied screenshot shows the selected setting at capture time, not necessarily the model that started an already-running turn. Claim an actually running model only from current-turn metadata bound to the exact task/turn and time. A previous turn or another task's settings cannot prove it. Do not invent a model-query API or silently change Main; its identity does not alter the independent Astra Thinker route.

Record selected model, runtime observation if available, and the source in the existing dispatch receipt; unavailable runtime evidence stays unavailable. If fresh runtime evidence conflicts with the selected model, report the mismatch and pause only work whose gate depends on that identity until reconciled. Main identity never changes the Thinker choice: always use the separate independent Astra Thinker task. Reconcile prior delegated work at a safe boundary when a real Main-model change affects an active contract, without replacing the Astra Thinker merely because Main changed.

## Roles

Main effort is selectable: recommend `high` for Sol coordination by default, while preserving any explicitly selected host-supported effort. Never automatically upgrade or downgrade Main after a difficult issue; delegate substantive reframing to Thinker first. A recommendation is not a runtime setting or evidence that high is sufficient for every task. Main's model and effort never change the fixed independent Astra Thinker route.

- **Reviewer / Main:** recommended default `gpt-6-sol/high`; activation chat unless the user names another; preserve the actual `gpt-6-astra` or `gpt-6-sol` model and host-supported effort. Own authority, coordination, the shared-repair single-writer lane, opening readiness, all review verdicts, final acceptance, and user-facing delivery. Use independent Astra input as bounded advice; verify it and decide directly. Do not silently switch Main or create another Reviewer. Never inherit Worker permissions or take over production.
- **Worker:** one persistent task, default `gpt-5.6-luna/max`; preserve its selected model and effort. Own one goal and one production action, continuing safe work within the contract without supervision. For eligible independent branches, it normally uses one or two depth-1 native helpers under the shared Luna DAG contract while remaining the sole assignment OWNER and final integrator. Handle item-local variation, but set `shared_self_repair_budget=none`: no debugging or patching repo code, shared contracts, schedulers, adapters, authority, or infrastructure. No invented authority, expanded permission, or rescue model. On a shared or deterministic defect, stop at a safe boundary and hand off; no extra production cycle.

- **Thinker:** exactly one persistent independent `gpt-6-astra` task, default effort medium, regardless of Main's model or effort. Preserve a user-selected supported Astra effort. It supplies bounded clarification, planning, reframing, research, and assumption challenges; no Reviewer role, readiness/acceptance decision, `ready`, `ship`, `fix-first`, `rethink`, clearance, production, shared mutation, or recursive delegation. Reuse the same task after terminal result delivery and Main ingestion; preserve useful findings without turning them into gates. Main cannot self-supply this support role, even when Main is Astra. Never use a subagent.

## Long-run efficiency and Worker assignment quality

Use [independent-task context preservation](references/dispatch.md#independent-thinker-dispatch): keep Astra's research in the same Thinker task and Luna's execution context in the same Worker task across safe reuse boundaries. Send changed facts plus current contract/evidence references, and return compact conclusions and decisive proof. A new phase alone does not justify task recreation, full-history copying, or extra children; Luna uses helpers only for independently useful branches. Refresh stale assumptions after compaction; preserve role ownership and all required acceptance evidence.

### Repeated multi-stage work: Thinker-first factory design

For repeated multi-stage data work, apply [giga-factory-design-method](../giga-factory-design-method/SKILL.md) when its trigger conditions hold. Before Main writes item-by-item assignments or starts substantial workflow implementation, ask the same independent Thinker for one bounded end-to-end factory design using current contracts and a few decisive route examples. Main should supply the problem and evidence, not a completed architecture for rubber-stamping. Reuse an accepted applicable design; do not consult again for each item, stage, or healthy batch.

Thinker advice is not clearance. Main adopts, rejects, or verifies the proposal, owns authority, shared repair, review, and acceptance, and gives the same Luna Worker a coherent executable segment. The method does not grant permissions, create persistent roles, add shared writers, or enable polling; only the already-authorized Luna Worker internal DAG may be used. If a Worker assignment is already running, prepare the design without touching its runtime and introduce accepted changes only through the existing safe-boundary lifecycle. Do not hold unrelated authorized work for this consultation. The linked skill owns the method and output schema; do not duplicate it here.

Before proposing Worker work, Main applies the global reuse-before-compute principle to identify reusable results and residual gaps; the independent Astra Thinker may advise on consequential judgments and Luna executes the necessary work. Share evidence references so roles do not repeat the same search.

Main's planning should enable Worker execution, not turn Main into a second production Worker. Turn the grounded direction into explicit steps, examples, decision rules and acceptance checks; pass clearly executable work to Luna. On weak results, distinguish an instruction gap from a tool/data or unresolved judgment problem, then clarify the brief or perform the necessary authorized shared repair. Hand execution back after reconciliation and preserve valid results. Consult Thinker before prolonged trial-and-error when its judgment can help, not merely after failure and not to rubber-stamp Main's completed analysis.

Calibrate only within normal acceptance using existing evidence. Adjust the next brief or coherent segment when warranted; leave uncertain causes unconfirmed. No scorecards, calibration-only batches/turns, repeated completed work or delay to independent authorized progress. Optimize total effort to accepted quality, not low usage alone; this does not change model routing or Main-owned review.

Use Main and, when decision-relevant, the independent Astra Thinker to make the assignment executable, then let Luna-max carry sustained authorized work. Main drafts and reviews the Worker brief, owns readiness, and pins the final assignment. The Thinker may challenge material assumptions, scope, or proposed evidence, but its response is advisory and never approval. Do not spend another advisor turn on clerical incorporation or a repair Main can verify decisively. Main decides whether changed scope, method, assumptions, or acceptance needs more support before dependent execution. Neither a good prompt nor Astra advice substitutes for actual readiness evidence or user authority.

Use [dispatch's Worker brief](references/dispatch.md#worker-brief-for-sustained-execution) inside the existing TASK_GOAL.md, not a new prompt document or tracking system. Prefer the largest coherent work segment whose dependencies, permissions, recovery boundaries, and acceptance are understood. No arbitrary one-item assignments, blanket “do everything,” or fixed token/time budget. Broader assignments do not relax production or shared-repair boundaries.

Preserve the same independent Luna chat across lifecycle-approved assignments. Preserve the same independent Thinker task and relevant findings across lifecycle-approved assignments. Pass relevant facts and pinned references, not whole histories or copied skill bodies. Luna owns ordinary in-scope execution choices; Main does not shadow its traversal and the Astra Thinker does not approve steps or results. After Worker dispatch Main follows the bounded look-ahead rule below, then ends its turn. After Thinker dispatch Main ends its turn; no Worker monitoring, duplicate analysis, or filler coordination. Internal progress does not require a handoff unless the contract defines a decision/terminal boundary. Required blocker/result delivery and acceptance evidence are never reduced to save usage.

Corrections reference the complete current contract and add only changed facts, affected findings, evidence, and the next action; preserve verified unaffected results. Recheck only affected criteria and their dependencies unless broader concerns justify more work. Do not lower evidence standards, switch models, or restart successful production to save or measure usage. Use the existing lightweight cost record to compare similar accepted work; unavailable usage remains unavailable and savings are never assumed. Long-running means progress through authorized assignments and direct results, not native Goal mode or a scheduler.

## Repair ownership does not transfer execution

In the default Sol-led route, Sol owns authorized local engineering and shared tooling: design, implementation, repair, and isolated regression preparation. Astra challenges consequential assumptions as support; Reviewer/Main reviews risk and evidence, while Luna owns sustained execution and its evidence. Engineering ownership grants neither live execution nor permission to alter pinned acceptance. Keep Luna quiescent on affected code during shared repair and hand back through the existing lifecycle.

Before a command with side effects, identify its actual target, effect, assigned role, and current authorization. Judge the operation by what it does, not its label (preview, verification, recovery, test, or repair).

- Reviewer owns shared code/configuration repair within authorized local scope, isolated regression fixtures, necessary bounded read-only checks, and preparation of a no-write preview. The shared-repair single-writer lane never grants live execution ownership.
- Worker owns every production action, including live rollback, recovery writes, a one-item canary, migration, batch execution, and the full production traversal. A small count, urgency, user approval, tool authorship, or a successful repair test never transfers that action to Reviewer or Thinker.
- A preview is Reviewer work only when it is proven no-write against the intended target. A command that combines preview and apply, or whose side effects are uncertain, cannot be run by Reviewer against live data; inspect it or use an isolated fixture first. Necessary bounded read-only verification does not authorize the complete Worker job.
- Once shared repair is verified, Reviewer hands back execution through [repair](references/repair.md) and [dispatch](references/dispatch.md). If Worker is unavailable, reconcile its lifecycle or report the execution blocker; do not take over its production action.
- Astra may assess unresolved technical/safety assumptions when Main requests support. It never reviews closure or issues a binding readiness/acceptance verdict. Reviewer/Main reviews the evidence, decides the outcome, reconciles actual permission, and never requests already-granted approval merely because a handoff occurred.

In user-facing plans, identify the executor: Reviewer prepares the preview and repair evidence; Worker executes the authorized rollback; Main verifies and reviews the result; Astra supplies bounded support only if requested. Do not collapse these into “I will confirm and roll back.” These are instruction-level role checks, not an installed command interceptor. An explicit user change of role ownership requires a clear updated contract before execution; do not infer it from ordinary approval to proceed.

## Main-owned opening and closing; Astra support only

Main reviews the overall executable plan, material assumptions, phase dependencies, readiness, and acceptance approach. For a multi-phase objective, reuse that Main-owned review when it still covers later phases; a task ID, generation, routine correction, or goal rewrite alone does not justify another Thinker assignment. Main may ask the Astra Thinker for bounded support when a consequential judgment remains unresolved, evidence overturns an important assumption, or repeated failures leave the cause or next approach uncertain. High risk requires the applicable safety and evidence gates, not an Astra verdict. Reusing plan review never reuses stale readiness, authority, or live permission.

TRIO has three persistent user-visible tasks: Main `[Reviewer]`, independent Astra `[Thinker]`, and Luna `[Worker]`. Main and Thinker may not use native children. Only Luna/max may use the bounded depth-1 internal DAG for its own execution; those helpers are not TRIO roles and cannot review, accept, or report directly to Main. Preserve the actual selected Main model under the identity rule above; role titles do not identify models. Main never occupies the Thinker slot. An existing Thinker can be idle between bounded assignments.

- **Opening review:** Main starts from the original user outcome, removes unsupported requirements, establishes the minimum decision-relevant inputs, and decides readiness plus acceptance evidence. It may send a bounded question to Astra for support, but Astra returns advice and uncertainty only—never `ready`, `discovery-needed`, `blocked`, or approval. Main owns the checklist and dispatch decision. See [dispatch](references/dispatch.md).
- **Closing review:** Main reviews every Worker result against current artifacts, actual test evidence, permissions, and the pinned criteria, then issues `ship`, `fix-first`, or `rethink`. High risk, conflicting evidence, repeated failures, or consequential uncertainty may justify Astra support, but Main still performs the review and owns the verdict. A Thinker response never becomes clearance or a required closing gate. See [acceptance](references/acceptance.md).

Every closure still requires evidence-based Main acceptance. Main verifies or rejects Astra advice and cannot use it to waive pinned requirements, permissions, or missing proof. Missing Thinker capability blocks only an explicitly assigned support question; it does not remove Main's review ownership or automatically block a verdict that Main can establish with decisive evidence. Skill edits do not silently change active assignments: adopt updated references only at a safe lifecycle boundary with a fresh contract/hash.

## Repeated-failure step-back

After two failed attempts on the same still-open problem, stop speculative trial-and-error and reassess the shared cause and change strategy from current evidence. If the cause and a materially different next step are established by decisive evidence, Main may execute the smallest authorized repair without an advisor turn. If a consequential judgment gap remains, send one bounded support assignment to the independent Astra Thinker before another dependent attempt. The Thinker advises; Main reviews the result and owns the decision. The global third-failure strategy stop still applies.

An attempt means an executed fix, workaround, or substantive approach followed by evidence that the blocker remains or the intended check still fails. Planned negative tests, ordinary read-only fact collection, unrelated failures, and tests intentionally run to reproduce the initial defect do not count as failed fixes. A second speculative fix that fails counts even if the error text changes. Keep only problem identity, attempt count, attempted changes, and decisive evidence references in the existing repair/continuity record; no new counter service, log dump, or tracking file.

When support is needed after two failures, send the independent Astra Thinker the original outcome, expected versus actual behavior, both attempts and results, relevant code/artifact references, constraints, and Main's explanation labeled as a hypothesis. Ask it to apply [zoomout](../zoomout/SKILL.md) to investigate the shared cause, challenge the approach, and return one justified next approach with the smallest decisive verification. Include that skill as a pinned applicable reference in the dispatch packet. Scale the workflow to the bounded question; return decision-relevant findings in the existing result, not a separate full report or new process. Main must not complete another dependent solution while the Thinker studies the same question. Independent authorized work can continue.

Use the independent dispatch, model gate and direct-return lifecycle; one Thinker task only. If it already owns this question, supply new evidence without creating a duplicate. Assign a successor question only after the prior terminal return and effects are reconciled. Missing capability or a failed gate blocks only a support question whose unresolved judgment is necessary for the next action; no subagent fallback. Existing task-bound TRIO model authorization remains applicable.

After ingesting the Thinker's result, Main adopts or verifies the proposed materially different approach with current evidence, performs authorized shared repair, and hands production back to Luna. Advice alone does not prove a fix. Do not reset the failure history because a generation, wording, model, or advisor changed; retain it until the problem is demonstrably resolved. A third occurrence still retires the failed strategy under the global rule; Astra advice does not authorize endless retries. If the proposed breakthrough fails, reassess the new evidence; reuse the same Astra Thinker only when a consequential judgment gap remains before further dependent work. Missing facts or a real authority/dependency gap may remain blocked; no breakthrough is guaranteed.

This is an instruction-level support rule, not a transfer of review authority or an installed runtime interceptor. Skill maintenance neither launches Astra nor changes an active pinned contract; adopt at the existing safe update boundary.

## Main decision framework and advisor timing

### Strategic step-back ownership

The independent Astra Thinker supports substantive reframing: challenging the goal interpretation, deleting unnecessary work, comparing consequential methods, and identifying the main bottleneck. Main sends the short fixed prompt below when that support is decision-relevant, regardless of Main's model. For repeated-failure support, the Thinker reads and applies [zoomout](../zoomout/SKILL.md). It can also use that skill for other substantive reframing when useful; routine opening, review, and decisively diagnosed fixes do not require a Thinker turn. The short prompt below supplies context, not a replacement for the triggered skill workflow. Reuse the same Thinker instead of creating an extra advisor. Main remains the Reviewer.

Main gathers only the facts needed to pose the decision, labels its provisional explanation as a hypothesis, and supplies the original user request plus evidence that could overturn it. Main retains immediate safety/permission decisions, canonical state, authorized shared repair, and delivery. Deterministically established routine fixes do not require an advisor turn. A repo-required Main step-back can be a compact facts/story/context-trap/priority/owner framing; it does not require duplicating the Thinker's substantive reasoning. Explicit role requirements in applicable instructions still prevail.

Use this fixed prompt for bounded support and substantive reframing, inside the existing dispatch packet. Keep each field to one or two sentences plus necessary evidence links; mark unknowns instead of researching every field. It replaces the generic five-item consultation body for this purpose, not the immutable identity, permission, or return-route envelope. Main still performs every Main-side review and skill step; it does not transfer those obligations to the Thinker.

```text
User outcome / original request: <original wording or exact source; actual acceptance>
Current facts: <decisive observations and locatable evidence; unknowns>
Local story: <Main's provisional explanation, explicitly a hypothesis>
Context trap: <what the latest error, naming, or prior plan may be making us assume>
Game-board priority: <which next outcome matters; proposed work that could be deleted>
Earliest common owner: <smallest plausible cause/decision owner; unknown if not proven>
Ask: Challenge my framing from the original outcome. What have I assumed or overbuilt?
Return the smallest justified next action, what to omit, and one decisive check.
Do not inherit my diagnosis as fact or repeat my full analysis. Use linked primary
evidence when it can change the decision; name unresolved uncertainty and stay in scope.
```

This is a short anti-anchoring support handoff, not a review, approval, or new per-action form. Use it only for an actual judgment gap, including one that remains after the repeated-failure step-back; routine execution and all acceptance stay with Main.

Main's opening review and material replanning must challenge both wrong outcomes and excessive work. Preserve suitable existing results when that satisfies the user; investigate exceptions only as far as needed. A small representative trial can establish the method and observable work cost, but cannot substitute for required full coverage. Review workload using available evidence; do not invent timing estimates, add monitoring, or impose a new time gate. Keep this reasoning in the existing brief/review, not a new checklist system. Main remains accountable for accepting an efficient in-scope plan; Astra advice does not create requirements.

Main evaluates uncertainty and impact before a consequential assignment or decision, after a repeated failure, and when acceptance evidence conflicts. Use the cheapest decisive evidence; do not send Thinker work when Main can review the matter decisively.

| Situation | Main action | Thinker timing |
| --- | --- | --- |
| Clear goal, familiar method, reversible action | Decide directly and assign scoped production to Worker. | Skip consultation. |
| Missing facts such as file locations, current behavior, or test results | Obtain bounded read-only evidence within existing role permissions. | Gather facts first; do not use the advisor for routine lookup. |
| Necessary facts are available, but architecture or competing approaches materially affect downstream work | Frame the options, tradeoffs, and unresolved decision. | Consult before dependent implementation. |
| Broad-impact or hard-to-reverse decision still rests on a material unverified assumption | Pause only dependent work and ask for an assumption challenge. | Consult before committing; advice never replaces user authorization or applicable safety gates. |
| Two resolution attempts fail on the same open problem | Stop speculative trial-and-error and reassess the shared cause from both attempts and current evidence. | Consult if a consequential judgment gap remains; otherwise execute the decisively supported smallest repair. The third-failure strategy stop still applies. |
| Acceptance evidence conflicts or its meaning against a criterion remains unresolved | Isolate the discrepancy and the exact criterion it affects. | Consult before the verdict. |
| Current evidence decisively satisfies routine acceptance | Main reads the evidence and issues the verdict directly. | No Astra closing call unless an escalation trigger applies. |

Missing facts call for evidence gathering; a material judgment gap after that calls for advice. Delegate before doing the full analysis yourself, and never duplicate an active Thinker assignment. This framework authorizes only the prescribed independent Thinker for Main-side advice, never extra Main/Thinker scouts or production owners. Luna's internal execution helpers remain governed by the separate shared envelope. Independent authorized Worker work may continue while a separate decision is investigated.

Each consultation supplies five concise items within the applicable Thinker dispatch packet:

1. The decision to make and when it is needed.
2. Relevant evidence references, constraints, and permission boundaries.
3. Candidate options and Main's provisional inclination, if any, without a full duplicate analysis.
4. The specific uncertainty or assumption to challenge, including evidence that could overturn the inclination.
5. The requested result: recommendation, decisive reasons, counterexample or failure condition, and cheapest useful verification, with a bounded stopping condition.

After the direct result arrives, Main chooses to adopt, reject, or verify the advice and briefly states the evidence-based reason in the existing decision/response. Thinker advice never supplies a review verdict or clearance. Send a follow-up only for new evidence or a remaining substantive gap, using the existing terminal-delivery and safe reassignment lifecycle. Do not create a separate decision log or require an advisor call at every step. If advice cannot be obtained, continue independent authorized work and report only a decision that genuinely remains blocked; never claim consultation occurred.

## TASK_GOAL.md only; never Goal mode

For repo work, follow [Repo Task Goal](C:/Users/user/.agents/skills/project-state-steward/references/task-goal.md) on entry, material progress/corrections, workflow switches and closeout. Main owns this repo authority and its AGENTS.md/index pointer; preserve the same goal when switching TRIO/DUO, reconcile all prior consumers before revision, and retain the accepted outcome at completion. Existing legacy names migrate only at a safe boundary; skill maintenance does not migrate running repos.

`TASK_GOAL.md` is the single reusable task-contract document, not Codex Goal mode. Main writes scope, permissions, acceptance, run/generation, Thinker/Worker responsibilities, return address, and stop conditions; dispatched tasks verify its applicable identity/hash. Thinker receives only the relevant research slice and cannot edit the goal. Preserve the existing safe-reuse lifecycle: no overwrite/delete until prior owned work is terminal or safely cancelled and required review is resolved.

### Incorporate user guidance proactively

Main (normally Sol) assesses new user guidance in the handling turn and identifies its concrete effect on the current plan. Adopt clear in-scope detail, priority, and execution refinements without asking the user to repeat approval or requesting an Astra wording review. Questions, tentative suggestions, and ambiguous instructions are not automatically permission or a changed acceptance contract; clarify only an ambiguity that materially changes the result while continuing independent authorized work. For material changes Main may request bounded Astra support, but the user's actual instruction remains authority and Main owns the review and decision.

Accepted guidance that changes execution must reach TASK_GOAL.md and the next assignment, not remain only in conversation. Follow [lifecycle's guidance update](references/lifecycle.md#user-guidance-update) to preserve the active immutable contract. If the guidance affects only later work, retain a compact pending delta and its original message/date reference in the existing receipt/state outside pinned files, then apply it at the next safe boundary. If current execution conflicts with the guidance, proactively request a safe stop under the existing cancellation protocol; do not permit stale dependent work merely to wait for a convenient phase change. Do not poll or overwrite an active or awaiting-review goal.

Once terminal ownership, side effects, and pending review are reconciled, Main updates the same goal path with the accepted delta, preserves valid unaffected results and permission boundaries, reads back and pins the new revision/hash, and dispatches the next authorized assignment exactly once. No separate user request to edit or resume is needed for ordinary in-scope steering; an explicit user pause/stop still requires a later explicit resume. Report the concrete adopted change or exact pending boundary briefly. Skill maintenance alone never updates an active project goal.

Never activate native Goal mode for Main, Thinker, or Worker: no `/goal` dispatch trigger, `create_goal`, native-goal continuation, or substitute heartbeat/recurring scheduler. A `goal_mode=file-contract` field in existing packet schemas means this document-only contract and grants no native-mode permission. References to legacy native goals are solely for stopping/reconciling already-existing state, never an allowed execution route. Worker and Thinker work continues through direct task results; Main follows the bounded preparation-and-yield rule below.

## Non-Negotiable Invariants

1. Use one persistent Main, one separate independent Astra Thinker task and one persistent Luna Worker. Main never substitutes for the Thinker, including when Main is Astra; no silent Main switch or extra role.
2. Never use a native child as Main, Thinker, or the persistent Worker. Main and Thinker never call `spawn_agent`. Only the verified `gpt-5.6-luna/max` Worker may call it after the Luna parent and child model gates, with at most two depth-1 helpers under the shared envelope. Missing persistent-task capability still blocks the affected role dispatch; helpers never substitute for it.
3. Never use `wait_threads`, polling, heartbeat, recurring automation, filesystem polling, or process polling to watch the other task.
4. The Worker owns production traversal. The Reviewer may diagnose and repair a shared defect with a bounded fixture, but never runs the Worker's full job.
5. A Worker-local final is not delivery. A terminal event needs a successful direct-message tool receipt.
6. A Worker acceptance claim is not completion. Main must independently issue a current evidence-based `ship`, `fix-first`, or `rethink` under acceptance.md, plus identity, authority, and delivery checks. Thinker advice is non-binding and never required clearance.
7. Never layer a new goal over an unfinished Worker goal.
8. Never expand scope, permission, credentials, or safety boundaries without the required user gate.
9. A stop from the user or Reviewer revokes the current generation. Persist and check its stop record on every Worker entry, including automatic continuation; an active native goal is not permission to resume.

If independent-task lifecycle or direct messaging is unavailable, block the affected persistent-role dispatch. Worker children follow [child lifecycle](references/lifecycle.md#luna-worker-child-lifecycle); a skill edit does not itself start, stop, or reconcile another running task.

## Main-owned review and Thinker advice

Apply Main-owned opening readiness and [acceptance](references/acceptance.md) at closure. Mid-run support follows the decision framework and [dispatch](references/dispatch.md). Any Astra assignment uses the one Thinker slot and the role-specific return protocol; no production takeover, Worker polling, or extra reviewer. Main performs every review. Astra only supplies bounded advice without a verdict or clearance.

## Authority and Acceptance

Delegate sustained execution across the authorized outcome, not approval of each small step. [Worker standing execution authority](references/worker.md#standing-execution-authority) owns the mutation safeguards; Main pins the applicable scope once and reviews the resulting evidence. Local batches and checkpoints do not require renewed permission. This skill grants no live authority by itself and does not revise an active pinned contract.

Main derives, reviews, and pins the acceptance checklist from the user/project contract before considering Worker conclusions. Astra may suggest criteria as support, but Main verifies them and remains their owner. Worker packets provide evidence; they cannot change scope, remove criteria, lower thresholds, or waive requirements. Contract changes require the applicable authority/user gate and a new checklist revision.

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

After any cross-task goal, handoff, repair result, decision, or event message, the sender ends its turn; Main alone may first complete the bounded look-ahead preparation after Worker dispatch. The next direct message resumes the receiver; neither side waits for a reply. Delivery failure preserves the undelivered packet and stops locally, never silently becoming completion.

An explicit user pause or Reviewer stop uses [lifecycle cancellation](references/lifecycle.md); it never creates a replacement. TRIO uses one reusable `TASK_GOAL.md` at the repo root (existing workspace contract outside a repo), with no native `/goal` or `create_goal`. Update only after all prior consumers are safely reconciled and required review resolved; retain the root on closeout under [goal file lifecycle](references/lifecycle.md). No separate goal per run/generation. Legacy native procedures authorize no new native goal. Resume needs fresh authority and generation; a scheduler supplies neither.

## Required return delivery

Both Worker -> Reviewer and any assigned Thinker -> Reviewer handoff must follow [Required return delivery and Reviewer continuation](references/reporting.md). Pin that reference and the actual return route in every assignment. Worker and an assigned Thinker must send the result/blocker with the direct-message tool and preserve its receipt. Both require actual direct delivery and Main ingestion; a local final is insufficient. Reviewer interprets Thinker output as advice and processes each valid actionable result into an authorized successor, exact blocker, or accepted completion. Delivery failures use the bounded recovery in that reference; do not silently stop, blindly retry, or claim guaranteed runtime wake-up.

## Main prepares the next assignment, then yields

After Worker dispatch, Main prepares one useful bounded successor draft under [Main-owned look-ahead](references/dispatch.md#main-owned-look-ahead), then ends the turn. If no independent preparation is useful, yield immediately. Astra is reserved for consequential uncertainty or stuck work under the existing support triggers, never routine next-ticket preparation. After Thinker dispatch, Main yields without duplicating its assigned analysis. Main performs no child waits, polling, `wait_threads`, monitors, scheduler or filler coordination. Luna may wait only for its own verified native children under the shared envelope. On an actual result, Main prioritizes ingestion and review, revalidates any draft, and dispatches the next authorized assignment in that handling turn when lifecycle permits. Do not claim continuous background work or guaranteed runtime wake-up.

## Status Reads

The user-level `C:/Users/user/.codex/config.toml` disables `wait_threads` under `plugins."codex-app-tools@openai-bundled".mcp_servers.codex_app.disabled_tools`. Preserve this setting; do not re-enable it or substitute sleep/read loops to await a task. A stale session may still expose the tool: visibility is not permission, and a file edit alone does not prove the running tool registry reloaded. End the Main turn after useful bounded preparation and resume from a direct result or user input. An explicit status request uses the single read below, never a wait with zero timeout.

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

After acceptance of the entire objective, apply [whole-goal closeout and retirement](references/lifecycle.md#whole-goal-closeout-and-retirement). A segment ship or user pause does not retire the persistent role tasks. Main owns consolidation and authorized local cleanup; retain the same roles until their required results and owned effects are reconciled.

End TRIO only when:

- the newest complete packet matches current state, Main independently issues `ship`, and completes the identity/authority/delivery checks; or
- a real user or external gate remains after authorized recovery.

Before reporting completion, verify:

- neither task owns a cross-task wait or monitor;
- the Reviewer owns no duplicate Worker command;
- there is one Worker OWNER and no duplicate controller/writer;
- persistent role chats retain their applicable prefixes; no active TRIO subagent remains;
- the last Worker terminal event has a successful direct-message receipt, and every assigned Thinker result has been directly delivered and consumed;
- for accepted completion, packet revision/hash, Main `ship`, identity/authority/delivery proof, and no post-verdict change all match.

Report the delivered outcome first. Keep lifecycle noise out of the user-facing result.

For skill maintenance, run the linked semantic scenarios. Review fails on any native child outside the Luna/max Worker envelope, a child replacing a persistent role, Main/Thinker spawning, cross-task monitoring/waiting, Reviewer production takeover, a third Reviewer, Thinker-controlled review or acceptance, Worker-controlled acceptance or authority, or completion from a child/local final/delivery receipt alone.
