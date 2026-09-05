# Dispatch

Reviewer: read before dispatch. For reuse or replacement, first satisfy [lifecycle](lifecycle.md); a fresh task uses this document directly.

## Visible Role Labels

Use these titles as soon as both task IDs exist:

- `[Reviewer] <base title>`
- `[Worker] <base title>`

Remove one existing role prefix before adding the correct one. Never stack or swap prefixes. Keep the meaningful base title. For a new Worker, put `ROLE: Worker` first in its initial prompt, create it once, then title it.

Take one immediate inventory/title snapshot to verify task IDs and titles. This is lifecycle verification, not Worker monitoring. If title control is unavailable, do not block valid work; put `ROLE: Reviewer` or `ROLE: Worker` first in the next packet and report the missing title capability once.

## Start and Exactly-Once Dispatch

Before dispatch, record:

- Reviewer task ID and host ID when available;
- actual Reviewer model and effort;
- Worker model and effort;
- workspace and authoritative resume entrypoint;
- scope, permissions, safety boundary, and acceptance criteria;
- a Reviewer-derived acceptance checklist pinned to the authoritative contract revision/hash, with criterion IDs, thresholds, and required evidence;
- exact direct-message tool;
- `goal_mode` (`file-contract` by default), a unique `run_id`/`generation`, and absolute `stop_record_path` outside the immutable goal/rules files; see [lifecycle cancellation](lifecycle.md);
- a dedup key from `Reviewer task ID + authority generation/action + normalized Worker goal`.

Use the entrypoint authority rules for the checklist. Read [Worker execution](worker.md) to define the progress boundaries, event delivery, and local process contract before constructing the goal. Pin the entrypoint and applicable reference files by absolute path and SHA256, including the Worker's later acceptance and pause procedures. Each role reads a reference only when its workflow is needed, verifying the pinned hash before the governed action. A missing or mismatched reference stops that action for handoff, not silent use of a newer file.

Before choosing `goal_mode=native`, verify that the actual Worker route exposes creation, termination/deletion, and fresh state readback proving the automatic goal absent. `get_goal`/`create_goal`/`update_goal(complete|blocked)` alone do not meet this requirement; neither do an archive action nor a promise to delete later. If capability differs on Worker entry, do not create a native goal. Use `file-contract` unless the user explicitly requires native scheduling, in which case report the missing cancellation capability. Do not start a disposable native goal merely to test deletion.

In `file-contract` mode the persistent Worker executes the complete task normally until a terminal event. The file records its objective and acceptance, not a scheduler. Do not put a literal `/goal` trigger in the initial prompt or call `create_goal`. Do not introduce another scheduler as a workaround. Pin the stop-record location and generation in the initial prompt.

Then:

1. Resolve or create one persistent Worker with `create_thread`, `fork_thread`, or an equivalent user-visible task operation.
2. A fresh Worker's initial prompt must contain the complete executable goal: `ROLE: Worker`, mission, authority, scope, boundaries, acceptance, Reviewer address, and event contract. Never create a setup-only Worker that depends on a later goal message.
3. If the complete goal is too large, save it once as an append-only UTF-8 artifact. Put its absolute path and SHA256 in the initial prompt with the mission, authority, hard boundary, and an instruction to verify and read it before acting.
4. Call the creation primitive at most once for the dedup key.
5. Treat timeout, exception, missing receipt, or `Unknown projectId` as ambiguous. Take exactly one immediate `list_threads` inventory. Match by Reviewer ID, dedup or prompt fingerprint, creation window, workspace, and authority.
6. If a match exists, dispatch succeeded. Do not retry. Keep exactly one OWNER. Send each duplicate a `terminal_event_pending / duplicate_worker_retired` stop packet before it consumes an action. Archive it only after the receipt proves no controller or writer started.
7. Use one fallback creation path only when the inventory proves no match exists. Keep the same dedup key.
8. Before the OWNER consumes the canonical action, prove at most one matching controller tree and one writer WIP. A non-owner that sees an in-flight action stops; it never waits on or inspects the OWNER.
9. Apply the role titles. For a newly created or replacement Worker only, take one immediate `read_thread` snapshot to prove its turn started and identify the OWNER.
10. End the Reviewer turn. Do not wait for completion.

If ownership cannot be mapped, freeze new claims, refills, and writes and send a Reviewer incident. Never guess.

Only in verified native mode, omit `token_budget` unless the user explicitly requested a numeric token budget. Counts such as “one Worker” or “30 items” are not token budgets. If an inferred tiny budget causes `budget_limited` before substantive work, stop live work and use the normal replacement path after repairing the contract.

## Worker Goal Shape

Use this compact shape in the fresh Worker's initial prompt or, only after `active_goal_none`, in one follow-up to an existing Worker:

```text
ROLE: Worker

goal_mode: file-contract
run_id / generation / absolute stop_record_path

Workspace and authoritative resume entrypoint.
Fresh state and last successful evidence.
One current interface or action.
Scope, permission, and safety boundary.
Applicable shared reference paths/hashes; verify and read when needed, before the governed action.
shared_self_repair_budget=none; shared repair belongs to the Reviewer.
Reviewer-defined natural action boundaries, objective-progress signals, last renewed snapshot, and boundary stall window.
Known false-block condition and bounded local process-wait rule.
Acceptance checklist reference/hash and criterion IDs.
Reviewer task ID, host ID, event types, and exact direct-message tool.
Terminal delivery requires a successful tool receipt; a local final is not delivery.
Only a defined event may stop the run.
```

Preserve the selected Worker model and effort. Do not steer a healthy Worker repeatedly.

## Hash-Bound Authority

When a Worker goal pins mutable canonical files, use this order:

```text
repair shared seam
→ write final canonical checkpoint
→ read back and hash the checkpoint
→ build and hash the complete Worker goal
→ dispatch exactly once
→ write an append-only dispatch receipt outside pinned state
→ do not change pinned canonical state until the Worker terminal event
```

Put task IDs and creation/title/archive receipts in the external dispatch receipt. A post-goal change that breaks a pinned hash invalidates the goal. Preserve the failed goal and replace the Worker with a fresh checkpoint/goal pair; never weaken or edit the dispatched goal.
