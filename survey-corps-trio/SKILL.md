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
| Hange / Thinker, Engineer | Sol medium | Useful bounded research, detailed planning, local repair/tests and review of non-Astra work. |
| Levi / Worker | Luna max | Execute explicit authorized steps and predefined checks; report results/errors to Astra. No managing, brainstorming, debugging, planning or self-directed correction. |

Names are labels, not roleplay. Keep the same three primary chats; do not manufacture assignments to keep every role busy. No extra reviewers, clones, subagents, CLI agents or substitute controllers without separate authorization. Authorized clones follow the parent routing in [reporting](references/reporting.md).

The invoking Astra chat is Main unless the user names another. If it is not Astra, do safe read-only preparation and ask the user to select the intended Astra Main; never silently switch models or create a replacement. Apply existing model/task gates with actual models, efforts and original invocation evidence before dispatch. A rejected gate blocks dependent dispatch, not independent preparation.

**Solo Astra work uses low only**, including direct implementation, repair and self-review. Team direction-setting research, guidance and review may use medium; never higher. An idle Sol/Luna chat does not make solo work team leadership. Before a medium Main takes over a work segment, reconcile ownership and verify a supported change to low. Record mode/effort in the existing assignment. Unknown or unchangeable settings are not proof of compliance; report the specific limitation. Returns preserve the receiver's settings, never the sender's effort.

## Choose work by total completion cost

Optimize time and effort to an accepted result, including briefing, review and rework. Low Sol usage with slow or incomplete output is not efficiency. Do not lower quality, force Sol participation or claim savings without comparable evidence.

Astra first reads relevant state and reusable evidence, then identifies the bottleneck, dependency topology, priorities and deferred work. Once the direction is grounded, continue directly at low when that is the shortest credible route, or delegate a useful bounded slice to Sol. No mandatory research-only ceiling or redundant discovery phase.

Give Sol the original request, framework, evidence, assumptions, scope and residual questions. Sol deepens its assigned slice and reuses valid findings. It may report contradictory facts encountered during its work and propose a correction; Astra decides direction. This is not a review assignment of Astra's work.

Astra owns correction of Levi errors, including execution slips: diagnose the gap, correct locally at low or assign useful Hange work, then give Levi explicit revised execution steps if needed. Levi reports evidence and does not debug or design its own fix. Hange is optional, never a mandatory intermediate step. On incomplete Sol work, clarify the defect, intended approach/example and acceptance check, or take over at low. Choose by total cost and quality; reconcile ownership and preserve valid results, authority and acceptance standards.

The planning owner prepares one executable brief with:
- Outcome, coverage, acceptance evidence and a plausible wrong result the checks must reject.
- Inputs, baseline, reusable findings, dependencies, allowed actions/paths and protected state.
- A coherent execution segment, explicit steps/decision rules, exact limits, predefined checks and error/stop boundaries.
- Verification and the pinned assignment identity, contract/hash and direct return route.

Astra pins the authorized brief. Prove readiness with existing decisive evidence or the smallest isolated/read-only probe; confidence or tool availability alone is insufficient. Missing evidence blocks dependent work only. No extra review round merely for wording.

## Execution and repair

Luna follows the brief through authorized phases and local checkpoints. On an error, ambiguity or failed check, pause affected work and return evidence to Astra; do not diagnose, improvise repairs, retry failed work or replan. Continue only clearly independent steps already specified in the brief. Astra sets segment size and reassesses canary limits at eligible handoffs; preserve per-item proof, predefined checks and exact caps.

A shared defect pauses affected Worker successors. Astra repairs locally at low or assigns Sol one coherent reproduction, correction, regression check and updated brief. Record one writer and explicit scope; preserve user changes and keep affected Luna work quiescent until handback. Sol cannot edit authority, acceptance, stop records, credentials or permissions.

Live rollback, recovery writes, canaries, migrations and production traversal remain Luna's responsibility under explicit authority and fresh gates. Local repair or self-review grants no live permission to Astra/Sol.

Use shrinking acceptance gaps at natural boundaries as progress. Two completed boundaries without progress require a technical handoff; a second identical failure changes strategy, a third stops that strategy. Do not invent time/token quotas.

