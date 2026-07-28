---
name: duo-long-running
description: Coordinate a no-poll Runner and Reviewer for duo long run, technical handoffs, user gates, and 雙 task.
---

# Duo Long Running

Run two Codex tasks:

- **Runner:** performs the long-running work.
- **Reviewer:** remains the user’s conversational interface and repairs shared technical failures.

Keep domain rules, authority, permissions, and acceptance criteria in the project or task contract. This skill only owns task coordination, event delivery, repair handoff, and goal replacement.

## Roles

### Runner

- Own exactly one current goal.
- Follow the task’s public interface and current authority.
- Continue every safe, authorized, in-scope next action without reviewer supervision.
- Handle ordinary item-local variation inside the task contract.
- Do not modify shared infrastructure, invent authority, expand permission, or call a rescue model.

### Reviewer

- Remain the user’s single conversational interface.
- Stay idle while the runner is healthy.
- Diagnose and repair shared technical failures after an event.
- Verify the smallest relevant path.
- Return a fresh goal after cleanly ending the runner’s old goal.
- Never silently inherit or expand the runner’s permissions.

## Hard No-Poll / No-Takeover Invariant

The runner owns the long action. A technical handoff transfers ownership of the
shared defect only; it does **not** transfer ownership of the runner’s traversal,
batch, migration, research loop, or acceptance run.

1. The reviewer may run one bounded reproduction or fixture that proves the
   shared repair. It must not run the runner’s full job, even when the repaired
   command is safe or read-only.
2. After sending a goal or follow-up to a healthy runner, the reviewer ends its
   own turn. It must not keep the turn open with `wait_threads`, `read_thread`,
   sleep, heartbeat, recurring automation, filesystem polling, or process
   polling.
3. “Let it run”, “it will message you”, “不要監看”, “不用等”, and equivalent
   user instructions set an absolute no-monitor flag. Only a new runner event
   or a later explicit user status request clears it for one read.
4. An explicit user status request permits exactly one immediate fresh
   snapshot. Report that snapshot and return to idle; do not begin a wait loop.
5. The sole automatic exception is a lifecycle replacement that requires proof
   the replacement turn started. Use one immediate snapshot (`timeoutMs: 0` or
   equivalent), never a bounded wait. Ordinary follow-up messages do not get
   this exception.
6. If the reviewer accidentally starts runner-owned work, stop only that exact
   reviewer-owned process, preserve its partial evidence as non-authoritative,
   hand the command back to the runner, and end the reviewer turn.

## Start

1. Record both task IDs, workspace, authoritative resume command or state reference, selected model/effort, scope, permissions, and acceptance criteria.
2. Inspect the runner task fresh; do not rely on chat summaries.
3. Include the reviewer task ID in the runner goal so the runner can send event messages back directly.
4. Send one compact `/goal` containing the authoritative entrypoint, allowed interface, boundaries, acceptance criteria, and event protocol.
5. Do not create monitoring, heartbeat, recurring automation, or periodic thread reads unless the user explicitly requests them.
6. After dispatch, end the reviewer turn. Dispatch is not followed by a
   completion wait.

## Event-Driven Protocol

The runner emits only:

- `milestone_complete`: a user-relevant deliverable is ready.
- `technical_handoff_required`: a shared technical defect prevents safe continuation.
- `user_gate_required`: authentication, authorization, an external dependency, or a decision genuinely requires the user.
- `acceptance_complete`: the final outcome is proven.

Routine progress, unchanged state, subprocess lifecycle noise, and temporary item-local repair do not generate messages.

For `technical_handoff_required`, send the packet to the recorded reviewer task before ending the runner turn. Marking the runner locally blocked without delivering the event is an incomplete handoff.

The reviewer:

- does not poll merely to prove the runner is alive;
- reads the runner fresh only after an event or an explicit user status request;
- replies through the thread messaging tool after a repair or decision;
- reports only user-relevant outcomes.
- ends its turn immediately after dispatching the repaired goal; runner
  completion must arrive as a new event.

If direct thread messaging is unavailable, the runner ends its turn with the same compact event packet; do not replace this with periodic polling.

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
3. Do not kill healthy OS processes or shared runtime state.
4. Transfer only the compact authoritative resume state, last successful evidence, permissions, acceptance criteria, reviewer task ID, and event protocol.
5. Verify the replacement runner has no unfinished goal before creating its new `/goal`.
6. Confirm the replacement turn is active with one immediate snapshot only,
   then end the reviewer turn.

