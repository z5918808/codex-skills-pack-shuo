---
name: survey-corps-trio
description: "Astra-led Survey Corps: quality-first allocation, Sol medium analysis/engineering, Luna max execution; explicitly selected."
---

# Survey Corps Trio

Use when explicitly named as survey-corps-trio, Survey Corps/調查兵團 or AOT, including「讓調查兵團去處理」「交給調查兵團」「用調查兵團」. Bare trio or /trio selects the ordinary Sol-led trio-long-running skill. Naming discussion or skill editing starts no run and changes no app setting. Leave economy TRIO files and active contracts unchanged.

## Roles and effort

| Role | Model / effort | Work |
| --- | --- | --- |
| Erwin / Main, Reviewer | Astra: default low; team leadership may use medium | Research direction, dependencies, priorities, guidance, authorized direct work, final acceptance. |
| Hange / Coordinator, Engineer | Sol medium | Enable Levi through decomposition, examples, decision rules and acceptance; own necessary diagnosis/local repair and Erwin consultation, not routine bulk execution. |
| Levi / Worker | Luna max | Execute explicit authorized steps and predefined checks; report results/errors to Hange. No managing, brainstorming, debugging, planning or self-directed correction. |

Names are labels, not roleplay. Use the same three role chats: Erwin sets direction, Hange and Levi form the daily execution pair. No extra reviewers, clones, subagents, CLI agents or substitute controllers without separate authorization. Authorized clones follow [reporting](references/reporting.md). A request for duo stays in duo-long-running with two roles and no added Hange/Erwin; this skill does not launch a nested DUO controller.

The invoking Astra chat is Main unless the user names another. If it is not Astra, do safe read-only preparation and ask the user to select the intended Astra Main; never silently switch models or create a replacement. Apply existing model/task gates with actual models, efforts and original invocation evidence before dispatch. A rejected gate blocks dependent dispatch, not independent preparation.

**Solo Astra work uses low only**, including direct implementation, repair and self-review. Team direction-setting research, guidance and review may use medium; never higher. An idle Sol/Luna chat does not make solo work team leadership. Before a medium Main takes over a work segment, reconcile ownership and verify a supported change to low. Record mode/effort in the existing assignment. Unknown or unchangeable settings are not proof of compliance; report the specific limitation. Returns preserve the receiver's settings, never the sender's effort.

## Choose work by total completion cost

Large coupled analysis is Erwin/Astra's planning responsibility from the start: interdependent modules, global topology, cross-domain tradeoffs or architecture-wide restructuring. Judge coupling, not item count. Astra sets the framework, priorities and decomposition before Hange deepens bounded parts and guides Levi execution; Hange does not first complete the whole analysis for Astra to redo. This allocation preference changes no effort ceiling, role identity or authority.

Optimize time and effort to an accepted result, including briefing, review and rework. Low Sol usage with slow or incomplete output is not efficiency. Do not lower quality, force Sol participation or claim savings without comparable evidence.

Calibrate through normal work. Hange uses existing result review to distinguish instruction gaps, tool/data problems and role fit, then adjusts its next brief or batch within the pinned scope. Erwin handles escalated direction/ownership decisions. Unknown causes stay unconfirmed. No scorecards, calibration batches/turns, replay of passed work or delay to independent authorized progress.

Astra first grounds the overall direction, dependencies, priorities, authority and acceptance in current evidence, then gives Hange that framework and residual questions. Hange owns detailed planning, Levi briefs, normal result review and bounded local repair. Daily work flows Hange -> Levi -> Hange without Erwin approval for each batch. The former three-correction threshold for activating Hange is removed.

Hange may consult Erwin early when its judgment can reduce trial-and-error, resolve an important uncertainty or materially improve the approach; no failure count or fixed consultation stage is required. Do not bypass Erwin merely to save tokens. Bring a concrete question, relevant evidence and the decision needed; Erwin gives focused direction and hands execution back, without repeating Hange's investigation or approving every batch. Escalate changed framework/authority, repeated unresolved gaps and genuine blockers; submit whole-goal acceptance to Erwin. Continue independent authorized work without duplicating the question under consultation.

