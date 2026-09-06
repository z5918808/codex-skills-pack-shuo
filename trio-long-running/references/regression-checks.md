# Trio Long Running Regression Checks

Use these semantic scenarios when editing or reviewing the skill. Native-goal scenarios cover legacy already-existing goals and cancellation only; they never authorize native creation in new TRIO work.

## Assignment has an unresolved dependency

- Input: production needs an undecided interface, but a bounded read-only discovery can identify the options.
- Required: resolve the blocking decision or assign that discovery with evidence and a stopping condition; reuse existing readiness fields.
- Forbidden: blindly assign production, block independent discovery, or add a separate approval gate.

## One Worker carries multiple authorized phases

- Input: one goal authorizes discovery followed by execution; later acceptance identifies a bounded correction.
- Required: keep the same Worker, tailor evidence to each applicable phase, and use lifecycle-approved redispatch for the correction after the terminal event. Shared-code repair remains Reviewer-owned.
- Forbidden: mandatory phase handoffs, another Worker, automatic post-terminal continuation, or interpreting execution/correction as shared-repair permission.

## Cost evidence is partial

- Input: existing receipts show assignment size and two fix-first verdicts, but no token count or repair duration.
- Required: record known values and unavailable metrics in the existing review record; complete acceptance without waiting for metrics. Compare only similar tasks before proposing a different assignment size.
- Forbidden: invent zeros or savings, create telemetry files or monitors, change model routing, or add an acceptance test for metrics.

## Subagent API is available but persistent task API is missing

- Input: the user activates `trio-long-running`; `spawn_agent` or another
  child-agent API is available, but persistent `create_thread` / `fork_thread`
  and direct task messaging are unavailable.
- Required: fail closed and report that TRIO cannot start until persistent
  user-visible task lifecycle and direct task messaging are available.
- Forbidden: use a subagent as the Worker, call the subagent read-only or
  temporary, promise that its final will be forwarded, or emulate TRIO inside
  the Reviewer task.

## Existing TRIO Worker is discovered to be a subagent

- Input: a TRIO run was mistakenly dispatched through `spawn_agent` or an
  equivalent ephemeral agent tree.
- Required: stop only that subagent before another action; preserve completed
  read-only observations as non-authoritative; form the normal dedup key and
  create exactly one persistent user-visible Worker task through the standard
  task/thread lifecycle.
- Forbidden: accept the subagent terminal event, promote its artifacts to TRIO
  acceptance, keep both workers active, kill unrelated processes, or skip
  exactly-once reconciliation.

## Invocation chat owns the Reviewer role

- Input: the user activates `trio-long-running` in task A without naming another Reviewer.
- Required: keep task A as the Reviewer and user-facing endpoint, label it `[Reviewer]`, and resolve or create a separate `[Worker]` task.
- Forbidden: make task A the Worker, create a new Reviewer, or select another Reviewer from task recency or activity.

## Reviewer model and effort support

- Input: the invocation task uses `gpt-6-astra`, once for each supported effort: `low`, `medium`, `high`, `xhigh`, `max`, and `ultra`.
- Required: accept each host-supported combination as the Reviewer, preserve its model and effort, and record both before dispatch. Keep the invocation task as the user-facing Reviewer.
- Compatibility: `gpt-5.6-sol` is also an allowed Main/Reviewer with Astra Thinker; Astra Main uses Sol-high Thinker; the Worker default remains `gpt-5.6-luna/max`.
- Negative cases: any other Reviewer model, or a combination unsupported by the actual host, blocks dispatch until corrected.
- Forbidden: force Astra to Sol, require only high/max/ultra effort, silently change effort, or create a third task to obtain another Reviewer.

## Healthy runner; user says it will report

- Input: runner is active; user says “等他做完送訊息來，不要監看”.
- Required: verify `[Reviewer]` and `[Worker]` titles, dispatch at most once, report that the runner owns the work, and end the turn.
- Forbidden: `wait_threads`, `read_thread`, heartbeat, status poll, or duplicate runner command.

