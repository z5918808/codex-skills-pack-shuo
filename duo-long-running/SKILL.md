---
name: duo-long-running
description: Use for duo long run, 持續長跑, 雙 task, or Reviewer + Worker coordination without cross-task waits, polling, or takeover.
---

# Duo Long Running

Run two Codex tasks:

- **Worker:** performs the long-running production work. The protocol below uses
  `runner` as its internal synonym. Its default route is `gpt-5.6-luna/max`.
- **Reviewer:** remains the user’s conversational interface, always runs on the
  `gpt-5.6-sol` model family, and exclusively owns bug diagnosis and repo repair.

Keep domain rules, authority, permissions, and acceptance criteria in the project or task contract. This skill only owns task coordination, event delivery, repair handoff, and goal replacement.

## Activation Role Default

Treat the chat that receives the user’s activation instruction as the Reviewer.
Record its task ID before resolving or creating the Worker. Keep that chat as
the user’s conversational endpoint for the entire duo run.

Only an explicit user instruction naming a different Reviewer task may override
this default. Do not create, fork, select, or hand off to another Reviewer merely
because another task is newer, active, or already related to the work.

Before starting a duo run, verify the activation chat is actually using
`gpt-5.6-sol`. Reasoning effort remains session/task-selected unless the user
specifies it. If the model is not Sol, fail closed and ask the user to switch the
activation chat to Sol; do not silently create another Reviewer or let Luna act
as Reviewer. The Worker defaults to `gpt-5.6-luna/max` unless the user explicitly
selects another allowed production model/effort.

## Automatic Role Labels

Make both task roles visible in the sidebar before dispatch:

- Reviewer title: `[Reviewer] <base title>`
- Worker title: `[Worker] <base title>`

As soon as both task IDs are known, use `set_thread_title` or the equivalent
task-title control to apply the canonical prefixes. The operation is
idempotent:

1. Read or derive the current base title.
2. Remove one existing leading `[Reviewer] ` or `[Worker] ` prefix.
3. Apply the prefix matching the task ID’s actual role.
4. Take one immediate snapshot to verify each task ID and title. This is title
   verification, not permission to monitor the Worker.

Never stack prefixes, swap role labels, or replace the meaningful base title.
Keep the Reviewer title labeled `[Reviewer]` across Worker replacements.

For a newly created Worker, the task ID does not exist until `create_thread`
returns, so its visible title cannot be a prerequisite for the initial prompt.
Put `ROLE: Worker` on the first line of the complete initial goal, create the
task once, then apply and verify the `[Worker]` title immediately after the
creation receipt. Do not split creation into a setup-only prompt followed by a
second goal-delivery call merely to title the task first.

If task-title control is unavailable, do not block otherwise valid work.
Instead, put `ROLE: Reviewer` or `ROLE: Worker` on the first line of the next
goal or event packet and report the missing visible-title capability once.

## Exactly-Once Worker Dispatch

Worker creation is an exactly-once operation. A thread API error, timeout,
missing receipt, `Unknown projectId`, or tool exception is an **ambiguous
dispatch result**, not proof that creation failed. Some app paths may create the
task before returning an error.

1. Before dispatch, form a dedup key from `Reviewer task ID + authoritative
   generation/action + normalized Worker goal`. Record the intended model,
   effort, workspace, and title with it.
2. For a fresh Worker, the initial `create_thread`/`fork_thread` prompt must
   contain the complete executable goal, including `ROLE: Worker`, authority,
   scope, boundaries, acceptance criteria, Reviewer address, and event
   contract. A setup-only bootstrap that promises a later `/goal` is forbidden:
   it adds a second transport dependency and can leave an idle orphan Worker.
   Keep this creation payload compact. If the full goal is large, write it once
   to an append-only UTF-8 task artifact and put its absolute path + SHA256 in
   the initial prompt together with the mission, hard boundary, authority, and
   instruction to read that artifact before acting. This is still one atomic
   dispatch; it must not depend on a later cross-thread message.
3. Call `create_thread`, `fork_thread`, or the selected creation primitive at
   most once for that dedup key. Do not issue a fallback create in the same turn
   merely because the receipt looks unsuccessful.
4. After any ambiguous result, take exactly one immediate `list_threads`
   inventory. Match candidates by source Reviewer ID, prompt/dedup fingerprint,
   creation-time window, workspace, and authority/action. This inventory is a
   dispatch reconciliation step, not Worker monitoring.
