---
name: heavy-duo
description: Run explicit two-task collaboration with a Worker and Astra Reviewer.
---

# Heavy Duo

Default pairing: `gpt-5.6-sol/medium` Worker + `gpt-6-astra` Reviewer. Preserve the user's selected Astra effort; this skill sets no new Reviewer effort default and never changes the running app model. Use Heavy Duo when the user requests this pair or substantive two-role work. Editing or discussing the skill starts no tasks.

## Flexible roles

- **Sol Worker:** gather facts, work out implementation details within Astra's plan, implement, test, and correct within the user's authorized scope. Medium is the default, not a ceiling. Worker may repair code and tooling needed for its assignment; no TRIO prohibition on shared repair is imported. Coordinate ownership before either role edits the same files.
- **Optional Luna/max Worker override:** when the user explicitly replaces Sol with verified `gpt-5.6-luna/max`, that Worker may use the bounded internal DAG in `C:\Users\user\.codex\harness_docs\16_subagent_ban.md`. Astra and the default Sol Worker never spawn. Native helpers do not become a third DUO role and do not inherit Heavy Duo planning, review, or acceptance.
- **Astra Reviewer / Planner:** own planning when the task needs a plan, clarify consequential decisions, challenge assumptions, review actual artifacts/evidence, and own final acceptance. Help early when its judgment can prevent substantial rework; do not wait for a completed wrong solution. Reviewer may perform useful authorized investigation or targeted fixes, provided it first reconciles ownership with Worker.
- The user can change scope, roles, model, effort, or who hosts the conversation in ordinary language. These defaults do not force a fixed phase sequence, read-only work, production-only work, mandatory opening ceremony, per-step approval, or a native long-running goal. A small request stays small; do not create an extra task for a trivial lookup unless explicitly requested.
- Research/advice requests remain read-only. Implementation requests permit bounded local implementation under current instructions. External/live actions, worktrees, destructive changes, and protected data retain their actual permission boundaries. “Free to work” does not create new external authority.

## Planning belongs to Astra

When a plan is requested or needed, Astra owns the approach, scope decomposition, priorities, dependencies, and acceptance strategy. Sol gathers only enough facts to frame the planning question, then gives Astra the original outcome, constraints, and decisive evidence before developing a full plan. Use the existing Astra Reviewer for planning; do not add a planner task or have Astra merely rubber-stamp a completed Sol plan.

Sol executes the resulting plan and decides routine implementation details within it. Material replanning returns to Astra before dependent execution; independent authorized work can continue. Reuse a still-valid plan and handle simple work directly without inventing a planning ceremony. Astra plans directly when it hosts the activation task; when Sol hosts, use the existing independent Astra return protocol. This allocation does not change models, effort, authority, or the user's ability to explicitly revise the roles.

## Two independent tasks

Use at most one persistent Worker and one Reviewer as independent Codex tasks, not child replacements, CLI sessions, or background controllers. Keep the activation task as the user-facing entrypoint. If it is Astra, it normally serves as Reviewer and pairs with Sol-medium Worker; if it is Sol, it normally serves as Worker and pairs with Astra Reviewer. Do not silently change the activation model, create a replacement Main, or add a third coordinator. If the actual model cannot fill the requested pairing, clarify only that material choice before dependent dispatch. A user-selected Luna/max Worker may have internal helpers under the conditional envelope above while remaining the sole persistent Worker.

Reuse an existing appropriate task only after its prior assignment/result and owned effects are reconciled. A model or role change applies to the next safe assignment; never discard completed evidence or switch an active assignment silently. Use `[Worker] <topic>` and `[Reviewer] <topic>` labels where supported; labels are not identity proof.

## Assignment and return

Sustained non-native repo work uses [Repo Task Goal](C:/Users/user/.agents/skills/project-state-steward/references/task-goal.md): one `TASK_GOAL.md`, one explicitly named state writer, proactive safe-boundary updates and a repo AGENTS.md/index pointer. Preserve Astra's acceptance ownership even when Sol is the state writer. Switching TRIO/DUO/Heavy Duo transfers the same goal/evidence only after old owners, deliveries and effects are reconciled; archived tasks cannot resume. Small/read-only or non-repo work keeps the lightweight contract below.

Preserve context in the same independent Sol Worker and Astra Reviewer tasks across lifecycle-approved assignments. Keep each role's detailed investigation in its own task; a new question, phase or correction alone does not require recreating the partner. Initially provide the original outcome and constraints; later send changed facts, failed attempts, current evidence references and the exact decision/action with the complete current contract reference. Astra retains planning and review context; Sol retains implementation context. Do not solve the same question twice or copy either task's entire conversation to the other.

