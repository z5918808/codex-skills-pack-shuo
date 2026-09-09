# Dispatch

Reviewer: read before dispatch after applying [automatic sizing](dag-workers.md). The creation/OWNER steps below apply per slot and assignment; fill the useful ready set before yielding. For reuse or replacement, first satisfy [lifecycle](lifecycle.md); a fresh task uses this document directly.

## Visible Role Labels

Use these titles as soon as the Reviewer and each Worker task ID exist:

- `[Reviewer] <base title>`
- `[Worker A] <specific outcome>` through `[Worker E] <specific outcome>`

Remove one existing role prefix before adding the correct one. Never stack or swap prefixes. Keep the meaningful base title. For a new Worker, put `ROLE: Worker` first in its initial prompt, create it once, then title it.

Take one immediate inventory/title snapshot to verify task IDs and titles. This is lifecycle verification, not Worker monitoring. If title control is unavailable, do not block valid work; put `ROLE: Reviewer` or `ROLE: Worker` first in the next packet and report the missing title capability once.

## Reviewer Pre-run Readiness

Before assigning production, the Reviewer establishes that the proposed route can produce the user's result and that acceptance can reject a plausible wrong result. A complete prompt, valid hashes, installed tools, or a healthy process alone do not prove readiness.

Use the cheapest decisive evidence for the actual uncertainty:

- **Outcome and boundary:** derive the deliverable, coverage, tolerances, and relevant failure cases from the user/project contract. Identify protected state and what must remain functional. Do not add quality requirements after seeing the Worker's result or substitute an easier proxy for the outcome.
- **Runnable assignment:** name the inputs, satisfied dependencies, allowed action or paths, and expected evidence for the current slice. Resolve architecture decisions that block execution before assigning production; an unresolved question stays with Reviewer; Worker may execute the explicit evidence-collection probes below. Reuse the goal's existing scope and readiness evidence, without a separate checklist or approval step.
- **Executable seam:** inspect the actual entrypoint, inputs, required capabilities, and output consumer. Establish a baseline with current applicable evidence or a bounded read-only probe/reversible fixture through that seam. A helper-only success does not prove its caller works. Reviewer runs only this bounded readiness check; the Worker retains the production traversal.
- **Acceptance discrimination:** identify a representative valid result and the most consequential plausible false-green result, such as omitted items, stale output, a no-op, or a report unsupported by the artifact. Show that the available check distinguishes them. Use known expected output or an existing negative fixture when sufficient; do not build a new test framework or run every imaginable edge case.
- **Continuity when affected:** if dispatch changes scheduling, handoff, stop, or resume, assess normal progress, explicit cancellation, and authorized repair-resume together. A stop check alone cannot establish long-run readiness. Distinguish observed runtime behavior from static reasoning and state any lost capability before dispatch.

Record the readiness conclusion and exact evidence references in the existing dispatch artifact beside the acceptance checklist; do not create another state system. Use `ready` only for the bounded route actually supported. If existing evidence already covers unchanged inputs, interface, and relevant revision, reuse it. A redispatch checks the repaired seam and affected acceptance conditions, not the entire pre-run again.

A deterministic shared defect belongs to [Reviewer repair](repair.md) before production dispatch. If discovery itself is the work, Reviewer chooses the investigation and may dispatch explicit probes with observable findings and a stopping condition; do not pretend the production route is ready or require the unknown solution in advance. Missing live permission blocks that live probe, while authorized local readiness work continues. When no safe evidence can establish a required capability, name that specific gap instead of dispatching a blind production run or inventing another approval gate.

## Start and Exactly-Once Dispatch

Before dispatch, record:

- Reviewer task ID and host ID when available;
- actual Reviewer model and effort;
- Worker model and effort, verified exactly `gpt-5.6-luna/max` under the applicable model/task gates;
- workspace and authoritative resume entrypoint;
- scope, permissions, safety boundary, and acceptance criteria;
- a Reviewer-derived acceptance checklist pinned to the authoritative contract revision/hash, with criterion IDs, thresholds, and required evidence;
- the pre-run readiness conclusion, baseline/representative-result evidence, and the false-green case the acceptance check rejects;
- exact direct-message tool, source-to-A and A-to-Reviewer routes for parallel work, plus the direct Reviewer emergency address;
- `goal_mode=file-contract`, root goal path/hash plus fixed slot `goal_path`/hash, `slot`/`node_id`, run and assignment generations, and separate run/assignment stop-record paths outside goal/rules files; see [lifecycle cancellation](lifecycle.md);
- a dedup key from `Reviewer task ID + run + slot + node + assignment generation/action + normalized Worker goal`.

Use the entrypoint authority rules for the checklist. Read [Worker execution](worker.md) to define the progress boundaries, event delivery, and local process contract before constructing the goal. Pin the entrypoint and applicable reference files by absolute path and SHA256, including the Worker's later acceptance and pause procedures. Each role reads a reference only when its workflow is needed, verifying the pinned hash before the governed action. A missing or mismatched reference stops that action for handoff, not silent use of a newer file.