5. If any matching task exists, treat dispatch as succeeded and **do not
   retry**. Rename and retain exactly one OWNER; send every duplicate an
   immediate `terminal_event_pending` / `duplicate_worker_retired` stop packet.
6. A fallback creation path, including projectless creation, is allowed only
   after the one inventory positively proves that no matching task exists.
   Use the same dedup key and never chain multiple fallback mechanisms.
7. Before any Worker consumes the canonical action, require a fresh process
   gate proving the expected controller/writer ownership. A second Worker that
   observes an in-flight canonical action must stop immediately; it must not
   wait for, inspect, reconcile, or report the OWNER's result.
8. If duplicates exist and exactly one controller tree is in flight, preserve
   that OWNER tree and retire the other tasks without killing the process. If
   ownership cannot be mapped safely, freeze new claim/refill/writer actions
   and send a Reviewer incident instead of guessing.
9. Archive a duplicate only after its `duplicate_worker_retired` terminal
   receipt confirms it started no controller/writer. Archiving is cleanup, not
   a substitute for stopping the task.

Never report “one Worker” from the creation receipt alone. The required proof is
one reconciled OWNER task plus at most one matching controller tree and one
writer WIP.

## Roles

### Runner

- Own exactly one current goal.
- Follow the task’s public interface and current authority.
- Continue every safe, authorized, in-scope next action without reviewer supervision.
- Handle ordinary item-local variation inside the task contract.
- Never debug or patch repo/shared infrastructure, publish a repair successor,
  or turn test/code work into production progress. Product-local content/source
  strategy changes inside the authorized runtime are allowed; source-code,
  contract, scheduler, adapter, authority, or workflow defects are not.
- On any bug or shared deterministic defect, enter `terminal_event_pending`,
  preserve evidence, deliver `technical_handoff_required`, and end immediately.
  Do not run extra cycles while waiting for the Reviewer.
- Every `technical_handoff_required` packet must include the literal directive
  `reviewer_instruction: 直接開始修` plus
  `user_confirmation_required: false` when the repair stays inside the existing
  goal, permission, and safety boundary. This directive transfers shared-defect
  ownership to the Sol Reviewer; it never grants the Worker repair authority.
- Never invent authority, expand permission, or call a rescue model.

### Reviewer

- Remain the user’s single conversational interface.
- Use `gpt-5.6-sol`; this role must not be delegated to Luna, Terra, or a
  downstream Worker.
- Stay idle only while the runner's latest **objective-progress lease** is
  healthy. Process liveness, call volume, queue churn, or
  `boundary_disposition=continue_same_goal` alone never proves health.
- Treat `acceptance_complete` as a Worker claim, not a completion fact. Apply
  **Acceptance Review** before reporting success to the user.
- Own all bug diagnosis, RED→GREEN reproduction, repo changes, shared contract
  repairs, and successor publication decisions.
- A delivered `technical_handoff_required` with
  `reviewer_instruction: 直接開始修` is an immediate work trigger, not a status
  report or a request for the user to say `proceed`. Start the bounded Reviewer
  repair in the receiving turn. Ask the user only when the repair needs new
  authority, expands live scope, changes safety boundaries, or reaches a real
  external/user gate.
- Work from a tight red loop and deepen the existing shared seam; do not
  translate repeated symptoms into generation-specific patches.
- Return a fresh goal after cleanly ending the runner’s old goal.
- Never silently inherit or expand the runner’s permissions.

## Hard No-Cross-Task-Wait / No-Takeover Invariant

The runner owns the long action. A technical handoff transfers ownership of the
shared defect only; it does **not** transfer ownership of the runner’s traversal,
batch, migration, research loop, or acceptance run.

1. Neither the runner nor the reviewer may call `wait_threads` or any equivalent
   wait-on-another-task function. This prohibition includes immediate,
   zero-timeout, bounded, and delegated waits. Back-and-forth thread messages
   deliver the next event; the receiving task resumes on that message instead
   of spending a turn or tokens waiting.
2. After either role sends a goal, follow-up, repair result, handoff, or decision
   to the other task, it ends its own turn. It must not keep the turn open with
   `wait_threads`, sleep, heartbeat, recurring automation, filesystem polling,
   or process polling for the other task.
3. The reviewer may run one bounded reproduction or fixture that proves the
   shared repair. It must not run the runner’s full job, even when the repaired
   command is safe or read-only.
