# Dispatch

Reviewer: read before dispatch. Establish Main's identity using [the entrypoint's identity rule](../SKILL.md#establish-mains-identity-without-changing-the-thinker), not its role title or historical route. Main identity is recorded but never selects or replaces the Thinker. For reuse or replacement, first satisfy [lifecycle](lifecycle.md); a fresh task uses this document directly.

## Visible Role Labels

Use `[Reviewer]`, `[Thinker]`, and `[Worker]` for the three independent tasks, preserving their base titles. Titles identify roles, never actual models. Missing title control is not a substitute for missing task identity.

## Independent Thinker dispatch

Every Main pairs with one separate persistent user-visible `gpt-6-astra` Thinker task, default effort medium. Preserve explicit supported Astra effort overrides. Main cannot satisfy or replace this support role, even when Main is Astra. Thinker is never a Reviewer, readiness owner, acceptance owner, or clearance gate. Never use a subagent or CLI substitute for Thinker support.

Before dispatch, require `python C:\Users\user\.codex\scripts\verify_subagents_disabled.py` to pass, then apply the actual model gate to the independent-task route and current task-bound invocation/approval evidence. A gate named `subagent_model_gate.py` does not authorize native child dispatch. The Thinker must have a stable task ID whose exact-ID read matches the expected role and workspace. A positive ordinary-list match can discover a task, but list omission cannot invalidate an exact-ID match. Missing supported task creation, direct messaging, exact-ID identity, or model capability blocks that dependent question; do not invent a fallback.

Reuse the existing Thinker after its previous assignment is terminal, delivered, ingested and effects reconciled. When creation is needed, use the supported task tool with explicit selected model/effort and a complete bounded initial assignment. Discover the project first; use the approved saved local project for read-only repo analysis, never an unapproved worktree. Reconcile ambiguous creation once; retain one Thinker OWNER and never retry from task-list omission alone.

Keep substantive support research in that independent Thinker task so Main need not load the research conversation. Reuse its relevant accumulated findings across planning, mid-run investigation, and zoomout; a new question or phase is not a reason to create a new Thinker. Main supplies the original outcome and constraints initially, then sends changed facts, failed attempts, current evidence references and the precise support question with the current complete contract reference. Do not copy either role's full transcript, repeat settled research, or use subagents to protect Main's context.

Thinker returns only decision-relevant advice, reasons, options, assumptions, unresolved uncertainty and locatable evidence under the existing compact reporting contract. It never returns `ready`, `ship`, `fix-first`, `rethink`, approval, clearance, or a review verdict. Main verifies the advice and owns every decision. Retain necessary reproducible research evidence once and reference it; avoid duplicating raw logs or scratch reasoning into Main or repo notes. Persistence is not unlimited memory: after compaction or changed evidence, recover the needed sources, recheck affected assumptions and explicitly supersede stale findings. Neither prior conversation nor model capability supplies missing facts or current authority.

Include `task_id / role / scope / permissions / rules_ref / rules_hash / state_version / next_action`, original outcome, question ID, relevant evidence and unresolved findings, actual Main task/return tool, and stopping condition. Initial support binds the existing draft/dispatch revision; later work binds the current goal generation/hash. Thinker is read-only except required support artifacts and direct result delivery: no review verdict, shared repair, production, or further delegation.

Ask for one coherent decision bundle: recommendation, reasons, material assumptions, what to omit, decomposition where needed, decisive verification and unresolved findings. Main ends its turn after dispatch. Thinker sends its result through [reporting](reporting.md) with a successful tool receipt before local final; reuse that task for later scoped questions.

## Main-owned opening with Astra support

Apply SKILL.md's Main-owned opening rule. Main reviews the plan, readiness, and acceptance evidence; normal phases and new assignment generations reuse that locatable Main review when it remains current. A new generation alone never requires a Thinker call. Main maintains the Worker brief for ordinary transitions directly and sends only a bounded unresolved support question to the independent Astra Thinker when useful.

TRIO activation still launches or reuses the independent Astra Thinker task regardless of Main's model, but this never transfers review authority. If a bounded opening support question is assigned, send the original request, relevant evidence, boundaries, and the short reframing prompt; consume its advisory result and record its identity/receipt separately from Main's decision. Main may adopt, reject, or verify the advice, then records readiness and pins the checklist from its own review. Do not send a Thinker assignment merely to approve wording, a deterministic repair, or Main's completed review. Main-owned readiness and acceptance never require Astra clearance.

## Worker brief for sustained execution

Before refining the brief, Main challenges its necessity: state the user's actual outcome, delete unsupported prerequisites, identify the minimum sufficient inputs, and separate consequential uncertainties from details the Worker can decide. Thinker may support a genuinely unresolved judgment, but its advice does not establish the brief or acceptance. Do not inherit a proposed traversal or evidence burden as a user requirement. Name the concrete user outcome or safety invariant protected by each additional prerequisite; omit unsupported additions.

When current placement or content may already be suitable, use a keep-or-correct route if it meets the request. Retrieve additional data or alternatives only when they can change that item's decision. Do not make a full taxonomy study, complete product dossier, or unrelated-field audit a default prerequisite. Use a few representative cases to prove the method rejects meaningful errors, then let Worker complete the required coverage. Sampling proves the method, not completion of unreviewed items.

Main prepares and reviews this compact brief in the existing goal/dispatch artifact. When key facts are still unknown, mark the corresponding part unresolved; Main may ask the Thinker to suggest the smallest discovery needed instead of inventing an executable plan. Main verifies any suggestions before dispatch. The brief is required content, not a new schema or an instruction to fill empty boilerplate.

| Brief content | What Luna must be able to determine |
| --- | --- |
| Outcome and acceptance | Concrete deliverable, coverage, criterion IDs, required proof, and a plausible wrong result the check must reject. |
| Relevant context | Confirmed decisions, inputs, current baseline, supported entrypoint/fixture, known failed approach and cause if relevant, and only the needed paths/pinned references. |
| Coherent work segment | What to finish autonomously, dependency order, natural action boundaries, useful progress signals, and where completion or a decision ends this assignment. Multiple authorized phases may stay in one assignment. |
| Judgment and permission | Routine choices Luna may make; protected state, allowed operations, and decisions that require handoff. Never delegate shared code repair or imply live permission. |
| Verification and recovery | Appropriate checks, expected results/tolerances, evidence to retain, how to avoid repeating completed effects, and the existing stop/shared-defect escalation conditions. |
| Return contract | Reviewer chat/tool, assignment/generation, pinned reporting.md, required result/blocker payload, and direct delivery before local final. |

During opening review, Main asks: Can Luna start without repeating broad investigation or guessing a consequential decision? Can it tell success from a false green? Is the segment large enough to complete useful work without per-step approvals, yet bounded by known dependencies and permission? Are ordinary execution choices distinguished from shared defects and authority changes? Is the return route explicit? If Astra support is used, request concrete gaps and the cheapest decisive evidence, not a verdict, full duplicate implementation, or rewrite for style.

Before dispatch, Main resolves material gaps and confirms the final brief and criteria with its own evidence-based review. Thinker advice may inform but never approve them. Bundle independent or sequential work only when the same authorized contract and safe boundaries cover it; do not enlarge a live/bulk action merely to reduce messages. Do not issue “continue” with no executable objective. On correction, supply the specific delta plus the current complete contract reference, not a replacement transcript. A complete revised acceptance packet is still required at closing, even when the correction prompt is concise.

## Reviewer Pre-run Readiness

The brief names why its segment must return, what current evidence would permit a larger successor, and the authorized ceiling. Local checkpoints alone do not end an assignment. Preserve small execution batches, per-item proof and proportionate semantic review while avoiding unnecessary terminal handoffs. At the next eligible handoff, reassess a temporary canary ceiling instead of copying it forever. Enlarge only when relevant failure modes are controlled and coverage, dependencies, recovery and authority remain adequate; high pass counts alone, automatic doubling, or a universal batch count are insufficient. New source shapes, unresolved semantic patterns or contradictory evidence require Main to reassess the affected scope. Main pins any larger segment through a reconciled successor contract, never across an active cap; it may request bounded Astra support for an unresolved material judgment, without a sizing-only review round.

Before assigning production, the Reviewer establishes that the proposed route can produce the user's result and that acceptance can reject a plausible wrong result. A complete prompt, valid hashes, installed tools, or a healthy process alone do not prove readiness.

Use the cheapest decisive evidence for the actual uncertainty:

- **Outcome and boundary:** derive the deliverable, coverage, tolerances, and relevant failure cases from the user/project contract. Identify protected state and what must remain functional. Do not add quality requirements after seeing the Worker's result or substitute an easier proxy for the outcome.
- **Runnable assignment:** name the inputs, satisfied dependencies, allowed action or paths, and expected evidence for the current slice. Resolve architecture decisions that block execution before assigning production; an unresolved question can instead be the bounded discovery objective below. Reuse the goal's existing scope and readiness evidence, without a separate checklist or approval step.
- **Executable seam:** inspect the actual entrypoint, inputs, required capabilities, and output consumer. Establish a baseline with current applicable evidence or a bounded read-only probe/reversible fixture through that seam. A helper-only success does not prove its caller works. Reviewer runs only this bounded readiness check; the Worker retains the production traversal.
- **Acceptance discrimination:** identify a representative valid result and the most consequential plausible false-green result, such as omitted items, stale output, a no-op, or a report unsupported by the artifact. Show that the available check distinguishes them. Use known expected output or an existing negative fixture when sufficient; do not build a new test framework or run every imaginable edge case.
- **Continuity when affected:** if dispatch changes scheduling, handoff, stop, or resume, assess normal progress, explicit cancellation, and authorized repair-resume together. A stop check alone cannot establish long-run readiness. Distinguish observed runtime behavior from static reasoning and state any lost capability before dispatch.

Record the readiness conclusion and exact evidence references in the existing dispatch artifact beside the acceptance checklist; do not create another state system. Use `ready` only for the bounded route actually supported. If existing evidence already covers unchanged inputs, interface, and relevant revision, reuse it. A redispatch checks the repaired seam and affected acceptance conditions, not the entire pre-run again.

A deterministic shared defect belongs to [Reviewer repair](repair.md) before production dispatch. If discovery itself is the work, dispatch a bounded discovery objective with an executable probe, an observable finding, and a stopping condition; do not pretend the production route is ready or require the unknown solution in advance. Missing live permission blocks that live probe, while authorized local readiness work continues. When no safe evidence can establish a required capability, name that specific gap instead of dispatching a blind production run or inventing another approval gate.

## Required return route for both delegated roles

Read [reporting](reporting.md) and pin its path/hash in each assignment. Worker and Thinker require an actual Reviewer destination and callable direct-message tool. Both roles require actual direct-message delivery before local final. Record actual receipt and consumption separately. Missing role-appropriate return capability blocks dependent dispatch.

## Execution owner before dispatch

For production or recovery, identify executor=Worker in the existing assignment alongside the exact action, target, no-write preview evidence when required, and actual permission reference. Reviewer preparing or approving the packet does not execute it. A combined preview/apply command must be separated or proven in an isolated fixture before Reviewer use. Follow the SKILL.md repair/execution boundary and repair.md handback for repaired routes. Thinker advice is neither readiness nor user authorization.

## Start and Exactly-Once Dispatch

Before dispatch, record:

- Reviewer task ID and host ID when available;
- actual Reviewer model and effort;
- Worker model and effort;
- workspace and authoritative resume entrypoint;
- scope, permissions, safety boundary, and acceptance criteria;
- a Main-reviewed and Main-pinned acceptance checklist tied to the authoritative contract revision/hash, with criterion IDs, thresholds, and required evidence; note any Astra advice separately without treating it as authority;
- the pre-run readiness conclusion, baseline/representative-result evidence, and the false-green case the acceptance check rejects;
- exact direct-message tool;
- `goal_mode=file-contract`, the fixed absolute `TASK_GOAL.md` path, its SHA256, a unique `run_id`/`generation`, and absolute `stop_record_path` outside the goal/rules files; see [lifecycle cancellation](lifecycle.md);
- a dedup key from `Reviewer task ID + authority generation/action + normalized Worker goal`.

Use the entrypoint authority rules for the checklist. Read [Worker execution](worker.md) to define the progress boundaries, event delivery, and local process contract before constructing the goal. Pin the entrypoint and applicable reference files by absolute path and SHA256, including the Worker's later acceptance and pause procedures. Each role reads a reference only when its workflow is needed, verifying the pinned hash before the governed action. A missing or mismatched reference stops that action for handoff, not silent use of a newer file.

New TRIO dispatches use `goal_mode=file-contract` only. Never create a native goal or test native creation. Existing native goals must be reconciled through [lifecycle](lifecycle.md); goal API availability does not change the new-dispatch mode.

In `file-contract` mode the persistent Worker executes the complete task normally until a terminal event. The file records its objective and acceptance, not a scheduler. Do not put a literal `/goal` trigger in the initial prompt or call `create_goal`. Do not introduce another scheduler as a workaround. Pin the stop-record location and generation in the initial prompt.

Then:

1. Reuse the existing exact-ID persistent Worker when lifecycle permits. Select a supported user-visible creation route only when no reusable Worker satisfies the lifecycle criteria; a new assignment, phase, generation, idle state, or task-list omission does not justify replacement. Prepare and hash the goal in steps 2–3 before calling creation in step 4.
2. Before creation, write the complete executable goal to the fixed workspace `TASK_GOAL.md`: mission, authority, scope, permissions, acceptance checklist, stop conditions, Reviewer address, and event contract. Apply the lifecycle reuse checks before overwriting an existing goal. Reviewer is its only writer; read back and hash the final UTF-8 file.
3. The initial prompt contains `ROLE: Worker`, mission, authority, hard boundary, goal path+SHA256, run/generation, and an instruction to verify and read the complete file before acting. This applies to goals of any size. Never create a setup-only Worker, depend on a later goal message, or create dated/per-generation goal copies.
4. Call the creation primitive at most once for the dedup key.
5. Treat timeout, exception, missing receipt, or `Unknown projectId` as ambiguous. Take exactly one immediate `list_threads` inventory. Match by Reviewer ID, dedup or prompt fingerprint, creation window, workspace, and authority. A match is positive evidence; omission is not proof that creation did not occur.
6. If a match exists, dispatch succeeded. Do not retry. Keep exactly one OWNER. Send each duplicate a `terminal_event_pending / duplicate_worker_retired` stop packet before it consumes an action. Archive it only after the receipt proves no controller or writer started.
7. If the inventory returns no match, keep creation ambiguous and stop dependent dispatch without retry or fallback creation. Resume only from a later authoritative creation result or an exact stable task ID that resolves to the matching task.
8. Before the OWNER consumes the canonical action, prove at most one matching controller tree and one writer WIP. A non-owner that sees an in-flight action stops; it never waits on or inspects the OWNER.
9. Apply the role titles. For a newly created or replacement Worker only, take one immediate `read_thread` snapshot to prove its turn started and identify the OWNER.
10. End the Reviewer turn. Do not wait for completion.

If ownership cannot be mapped, freeze new claims, refills, and writes and send a Reviewer incident. Never guess.

Do not call native goal APIs to assign a token budget. Counts such as “one Worker” or “30 items” are not token budgets.

## Worker Goal Shape

Use this compact shape in `TASK_GOAL.md`, referenced by the fresh Worker's initial prompt or one authorized follow-up to an existing Worker. Apply [lifecycle](lifecycle.md) first: file reuse requires the prior generation's stopped state, no in-flight side effects, and resolved review. If an old native goal exists, reconcile it before file-contract dispatch; do not require deletion of a nonexistent native goal:

```text
ROLE: Worker

goal_mode: file-contract
goal_path: <fixed absolute workspace path to TASK_GOAL.md>
run_id / generation / absolute stop_record_path

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

Put task IDs and creation/title/archive receipts in the external dispatch receipt. Keep `TASK_GOAL.md` unchanged while its generation is active or awaiting acceptance. A missing file or changed hash stops dependent work for reconciliation; never adopt the new contents automatically. Record the failed identity/hash in the existing receipt, safely stop the old generation, and apply lifecycle reuse before writing a fresh goal at the same path. A file mismatch alone does not require replacing the Worker task or making an archival goal copy.