New DUO dispatches use `goal_mode=file-contract` only. Never create a native goal or test native creation. Existing native goals must be reconciled through [lifecycle](lifecycle.md); goal API availability does not change the new-dispatch mode.

In `file-contract` mode the persistent Worker executes the complete task normally until a terminal event. The file records its objective and acceptance, not a scheduler. Do not put a literal `/goal` trigger in the initial prompt or call `create_goal`. Do not introduce another scheduler as a workaround. Pin the stop-record location and generation in the initial prompt.

Then:

1. Resolve the existing persistent Worker or select one supported user-visible creation route. Prepare and hash the goal in steps 2–3 before calling creation in step 4.
2. Before creation, write the complete executable goal to the fixed slot assignment `goal_path`, referencing the immutable root `DUO_GOAL.md`: mission, authority, scope, permissions, acceptance checklist, stop conditions, Reviewer address, and event contract. Apply the lifecycle reuse checks before overwriting an existing goal. Reviewer is its only writer; read back and hash the final UTF-8 file.
3. The initial prompt contains `ROLE: Worker`, mission, authority, hard boundary, goal path+SHA256, run/generation, and an instruction to verify and read the complete file before acting. This applies to goals of any size. Never create a setup-only Worker, depend on a later goal message, or create dated/per-generation goal copies.
4. Call the creation primitive at most once for the dedup key.
5. Treat timeout, exception, missing receipt, or `Unknown projectId` as ambiguous. Take exactly one immediate `list_threads` inventory. Match by Reviewer ID, dedup or prompt fingerprint, creation window, workspace, and authority.
6. If a match exists, dispatch succeeded. Do not retry. Keep exactly one OWNER for that assignment; other independent slots are not duplicates. Send each duplicate a `terminal_event_pending / duplicate_worker_retired` stop packet before it consumes an action. Archive it only after the receipt proves no controller or writer started.
7. Use one fallback creation path only when the inventory proves no match exists. Keep the same dedup key.
8. Before the OWNER consumes the canonical action, prove one matching assignment owner and WIP=1 for its mutable resource; disjoint slots may run concurrently. A non-owner that sees an in-flight action stops; it never waits on or inspects the OWNER.
9. Apply the role titles. For a newly created or replacement Worker only, take one immediate `read_thread` snapshot to prove its turn started and identify the OWNER.
10. Repeat for the remaining useful ready slots within the five-slot cap, then end the Reviewer turn. Do not wait for completion.

If ownership cannot be mapped, freeze new claims, refills, and writes and send a Reviewer incident. Never guess.

Do not call native goal APIs to assign a token budget. Counts such as “one Worker” or “30 items” are not token budgets.

## Worker Goal Shape

Use this compact shape in the fixed per-slot assignment `goal_path`, referenced by the fresh Worker's initial prompt or one authorized follow-up to an existing Worker. Apply [lifecycle](lifecycle.md) first: file reuse requires the prior generation's stopped state, no in-flight side effects, and resolved review. If an old native goal exists, reconcile it before file-contract dispatch; do not require deletion of a nonexistent native goal:

```text
ROLE: Worker

goal_mode: file-contract
root_goal_path / root_goal_sha256
goal_path: <fixed absolute per-slot assignment path>
slot / node_id / accepted prerequisite artifact identities
run_id / assignment generation / run_stop_record_path / assignment stop_record_path

Workspace and authoritative resume entrypoint.
Fresh state and last successful evidence.
One current interface or action.
Applicable work phase(s) and evidence deliverable; use Worker execution's phase guidance.
Scope, permission, and safety boundary.
Applicable shared reference paths/hashes; verify and read when needed, before the governed action.
shared_self_repair_budget=none; shared repair belongs to the Reviewer.
Reviewer-defined natural action boundaries, objective-progress signals, last renewed snapshot, and boundary stall window.
Known false-block condition and bounded local process-wait rule.
Acceptance checklist reference/hash and criterion IDs.
Reviewer task/host IDs and emergency address; ordinary return task/host IDs (A for parallel producers); relay assignment/roster identity, event types and exact direct-message tool.
Terminal delivery requires a successful tool receipt; a local final is not delivery.
Only a defined event may stop the run.
```

Every new or reused Worker assignment uses exactly `gpt-5.6-luna/max`; unavailable or mismatched settings block dependent dispatch, not safe Reviewer preparation. Reconcile an active legacy assignment before changing its settings. Do not steer a healthy Worker repeatedly.

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

Put task IDs and creation/title/archive receipts in the external dispatch receipt. Keep root `DUO_GOAL.md` unchanged while any slot uses it; keep each assignment goal unchanged while that slot generation executes or awaits acceptance. Mutable DAG receipts stay outside both. A missing file or changed hash stops dependent work for reconciliation; never adopt the new contents automatically. Record the failed identity/hash in the existing receipt, safely stop the old generation, and apply lifecycle reuse before writing a fresh goal at the same path. A file mismatch alone does not require replacing the Worker task or making an archival goal copy.