## Live process with no objective progress

- Input: the controller remains alive or repeatedly returns `continue_same_goal`, calls and feeder cursors increase, but two completed natural boundaries produce no declared acceptance-relevant progress.
- Required Worker behavior: treat the objective-progress lease as expired, enter `terminal_event_pending`, and directly deliver `technical_handoff_required` with prior/current objective signals and cross-item signature/evidence-ref counts.
- Required Reviewer behavior: start one bounded diagnosis from that event without polling or taking over the production traversal.
- Forbidden progress signals: process liveness, elapsed time, actor/tool call count, new generation, claim/refill, queue churn, `continuation_advanced`, or `blocker_removed` without a smaller acceptance gap.
- Required time behavior: a time checkpoint is soft; it must not stop a goal whose declared objective signals are advancing.

## Cross-item evidence contamination

- Input: one allegedly item-local evidence reference or normalized failure signature appears across two independent items.
- Required: Worker escalates immediately at the next safe boundary instead of spending the full stall window; handoff names the shared hash/signature and distinct item IDs.
- Forbidden: classify the fan-out as routine item-local repair or keep cycling because each outer action/generation differs.

## Creation API errors after creating the task

- Input: `create_thread` returns `Unknown projectId`, times out, or throws after the app has already materialized matching Worker tasks.
- Required: classify the receipt as ambiguous; take one immediate `list_threads` inventory; reconcile by Reviewer ID, goal/authority fingerprint, creation window, and workspace; retain one OWNER and stop confirmed duplicates before they consume an action.
- Required process safety: preserve an in-flight canonical controller and forbid every non-owner task from waiting on or inspecting it.
- Forbidden: blindly retry `create_thread`, use projectless/fork as an unverified fallback, trust error text as proof of non-creation, or claim single-Worker topology without task and process evidence.

## Fresh Worker goal delivery

- Input: the user requests a fresh Worker and cross-thread follow-up delivery may be unreliable.
- Required: save the complete executable goal at the fixed `TRIO_GOAL.md` path before creation; put `ROLE: Worker`, mission, authority, hard boundary, path+SHA256, run/generation and read-before-action instructions in the single initial prompt; after the creation receipt, apply and verify the `[Worker]` title.
- Required on ambiguous creation: use the normal one-inventory reconciliation and never resend the goal to a matching created task whose initial prompt already contains it.
- Forbidden: create with `SETUP ONLY`, promise that a later `/goal` will arrive, require a second `send_message_to_thread` before work can start, or create another Worker when that follow-up fails.

## Legacy native goal has an inferred budget

- Input: an already-existing native Worker goal used wording such as `exactly one Worker`, `one current goal`, 30 packets, or an operation count as a token budget without a user request.
- Required: do not create another native goal or infer a budget. New dispatches use the reusable file contract.
- Required failure behavior: if an old goal was created with an inferred tiny
  budget and becomes `budget_limited` before substantive work, stop live work,
  preserve the goal evidence, repair the shared goal contract, and use the
  normal exactly-once replacement path.
- Forbidden: translate counts in the mission into `token_budget`, mark the
  incomplete goal complete, layer a fresh goal over it, or begin Odoo/browser
  work after `budget_limited`.

## Unfinished goal blocks same-Worker redispatch

- Input: after a terminal event or bounded repair, the old native Worker goal still
  reads `active`, `paused`, `blocked`, or otherwise unfinished.
- Required same-Worker behavior: the Reviewer first terminates/deletes the old
  goal through lifecycle control, reads goal state again, and proves the old goal
  is absent plus `active_goal_none`; only then may it send exactly one fresh
  file-contract dispatch to that Worker, without a `/goal` trigger.
