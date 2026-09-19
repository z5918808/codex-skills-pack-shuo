---
name: minimum-effective-harness-tuning
description: Design or prune skills, AGENTS.md, and agent prompts for minimal guidance with intact authority and acceptance.
---

# Minimum Effective Harness Tuning

Keep the smallest set of instructions that changes useful behavior. Optimize for completed work, sound evidence, and clear authority; fewer words alone do not prove improvement.

Use this skill when the instructions themselves are being designed or revised. Merely encountering an AGENTS.md or using another skill is not a reason to audit it.

## Working Method

Use these questions to guide decisions, not as a mandatory sequence or report template:

- **Outcome:** What result is required, what proves it, and where should work stop?
- **Purpose:** Does this instruction supply needed knowledge, a task-specific procedure, an authority boundary, an acceptance condition, or a workaround for an observed failure?
- **Necessity:** Does it materially change behavior? Can it be deleted, combined, or replaced with a shorter outcome requirement?
- **Placement:** Which role needs it, and at which event? Put it where that consumer will discover it without loading unrelated material.
- **Evidence:** Would the revision reduce unnecessary work while preserving completion, verification, and permission boundaries?

For new instructions, start from the requested outcome and add only the guidance the task needs. For existing instructions, read [audit.md](references/audit.md) when deciding what to retain, remove, rewrite, or move. For a material change to behavior or routing, use the relevant cases from [scenarios.md](references/scenarios.md); do not run every case for a wording-only edit.

## Design Principles

- Prefer required results and observable evidence over prescribed thinking, fixed numbers of hypotheses, reflection templates, or ceremonial steps.
- Keep precise sequences where ordering protects correctness, permission, or recovery. An uncertain external write and a local wording correction do not need the same process.
- Preserve explicit user authority boundaries, acceptance thresholds, and role ownership. Model capability is not permission to lower them. Continue work already authorized; do not add repetitive approval requests.
- When the user grants a continuing objective to an execution owner, encode it as one bounded execution envelope instead of requiring approval for every item or mutation. The envelope should name the goal scope, allowed mutation classes, invariants, acceptance evidence, and stop conditions. Within it, the executor may advance continuously; Reviewer/Main reviews milestones and exceptions rather than re-authorizing routine actions. Keep each external write attributable and diagnosable with a fresh preimage or equivalent current-state proof, exact intended delta, single-writer control, durable receipt/readback, and a tested or materialized recovery path. If the outcome becomes unknown, the action cannot be reconstructed or reversed to the required standard, the writer identity is uncertain, or the next action leaves the envelope, fail closed at that boundary. These are execution gates, not new approval prompts.
- Match assistance to the actual role and task. Keep execution details out of a reviewer's general reasoning instructions. Treat model-specific claims as hypotheses to validate, not permanent rules about named models.
- Make shared behavior canonical in one place. Repository AGENTS.md routes applicable defaults; skills carry task-specific workflows; references hold conditional detail; project state belongs in the project's existing state mechanism. Task prompts carry the current objective and scope, referencing shared rules where available. Follow the user's existing ownership conventions.
- Use progressive disclosure only when it saves irrelevant reading. A short, single-purpose skill does not need a router. When splitting a workflow, preserve discoverability and applicable version/hash contracts; avoid a new instruction to preload every reference.
- Reuse sufficient current evidence. Tests should expose a plausible wrong result, not restate the implementation. Do not add repeated tests, reports, or checkpoints just to demonstrate diligence.
- A workaround needs an observed problem and an applicable scope. Remove it when its reason no longer applies, but do not assume age or a new model proves it obsolete.

## Apply and Validate

Respect the request's action scope: advice or review does not automatically authorize edits. Once edits are authorized, make the bounded changes without asking the user to approve each routine step. Do not broaden into global skill cleanup or change unrelated project instructions.

For a skill edit, use `skill-creator` for packaging and format validation; do not duplicate its format rules here. Inspect only the affected consumers and references needed to establish that the new route works. Missing runtime evidence limits claims of effectiveness, not otherwise authorized document improvements.

Report the consequential decisions and evidence at the size the change needs. Distinguish document/format checks, static scenario reasoning, and observed agent behavior. Describe unmeasured benefits as expected, never as demonstrated speedups. Avoid producing a new governance framework, scoring system, or report file unless the task needs one.
