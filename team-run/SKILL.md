---
name: team-run
description: "Run TEAM RUN or /team-run for complex delegated goals; one captain owns integration and acceptance, not persistent DUO."
---

# TEAM RUN / 影分身之術

One reviewer owns the thinking, decisions, coordination, integration, and final acceptance; shadow clones perform bounded repetitive work. The reviewer is the captain referenced below and in coordination.md, not an additional leader agent. The activation conversation is the reviewer unless the user explicitly names another. Keep `name: team-run`; `/影分身之術` is an invocation alias for the same skill, not a duplicate skill. Creating or reviewing this skill does not start a squad.

## Operating shape

- **Reviewer (captain):** own problem framing, architecture, uncertain diagnosis, tradeoffs, and acceptance decisions; derive acceptance from the user/project contract, split work, assign ownership, schedule dependencies, resolve cross-lane conflicts, integrate, and verify delivery. Keep one user-facing endpoint and one writer for canonical state and the integrated deliverable. Preserve the captain's current model; do not create a replacement leader.
- **Shadow clones (workers):** bounded one-shot subagents only for time-consuming repetitive work with reviewer-defined rules and objectively checkable outputs, such as repeated data extraction, patterned edits, or running prescribed checks. Give each a concrete output, assigned input baseline, permitted output area, and acceptance criteria. If the task needs new reasoning, an architectural choice, ambiguous interpretation, or changed acceptance, return that question to the reviewer instead of deciding it. Produce immutable artifacts or patches for the captain. No recursive delegation, shared-state edits, self-expanded scope, or self-certified delivery.
- **Review:** the captain always checks evidence and integration. Add an independent bounded reviewer for explicit review requests, material risk, complex changes, or unresolved conflicting evidence. A reviewer does not become a second captain or rewrite acceptance.

DUO owns a persistent Reviewer/Worker pair with its own transport constraints. TEAM RUN owns multiple work lanes and replaces terminal workers with fresh bounded assignments. Do not import DUO's persistent-task lifecycle or no-wait rules. Use native subagent tools for subtasks; only create user-visible tasks when the user explicitly requests new tasks.

## Frame the goal before dispatch

1. Identify the intended result, scope, exclusions, current authority, and observable acceptance. Separate locally authorized implementation from external/live actions. Planning or diagnosis alone authorizes no implementation.
2. Read relevant current files and the repo's declared state entry if one exists. Preserve user changes. For cross-session or long-running work, apply the available continuity/state skills; a bounded run needs no new governance files.
3. The reviewer resolves unknown contracts and major decisions before defining repetitive worker lanes by deliverable and dependency; do not delegate primary thinking as a discovery lane. Each item has inputs, output contract, owner, acceptance, and explicit prerequisites. Resolve cycles or assign a contract-discovery item before dispatching dependent implementation.
4. If the prompt provides no configuration, the reviewer autonomously chooses the work split, clone count, and scheduling; do not ask for routine configuration. Minimize expected total resource use (context, agent startup, retries, and reviewer rework), not just per-call cost, while preserving correctness and acceptance. Keep the Terra medium clone default; small indivisible tasks stay with the reviewer. Batch coherent repetitive items, pass only needed inputs, and add a clone only when its useful work justifies coordination overhead. Choose the smallest useful squad. Use only the number justified by ready repetitive work; the user may set a different count in the prompt, subject to runtime capacity and reviewer integration capacity. Increase only when independent ready work, available capacity, and the captain's integration capacity justify it. User budgets and runtime limits win.
5. Keep shared edits, final integration, and live actions in the captain's single-writer lane. Workers write their own isolated artifacts; do not create worktrees without approval. If safe output isolation is unavailable, parallelize read-only preparation and serialize mutations.

## Establish the dispatch contract

Every worker/reviewer assignment and retry includes the applicable reference/hash for Outcome-first verification（所在專案適用的驗收規則；主機需自行提供） and requires recipients to read it.

Before dispatch read [coordination.md](references/coordination.md) for packet and board fields. Use the existing runtime's tools and gates; discover their actual interfaces instead of inventing commands.