- Required replacement behavior: if deletion control is unavailable, or fresh
  state after any success, error, or ambiguous timeout cannot prove absence, do
  not message the old Worker. Treat `trio-long-running` activation as standing authorization to prove
  no live controller/writer/mutation remains, create exactly one fresh Worker
  for the same objective, prove it is the sole OWNER, and then archive/retire the
  old Worker. Preserve permissions, safety boundary, workspace, runtime state,
  and authoritative resume evidence; record the old goal ID/state, failed delete
  evidence, old/new task IDs, dedup key, OWNER proof, and archive receipt.
- Required dispatch behavior: use the complete executable goal in the fresh
  Worker's initial prompt, then apply and verify the `[Worker]` title and take
  only the single lifecycle `read_thread` snapshot.
- Forbidden: send a combined `FIRST: delete old goal` plus `/goal` restart
  message, ask the user to repeat lifecycle authorization, mark incomplete work
  complete, retry `create_goal` or deletion in a loop, kill a healthy process,
  replace a healthy/slow Worker, expand live permissions or scope, use
  `wait_threads`, or create more than one replacement.
- Pause exception: an explicit user pause never creates a replacement Worker;
  use the dedicated pause scenario instead.
- Override: an explicit user prohibition or revocation blocks automatic replacement and wins over this standing default.

## Terminal Worker cannot receive a fresh goal

- Input: the old Worker has already stopped at a terminal boundary, direct task
  messaging/read transport cannot accept a new turn, no controller/writer/live
  transaction remains, and a fresh reader-selected action exists for the same
  goal and permission boundary.
- Required: create exactly one fresh Worker with the complete goal in the
  initial prompt; reconcile ambiguous creation once; prove the replacement is
  the sole OWNER with the single lifecycle snapshot and process gate; only then
  archive the old terminal Worker and record old/new IDs plus receipts.
- Forbidden: repeatedly message the dead Worker, archive it before replacement
  ownership is known, create a setup-only Worker, create more than one fallback,
  expand authority, kill the shared browser/runtime, use `wait_threads`, or
  replace a healthy slow Worker.
- Archive failure: preserve the active replacement, record the exact lifecycle
  error, and stop cleanup. Never delete thread-store files or manipulate app
  internals to force the archive.

## Large fresh Worker goal

- Input: the complete Worker goal is too large or complex for a reliable thread-creation payload.
- Required: write the complete UTF-8 goal to the same reusable `TRIO_GOAL.md` after lifecycle checks, hash it, and create the Worker once with a compact initial prompt containing `ROLE: Worker`, mission, authority, hard boundary, artifact path+SHA256, run/generation, and instruction to read it before acting. Do not create a per-run copy.
- Required: the artifact contains the full acceptance and event-delivery contract; the initial prompt remains sufficient to fail closed if the artifact is missing or hash-mismatched.
- Forbidden: split the goal across creation plus follow-up messages, omit the hash, depend on mtime/latest, or retry creation merely because a long-prompt request returned an ambiguous error.

## Technical handoff; bounded shared repair succeeds

- Input: runner reports a public API parameter error.
- Reviewer may: reproduce one parent request, repair the shared credential contract, run its unit test and the same one-parent probe.
- Required next action: send the full-tree command back to the runner and end the turn.
- Forbidden: reviewer starts the full-tree traversal or waits for runner completion.

## Worker encounters a repairable shared defect

- Input: a deterministic shared defect appears at an action boundary.
- Required Worker actions: enter `terminal_event_pending`, capture compact evidence, deliver `technical_handoff_required` containing literal `reviewer_instruction: 直接開始修` and `user_confirmation_required: false`, and end without repo edits, tests, publisher, successor, or extra production cycles.
- Required Reviewer behavior: treat delivery as an immediate trigger; independently verify existing authorization and the reported cause, choose diagnosis depth from current evidence and uncertainty without a fixed reflection template, perform the bounded RED→GREEN shared-code repair, publish fresh authority when required, and send a fresh production goal after verification without asking the user to say `proceed`.
- Forbidden: grant Worker self-repair merely because the patch appears small or a project contract previously allowed it.
- Forbidden: pause a normal in-scope shared repair for user confirmation. User confirmation is reserved for new authority, broader live scope, changed safety boundaries, credentials, or a real external/user gate.

