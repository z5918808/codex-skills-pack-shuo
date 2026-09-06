---
name: duo-brainer
description: "Pair Astra or Sol Main with a complementary independent Thinker for bounded research; Main owns acceptance."
---

# Duo Brainer

Recommended default setup: Astra Main with Sol-high Thinker. This is a starting preference, not an automatic model switch: preserve the user's actual Main model/effort. If Main is Sol, use Astra Thinker through the adaptive route. The user selects the Main model in the interface; this skill does not set an application default.

Keep the activation chat as Main/Reviewer and user-facing endpoint. Use one independent Thinker task with the complementary model, never a subagent. Editing this skill does not start tasks. This is bounded research collaboration, not production execution.

## Roles and cost objective

- **Main / Reviewer:** preserve the activation chat and its actual supported model/effort. Main owns the question, authority, orchestration, acceptance standards, and final verdict. Supported Main models are `gpt-6-astra` and `gpt-5.6-sol`; unsupported models block only this dispatch route, never trigger a silent switch.
- **Adaptive Thinker:** Astra Main selects `gpt-5.6-sol/high`; Sol Main selects `gpt-6-astra` with a host-supported effort chosen for the bounded question unless the prompt specifies it. With Astra Main, Sol performs substantive research, detailed reasoning, design elaboration, and evidence mapping. With Sol Main, Sol carries that detailed work and asks Astra for high-value ideation, initial topology/design, blind spots, or critical decision advice. Main retains final acceptance in either mode. Thinker is read-only within scope: no production, recursive delegation, shared mutations/repairs, or live actions. Return source-backed recommendations and uncertainty, never self-certify acceptance.
- Minimize total tokens and coordination overhead: send only the question, relevant references, standards, and stopping condition. Do not solve the delegated question first or duplicate active Thinker analysis. Return concise findings and decisive evidence, never raw reasoning/transcripts. Model confidence is not correctness; Main verifies consequential claims without repeating the entire investigation.
- Delegate only a substantive question whose expected value exceeds coordination overhead. Handle trivial work directly and route bulk/repetitive execution elsewhere. Do not promise model productivity or token savings without measurements.

## Model changes

Before each new assignment, verify Main's actual current model and derive the complementary Thinker route. A user switch changes future assignments only: do not spawn a replacement while prior work is active or ownership is uncertain. Ingest its terminal result or reconcile cancellation first, then reconfigure or replace the independent Thinker task through supported tools and current approval gates. Never change an active task's model mid-assignment or discard completed evidence solely because Main changed models.

## Dispatch and return

1. Identify the analytical question, what decision it supports, known constraints, authority, evidence needed, and bounded finish. Use no native goal, recurring automation, background sidecar, or additional production controller.
2. Resolve at most one Thinker for this Reviewer and current question from actual task IDs/receipts. Use supported independent task creation and direct task messaging. Never substitute `spawn_agent`, a child agent, or a CLI session. If these capabilities are unavailable, report analysis delegation unavailable; do not report Main-only analysis as delegated work.
3. Apply current model/task-dispatch gates using the actual route and selected effort. Adaptive selection does not grant perpetual model approval: an explicit current request assigning the selected model to this task supplies approval when properly recorded; when invoked from an explicitly user-requested TRIO run, that TRIO invocation is the task-bound authorization for its prescribed Thinker route: record and pass it to the gate without asking again. Outside that case, obtain approval only when the current session has not already authorized the assignment. Preserve pinned shared rules/hash and packet fields required by the global contract. Do not invent gate arguments, approval records, or exempt independent tasks from gates.
4. Prepare a focused initial prompt with `ROLE: Thinker`, Reviewer task ID, question, permitted reads, prohibited actions, evidence references, acceptance/stopping criteria, rules reference/hash, generation, selected model/effort, and compact return contract. Create a separate task once with title `[Thinker] <question>` and explicit selected model/effort. For repo analysis, discover the project and explicitly use its saved local checkout for read-only analysis; no unapproved worktree. Use projectless for non-repo research.
5. A creation timeout or ambiguous receipt is not proof of failure. Reconcile with one immediate task inventory before any retry; never create another Thinker while ownership is uncertain. A receipt binds task ID and question. Keep only the relevant ID/hash/decision state in existing records; no repo context dumps or new board system.
6. End the Reviewer turn after delivery. Thinker performs the work, then sends the Reviewer one direct message containing `status / summary / blocker / artifact path+sha or source references / next_action`, including recommendation and material uncertainty in the summary. A detailed artifact is created only if required by the task. Verify a successful message receipt, then end the Thinker turn. Local final text alone is not delivery.
7. No `wait_threads`, polling, heartbeat, monitor, or repeated Main status turns. React to the delivered result; one immediate status read is allowed for explicit user status requests or necessary event reconciliation. An uncertain send must be reconciled before retrying; do not blindly resend. Never report undelivered analysis as complete.
8. Main checks source freshness, scope, reasoning-sensitive evidence, and acceptance. Thinker recommendations cannot change criteria, authorize actions, or certify completion. Accept the supported conclusion, perform a targeted independent check, or send one bounded correction with the specific gap; repeated failures follow the global stop/change-strategy rule.
9. The Thinker ends after its terminal message and has no continuing job. Use the same independent task for a necessary correction only after prior work is terminal and ingested; never layer active assignments. This is not reuse of a retired subagent. User stop revokes the generation; no automatic continuation restores it. Do not archive/delete tasks automatically or leave owned processes running.

## TRIO acceptance integration

When called by [trio-long-running acceptance](../trio-long-running/references/acceptance.md), keep the existing production Worker and Reviewer roles unchanged. Thinker is a bounded analysis assistant, not another Reviewer or production Worker. At most one complementary-model Thinker may be active alongside that pair; it cannot use the Worker's credentials, rewrite `TRIO_GOAL.md`, repair shared code, run production, or issue `ship`.

At acceptance, Main identifies whether a meaningful unresolved research/analysis question remains. If so, dispatch that question with the pinned checklist and relevant evidence, then end the turn until Thinker's direct result. If current proof already resolves acceptance, skip the extra call. After receiving analysis Main alone applies the original `ship | fix-first | rethink` criteria. Thinker output is advisory and never a substitute for required independent verification. TRIO follows the same adaptive pairing; do not silently switch Main or create a replacement Reviewer.

## Maintenance checks

Static scenarios (not runtime proof):

- A bounded architecture comparison: the complementary Thinker supplies targeted analysis; Main decides. No production Worker, subagent, full parent transcript, or repeated monitoring.
- A trivial lookup or thousand-item repetitive job: do not add Thinker overhead; handle directly or route the execution workflow.
- TRIO evidence has an unresolved technical discrepancy: one complementary-model Thinker investigates only that gap; the production Worker remains quiescent after its terminal event; Main retains acceptance and shared repair.
- TRIO already has decisive evidence: skip redundant Thinker analysis and apply existing acceptance. No fabricated cost-saving claim.
- Thinker recommends waiving a criterion or changing production: treat as advice, preserve authority and original acceptance; do not ship from model confidence.
- Missing direct messaging, ambiguous creation, revoked generation, or unavailable model gate: stop the affected dispatch/delivery boundary, preserve compact evidence, and do not emulate it with subagents or background jobs.

Run skill format validation after maintenance. Distinguish static walkthroughs from actual task creation/message/model-routing proof. Cost metrics are optional existing evidence, never a new acceptance gate or monitoring system.
