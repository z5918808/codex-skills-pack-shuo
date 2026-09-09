# Worker Execution

Worker: read before the first production action. Use exactly `gpt-5.6-luna/max` and follow the entrypoint execution-only boundary: no management, brainstorming, debugging, planning or self-directed fixes. Reviewer reads this when preparing a goal; it does not authorize Reviewer production work.

## Evidence by Work Phase

Use only the phases needed for the assigned objective, within the same persistent Worker and pinned scope:

- Evidence collection: execute Reviewer-named probes/lookups and return observed facts and unresolved questions; do not design an investigation or choose a solution.
- Execution: return the authorized artifact or change and its relevant verification results. This phase does not grant repo/shared-code repair authority; shared defects still belong to the Reviewer.
- Correction execution: follow explicit Reviewer-provided correction steps within a fresh authorized goal and return predefined check results. Diagnosis, fix design and shared-code changes remain Reviewer-owned.

A goal may include several phases. Phase transitions already covered by that goal need no new message, task, or acceptance gate; use the existing terminal events and lifecycle rules when scope or authority changes. Do not split healthy work into extra handoffs merely to label phases.

## Event Protocol

### Re-entry and stop precedence

Before the first production action of every turn, after a compaction/resume, and before each new batch or external mutation, read the pinned generation's stop record and the Worker's own terminal state. This is a local permission check, not cross-task monitoring. Follow [lifecycle cancellation](lifecycle.md) if either revokes execution. An automatic `continue`, active native goal, older goal text, or successful handoff delivery does not clear a stop. Do not repeat production, verification, handoff delivery, or goal creation after a terminal event merely because a scheduler starts another turn. Only safe reconciliation of an already-started action and a missing stop receipt remain authorized.

After the stop/terminal check, verify the fixed `DUO_GOAL.md` path against the dispatched run/generation and SHA256 at these same action boundaries. A missing or changed goal stops dependent work for handoff; never recreate it, edit it, or adopt a later generation without a fresh authorized dispatch. Reviewer alone writes, deletes, or reuses this file.

New DUO work uses `file-contract` and never creates a native goal. An unexpected existing native goal must use lifecycle reconciliation, not an invented terminate API or `update_goal` misuse.

Normal production events are:

- `milestone_complete`
- `technical_handoff_required`
- `user_gate_required`
- `acceptance_complete`
- `delivery_failed`

An explicit pause uses the deletion receipts defined in [lifecycle](lifecycle.md).

Routine progress and subprocess noise do not create events. An error, ambiguity or failed predefined check requires a safe technical handoff without waiting for a repeated failure; the progress lease also catches silent lack of progress.

For every terminal event:

1. Atomically enter `terminal_event_pending`. Stop new claims, refills, and actions.
2. Let one already-started mutation reach only its required safe reconciliation boundary. Start no successor.
3. Build the compact packet from that boundary and record process/action liveness and observed side effects.
4. Call the recorded direct-message tool with the exact Reviewer task and host IDs. End the result message with 「依整體目標與目前進度，我下一步應完成哪個具體成果？」; do not send a separate follow-up question or choose the next task yourself.
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

`attempted_recoveries` records only required reconciliation of an already-started action, otherwise none; it grants no trial fixes, debugging, retries or repair successors. Report the observed missing input/permission rather than inventing a diagnosis. Permission advice cannot override the Reviewer's check of actual authority.

For `acceptance_complete`, use the packet in [acceptance](acceptance.md) and deliver it through the terminal event protocol above.

## Local Process Rule

Silence alone is not failure for a Worker-owned synchronous child process:

- measure timeout from the real process start, not turns or tool calls;
- inspect the exact PID/job, liveness, CPU movement, output artifacts, and declared timeout;
- if evidence advances, keep waiting on that same local action; never launch a duplicate;
- escalate after the bounded timeout plus two fresh local probes, or deterministic failure;
- immediately before handoff, check completion once and cancel a stale blocker if the action finished.

This local process wait is not cross-task waiting.