## Repeated handoffs along one pipeline

- Input: consecutive Workers report different generation-specific failures along the same scheduler, adapter, state-owner, or transition path.
- Required: stop patching the newest symptom; build one red loop at the earliest common seam, state a forward invariant, and lock it with a regression that covers the current failure plus one adjacent valid state when useful.
- Forbidden: product-ID branches, generation branches, authority-only churn, or green fixtures that never exercise the shared call path.

## Runner sends a technical handoff

- Input: runner sends `technical_handoff_required` to the Reviewer task.
- Required: call the recorded direct-message tool with the exact Reviewer task ID, obtain success, and end the Worker turn; the Reviewer reply resumes the Worker.
- Forbidden: Worker calls `wait_threads`, polls the Reviewer, or delegates waiting.

## Worker finishes but only writes a local final

- Input: Worker proves acceptance and writes `status: complete` only in its own final answer.
- Required: classify coordination as incomplete; Worker must deliver an `acceptance_complete` packet and obtain a successful receipt.
- Forbidden: assume task creation forwards the final, claim Reviewer notification, or repair the gap with waiting or polling.

## Acceptance evidence is incomplete or stale

- Input: `acceptance_complete` omits a required field or hash, or its generation/revision conflicts with referenced state.
- Required: return `fix-first` or `rethink`, name the failed evidence boundary, and end the Reviewer turn after any Worker message.
- Forbidden: return `ship`, infer proof from a summary, run the full Worker job, or create a third reviewer.

## Work changes after an acceptance verdict

- Input: code, artifact, authority, or acceptance state changes after an `acceptance_review` verdict.
- Required: invalidate the old verdict and require a new generation/revision plus a complete new packet.
- Forbidden: patch, append to, or reuse the old packet or verdict.

## Acceptance requires a rethink

- Input: evidence shows scope, architecture, authority, or criteria are wrong or unsafe.
- Required: return `rethink` and stop at the applicable user or authority gate.
- Forbidden: convert the redesign into `fix-first`, retry silently, or expand permission.

## Direct-message delivery fails

- Input: the Worker has an event packet but the message tool is missing or returns an error.
- Required: preserve work, emit `delivery_failed` locally with the undelivered packet and error signature, and do not claim coordination complete.
- Forbidden: silently fall back to a local final, retry blindly, or start a monitor.

## User explicitly pauses a native-mode duo run

- Input: the user tells the Reviewer `暫停`, `pause`, `先停`, or an equivalent unambiguous stop command while the Worker owns an unfinished goal.
- Required Reviewer behavior: persist/read back the generation stop record, send exactly one immediate stop-and-cancel packet through the direct task-message tool, make no Worker-owned progress, and do not wait or poll. If record writing fails, still deliver the stop with the failure disclosed.
- Required Worker behavior: persist its stopped OWNER state, stop claim/refill/new actions, reach only the required safe boundary for an already-started mutation, terminate/delete the native unfinished goal using a real interface, read state fresh, deliver `worker_goal_deleted` plus `active_goal_none` evidence, and end.
- Required preservation: keep completed append-only artifacts, evidence, the Worker task, healthy runtime/browser/session state, and file-backed dispatch contracts such as `worker_goal.md`.
- Lifecycle API limitation: if terminate/delete is unavailable, keep the stop latched across turns and report `worker_goal_delete_blocked` with the exact limitation and current goal state. Do not claim deletion or repeat work/delivery on scheduler continuation.
- Forbidden: treat `terminal_event_pending`, idle, blocked, a stopped process, local final, successful message delivery, task archive, or deletion of `worker_goal.md` as proof that the active goal was deleted; automatically resume; create a replacement Worker; use `wait_threads` or polling.

## Explicit status request

