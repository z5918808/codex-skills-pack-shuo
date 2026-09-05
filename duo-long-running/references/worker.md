# Worker Execution

Worker: read before the first production action. Follow the entrypoint role and authority boundaries. Reviewer reads this when preparing a goal; it does not authorize Reviewer production work.

## Event Protocol

### Re-entry and stop precedence

Before the first production action of every turn, after a compaction/resume, and before each new batch or external mutation, read the pinned generation's stop record and the Worker's own terminal state. This is a local permission check, not cross-task monitoring. Follow [lifecycle cancellation](lifecycle.md) if either revokes execution. An automatic `continue`, active native goal, older goal text, or successful handoff delivery does not clear a stop. Do not repeat production, verification, handoff delivery, or goal creation after a terminal event merely because a scheduler starts another turn. Only safe reconciliation of an already-started action and a missing stop receipt remain authorized.

Check `goal_mode` before any goal API call. With `file-contract`, never create a native goal. With native mode, unavailable cancellation/readback capability blocks native goal creation; use the dispatch capability procedure, not an invented terminate API or `update_goal` misuse.

Normal production events are:

- `milestone_complete`
- `technical_handoff_required`
- `user_gate_required`
- `acceptance_complete`
- `delivery_failed`

An explicit pause uses the deletion receipts defined in [lifecycle](lifecycle.md).

Routine progress and subprocess noise do not create events unless the objective-progress lease expires or a shared signature contaminates two items.

For every terminal event:

1. Atomically enter `terminal_event_pending`. Stop new claims, refills, and actions.
2. Let one already-started mutation reach only its required safe reconciliation boundary. Start no successor.
3. Build the compact packet from that boundary and record process/action liveness and observed side effects.
4. Call the recorded direct-message tool with the exact Reviewer task and host IDs.
5. Treat only a successful tool result as delivery.
6. End the Worker turn immediately. Its local final may only say the event was delivered.

The terminal state persists across turns. For user/Reviewer stops, persist revocation before attempting delivery or native cancellation. Native goal deletion, safe process stop, and receipt delivery are separate facts; use lifecycle cancellation evidence, not an idle/final status, to claim automatic continuation was removed.

If delivery fails, do not retry blindly, wait, poll, or claim completion. Preserve work and end locally with:

```text
delivery_failed
intended_event_type:
reviewer_task_id:
error_signature:
undelivered_packet:
```

## Objective-Progress Lease

The Worker evaluates a deterministic lease after every completed natural action boundary.

- Name the smallest acceptance-relevant signals, such as a new deliverable, newly packet-ready item, accepted completion, fewer missing requirements, or smaller closure distance.
- Before dispatch, the Reviewer defines natural boundaries and signals for this goal. Multi-step preparation may use a bounded composite action or a verifiable prerequisite artifact tied to a named acceptance gap. A new file alone is not progress. The Worker cannot redefine boundaries, signals, or the stall window during execution; a mismatch uses the normal handoff and fresh-goal path.
- Default stall window: two completed natural boundaries.
- Renew only when a named signal advances.
- Never renew from liveness, elapsed time, calls, generations, claims, refills, cursor movement, queue changes, `continuation_advanced`, a new error signature, or `blocker_removed` without a smaller acceptance gap.
- A time checkpoint is only a soft observation. It cannot stop a goal whose objective signals advance.
- When the stall window expires, enter `terminal_event_pending` and deliver `technical_handoff_required` with `failed_signature: objective_progress_lease_expired`.
- If the same normalized failure signature or allegedly item-local evidence reference reaches two independent items, escalate at the next safe boundary without waiting for the stall window.

The lease handoff includes boundary count, prior/current signal values, top signature or repeated evidence hash, affected item IDs and distinct-item counts, exact controller/writer liveness, and observed side effects.

## Technical Handoff Packet

The Worker sends:

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

`attempted_recoveries` may contain only authorized item-local runtime actions, never repo edits, tests, publisher runs, or repair successors. Set `user_confirmation_required: true` only for new live permission, broader product scope, credentials, a changed safety boundary, an external dependency, or a real user decision.

For `acceptance_complete`, use the packet in [acceptance](acceptance.md) and deliver it through the terminal event protocol above.

## Local Process Rule

Silence alone is not failure for a Worker-owned synchronous child process:

- measure timeout from the real process start, not turns or tool calls;
- inspect the exact PID/job, liveness, CPU movement, output artifacts, and declared timeout;
- if evidence advances, keep waiting on that same local action; never launch a duplicate;
- escalate after the bounded timeout plus two fresh local probes, or deterministic failure;
- immediately before handoff, check completion once and cancel a stale blocker if the action finished.

This local process wait is not cross-task waiting.