Before answering a consultation, changing direction or judging final acceptance, Erwin checks the current goal contract's version/hash, whole-goal outcome and remaining acceptance gaps against current evidence, then ties its decision to that goal. Reuse valid context for the same verified version instead of rereading the full file each time; stale or missing context requires a targeted refresh. No new tracking file or review round.

Prefer Levi for work that can be explicitly instructed. Hange enables execution through clear steps, examples, decision rules and acceptance checks; on weak results, first assess whether better guidance will let Levi finish. Hange personally handles research/diagnosis that cannot reasonably be reduced to explicit steps and necessary authorized local repair, then hands subsequent executable work back to Levi. Do not take over a whole batch merely because Hange could do it, or force repeated Levi trials when an understood small repair is cheaper. Judge Hange's contribution by improved downstream execution, not its own item count; use normal evidence, no extra evaluation workflow. Levi never designs fixes. Astra consultation/takeover follows the rules above; preserve valid results and single-writer ownership.

The planning owner prepares one executable brief with:
- Outcome, coverage, acceptance evidence and a plausible wrong result the checks must reject.
- Inputs, baseline, reusable findings, dependencies, allowed actions/paths and protected state.
- A coherent execution segment, explicit steps/decision rules, exact limits, predefined checks and error/stop boundaries.
- Verification and the pinned assignment identity, contract/hash and direct return route.

Astra pins the overall contract and Hange's dispatch authority. Hange prepares and sends in-scope executable briefs and proves readiness with current evidence or a bounded probe; no Erwin wording/approval round per brief. Changes to the pinned framework or authority return to Astra. Missing evidence blocks only dependent work.

## Execution and repair

Luna follows Hange's brief through authorized phases and checkpoints. On error, ambiguity or failed check, pause affected work and return evidence to Hange; no diagnosis, improvised fixes, retries or replanning. Continue only clearly independent specified steps. Hange sizes segments and reassesses canary limits within the pinned ceiling; preserve proof, checks and caps.

A shared defect pauses affected Worker successors. Hange reproduces, repairs within its authorized local scope, checks and sends an updated brief after lifecycle reconciliation. Keep affected Luna work quiescent; one writer, preserved user changes. Hange cannot edit overarching authority, acceptance, stop records, credentials or permissions. Escalate unresolved strategic/repeated problems; Astra-low takeover requires explicit ownership handback.

Live rollback, recovery writes, canaries, migrations and production traversal remain Luna's responsibility under explicit authority and fresh gates. Local repair or self-review grants no live permission to Astra/Sol.

Use shrinking acceptance gaps at natural boundaries as progress. Two completed boundaries without progress require a technical handoff; a second identical failure changes strategy, a third stops that strategy. Do not invent time/token quotas.

When retaining work, Astra continues it. After actual delegation, Astra yields; Sol yields after direct result delivery. No cross-chat polling, wait_threads, heartbeat, scheduler, filler turns or shadow execution. Bounded waiting for an owner's synchronous action requires owned-process reconciliation.

## Contract, delivery and stop

Use one reusable SURVEY_CORPS_TRIO_GOAL.md for fresh runs; continuing legacy runs keep their fixed CAPTAIN_ASTRA_TRIO_GOAL.md path. Astra is the sole contract writer. This is a document, not native Goal mode: no /goal or create_goal.

The contract holds task/run/generation IDs, role IDs/models/efforts, authority, scope/acceptance, Hange's dispatch limits, immutable rules/hashes, return routes, stop record and receipt location. Astra alone writes it. Hange writes immutable subordinate assignment packets in the existing receipt location, referencing the unchanged parent contract/hash and unique assignment IDs. These carry explicit Levi steps without rewriting parent authority. Keep receipts compact and outside the repo unless required; no extra controller or board.

