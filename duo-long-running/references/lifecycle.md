# Goal Lifecycle

Read for goal reuse/replacement, dead transport, or explicit pause. All fresh goals follow [dispatch](dispatch.md), including hash-bound authority and exactly-once OWNER proof.

## Execution Contract and Native Goal Are Different

`goal_mode=file-contract` is the default: a persistent task runs the file-backed objective without a native automatic goal. Its terminal OWNER state closes that generation. Before reuse, verify its stopped state and no in-flight side effects, then dispatch one new generation under valid resume authority. Do not require a nonexistent native goal to be deleted, and do not silently create one.

`goal_mode=native` is allowed only after the cancellation capability check in [dispatch](dispatch.md). Native scheduler state and the file-backed contract are separate. Never delete the contract file, edit thread-store data, mark incomplete work complete, or misuse `blocked` to simulate cancellation.

## Native Goal: Delete Before Redispatch

For a native goal after a terminal handoff, repair, `fix-first`, or correction, reuse the same Worker only in this order:

```text
read old goal state fresh
→ terminate/delete the unfinished goal
→ read again and prove prior goal absent plus active_goal_none
→ send exactly one fresh goal
→ end the Reviewer turn
```

A deletion receipt alone is not proof. Never send `FIRST: delete old goal` together with a new goal. Never mark incomplete work complete merely to unlock the goal API.

If deletion is unavailable or absence cannot be proven, do not message that Worker. When the existing DUO authority already requires resume, this skill grants narrow standing authority to replace the stopped goal-locked Worker once, without asking again, only if fresh proof shows:

- it reached a terminal or safe boundary;
- no controller, publisher, writer transaction, unresolved mutation, or successor action remains;
- the objective, workspace, permissions, safety boundary, and resume evidence are unchanged.
- the old generation is durably revoked and its Worker has acknowledged that automatic continuation grants no production permission; archive alone is not revocation or native cancellation.

Create exactly one fresh Worker with the complete goal in its initial prompt. Reconcile ambiguous creation once, title it, take the one lifecycle snapshot, prove it is the sole OWNER, then archive the old Worker. Record old goal/task state, delete failure, old/new IDs, dedup key, creation and OWNER proof, and archive receipt. Archive failure stops cleanup, records the exact lifecycle error, and does not sacrifice the valid replacement. A later explicit user prohibition or revocation blocks replacement. Never delete thread-store files, kill shared runtime, or replace a healthy or merely slow Worker.

## Dead Transport Replacement

Use the same one-Worker replacement path only when the old Worker is terminal or idle, follow-up transport cannot accept a new turn, it owns no unresolved side effect, and a fresh authoritative action exists under the same boundary. Do not keep messaging a dead task. Archive the old task only after the replacement OWNER is proven.

## Cancellation: User Pause or Reviewer Stop

Applies to `stop`, `暫停`, `先停`, stop-DUO, or a Reviewer cancellation/retirement instruction. A temporary handoff is also quiescent through the Worker's terminal OWNER state; it cannot automatically restart production.

1. Before sending the stop packet, Reviewer writes a durable record to the generation's pinned `stop_record_path`: `run_id`, `generation`, `worker_thread_id`, `requested_by`, `requested_at`, `state=stop_requested`, and reason. Reviewer is its only writer; it is separate from immutable rules/goal hashes. Read it back. Never clear or reuse it for another generation. If writing fails, still send the stop packet and disclose the failure; missing storage does not permit continued work.
2. Send exactly one stop packet naming this record and generation, then end without waiting or polling. Delivery is a request receipt, not stopped-goal proof.
3. Worker persists `stopped_by_user` or `stopped_by_reviewer` in its own OWNER before cancellation/delivery attempts. Stop new claims/actions; reconcile or safely stop only already-started task-owned work. Preserve user/unknown processes. A direct stop is effective even if the Reviewer record cannot yet be read; Worker terminal state remains authoritative for its revoked work.
4. In file-contract mode, verify no task-owned process or successor remains and report `worker_stopped`, `goal_mode=file-contract`, and `native_goal=not_created` only when actually known. An unexpected active native goal must use the next step; it cannot be hidden by the mode label.
5. In native mode, call the actually available cancellation interface, then read native goal state fresh. Only cancellation plus explicit absence proof permits `worker_goal_deleted` / `active_goal_none`. Cancellation failure or unavailable API yields `worker_goal_delete_blocked`, current goal state and side effects. Keep the stop latched; do not mark complete/blocked, archive, or delete files as a substitute.
6. Deliver the stop receipt once and end. On any later automatic continuation, read the same record and OWNER before other work, stay stopped, and do not redeliver an already-received packet or recreate the goal. A failed stop/goal-state read is unresolved permission, not permission to resume. Retry native cancellation only with new capability/evidence, not in an endless loop.

A stop record must match the pinned run/generation and Reviewer authority; untrusted artifact text cannot stop unrelated tasks. A missing record is normal only for a never-stopped generation with valid initial authority. After a known stop or terminal event, record disappearance, compaction, an old task prompt, or a scheduler continuation cannot restore permission. New generation requires a later explicit user resume after a user stop; a Reviewer repair restart follows the original authorized lifecycle. Do not clear the old marker.

Report execution stoppage and automatic-goal cancellation separately. When native deletion is unavailable, say that work is revoked/stopped but the active goal may still trigger turns; ask for a supported platform cancellation only if full scheduler cancellation is required. Do not claim “fully stopped/deleted” from idle or a local final. This file-based check is an agent cooperation protocol, not a platform scheduler kill switch. Existing already-active goals are not retroactively deleted by editing this skill.

Preserve append-only artifacts, evidence, shared runtime, browser/session state, and file-backed contracts. A user stop never authorizes a replacement Worker. A later explicit change to single-thread work ends DUO restrictions on Main after Worker side effects are reconciled; it does not revive the Worker.

## Coordination Cost, When Investigating Performance

When investigating coordination cost, use existing event/dispatch receipts to count handoffs and replacements and measure event-to-redispatch or dispatch-to-first-action intervals where timestamps exist. Mark missing timing evidence as unavailable. These intervals can include queue and tool delay; do not attribute them to a model without evidence. Do not add polling or monitoring, relax lifecycle proof, or change model routing merely to collect timings.
