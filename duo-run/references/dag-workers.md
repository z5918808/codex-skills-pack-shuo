# Task sizing and opt-in DAG Worker tasks

Canonical allocation contract for duo-run and astra-luna-duo. Reviewer reads before deciding whether to dispatch; dispatched Workers read the ownership, identity and stop rules applicable to their assignment. Pin this file with the invoking skill. This is a two-role workflow: one Reviewer, zero to five Luna Worker tasks, not extra reviewers or nested controllers. Skill maintenance starts no runtime tasks.

## Trigger and approval before task creation

Choose the cheapest adequate execution mode from scope, dependencies, write ownership and handoff cost; do not ask the user to choose a Worker count.

- **Small / direct:** short advice, one localized correction, a simple configuration change or a bounded check whose briefing and review would cost more than execution stays with Main. Create zero Worker tasks, goal files or DAG reports. Follow Main's existing model/effort and local permission rules; if blocked by those rules, report that specific blocker rather than spawning Workers as a workaround.
- **Substantial / serial:** a coherent execution segment with no useful independent branches uses one Luna max task. Do not split it merely to populate the sidebar.
- **Substantial / parallel candidate:** propose a DAG only when at least two useful segments have independent preparation, explicit inputs/outputs and nonoverlapping write ownership or immutable handoff artifacts, and parallel benefit plausibly exceeds briefing, review and integration cost. A long checklist, many files, the word DAG or a skill invocation alone does not meet this trigger. Shared mutable state, unresolved dependencies and cheap tiny subtasks stay serial.

For qualifying work, first ask one concise question with the recommended branches, expected useful Worker count, and material coordination cost. Until the user explicitly approves DAG for this goal, create no parallel Worker tasks, make no DAG dispatch, and do only independent authorized preparation or serial work. Explicit approval already given for this goal needs no repeat; a general skill invocation or this configuration edit is not DAG approval. After approval, automatically dispatch/refill within that approved scope, allocating at most five concurrently assigned or creating Worker slots A–E, each exactly `gpt-5.6-luna` with `thinking=max`. Pending or ambiguous creations reserve capacity; no sixth Worker and no model fallback. Use fewer when readiness, host capacity or actual useful work is lower. Reuse safely reconciled idle slots; do not create an accumulating task per node. The Reviewer is outside this five-Worker cap. One immutable rules version covers all participants.

The user's explicit activation of either skill for an execution goal requests the ordinary serial Worker task when needed. Parallel task creation additionally requires explicit DAG approval for that goal; editing or installing the skill grants neither execution nor future DAG approval. Preserve original invocation evidence and apply existing model dispatch gates per Worker. This grants no new Astra/Sol participant, external write or worktree permission. Ordinary small work needs no dispatch or dispatch gate.

## Streaming scheduling and write ownership

Reviewer alone records the approved DAG in existing task state/receipts: `node_id`, prerequisites, output/acceptance evidence, allowed write paths or resource, owner slot, assignment generation, state and failure/release condition. This file owns DUO-specific streaming, task transport and lifecycle; no second scheduler or reporting template is needed.

Dispatch only nodes whose prerequisites have Reviewer-accepted evidence, required authority and an available write resource. A node may carry a coherent sequence; do not dispatch trivial steps separately. Fill the useful ready set up to the cap before yielding. On a delivered result, reconcile and accept that node, release its eligible successors immediately and refill free slots without waiting for unrelated Workers or an entire wave. A failure pauses its dependents, not independent branches. Reviewer owns diagnosis and repair design; Workers remain execution-only and cannot spawn or assign tasks.

Parallel Workers write only their assigned disjoint paths or private output artifacts, never the shared registry/ledger/queue. Shared-code integration, deployment, live mutation and migration each use a serialized critical lane with WIP=1 and existing permissions. Reviewer owns the coordination state; an explicitly assigned Luna owns full production traversal. Before Reviewer repair touches shared code, quiesce affected writers and descendants; unaffected work may continue. Worktrees still require explicit approval; disjoint local paths or private patch artifacts may be used without inventing that approval.