When retaining work, Astra continues it. After actual delegation, Astra yields; Sol yields after direct result delivery. No cross-chat polling, wait_threads, heartbeat, scheduler, filler turns or shadow execution. Bounded waiting for an owner's synchronous action requires owned-process reconciliation.

## Contract, delivery and stop

Use one reusable SURVEY_CORPS_TRIO_GOAL.md for fresh runs; continuing legacy runs keep their fixed CAPTAIN_ASTRA_TRIO_GOAL.md path. Astra is the sole contract writer. This is a document, not native Goal mode: no /goal or create_goal.

The contract holds task/run/generation/assignment IDs, role chat IDs/models/efforts, original authority, scope/acceptance, executable brief, immutable rules references/hashes, return destination/tool, stop record and receipt location. Keep compact receipts outside the repo unless required there; no transcript dumps or extra boards.

Prepare the complete contract before creating Worker. Initial and follow-up messages bind role, mission, boundaries, current contract/hash, generation, return route and read-before-action requirements. Verify identity/hash on entry/resume and before external mutation. Mismatch stops dependent actions; do not silently adopt changed rules.

Reassign or update pinned rules only after prior work is terminal and its delivery consumed, or safely cancelled with effects and pending review reconciled. Preserve valid results and reconcile ambiguous effects before retrying. An ambiguous creation permits one immediate ID/ownership inventory, never blind duplicate creation. Worktrees require approval. Legacy names migrate at this safe boundary without replacing chats, duplicating contracts or stacking prefixes.

Both delegated roles must follow [Return delivery](references/reporting.md); include that pinned reference in every assignment. Local finals are not delivery. Each return ends「請指示下一步。」; Astra decides and performs the next authorized action, dispatch, exact blocker or whole-goal acceptance in that handling turn.

On user stop, Astra latches generation revocation in the existing stop record and sends a direct stop. Roles check before actions and at safe boundaries, stop successors and reconcile their own effects. A stop receipt or idle UI is not proof of termination. Resume needs fresh user authority and a reconciled new generation; missing stop files or scheduler messages grant none.

## Review and acceptance

**Astra-authored work is reviewed only by the same Astra itself, at low.** Do not assign Sol, Luna, another Astra or a reviewer clone to review, approve or independently validate that work. In mixed packets, keep Astra-authored portions with Astra; optional Sol review is limited to non-Astra work.

Self-review still requires actual artifacts and relevant tests/readbacks against the original acceptance criteria, including a check that rejects the plausible wrong result. Astra runs or inspects that evidence itself and states unresolved gaps. Self-review is not independent review, and model confidence alone is not evidence.

For Sol/Luna work, Astra reviews directly or asks Sol for a useful review of non-Astra work. High-risk/conflicting evidence or Sol-authored shared repair needs a discriminating corroborating check, which Astra may perform itself. Reuse current valid evidence; do not add review rounds for ceremony. All final acceptance belongs to Astra.

At assignment or contract-required boundaries, check identity/hash freshness, criterion coverage and affected dependencies. A segment pass is not whole-goal completion. Return ship, fix-first or rethink with evidence and unresolved items; corrections update the packet and recheck affected criteria. Missing required proof cannot ship.

Completion requires whole-goal ship, consumed returns, no unrecorded owned processes/effects and no post-verdict change. Percentages, if used, derive from verified criteria and stay below 100 until ship.

## Whole-goal retirement and maintenance

After whole-goal acceptance, Hange reconciles role/clone retention receipts and performs only authorized bounded cleanup; each process owner accounts for its effects. This administrative reconciliation is not review of Astra's product work. Keep Hange until its return is consumed; Astra checks the closeout without repeating the inventory.

Preserve deliverables, reusable tests, acceptance/rollback proof and referenced evidence. Remove only verified goal-owned disposable artifacts within existing deletion authority; leave ambiguous/user files and active/shared profiles. Record deferred cleanup; optional cleanup does not revoke product acceptance.

Archive authorized role chats with set_thread_archived only after terminal assignments, consumed returns and reconciled effects. Keep Astra as the user entrypoint. Confirm archival results; failure remains pending. No history purge, unknown-process termination or new cleanup framework.

When editing, review [Regression scenarios](references/regression-checks.md) and verify economy TRIO hashes are unchanged. These instructions do not install runtime enforcement or guarantee message wake-up; static validation is not a live multi-chat test.
