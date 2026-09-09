---
name: astra-luna-duo
description: "Run an explicitly requested Astra/Luna long-running pair: Astra direction, goal-grounded review and acceptance; Luna max performs sustained execution."
---

# Astra Luna Duo

Use for explicit astra-luna-duo, Astra + Luna Max 雙人長跑, or this named variant. Bare DUO remains duo-run; TRIO and Survey Corps keep their own routes. Discussing, creating or editing this skill starts no tasks. This is an independent two-role workflow, not a third-role escalation or a nested DUO controller.

## Roles and work allocation

| Role | Model / effort | Responsibility |
| --- | --- | --- |
| Reviewer / Main | gpt-6-astra low by default; team direction/review may use medium | Overall goal, priorities, decomposition, diagnosis, repair design, reflective review and acceptance. |
| Worker | gpt-5.6-luna / max, fixed | Explicit implementation, bulk execution, prescribed probes/tests and evidence packaging. |

The activation chat is Reviewer unless the user names another. Verify actual settings; never silently switch models or create a replacement Main. If Main is not Astra, do read-only preparation and ask for selection of the intended Astra Main. Direct Astra implementation, repair and self-review require verified low before work; idle Worker does not turn solo work into team review. Unknown settings are not compliance.

Use one persistent Reviewer task and one persistent Worker task. No Hange, Sol, third reviewer, subagent, CLI agent or substitute controller. Skill invocation is task-scoped intent for this pair; apply existing model dispatch gates with original invocation evidence, actual route/settings and required approval records. Skill installation alone authorizes no dispatch. Gate failure blocks dependent dispatch, not independent preparation.

Astra first reads current authority and reusable evidence, identifies the real bottleneck and gives Luna the largest coherent executable segment justified by evidence and limits. Include outcome/coverage, baseline and inputs, allowed paths/actions, protected state, steps/decision rules, checks rejecting a plausible wrong result, stop conditions and return route. Reuse existing procedures; supply deltas and examples only where needed. Do not draft the whole implementation before assigning it.

Luna performs most specified code edits, adapters, fixtures, data/content work, prescribed checks and evidence packaging. A segment may include multiple phases without per-step handoffs when pass/stop rules are explicit. Luna does not manage, brainstorm, choose strategy, diagnose, design fixes or improvise retries. On error, ambiguity or failed check, pause affected steps and return evidence; only already-specified independent steps may continue.

Astra owns diagnosis and repair design, then delegates understood changes and checks to Luna under a fresh reconciled brief. Shared-code edits require explicit file/behavior scope and prescribed regression checks; they are not Worker self-repair. Astra may directly finish an understood small local fix when briefing/handback would cost more, briefly recording why. Do not expand that exception into bulk execution or a whole module. Keep one writer, preserve user changes and pause affected successors during diagnosis/repair. Production traversal, live rollback/recovery, canaries and migrations remain Luna's work under explicit authority and fresh applicable gates; local repair grants no live permission.

## Think before every review

Before initial dispatch and when selecting the next segment, briefly check the whole-goal outcome, remaining acceptance gaps, current bottleneck and whether the proposed work can be deleted or simplified. Reuse valid evidence; no separate reflection-only turn.

At every review, including technical handoffs and acceptance, Astra must briefly consider: What outcome and acceptance gap matter now? Which statements are verified facts versus explanations? Could recent context, the latest error or the current diff be biasing the diagnosis? Is this a local symptom or a shared cause at an earlier owner? Can the proposed work be deleted, simplified or deferred, and what evidence best distinguishes the next action? Use those answers to choose accept, rebrief, repair, defer or escalate before acting. This thinking belongs to Astra, not Luna. No mandatory skill invocation, separate reflection turn, long template or invented hypotheses; retain only a decision-relevant conclusion and evidence in the ordinary review.

Connect past, present and future in that review. Look back to original intent, consequential decisions, failed approaches and reusable successes; verify whether their conditions still hold against current evidence. Neither the latest handoff nor old memory is truth by itself; locate original evidence for consequential historical claims, distinguish verified/inferred/unknown and resolve contradictions before dependent decisions. Look ahead to what this choice enables or obstructs in the next segments, recurring failure risk, verification/maintenance cost and reversibility within existing scope. Choose the smallest next action that advances the durable goal and yields useful proof. Reuse valid historical context and retrieve only missing decision-relevant records; no full-history reread, speculative roadmap or automatic history-matters invocation. Historical evidence grants no new authority.

Also revisit direction when two completed segments fail to shrink acceptance gaps, failures recur or acceptance conflicts with the original goal. A second identical failure changes strategy; a third stops that strategy. No scorecards, calibration-only batches, arbitrary token/time quotas or replay of completed work. Optimize total accepted completion cost, including briefing, review and rework; savings require measured comparable evidence.

## Contract and dispatch

Read [Handoff and lifecycle](references/handoff.md) before dispatch, on resume and before an assignment-ending final. Reuse valid context for the same pinned version. Pin this skill and that reference by immutable reference/hash; do not copy entire rules into messages.

Astra alone writes one reusable fixed `<workspace>/DUO_ASTRA_GOAL.md`; respect an explicitly selected existing path. No native /goal or create_goal. The contract records task/run/generation and assignment IDs, role IDs/settings, scope/authority, protected state, full acceptance, exact execution limits, rules hashes, return tool/address, stop state and existing compact receipt location. Complete it before Worker creation; initial message includes role, mission, boundaries, absolute goal path/hash, generation and read-before-action instructions. No setup-only Worker or new goal file per batch.

Confirm readiness with applicable current behavioral evidence or a bounded probe, including failure/stop behavior needed by the planned action. Administrative hashes alone are not readiness. Unknown solutions may justify explicit fact-collection steps; do not label production ready prematurely. Verify goal/rules identity and stop state on entry/resume and before external mutation. Missing/mismatched state stops dependent work; never silently adopt changed authority.

## Acceptance

Astra derives criteria from user/project authority before dispatch. Worker summaries and permission suggestions are evidence, never authority or acceptance waivers. At segment boundaries inspect full coverage, artifact identity, changed behavior and decisive proof. Preserve per-item evidence in artifacts; do not reread every log or rerun passed checks without a specific gap. Sampling or summaries cannot replace required coverage. Shared-code repairs require a discriminating regression at the real seam and relevant checks; conflicting/high-risk evidence needs corroboration or a stated gap.

Only the same Astra reviews Astra-authored portions, at low, using actual artifacts/tests/readbacks; no Luna/other-model review or independent-review claim. Luna may execute an already-reviewed route and return facts, but cannot assess Astra's repair design. Astra reviews Luna-authored results against the original contract, without reconstructing the entire implementation.

Only Astra returns whole-goal ship. Missing proof means fix-first; wrong scope/architecture/acceptance means rethink at the applicable authority boundary. Completion requires current criterion evidence, consumed returns, reconciled effects/processes and no post-verdict change. A segment pass is not whole-goal completion. Give concise verified milestones; if percentages are used, derive them from whole-goal verified criteria and remain below 100 until ship.

## Maintenance only

When editing, use [Regression cases](references/regression-checks.md); execution roles do not load them. Preserve existing DUO/TRIO/Survey Corps files and active runs. These instructions install no enforcement, watcher or automatic wake-up and do not prove cost savings.