## Persistent sidebar tasks and transport

Use supported `create_thread` / `send_message_to_thread` task tools, never `spawn_agent`, CLI/background substitutes or a new Reviewer. Resolve the saved project with list_projects when needed. Respect the actual create_thread environment contract and worktree approval; do not silently select local merely to evade a required worktree or create a worktree without authorization.

Keep Main as `[Reviewer] <base title>` and label slots `[Worker A] <specific outcome>` through `[Worker E] <specific outcome>`. One-Worker execution uses A. Strip an existing role prefix before applying one; retain meaningful titles. Do not pin, archive, or reorder unrelated user tasks. If title controls are unavailable, retain IDs/roles in receipts and disclose once.

Bind every dispatch/result/stop receipt to `run_id`, `slot`, `node_id`, assignment generation, task/host ID, contract hash and event identity. Dedup and sole OWNER checks are per assignment and resource, not a prohibition on independent Workers. Reconcile ambiguous creation once by those identities; different slots are not duplicates. A failed send or uncertain creation retains its pending receipt and reserved ownership until reconciled, while unrelated ready slots can proceed.

Worker returns once per terminal segment and yields. Reviewer sends the current ready set of dispatches/stops, then yields; the old single-recipient end-after-send rule applies to Worker returns, not to the first message of a ready set. No cross-task polling, watcher, heartbeat, artificial wake-up or duplicate execution. Tool success is neither consumed evidence nor guaranteed wake-up. Respect higher-priority host requirements for a bounded startup check; do not turn it into ongoing monitoring. Without supported persistent task lifecycle/direct messaging, block dispatch and report the missing capability.

## Stable contracts, independent reuse and cancellation

Use the existing fixed root goal (`DUO_GOAL.md` or `DUO_ASTRA_GOAL.md`) for whole-goal scope, authority, acceptance, rules hashes and run stop-record location. Keep it immutable while any assignment uses it. Keep mutable DAG/task IDs and receipts outside pinned goal files.

Each used slot has one fixed reusable sibling assignment file: `DUO_WORKER_A_GOAL.md` … `DUO_WORKER_E_GOAL.md`, or `DUO_ASTRA_WORKER_A_GOAL.md` … `DUO_ASTRA_WORKER_E_GOAL.md`. Create only used slots, never a new path per node/generation. Reviewer writes the full bounded assignment before creation/redispatch: root path/hash, node/prerequisites and accepted input identities, allowed writes, predefined steps/checks, slot/generation, Reviewer return address, and separate run-level plus assignment-level stop-record paths. Workers verify both root and their own assignment identity on entry/resume and before governed effects.

Existing per-Worker dispatch, terminal, repair, goal reuse and replacement procedures apply to that slot's assignment file and generation. Root goal reuse requires all users terminal/stopped and review resolved; slot reuse requires only that slot terminal/stopped, effects reconciled and review resolved. Updating an idle slot must not invalidate another active slot. No native goal or scheduler is created.

User stop-DUO revokes the run, halts all new dispatches and sends a stop to every nonterminal/possibly-created slot; preserve uncertainty if an ID or delivery is unresolved. Reviewer local repair may revoke only named affected assignments. A Worker checks both run and assignment stop records; a root stop always wins. Persist/read back separate stop records without modifying pinned goals. Late/duplicate results from revoked generations cannot release successors or restore work. Reuse after user stop requires explicit fresh resume and reconciled effects; known stops survive missing files and compaction.

## Acceptance

Reviewer alone accepts per-node evidence and whole-goal completion. Ship requires full root criteria, accepted integrated artifacts, consumed current returns and reconciled effects for every slot, with no unfinished descendant or reserved unknown creation. Dispatch counts are not completed work; claim actual parallel execution only with observed outputs or stages, otherwise report dispatched/unverified. Do not add a report or telemetry system merely to prove concurrency.

For skill maintenance only, use [DAG regression fixtures](regression-checks.md#task-sizing-and-opt-in-dag-coverage).