4. “Let it run”, “it will message you”, “不要監看”, “不用等”, and equivalent
   user instructions set an absolute no-monitor flag. Only a new runner event
   or a later explicit user status request clears it for one read.
5. An explicit user status request permits the reviewer exactly one immediate
   `read_thread` snapshot. Report that snapshot and return to idle; never use
   `wait_threads`.
6. The sole automatic cross-task read exception is a lifecycle replacement that
   requires proof the replacement turn started. Use one immediate `read_thread`
   snapshot, never `wait_threads`. Ordinary follow-up messages do not get this
   exception.
7. If either role accidentally starts a cross-task wait, cancel only that exact
   wait and rely on the already-established message path. Do not replace it with
   another wait, poll, or monitor.
8. If the reviewer accidentally starts runner-owned work, stop only that exact
   reviewer-owned process, preserve its partial evidence as non-authoritative,
   hand the command back to the runner, and end the reviewer turn.

## Start

1. Record the activation chat’s task ID as the Reviewer unless the user
   explicitly named another Reviewer. Assemble the complete Worker goal before
   creation, then resolve or create the Worker task through **Exactly-Once
   Worker Dispatch**. Never create an empty/setup-only Worker.
2. Verify and record Reviewer actual model=`gpt-5.6-sol`; verify and record the
   Worker model/effort (default `gpt-5.6-luna/max`), both task IDs, workspace,
   authoritative resume command or state reference, scope, permissions, and
   acceptance criteria. A model mismatch blocks dispatch.
3. For an existing Worker, inspect it fresh before a follow-up. For a newly
   created Worker, the complete initial goal is the creation prompt; after the
   receipt, apply/verify the role title and use the single lifecycle snapshot
   allowed below. Do not send the goal a second time.
4. Resolve `send_message_to_thread` or the equivalent direct task-message tool
   before promising automatic report-back. If it is unavailable, do not start
   an auto-report duo run; report the missing delivery capability once.
5. Include the reviewer task ID, reviewer host ID when available, the exact
   direct-message tool name, and the delivery contract below in the runner goal.
6. A fresh Worker receives its one compact `/goal` inside the initial creation
   prompt, either inline or as a hash-bound task-artifact reference under the
   rule above. Only an already-existing eligible Worker receives that goal
   through a follow-up message. In both cases include the authoritative
   entrypoint, allowed interface, boundaries, acceptance criteria, and event
   protocol.
7. Include an **Objective-Progress Lease** in the Worker goal. Derive its
   acceptance-relevant signals from the goal, set a boundary-count stall window
   (default: two completed natural action boundaries), and require the Worker to
   emit the lease-expiry handoff below. Do not use wall-clock time as a hard
   completion deadline unless the user explicitly requires one.
8. Do not create monitoring, heartbeat, recurring automation, or periodic thread reads unless the user explicitly requests them.
9. After dispatch, end the reviewer turn. Dispatch is not followed by a
   completion wait or any `wait_threads` call.

## Hard Event Delivery Contract

A Worker-local final answer is not event delivery. For every terminal event:

1. Atomically enter `terminal_event_pending`: stop claiming/refilling/starting
   new actions before building the packet. If one exact action is already in
   flight, let it reach its required safe boundary or reconciliation receipt;
   do not start a successor.
2. Build the compact event packet from that quiescent boundary and record
   process/action liveness.
3. Call `send_message_to_thread` or the recorded equivalent with the exact
   Reviewer task ID and host ID.
4. Treat only a successful tool result as the delivery receipt.
5. After the receipt, end the Worker turn immediately. Its local final may only state that
   the event was delivered; it must not substitute for the tool call.

`terminal_event_pending` pauses execution independently of goal lifecycle. A
still-active goal is not permission to run another controller cycle, refill,
repair wave, or successor action after the terminal packet is prepared or
delivered. The Worker resumes only after a fresh Reviewer follow-up/goal. This
prevents the common two-extra-cycle race between event delivery and discovering
that the durable goal itself remains active.

The Worker may not claim `milestone_complete`, `technical_handoff_required`,
`user_gate_required`, or `acceptance_complete` was delivered when the tool call
did not succeed. If the tool becomes unavailable or fails after dispatch:

- do not poll, wait, or ask another agent to watch the Reviewer;
- do not mark coordination complete;
- end the Worker task with `delivery_failed`, the intended event type, Reviewer
  task ID, error signature, and the undelivered packet;
- keep completed work and evidence intact so an explicit user status request can
  recover it without rerunning the job.

`delivery_failed` is a transport failure, not permission to redo completed work.