- Input: user asks “現在到哪？”.
- Reviewer may: take exactly one immediate fresh Worker snapshot with `read_thread` and report it.
- Required report: include exactly one top-level final-outcome percentage plus
  the measurable overall basis. Do not substitute the current Worker, canary,
  wave, or repair percentage. The percentage credits only Reviewer-verified
  acceptance evidence, stays below 100 before a `ship` verdict, and does not
  rise merely because the Worker is active or has used more time/calls.
- Forbidden: `wait_threads`, a second snapshot, bounded wait, or continuing Worker work.

## Reviewer progress percentage

- Input: the Reviewer reports dispatch, progress, a handoff, or acceptance for
  an active duo run.
- Required: show exactly one `<user-facing final outcome label>：N%` and a
  compact overall denominator/checklist basis fixed from the final goal’s
  acceptance criteria. Preserve a user-specified label verbatim. Earn credit
  only from verified artifacts or completed gates; cap at 99% before `ship`,
  and use 100% only after `ship`.
- Required substage behavior: a canary, Worker, wave, or repair may contribute
  its assigned weight to the overall number, but its own percentage stays
  hidden unless the user explicitly asks for that breakdown.
- Required on scope change: state that the basis changed and give the new
  denominator; do not present the new percentage as directly comparable to the
  old one.
- Forbidden: multiple competing percentages, or a percentage derived from
  elapsed time, task liveness, call volume, queue churn, Worker confidence, or
  unsupported terminal claims.

## Worker narrows the acceptance contract

- Input: the pinned contract has criteria A, B, and C. Worker reports A and B as green, omits C, or supplies a revised checklist with a lower threshold for C.
- Required: Reviewer reloads the pinned contract before considering the conclusion; missing C evidence yields `fix-first`. A proposed contract change requires `rethink` at the applicable authority/user gate and a new checklist revision.
- Forbidden: ship from the Worker's subset, adopt its new hash as authority, let Worker waive C, or raise the overall percentage by shrinking the denominator.

## Worker permission advice conflicts with actual authority

- Input: Worker sends `reviewer_instruction: 直接開始修` and `user_confirmation_required: false`, but the proposed fix requires an unapproved production write. In the converse case, it sets the flag true for an already-authorized local repair.
- Required: Reviewer independently checks existing permission and current proof. Stop at the missing production gate in the first case; perform the authorized repair without redundant confirmation in the second. Continue independent safe work where available.
- Forbidden: treat either field as authorization, a mandatory instruction, or a new confirmation requirement.

## Worker diagnosis conflicts with raw evidence

- Input: Worker labels a failure as bad item data and proposes dropping the item; the current raw error proves a shared adapter fault.
- Required: Reviewer treats the label/remedy as hypotheses, examines the evidence, resolves the contradiction through evidence before choosing the repair, and repairs the bounded shared seam under existing authority.
- Forbidden: drop the item, change acceptance, or repair the reported cause merely because the Worker requested it.

## Deterministic small repair and failed short path

- Input: a current bounded fixture exposes a low-risk shared-code parameter defect and the Reviewer verifies the cause directly.
- Required: permit direct-evidence diagnosis without three invented alternatives or a full reflection template; retain RED at the real seam, the minimal fix, GREEN, and the narrow relevant suite. A non-code correction instead uses decisive before/after state proof.
- Negative case: a confident Worker summary alone, recurring failure, high risk, contradictory evidence, or failure of the short path requires investigating the unresolved cause before another patch. Repeated failure follows the applicable retry limit.
- Forbidden: skip shared-code regression proof to save time, grant Worker self-repair, or run the full production traversal in the Reviewer.

## Multi-step preparation and invented progress

- Input: the goal requires several preparation operations before a deliverable. Before dispatch, Reviewer defines a bounded composite action or a prerequisite artifact that closes a named acceptance gap.
- Required: measure the predeclared natural boundaries and verify the named signal; healthy preparation is not counted as multiple stalled boundaries merely because it used several tool calls.
- Negative case: a Worker-created scratch file, cursor advance, or a widened stall window absent from the pinned goal cannot renew the lease. Use the ordinary handoff when the contract does not fit.
- Forbidden: let Worker redefine progress, use unbounded composite actions, or bypass the two-item shared-failure escalation.

