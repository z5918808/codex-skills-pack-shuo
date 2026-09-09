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

Astra first reads current authority and reusable evidence, identifies the real bottleneck and gives Luna the largest coherent executable segment justified by evidence and limits. Include outcome/coverage, baseline and inputs, allowed paths/actions, protected state, steps/decision rules, checks rejecting a plausible wrong result, stop conditions and return route. For successors, reference the verified current contract, procedures and accepted evidence; supply only changed instructions and examples needed to remove ambiguity. Ensure the receiver can access those references; provide missing context rather than resending all background. Do not draft the whole implementation before assigning it.

Luna performs most specified code edits, adapters, fixtures, data/content work, prescribed checks and evidence packaging. Default to one bounded implementation -> prescribed checks -> evidence segment when dependencies, pass/stop rules and authority permit. Split for a justified execution limit, actual unresolved decision, failed check, scope/authority change or required approval; never enlarge live scope or skip a required checkpoint to reduce handoffs. Luna does not manage, brainstorm, choose strategy, diagnose, design fixes or improvise retries. On error, ambiguity or failed check, pause affected steps and return evidence; only already-specified independent steps may continue.

Astra owns diagnosis and repair design, then delegates understood changes and checks to Luna under a fresh reconciled brief. Shared-code edits require explicit file/behavior scope and prescribed regression checks; they are not Worker self-repair. Astra may directly finish an understood small local fix when briefing/handback would cost more, briefly recording why. Do not expand that exception into bulk execution or a whole module. Keep one writer, preserve user changes and pause affected successors during diagnosis/repair. Production traversal, live rollback/recovery, canaries and migrations remain Luna's work under explicit authority and fresh applicable gates; local repair grants no live permission.

## Think before every review

Before initial dispatch, next-segment selection and every review (including technical handoff and acceptance), Astra briefly checks:

- **Past:** original intent, relevant decisions, failed approaches and reusable successes; do their conditions still hold? Latest handoffs and old memory are claims, not truth. Ground consequential historical claims in original evidence, distinguish verified/inferred/unknown and resolve contradictions before dependent decisions.
- **Present:** the remaining acceptance gap and real bottleneck; separate facts from explanations, check recent-context bias and local symptoms versus their earliest shared cause. Can work be deleted, simplified or deferred?
- **Future:** what the next segment enables or obstructs, recurring failure and verification/maintenance cost, and reversibility within current authority. Choose the smallest useful next action and its decisive proof.

This thinking belongs to Astra and informs accept, rebrief, repair, defer or escalate. Reuse valid context; retrieve history only for a missing decision-relevant fact, conflicting claim or changed condition. Do not reread full history, rewrite the roadmap, invoke another skill or create a reflection-only turn by default. Keep only conclusions that affect the decision in the ordinary review; historical evidence grants no authority.

Also revisit direction when two completed segments fail to shrink acceptance gaps, failures recur or acceptance conflicts with the original goal. A second identical failure changes strategy; a third stops that strategy. No scorecards, calibration-only batches, arbitrary token/time quotas or replay of completed work. Optimize total accepted completion cost, including briefing, review and rework; savings require measured comparable evidence.

## Contract and dispatch

Read [Handoff and lifecycle](references/handoff.md) before dispatch, on resume and before an assignment-ending final. Reuse valid context for the same pinned version. Pin this skill and that reference by immutable reference/hash; do not copy entire rules into messages.

Astra alone writes one reusable fixed `<workspace>/DUO_ASTRA_GOAL.md`; respect an explicitly selected existing path. No native /goal or create_goal. The contract records task/run/generation and assignment IDs, role IDs/settings, scope/authority, protected state, full acceptance, exact execution limits, rules hashes, return tool/address, stop state and existing compact receipt location. Complete it before Worker creation; initial message includes role, mission, boundaries, absolute goal path/hash, generation and read-before-action instructions. No setup-only Worker or new goal file per batch.

Confirm readiness with applicable current behavioral evidence or a bounded probe, including failure/stop behavior needed by the planned action. Administrative hashes alone are not readiness. Unknown solutions may justify explicit fact-collection steps; do not label production ready prematurely. Verify goal/rules identity and stop state on entry/resume and before external mutation. Missing/mismatched state stops dependent work; never silently adopt changed authority.

## Acceptance

Astra derives criteria from user/project authority before dispatch. Worker summaries and permission suggestions are evidence, never authority or acceptance waivers. At segment boundaries inspect full coverage, artifact identity, changed behavior and decisive proof. Reuse accepted evidence after confirming its artifact/version, inputs, assumptions and criterion coverage still apply; inspect the delta, uncovered criteria and conflicts. Repeat checks only when relevant changes, expired conditions, new failures or unreliable evidence invalidate that proof. Preserve per-item evidence in artifacts; do not reconstruct passed work or reread every log. Sampling or summaries cannot replace required coverage. Shared-code repairs require a discriminating regression at the real seam and relevant checks; conflicting/high-risk evidence needs corroboration or a stated gap.

Only the same Astra reviews Astra-authored portions, at low, using actual artifacts/tests/readbacks; no Luna/other-model review or independent-review claim. Luna may execute an already-reviewed route and return facts, but cannot assess Astra's repair design. Astra reviews Luna-authored results against the original contract, without reconstructing the entire implementation.

Only Astra returns whole-goal ship. Missing proof means fix-first; wrong scope/architecture/acceptance means rethink at the applicable authority boundary. Completion requires current criterion evidence, consumed returns, reconciled effects/processes and no post-verdict change. A segment pass is not whole-goal completion. Give concise verified milestones; if percentages are used, derive them from whole-goal verified criteria and remain below 100 until ship.

## Maintenance only

When editing, use [Regression cases](references/regression-checks.md); execution roles do not load them. Preserve existing DUO/TRIO/Survey Corps files and active runs. These instructions install no enforcement, watcher or automatic wake-up and do not prove cost savings.