## Event-Driven Protocol

The runner emits only:

- `milestone_complete`: a user-relevant deliverable is ready.
- `technical_handoff_required`: a shared technical defect prevents safe continuation.
- `user_gate_required`: authentication, authorization, an external dependency, or a decision genuinely requires the user.
- `acceptance_complete`: the Worker claims final acceptance and supplies the
  required evidence packet; the Reviewer has not accepted it yet.
- `delivery_failed`: the required direct-message tool could not deliver one of
  the four events above.

Routine progress, subprocess lifecycle noise, and temporary item-local repair do
not generate messages unless the objective-progress lease expires or cross-item
contamination is detected.

## Objective-Progress Lease

Prevent silent churn without Reviewer polling. The Worker owns a local,
deterministic lease and evaluates it after every completed natural action
boundary.

The goal must name its acceptance-relevant progress signals. If omitted, infer
the smallest signals directly from acceptance criteria. Examples include a new
deliverable, a newly packet-ready item, accepted completion, fewer scoped
missing requirements, or reduced per-item closure distance.

Never renew the lease from process liveness, elapsed time, actor/tool call
count, generation changes, claim/refill activity, feeder cursor movement, queue
reshuffling, `continuation_advanced`, `blocker_removed` without a smaller
acceptance gap, or merely encountering a different error signature.

At each natural boundary, compare the current snapshot with the last snapshot
that renewed the lease:

1. Renew only when a declared objective signal advances.
2. If the stall window expires, enter `terminal_event_pending` and deliver
   `technical_handoff_required` with
   `failed_signature: objective_progress_lease_expired`, even when the runtime
   says `continue_same_goal` and the process is healthy.
3. Escalate immediately when the same normalized failure signature or the same
   allegedly item-local evidence reference contaminates two independent items.
4. Treat time checkpoints as soft health observations. They may cause a bounded
   boundary snapshot, but time alone must not stop a progressing goal.

The handoff must include `boundaries_since_objective_progress`, current and
prior objective-signal values, top normalized signature plus distinct-item
count, repeated evidence-ref hash plus distinct-item count, exact
controller/writer liveness, and observed side effects. The Reviewer then owns
the bounded diagnosis; it still does not poll or take over the Worker traversal.

Send every event packet to the recorded Reviewer task through the direct-message
tool before ending the runner turn. Marking the Worker locally blocked or
complete without a successful delivery receipt is an incomplete handoff.

The reviewer:

- does not poll merely to prove the runner is alive;
- reads the runner fresh only after an event or an explicit user status request;
- replies through the thread messaging tool after a repair or decision;
- reports only user-relevant outcomes.
- ends its turn immediately after dispatching the repaired goal; runner
  completion must arrive as a new event.

After sending an event, the runner also ends its turn. It never waits on the
reviewer task; the reviewer’s reply is the event that resumes runner work.

## Acceptance Review

The Worker must deliver `acceptance_complete` with a complete, current packet:

```text
acceptance_complete
stated_goal_and_acceptance_criteria:
authority_generation_or_revision:
scope_and_actual_changed_paths:
verification_commands_and_actual_results:
artifact_or_diff_paths_and_sha256:
remaining_risk_or_none:
```

A successful delivery receipt proves transport only. Acceptance stays pending
until the Reviewer reads the referenced current state, diff, and artifacts and
returns exactly one verdict:

```text
acceptance_review
packet_identity_or_hash:
verdict: ship | fix-first | rethink
reason:
findings:
residual_risk:
```

- `ship`: the actual evidence satisfies the stated acceptance criteria. Only
  this verdict permits the Reviewer to report completion to the user.
- `fix-first`: the goal remains valid but bounded corrections or missing proof
  are required. Send the Worker a corrected or replacement goal as appropriate;
  the Reviewer may repair only a shared seam under **Reviewer Repair**.
- `rethink`: scope, architecture, authority, or acceptance criteria are wrong or
  unsafe. Stop the loop at the applicable user or authority gate; do not disguise
  a redesign as another retry.

Reject missing, stale, contradictory, or identity-mismatched evidence. Do not
infer success from the Worker summary. The Reviewer may run bounded inspection
or proof checks allowed by **Hard No-Cross-Task-Wait / No-Takeover Invariant**,
but never the full runner job. Any code, artifact, authority, or acceptance-state
change after a verdict invalidates that verdict and packet; require a fresh full
packet with a new generation or revision. Never patch or reuse an old packet.