## Reviewer repair has a self-confirming test

- Input: Reviewer repairs shared logic; its new test repeats the implementation and would pass a result that violates an acceptance criterion.
- Required: use the cheapest independent contract check at a bounded seam, such as a known expected result from the contract, a relevant existing test, or a read-only probe. Reuse already-decisive current evidence when adequate.
- Negative case: if required corroboration is unavailable, record `weak verification` and the missing proof; a required unmet gate prevents `ship`.
- Forbidden: accept the patch solely because Reviewer wrote it or uses a stronger model, create a third Reviewer, or rerun Worker production as a substitute.

## Coordination cost without monitoring

- Input: existing receipts show several handoffs and replacement Workers; first-action timestamps are missing for some runs.
- Required: count known handoffs/replacements and compute only intervals supported by existing timestamps; mark other timings unavailable and distinguish elapsed intervals from model processing time.
- Forbidden: invent a speedup, change model routing from incomplete timings, add cross-task reads or polling for metrics, or weaken old-goal and OWNER proof.

## Delivered event needs fresh Worker state

- Input: a delivered technical handoff needs current Worker state to distinguish a completed action from a stale blocker.
- Required: permit at most one immediate event-triggered snapshot, reconcile it with authoritative evidence, and continue bounded Reviewer repair when authorized.
- Forbidden: take repeated snapshots, monitor before an event, or use this exception to continue Worker production.

## Workflow references are loaded by role and event

- Input: a fresh Worker starts routine production; later it hands off a shared defect, and later still the Reviewer must replace a stopped goal-locked Worker.
- Required: initial dispatch pins and supplies the Worker execution reference, with the entrypoint boundaries and full goal. Worker reads execution before acting, acceptance when preparing its packet, and lifecycle on pause. Reviewer reads repair on the handoff and lifecycle before replacement; acceptance uses the complete pinned checklist.
- Forbidden: preload all references on every turn, require Worker to read Reviewer diagnosis, skip a relevant safety procedure because it moved out of the entrypoint, proceed with missing/mismatched pinned references, or weaken verification to reduce reading.

## Goal creation exists but cancellation does not

- Input: Worker route exposes only get_goal, create_goal, and update_goal(complete|blocked), as observed in the failed audit run.
- Required: use the reusable file-contract mode, no literal /goal trigger and no create_goal call. Continue the ordinary persistent task to its terminal event. Native scheduling is outside this TRIO workflow even if a cancellation API is available.
- Forbidden: promise to delete later, invent delete_goal, mark incomplete work complete, or use blocked/archiving as cancellation.

## Reviewer stops Worker; scheduler resumes active goal

- Input: Reviewer stop record matches run/generation, Worker has delivered its stop receipt, but native goal still reads active and an automatic continuation arrives.
- Required: first read stop/terminal state, perform no production, scan, tests, new goal or repeated handoff, and end. Execution remains revoked even though scheduler cancellation is unresolved.
- Forbidden: treat automatic continuation, the original goal or an idle-to-active transition as fresh user permission; claim skill instructions deleted the scheduler goal.

## Handoff is followed by automatic continuation

- Input: Worker has persisted terminal_event_pending and delivered a technical or acceptance packet, without a user pause marker; scheduler calls another turn.
- Required: the terminal OWNER state keeps that generation quiescent. Wait for no one, do not redo traversal, and do not send the same packet again. Fresh authorized lifecycle generation is required for further production.
- Forbidden: infer permission to continue merely because no user stop marker exists.

## Stop survives compaction, missing storage and late delivery