- Pin one immutable shared rules bundle and hash, scoped role references, input hashes, state version, and run generation. Keep shared behavior in its canonical skill/docs; packets point to pinned references instead of copying the rules. Verify each worker's loaded rule hash before accepting its output; before any external mutation, missing or mismatched authority proof fails closed.
- Apply the host's current model, parent and task authorization checks to the actual selected model/effort. Workers default to listed Terra/medium, including repetitive translation; separate Reviewers default to gpt-6.1-sol/medium. The captain preserves its actual model. Explicit current task selections override defaults within their authorized scope; never inherit Sol/Astra consent merely from the captain's model. Missing required gates, unsupported models or incompatible loaded roles stop the dependent dispatch, with no silent substitution or parent-rule bypass. This public version requires no author-specific gate scripts.
- A missing/failed dispatch gate or unavailable subagent capability blocks delegation and its dependents. Continue independent authorized local preparation; describe the squad as not started. Do not emulate a squad with shell background jobs or silently report captain-only work as parallel execution.
- Claim ownership only after a dispatch receipt binds the planned task ID to an actual agent ID. A created agent alone does not prove useful work has started.

## Schedule work as outputs become ready

Use the dependency/ownership contract below. If the project requires a separately installed streaming-DAG workflow, follow its real contract as well. Claim actual concurrency only from observed runtime/effect evidence, not merely dispatched tasks.

- Dispatch only items whose required inputs the captain has accepted. Start the next eligible item immediately when its prerequisites are satisfied; do not impose an all-workers-finish barrier.
- Prioritize work that delays the final outcome, then work that removes uncertainty or feeds an idle integration lane. Cap work in progress at the selected squad limit, counting executing and not-yet-stopped workers.
- Use native completion events and bounded batch waits supported by the subagent runtime. Avoid frequent polling and unrelated status reads. Continue captain-owned integration or useful preparation between events; do not duplicate an active worker's assignment. Honor user no-monitor instructions and keep waits within the host's communication limits.
- A worker submits only `status / summary / blocker / artifact path+sha / next_action`; put detailed evidence and provenance inside the artifact. The captain checks hashes, baseline, authority, and item acceptance before releasing downstream work.
- A local pass releases only the outputs proven by that check. Reserve whole-goal completion for integration acceptance; worker completion counts and dispatch counts are not outcome percentages.

## Integrate and repair

Read [coordination.md](references/coordination.md) for freshness and recovery semantics.

1. Inspect each returned artifact and its evidence. Reconcile incompatible assumptions against the pinned contract, using a targeted probe or contract decision rather than majority vote. Reject unsupported conclusions even when several workers agree.
2. Recheck target baselines before applying a patch. The captain integrates one change at a time, preserving unrelated edits. Shared-interface changes invalidate affected descendants until their inputs and relevant tests are refreshed; unaffected lanes continue.
3. Send item-local failure into a named repair item with evidence and bounded acceptance. Shared failures belong to a captain-owned repair lane; workers stop affected actions and cannot patch common rules or infrastructure on their own.
4. On the second occurrence of the same failure, identify the shared cause and change strategy. On the third, stop that strategy and retain evidence. Continue independent useful work; a blocked lane stays visible in the full acceptance contract.
5. Before replacing an active or unresponsive worker, stop it and verify its lifecycle state. Quarantine late output. If stop cannot be proven, keep its ownership reservation and block a conflicting replacement; safe unrelated lanes may continue.
6. On user pause/stop, revoke the generation, stop dispatch, request cancellation, and verify task-owned workers/processes. Resume reconciles actual state, permission, hashes, and a new generation; an automatic continuation cannot restore revoked permission.

Shared-rule changes use one-task canary, bounded proof, then promotion per the global contract. Do not edit a pinned bundle in place or allow workers with different rule revisions to mutate shared state.

## Accept the complete outcome

The captain verifies the assembled deliverable against the original acceptance checklist and runs the relevant integration checks on the current combined state. Passing lane tests alone is insufficient. Report unresolved criteria and external gates without calling them delivered. Do not deploy, publish, send, or mutate live data based solely on local implementation authorization.

After terminal results are ingested, mark bounded workers disposable and do not reuse them for unrelated assignments. Record success, failure, cancellation, owned effects and Main ingestion in the existing host lifecycle record. Run any lifecycle gate required by that host; missing required capability blocks its boundary, not independent preparation. Do not invent a replacement validator or claim unverified process shutdown. No unrecorded task-owned background work may remain.

Tell the user what is delivered, the evidence supporting it, and any remaining blocker. During execution show accepted outcomes, active lanes, and the next dependency/decision in plain language; retain the DAG skill's required proof fields when it applies. Do not make the user coordinate workers or interpret raw transcripts.

## Maintenance checks

When editing this skill, walk through [scenarios.md](references/scenarios.md). Structural validation does not prove that real multi-agent execution works. Record whether checks were a desk walkthrough, an independent evaluation, or an actual squad run.