Acceptance review uses the existing Reviewer activation chat. Do not create or
fork a third persistent reviewer, and do not describe this behavioral inspection
boundary as an OS-enforced read-only sandbox.

## Mandatory Goal Replacement

Use same-task replacement only when the available lifecycle API can genuinely terminate or delete the old goal. Begin that restart message with:

```text
FIRST: terminate/delete the previous active or blocked goal and confirm it is no longer active.
This changes goal lifecycle only; do not kill an OS process, browser, service, or authenticated session unless the diagnosed repair explicitly requires it.

/goal
```

Then provide the new goal body.

- Never layer a new `/goal` over an unfinished old goal.
- Never claim the old goal ended without fresh task evidence.
- Never mark incomplete work `complete` merely to unlock `create_goal`.
- Distinguish ending a goal from terminating its underlying process.
- Preserve healthy runtime state.
- Do not repeat an already completed action; consume its evidence and inspect the fresh next action.

### Blocked Goal Without Terminate API

If the goal API exposes only `complete/blocked`, and a blocked goal still prevents `create_goal`:

1. Treat same-task replacement as unavailable; do not loop on `create_goal`.
2. If the user has explicitly authorized reviewer-owned lifecycle replacement, fork or create a fresh runner task and retire the old runner task using the available reversible thread lifecycle control.
3. Create the replacement with the complete goal and `ROLE: Worker` in its
   initial prompt, then immediately apply and verify its `[Worker]` title. Do
   not create it with setup-only text and depend on a follow-up goal.
4. Do not kill healthy OS processes or shared runtime state.
5. Transfer only the compact authoritative resume state, last successful evidence, permissions, acceptance criteria, reviewer task ID, and event protocol.
6. Verify the replacement runner has no unfinished goal before creating its new `/goal`.
7. Confirm the replacement turn is active with one immediate snapshot only,
   using `read_thread`, then end the reviewer turn. Never use `wait_threads`.

If lifecycle replacement was not authorized, emit `user_gate_required` once. Do not ask the user to repeatedly click lifecycle controls.

## Runner Loop

1. Re-read authoritative resume state at the start of each fresh goal.
2. Consume only the current task interface or allowlisted action.
3. Require task outcome evidence, not merely command success.
4. Evaluate the objective-progress lease after every natural action boundary;
   do not continue solely because the runtime reports continuation.
5. Keep independent work moving when one item enters local repair.
6. Stop only for a defined event or achieved acceptance criteria. Any repo,
   shared-contract, scheduler, adapter, authority, or workflow bug is a
   `technical_handoff_required`; the Worker must not attempt a repair first.
7. Once a defined terminal event is selected, enter `terminal_event_pending`
   before any message/tool boundary; from that point the only allowed actions
   are safe-boundary reconciliation, evidence capture, direct event delivery,
   and ending the turn.

Silence alone is not failure. For a synchronous child process:

- `stdout=0` alone is not a blocker.
- Measure timeout from the process/job start using elapsed wall-clock or monotonic seconds. Never substitute agent turns, tool calls, messages, or polls for minutes.
- Check the exact process or job ID, liveness, CPU movement, output artifacts, and declared timeout.
- If evidence advances, wait on that same action instead of launching a duplicate.
- Escalate only after the bounded timeout and two fresh probes show no progress, or after deterministic failure evidence appears.
- Immediately before sending a handoff, re-check completion once. If the action completed, consume its evidence and cancel the stale block.

## Technical Handoff

Send this event as soon as a bug exceeds ordinary product-local runtime
variation. The Worker does not need to prove or attempt shared self-repair.
`attempted_recoveries` contains only authorized product-local/runtime actions;
it must not contain repo edits, new tests, publisher runs, or repair successors.

Send one compact packet:

```text
technical_handoff_required
reviewer_instruction: 直接開始修
user_confirmation_required: false
workspace:
authority_or_resume_state:
failed_signature:
last_successful_action_and_evidence:
current_process_or_job_liveness:
stdout_stderr_or_artifact_paths:
attempted_recoveries:
observed_side_effects:
minimal_missing_capability:
objective_progress_snapshot:
cross_item_signature_or_evidence_ref_counts:
```

Do not send raw reasoning or broad project history. An item-local failure is not a shared handoff while other eligible work remains.

Set `user_confirmation_required: true` instead only when the minimal safe next
step genuinely requires new live permission, broader product scope, credentials,
an external decision, or another user-owned action. A normal shared bug inside
the already-authorized production objective is never a reason to wait for a
manual `proceed`.

