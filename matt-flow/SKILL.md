---
name: matt-flow
description: "Explicit-only router for /matt-flow, $matt-flow, or Matt style; enters the nearest useful engineering stage."
---

# matt-flow

Route the current task through Matt Pocock's installed skills without recreating or expanding their workflows.

## Activation

- Activate only on explicit invocation or explicit delegation from `find-my-safe-work-island`. Do not infer Matt style from an ordinary task.
- Respect Global and repo instructions, permissions, safety gates, and user scope.

## Route

1. Read the installed `ask-matt/SKILL.md` completely as the canonical routing map. Do not execute it as a work stage or repeat its full map.
2. Inspect the current request and only enough repository evidence to identify the nearest useful stage.
3. Select the lightest Matt skill capable of producing the requested outcome.
4. Read that skill's `SKILL.md` completely before executing it.
5. Load another skill only when the current skill finishes and the requested outcome still requires another stage.

If this wrapper conflicts with `ask-matt` about Matt's route or skill semantics, follow `ask-matt`. Explicit user intent, Global/repo instructions, permissions, and safety gates still override both.

Treat docs as evidence, not automatic truth. Resolve contradictions with bounded checks; ask only when a material product or safety decision remains.

Start with one concise line:

`Route: <current state> → <selected skill> → <requested finish>`

Do not print the full Matt workflow or a stage ledger unless the task genuinely spans multiple stages or sessions.

## Entry rules

Enter at the nearest stage supported by current evidence:

- Existing usable spec → do not restart with grilling.
- Existing tickets → enter implementation when appropriate.
- Existing implementation or PR → enter review or validation.
- Reproducible bug → use the bug-diagnosis route.
- Missing material product decisions → use grilling or specification.
- Large cross-session work → use the relevant planning or handoff route.

Do not create missing artifacts merely to complete a ritual.

## Depth modes

- **Default:** reuse satisfied stages, enter at the nearest useful stage, and run only what the requested outcome needs.
- **Heavy / end-to-end / full:** chain the complete applicable Matt workflow through validated acceptance. Reuse stages already proven sufficient.
- **Full reset / from scratch / fresh reconstruction:** treat existing assumptions, specs, and tickets as evidence rather than authority; re-research or rebuild the applicable flow from the front. Preserve existing authoritative artifacts instead of silently overwriting them.

Only explicit user wording selects a heavier mode. Lightweight routing does not limit how deep an explicitly requested run may go.

## Progression

After each selected skill reaches its exit condition:

1. Compare the result with the user's requested outcome.
2. Stop when that outcome is met and validated.
3. Otherwise choose and load only the next necessary Matt skill.
4. Re-enter an earlier stage only when a material unresolved decision blocks progress.

Finish boundaries:

- Research, grill, spec, tickets, review, architecture, triage, or handoff request → stop after that deliverable.
- Build, fix, or ship request → continue through the necessary implementation, review, repair, and validation.
- Explicit end-to-end request → chain only the stages required to reach validated acceptance.

Do not add wrapper-level approval ceremonies. Pause only for a material decision, required permission, genuine blocker, or safety gate.

## Artifacts

When creating durable specs, tickets, ADRs, or handoffs:

- Follow the repository's existing conventions.
- Inspect before writing and never silently overwrite authoritative work.
- Reuse the same artifact for the same objective while it remains an unconsumed draft.
- When downstream work already depends on it, preserve the old version and create a clearly identified revision for material changes.
- Keep provenance simple: record the source path, issue, commit, or revision when another stage depends on it.

Do not create revision infrastructure, hashes, state files, or tracking metadata unless the repository already uses them or the task genuinely requires long-running durable coordination.

## Skill resolution

Resolve installed skills using the harness lock or manifest when available.

Otherwise:

1. Prefer `~/.codex/skills`.
2. Fall back to `~/.agents/skills`.
3. If duplicate copies differ and neither is pinned, report the ambiguity instead of mixing versions.

## Done

Use the active skill's completion contract together with Global `Done`.

When files changed, include relevant tests or checks, actual diff review, and the highest practical behavior proof.

Report which Matt skills were used; do not claim that skipped stages ran.