Return compact conclusions, reasons, actionable findings, unresolved uncertainty and necessary evidence through the direct-message contract below. Keep required reproducible evidence once and reference it rather than duplicating logs or scratch reasoning. After compaction or changed evidence, recover needed sources, recheck affected assumptions and supersede stale findings; persistence is not unlimited memory or permission to trust old authority. This preserves context without extra persistent roles or a new tracking system; any valid Luna helpers stay internal to that Worker. Explicit user changes to roles and existing safe replacement rules still apply.

1. Frame outcome, bounded assignment, scope/permissions, current facts, acceptance and stop conditions. Use `TASK_GOAL.md` for sustained repo work under the shared contract; otherwise a concise message or existing contract suffices. No extra board, timer or fixed budget.
2. Resolve actual task identities and tools. Apply the current model/task-dispatch gates to the selected route and models, recording the original task-bound authorization. An explicit request assigning this default pair supplies the prescribed role/model authorization when accepted by the applicable gate; it grants no extra agents or live permission. Skill maintenance alone is not dispatch authorization. Preserve Reviewer effort if known; for a new Reviewer use its configured supported default unless the user selects one, and do not invent an effective setting or approval record. A failed gate blocks its dependent dispatch, not independent authorized work.
3. Include the required shared packet identity (`task_id / role / scope / permissions / rules_ref / rules_hash / state_version / next_action`) plus the actual partner task/return tool, assignment ID, evidence references, allowed work and finish criteria. Use minimal context, not full transcripts or copied skill bodies. For a new task, send its complete useful assignment at creation, using explicit Sol medium for the default Worker and the authorized Astra settings for Reviewer. Respect project selection and worktree approval; never create a setup-only duplicate.
4. An ambiguous creation receipt requires one supported identity reconciliation before retry. Do not create another partner while ownership is unknown. Keep compact identity/receipt references in existing state only where needed.
5. The assigned role performs the bounded work, then sends the partner a direct result with `status / summary / blocker / artifact path+sha or source references / next_action`. Include material uncertainty, actual validation and any unresolved owned effects. Verify the message receipt, then end its turn. Local final text alone is not cross-task delivery. No acknowledgement-only ping-pong, polling, `wait_threads`, heartbeat, or monitoring. End the sending turn after a substantive handoff; resume from its real result. A user status request permits one immediate supported snapshot.
6. Reviewer accepts the result from actual evidence, requests the specific missing correction, or identifies the precise unresolved decision. Do not duplicate the whole Worker investigation or delegate only after solving it yourself. Worker self-confidence and Reviewer confidence cannot substitute for verification. Reviewer output does not grant permission or waive the user's criteria. A delegated Reviewer sends its verdict directly back to the activation Worker, which handles the user-facing delivery or authorized correction.
7. A failed or ambiguous send is not completion: retain the compact packet/error, reconcile supported delivery evidence before retry, and never rerun completed work just to recover a message. User stop revokes the assignment; reconcile only known task-owned work, preserve user processes, and do not resume automatically. No automatic task archival/deletion.

## Review proportional to the work

Use early Astra input for consequential architecture, unclear outcomes, meaningful tradeoffs, or repeated unexplained failures. Routine execution choices stay with Worker. A coherent review should return the decision, material reasons, actionable findings and decisive next verification together; avoid many tiny consultations.

At completion, Astra checks the requested outcome, changed artifacts, relevant tests or source evidence, and remaining limitations. Accept, request bounded correction, or identify a real blocker. Reuse unaffected valid evidence after a correction. Do not impose TRIO's mandatory opening, production ownership split, percentage reporting, or retirement workflow on Heavy Duo. No measured speed or token-saving claim without comparable runtime evidence.

## Maintenance checks

Static scenarios, not runtime proof:

- A task needs planning: Astra chooses the approach and decomposition before Sol develops the solution; Sol supplies facts and executes. A material plan change returns to Astra, while routine details do not require another planning round.
- A local implementation request: Sol medium edits and tests; Astra reviews the actual result. Worker is not restricted to read-only advice, and Reviewer does not duplicate the full implementation.
- A research-only request: both stay read-only and return source-backed findings; the Worker label grants no mutation authority.
- The user chooses a different effort or division of work: adopt it at a reconciled boundary under actual model gates; do not force the defaults or invent extra roles.
- The user selects Luna/max as Worker: eligible independent branches may use at most two depth-1 helpers after both gates; helper finals are integrated by Luna and never replace Astra review. Sol/Astra/other models do not spawn.
- Main is Sol: keep its task and use one Astra Reviewer. Main is Astra: keep it and use one Sol-medium Worker. No silent Main switch or third task.
- A live action lacks authority, creation is ambiguous, or a result is undelivered: stop only the dependent boundary; preserve completed work and continue independent authorized preparation.

Run skill format validation and check affected references after maintenance. Do not launch the pair merely to test a documentation edit.