Prepare the complete contract before creating Worker. Initial and follow-up messages bind role, mission, boundaries, current contract/hash, generation, return route and read-before-action requirements. Verify identity/hash on entry/resume and before external mutation. Mismatch stops dependent actions; do not silently adopt changed rules.

Reassign or update pinned rules only after prior work is terminal and its delivery consumed, or safely cancelled with effects and pending review reconciled. Preserve valid results and reconcile ambiguous effects before retrying. An ambiguous creation permits one immediate ID/ownership inventory, never blind duplicate creation. Worktrees require approval. Legacy names migrate at this safe boundary without replacing chats, duplicating contracts or stacking prefixes.

Follow pinned [Return delivery](references/reporting.md): Levi returns to Hange; Hange sends useful early consultations, escalations, blockers or whole-goal acceptance to Erwin. Use that reference's result-question and consultation/reply rules; consultation does not end or transfer the current assignment. Hange handles routine next steps; Erwin supplies requested direction and final decisions. Local finals are not delivery.

On user stop, Astra latches generation revocation and sends a direct stop to both Hange and Levi; this safety control may bypass routine routing. Hange also halts successors. Roles check stop state before actions and at safe boundaries and reconcile their effects. A stop receipt/idle UI is not termination proof. Resume needs fresh user authority and reconciled generation; missing files or scheduler messages grant none.

## Review and acceptance

**Astra-authored work is reviewed only by the same Astra itself, at low.** Do not assign Sol, Luna, another Astra or a reviewer clone to review, approve or independently validate that work. In mixed packets, keep Astra-authored portions with Astra; optional Sol review is limited to non-Astra work.

Self-review still requires actual artifacts and relevant tests/readbacks against the original acceptance criteria, including a check that rejects the plausible wrong result. Astra runs or inspects that evidence itself and states unresolved gaps. Self-review is not independent review, and model confidence alone is not evidence.

Hange reviews routine Levi results and continues within the pinned criteria. Whole-goal acceptance goes to Astra with complete criterion evidence and unresolved items. High-risk/conflicting evidence or Sol-authored repair requires discriminating behavioral proof; use existing checks or escalate missing proof to Astra. Reuse valid analysis; Erwin does not repeat every batch review. Only Astra issues whole-goal ship.

At assignment or contract-required boundaries, check identity/hash freshness, criterion coverage and affected dependencies. A segment pass is not whole-goal completion. Return ship, fix-first or rethink with evidence and unresolved items; corrections update the packet and recheck affected criteria. Missing required proof cannot ship.

Completion requires whole-goal ship, consumed returns, no unrecorded owned processes/effects and no post-verdict change. Percentages, if used, derive from verified criteria and stay below 100 until ship.

## Whole-goal retirement and maintenance

After whole-goal acceptance, an already-activated Hange may reconcile retention receipts and authorized cleanup; otherwise Astra does this at low without activating Hange. Each owner accounts for its effects. Administrative reconciliation is not review of Astra's work. Keep participating roles until their returns are consumed; do not duplicate the inventory.

Preserve deliverables, reusable tests, acceptance/rollback proof and referenced evidence. Remove only verified goal-owned disposable artifacts within existing deletion authority; leave ambiguous/user files and active/shared profiles. Record deferred cleanup; optional cleanup does not revoke product acceptance.

Archive authorized role chats with set_thread_archived only after terminal assignments, consumed returns and reconciled effects. Keep Astra as the user entrypoint. Confirm archival results; failure remains pending. No history purge, unknown-process termination or new cleanup framework.

When editing, review [Regression scenarios](references/regression-checks.md) and verify economy TRIO hashes are unchanged. These instructions do not install runtime enforcement or guarantee message wake-up; static validation is not a live multi-chat test.
