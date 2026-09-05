# Goal Lifecycle

Read for goal reuse/replacement, dead transport, or explicit pause. All fresh goals follow [dispatch](dispatch.md), including hash-bound authority and exactly-once OWNER proof.

## Delete Before Redispatch

After a terminal handoff, repair, `fix-first`, or correction, reuse the same Worker only in this order:

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

Create exactly one fresh Worker with the complete goal in its initial prompt. Reconcile ambiguous creation once, title it, take the one lifecycle snapshot, prove it is the sole OWNER, then archive the old Worker. Record old goal/task state, delete failure, old/new IDs, dedup key, creation and OWNER proof, and archive receipt. Archive failure stops cleanup, records the exact lifecycle error, and does not sacrifice the valid replacement. A later explicit user prohibition or revocation blocks replacement. Never delete thread-store files, kill shared runtime, or replace a healthy or merely slow Worker.

## Dead Transport Replacement

Use the same one-Worker replacement path only when the old Worker is terminal or idle, follow-up transport cannot accept a new turn, it owns no unresolved side effect, and a fresh authoritative action exists under the same boundary. Do not keep messaging a dead task. Archive the old task only after the replacement OWNER is proven.

## User Pause

An explicit `pause`, `暫停`, or `先停` deletes the Worker's unfinished durable goal; it does not delete files or the task.

1. The Reviewer sends exactly one pause packet and ends. It does not wait, poll, or take over.
2. The Worker stops new claims/actions and lets one in-flight mutation reach only its safe reconciliation boundary.
3. The Worker terminates/deletes its active, paused, blocked, or otherwise unfinished goal through the lifecycle interface.
4. It reads goal state fresh and requires explicit `active_goal_none` evidence.
5. It delivers `worker_goal_deleted`, `active_goal_none`, safe-boundary disposition, preserved artifact references, and observed side effects, then ends.

Preserve append-only artifacts, evidence, the Worker task, shared runtime, browser/session state, and file-backed goal contracts. The Reviewer may report the pause complete only from the fresh deletion receipt; delivery of the pause request is not deletion proof. If lifecycle deletion is unavailable, keep work stopped and deliver `worker_goal_delete_blocked` with the exact limitation and current goal state. Do not claim deletion, archive as a substitute, or create a replacement. Resume requires a later explicit user instruction and a new complete goal.

## Coordination Cost, When Investigating Performance

When investigating coordination cost, use existing event/dispatch receipts to count handoffs and replacements and measure event-to-redispatch or dispatch-to-first-action intervals where timestamps exist. Mark missing timing evidence as unavailable. These intervals can include queue and tool delay; do not attribute them to a model without evidence. Do not add polling or monitoring, relax lifecycle proof, or change model routing merely to collect timings.