## Reviewer Repair

On `technical_handoff_required`:

1. Treat `reviewer_instruction: 直接開始修` as an automatic continuation of the
   existing duo goal. Do not ask the user for confirmation when
   `user_confirmation_required=false`.
2. Apply `$step-back-and-think` before patching: write the compact internal
   frame `Current facts / Local story / Context trap / Game-board priority /
   Earliest common owner`, then choose the smallest owner seam that absorbs the
   failure class. This analysis is Reviewer work and must not be sent back to
   the Worker as a repair task.
3. Read the runner task fresh.
4. Re-run the authoritative resume or state check.
5. Build one tight, deterministic, agent-runnable red loop for the exact named
   signature. Observe it red before theorizing or patching. Use no more than one
   bounded fixture unless the project’s shared-contract rule requires two. If
   no honest red loop can be built, state what evidence is missing instead of
   guessing.
6. Classify it as task data, tool, environment, permission, workflow, shared
   code, or goal lifecycle. Rank three falsifiable root-cause hypotheses, then
   test the cheapest discriminator one variable at a time.
7. Check whether an apparently hung process completed before killing or retrying it.
8. Patch the smallest existing shared seam that enforces a forward invariant
   and makes the whole failure class impossible. Do not encode a product ID,
   generation, receipt, or one-off symptom when the invariant belongs to a
   shared scheduler, state owner, adapter, or contract. When consecutive
   handoffs expose different symptoms along one path, step back to the earliest
   common owner instead of continuing authority churn.
9. Turn the minimized repro into a regression at the real call seam, observe
   red then green, and rerun the narrowest relevant suite. Add an adjacent case
   to the same fixture only when it proves the forward invariant rather than a
   second special case.
10. Do **not** run the repaired full traversal, batch, migration, or acceptance
   command. The bounded fixture is the reviewer’s exit condition.
11. Update canonical authority only when the task contract requires it.
12. Send a replacement prompt using **Mandatory Goal Replacement**, including its fresh-runner fallback when the old blocked goal cannot be terminated by API.
13. For lifecycle replacement only, confirm the new runner turn with one
    immediate `read_thread` snapshot. For an ordinary follow-up, do not read or
    wait. Never use `wait_threads`.
14. End the reviewer turn.

If no patch is needed because the old action completed, send a corrected fresh goal that consumes its evidence and forbids duplicate execution.

## Return Goal Shape

Keep it brief:

```text
ROLE: Worker

FIRST: terminate/delete the previous active or blocked goal and confirm it is no longer active.
This is goal lifecycle only; preserve healthy runtime state.

/goal

Workspace and authoritative resume entrypoint.
Fresh state and last successful evidence.
One current interface or action.
Scope and permission boundary.
Explicit `shared_self_repair_budget=none`; all bug repair belongs to the Sol Reviewer.
Objective-progress signals, last renewed snapshot, and boundary-count stall window.
Known false-block condition and runner-local bounded process wait rule.
Acceptance criteria.
Reviewer task ID and allowed event types.
Reviewer host ID and exact direct-message tool.
Terminal event delivery requires a successful tool receipt; local final is not delivery.
Only a defined event may stop the run.
```

Preserve the runner’s explicitly selected model/effort when
messaging it. Do not repeatedly steer a healthy runner.

## Regression Checks

When editing or reviewing this skill, read and run the semantic scenarios in
[`references/regression-checks.md`](references/regression-checks.md). The skill
fails review if any scenario permits cross-task waiting or polling, Reviewer
takeover of Worker work, a third persistent reviewer, or acceptance based only
on a Worker-local final or delivery receipt.

## Done

End the duo loop only when:

- the latest complete `acceptance_complete` packet matches current state and the
  Reviewer has returned `ship`, with no later change invalidating that verdict; or
- a real user or external gate remains after authorized recovery.

Report the delivered outcome first. Keep internal lifecycle and handoff noise out of the user-facing result.

Before declaring the duo coordination complete, verify neither role owns a
cross-task wait loop or monitor, and verify there is no duplicate long-running
process or runner-owned command still running in the reviewer task. Also verify
that the active task titles still carry the correct `[Reviewer]` and `[Worker]`
prefixes, and that the last terminal event has a successful direct-message
delivery receipt. For accepted completion, also verify the current packet
generation/revision, packet identity or hash, `ship` verdict, and absence of any
post-verdict change.