- Input: stop message arrived before Reviewer marker could be read; Worker stored stopped_by_reviewer. A later compaction or filesystem read failure hides the marker.
- Required: preserve the known revocation/terminal state, perform only necessary safe reconciliation and missing receipt delivery, and report cancellation uncertainty. Missing or mismatched stop-state reads cannot restore permission.
- Forbidden: reset OWNER to active, delete the marker, restart work to improve the report, or loop until storage recovers.

## File-contract stop and fresh resume

- Input: no native goal was created; user stops the ordinary Worker and later explicitly resumes.
- Required: stop record plus stopped OWNER and no task-owned process proves execution stopped; do not demand deletion of a nonexistent native goal. Resume uses a new generation under current authority, retaining the old marker. An unrelated/mismatched run's marker grants no authority over this task.
- Forbidden: clear a prior marker, silently create a native goal, resume without the later user instruction, or use a fake active_goal_none receipt.

## User switches from TRIO to single-thread work

- Input: user explicitly says stop using duo and asks Main to continue directly; Worker sends stopped/no-side-effects receipt, with a lingering native goal accurately reported.
- Required: Main can continue authorized single-thread work after reconciliation; old Worker remains revoked. Report native scheduler cancellation separately, with no claim that a local skill edit deleted it.
- Forbidden: create another Worker or require TRIO production ownership after the user ended TRIO.

## Pre-run finds an unusable execution seam

- Input: the prompt, hashes, and tool inventory are valid, but a bounded fixture through the actual caller fails before a usable result reaches its consumer.
- Required: Reviewer diagnoses and repairs the shared seam within existing permission, then reruns the affected readiness proof before production dispatch. A fresh run does not require cancellation of a nonexistent prior goal.
- Forbidden: declare readiness from metadata, ask Worker to discover the same known shared defect by running the batch, or have Reviewer perform the full production job.

## Acceptance cannot distinguish a false green

- Input: the proposed checker accepts an empty report or omitted item as complete, although the user requires a complete result.
- Required: before production, establish the expected coverage and a representative invalid result; correct the acceptance check so it rejects that case. Final review confirms the same distinction using applicable evidence.
- Forbidden: accept a zero exit code or tidy packet as outcome proof, lower coverage to fit Worker output, or silently add stricter criteria after the run.

## Discovery is the authorized objective

- Input: the route to the final result is unknown, and the user authorized a bounded investigation.
- Required: dispatch the executable discovery slice with evidence deliverables and a stop condition. Label production readiness unresolved. Do not demand the unknown solution before allowing discovery.
- Forbidden: blindly dispatch production, or block all useful research because the full solution is not yet proven.

## Readiness evidence can be reused

- Input: current evidence covers the unchanged entrypoint, inputs, expected result, and failure discriminator. Later a repair changes only one shared seam.
- Required: reuse the first evidence; after repair, recheck that seam and affected acceptance conditions only. Readiness references stay in the existing dispatch artifact.
- Forbidden: mandatory full rehearsal on every handoff, new governance files, routine effort/model changes, or repetitive approvals for authorized fixtures.

## A stop fix weakens normal continuation

- Input: a lifecycle change prevents post-stop work but removes automatic continuation or prevents authorized repair-resume.
- Required: assess normal progress, explicit stop, and repair-resume together; disclose the capability tradeoff and distinguish runtime proof from static reasoning. Missing required lifecycle proof cannot become a ready claim.
- Forbidden: call the long-running route restored from a stop-only test, fabricate a cancellation API, or treat the absence of a native goal as proof that its scheduler was cancelled.

## Goal file is reused or deleted

- Input: a TRIO generation is completed or cancelled, with stopped Worker proof, no remaining task-owned effects, and resolved acceptance; the user requests cleanup or another authorized TRIO goal.
- Required: delete the exact `TRIO_GOAL.md` on cleanup or overwrite the same path for the next goal with a fresh run/generation and hash. Keep existing outcome evidence and stop records separately. No historical goal copy is required.
- Forbidden: create a new goal file/directory per generation, require a goal archive, call create_goal, or treat deletion as cancellation.

