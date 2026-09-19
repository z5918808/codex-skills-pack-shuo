# Repo Task Goal

Read when starting, resuming, materially updating, switching workflows or closing a sustained non-native repo objective. This is a document contract, not native Goal mode or a scheduler.

## One authority

Use `<repo>/TASK_GOAL.md` as the sole current authority for the active objective, scope, acceptance, workflow, role ownership, verified progress, blockers and next action. User instructions and permission gates remain higher authority; runtime evidence proves facts. The file grants no permissions and does not start or resume work by itself.

Main is the sole designated writer. In a workflow whose activation task is a Worker, explicitly name the state writer and acceptance owner; they need not be the same task. Other roles return proposed changes and evidence. Never infer ownership from titles; archived tasks cannot be active owners or resume targets.

Use this for sustained non-native implementation and multi-role repo work, including TRIO, DUO and Heavy Duo. Ordinary Q&A, review-only requests and small direct fixes do not require creating or editing a goal. Native goals retain their own lifecycle; this contract does not replace or automatically enable them. Outside a repo, keep the existing task contract unless the user requests this file.

Repo `AGENTS.md` or its existing index must point here as the current task authority. Existing project status, `_ctx`, milestones, specs and ADRs retain their distinct roadmap, index, criteria and decision roles; reference them rather than duplicate current task status. If they currently own the same objective, explicitly transfer that authority and update the pointers at a safe boundary. Do not create a second authority or overwrite another active objective. Concurrent unrelated work needs reconciled repo ownership before adopting the same root file.

## Keep it useful and current

Keep only: original request/correction references; objective and exclusions; permissions and acceptance; workflow and actual role IDs; revision/run/generation and applicable rule/evidence references; verified completed work; unresolved obligations/blockers; one next action with its owner; stop/completion state. Existing subordinate slot assignments are bounded execution instructions, not competing repo goals. No transcripts, duplicate logs or new tracking service.

Update proactively when accepted user guidance, scope, acceptance, workflow, owner, verified progress, blocker or next action materially changes, and before handoff/compaction/closeout. Do not require a separate user request for authorized state upkeep, write for every tool call, or mark planned work complete. Read-only scope still permits only a proposed delta.

While any assignment executes or awaits review against the file's hash, keep that revision immutable. Record a compact pending delta with its original source in the existing receipt outside pinned files. If guidance invalidates execution, stop affected work through its actual lifecycle. At the next safe boundary, reconcile all consumers, returns, processes, side effects and acceptance; then update the same file, increment revision/generation as applicable, reread/hash and dispatch once. A send receipt or idle task alone is not reconciliation. Do not invent monitoring or duplicate goal snapshots to keep status current.

## Switch TRIO / DUO / Heavy Duo

1. Stop new old-workflow assignments; bring every affected role to a verified safe boundary. Reconcile pending deliveries, effects and review. Preserve valid results and unresolved obligations, including an exiting Thinker's findings.
2. Transfer the sole writer and remaining responsibilities explicitly. Retain the original objective, permissions and acceptance unless the user changes them; choose only authorized models/roles under the destination workflow's gates. Switching workflows is no extra model or live-action permission.
3. Update the same `TASK_GOAL.md` with the destination workflow, owners, preserved evidence, remaining work and new revision/generation. Retire/revoke old assignments in existing stop/receipt records before new dispatch. Late old results are evidence for reconciliation, never authority to resume or repeat effects.
4. Dispatch the next authorized assignment exactly once. Reuse only eligible non-archived tasks after reconciliation. User pause/stop still needs explicit later resume; a switch never bypasses unresolved effects or permission gaps.

## Legacy files and closeout

`TRIO_GOAL.md`, `DUO_GOAL.md`, `DUO_ASTRA_GOAL.md` or a custom existing contract stay pinned until old consumers are reconciled. Then transfer the current objective to `TASK_GOAL.md`, update repo pointers/validators and next dispatch references, and mark the legacy authority superseded with a pointer. Preserve required historical proof; no automatic deletion, bulk migration or changes to unrelated running repos during skill maintenance. Do not migrate fixed per-slot assignment files merely because the root changed.

At completion retain `TASK_GOAL.md` with the accepted outcome, evidence, unresolved items and no active next action. At pause retain the stop state and resume condition. It is repo authority, not disposable scratch. Reuse it for a later authorized objective only after prior ownership/results/effects are reconciled. Deletion requires an explicit request that also resolves the repo authority pointer.

## Maintenance checks

Verify these scenarios by inspecting affected instructions; static checks do not prove live behavior:

- Mid-run TRIO → DUO: reconcile every old consumer, carry evidence/Thinker obligations forward, retire old generations, then dispatch under one updated root.
- User correction during execution: pending delta outside the pinned file, affected stop if needed, one safe revision and no duplicate execution.
- Existing legacy/custom root or project-status authority: keep active hash valid, migrate only at a safe boundary, update pointers, no competing current goal.
- Paused or archived owner: no automatic resume or reuse; completion retains the authoritative file.
- Small/read-only/native task: no forced goal-file creation, writes or native-mode conversion.