If lifecycle replacement was not authorized, emit `user_gate_required` once. Do not ask the user to repeatedly click lifecycle controls.

## Runner Loop

1. Re-read authoritative resume state at the start of each fresh goal.
2. Consume only the current task interface or allowlisted action.
3. Require task outcome evidence, not merely command success.
4. Keep independent work moving when one item enters local repair.
5. Stop only for a defined event or achieved acceptance criteria.

Silence alone is not failure. For a synchronous child process:

- `stdout=0` alone is not a blocker.
- Measure timeout from the process/job start using elapsed wall-clock or monotonic seconds. Never substitute agent turns, tool calls, messages, or polls for minutes.
- Check the exact process or job ID, liveness, CPU movement, output artifacts, and declared timeout.
- If evidence advances, wait on that same action instead of launching a duplicate.
- Escalate only after the bounded timeout and two fresh probes show no progress, or after deterministic failure evidence appears.
- Immediately before sending a handoff, re-check completion once. If the action completed, consume its evidence and cancel the stale block.

## Technical Handoff

Send one compact packet:

```text
technical_handoff_required
workspace:
authority_or_resume_state:
failed_signature:
last_successful_action_and_evidence:
current_process_or_job_liveness:
stdout_stderr_or_artifact_paths:
attempted_recoveries:
observed_side_effects:
minimal_missing_capability:
```

Do not send raw reasoning or broad project history. An item-local failure is not a shared handoff while other eligible work remains.

## Reviewer Repair

On `technical_handoff_required`:

1. Read the runner task fresh.
2. Re-run the authoritative resume or state check.
3. Reproduce the named signature using the cheapest decisive evidence and no
   more than one bounded fixture unless two fixtures are required by the
   project’s shared-contract rule.
4. Classify it as task data, tool, environment, permission, workflow, shared code, or goal lifecycle.
5. Check whether an apparently hung process completed before killing or retrying it.
6. Patch only the smallest proven shared root cause.
7. Run the narrowest relevant verification.
8. Do **not** run the repaired full traversal, batch, migration, or acceptance
   command. The bounded fixture is the reviewer’s exit condition.
9. Update canonical authority only when the task contract requires it.
10. Send a replacement prompt using **Mandatory Goal Replacement**, including its fresh-runner fallback when the old blocked goal cannot be terminated by API.
11. For lifecycle replacement only, confirm the new runner turn with one
    immediate snapshot. For an ordinary follow-up, do not read or wait.
12. End the reviewer turn.

If no patch is needed because the old action completed, send a corrected fresh goal that consumes its evidence and forbids duplicate execution.

## Return Goal Shape

Keep it brief:

```text
FIRST: terminate/delete the previous active or blocked goal and confirm it is no longer active.
This is goal lifecycle only; preserve healthy runtime state.

/goal

Workspace and authoritative resume entrypoint.
Fresh state and last successful evidence.
One current interface or action.
Scope and permission boundary.
Known false-block condition and runner-local bounded process wait rule.
Acceptance criteria.
Reviewer task ID and allowed event types.
Only a defined event may stop the run.
```

Preserve the runner’s explicitly selected model/effort when messaging it. Do not repeatedly steer a healthy runner.

## Regression Checks

Use these scenarios when editing or reviewing this skill:

### Healthy runner; user says it will report

- Input: runner is active; user says “等他做完送訊息來，不要監看”.
- Required reviewer actions: dispatch at most once, report that the runner owns
  the work, end the turn.
- Forbidden: any `wait_threads`, `read_thread`, heartbeat, status poll, or
  duplicate runner command.

### Technical handoff; bounded shared repair succeeds

- Input: runner reports a public API parameter error.
- Reviewer may: reproduce one parent request, repair the shared credential
  contract, run its unit test and the same one-parent probe.
- Required next action: send the full-tree command back to the runner and end
  the turn.
- Forbidden: reviewer starts the full-tree traversal or waits for runner
  completion.

### Explicit status request

- Input: user asks “現在到哪？”.
- Reviewer may: take exactly one immediate fresh runner snapshot and report it.
- Forbidden: a second snapshot, bounded wait, or continuing the runner’s work.

The skill fails review if any scenario permits reviewer polling or runner-work
takeover.

## Done

End the duo loop only when:

- acceptance criteria are proven, or
- a real user or external gate remains after authorized recovery.

Report the delivered outcome first. Keep internal lifecycle and handoff noise out of the user-facing result.

Before declaring the duo coordination complete, verify there is no reviewer-owned
wait loop, monitor, duplicate long-running process, or runner-owned command still
running in the reviewer task.