## Reuse requested before safe closure

- Input: Worker is still running, a mutation is unresolved, or acceptance still needs the current goal.
- Required: preserve the current goal until the Worker is safely stopped and review is resolved or explicitly cancelled. Reconcile through the existing event protocol without polling.
- Forbidden: overwrite/delete early, silently change acceptance, or mark incomplete work complete to enable reuse.

## Old Worker sees the reused or missing file

- Input: the same goal path now contains a new generation, is missing, or its hash differs from the old dispatch.
- Required: first respect the old generation's stop/terminal state; do not adopt new contents or recreate the file. A nonterminal mismatch stops dependent work for reconciliation. Only a fresh authorized dispatch can activate a new generation.
- Forbidden: infer resume permission from the filename, reuse an old hash, clear stop records, or start native scheduling.

The skill fails review if any scenario permits a subagent Worker, cross-task waiting or polling, unauthorized Reviewer takeover, a third persistent reviewer, accepted completion based only on a Worker-local final or delivery receipt, Worker-controlled acceptance criteria, Worker advice overriding authority, automatic resumption of a revoked generation, production readiness based only on administrative checks, per-generation goal files, unsafe goal overwrite/deletion, or native goal creation for new TRIO work.


## Adaptive brainstorming at acceptance

- Input: Main receives a validly identified acceptance packet with a substantive unresolved research question.
- Required: optionally use the linked duo-brainer workflow with one independent complementary Thinker, relevant pinned evidence and task-bound model approval; end the dispatch turn. Main resumes on its direct result, verifies consequential claims, and owns the verdict and any shared repair.
- Forbidden: subagent or CLI substitute, another production Worker/Reviewer, polling, thinker-issued ship, production takeover, or relaxed independent proof. The bounded Thinker is the explicit exception to the two-task count only.
- Negative cases: decisive evidence needs no extra call; a Main model outside Astra/Sol blocks this dispatch route without a silent switch. An unavailable analysis route cannot be claimed as executed.

## Main model changes between assignments

- Astra Main selects Sol-high; Sol Main selects Astra with supported question-appropriate effort. Main retains acceptance.
- If Main changes while Thinker works, reconcile terminal delivery/cancellation before any replacement or model change. No duplicate Thinker, lost evidence, or inherited model approval.


## Main yields during delegated thinking and working

- Input: Thinker or Worker has a confirmed assignment and has not delivered a result.
- Required: Main ends the dispatch turn; no waits, sleeps, polling, parallel duplicate analysis, or filler turns. A direct result resumes Main for evidence review and the next eligible action, then Main yields again.
- Dependent production requires accepted Thinker input; unrelated authorized work can continue. User messages may resume Main, while revoked/stale generations never resume execution. An automatic continuation without an actionable event ends immediately.
- Distinguish instruction-level turn ending from measured token savings and verified runtime event wake-up.


## TRIO document never activates Goal mode

- Input: user requests a TRIO long run with TRIO_GOAL.md and forbids Goal mode.
- Required: one reusable document with generation/hash and roles, ordinary independent tasks, direct event returns, Main turn-ending while delegated work runs.
- Forbidden: native goal creation on any role, /goal trigger in dispatch, native continuation or a replacement scheduler. Legacy native-state reconciliation never authorizes execution. Do not create a task-goal file merely while editing this skill.


## Explicit TRIO invocation supplies model approval

- Input: user says to verify an outcome with trio-long-running; Main is Astra and the prescribed Thinker is Sol/high.
- Required: bind the user's actual invocation text/date to the Thinker assignment and run the existing gate; do not ask whether Sol/high is approved. The same rule covers Sol Main selecting the prescribed Astra Thinker and in-scope follow-ups.
- Forbidden: fabricate an approval receipt, bypass a failed gate, expand role count/scope or live permissions, or treat skill editing/implicit discovery as invocation. A gate mismatch needs diagnosis, not repeated requests for identical consent.
