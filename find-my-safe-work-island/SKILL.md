---
name: find-my-safe-work-island
description: Use only for /find-my-safe-work-island or $find-my-safe-work-island to bound an overwhelming, huge, or dirty repository.
---

# find my safe work-island

Build one understandable, protected work island inside a dirty repository. Do not clean the surrounding universe.

## Contract

- Activate only on explicit invocation.
- Preserve every existing dirty or untracked change as user-owned state.
- Do not reset, revert, delete, move, reformat, commit, or broadly refactor unrelated work.
- Do not audit or model the entire repository. Expand the island only when evidence shows the goal depends on another surface.
- Respect Global and repo instructions, safety gates, scope, and live-action permissions.

## 1. Fix the destination

Infer the observable goal and finish boundary from the current chat:

- `island-only` — establish the bounded truth map and recommended route.
- `spec-green` — establish the island, then produce a validated spec.
- `implementation-green` — establish the island, then implement, review, repair, and validate the bounded goal.

If the goal or finish boundary cannot be inferred safely, ask one decision-dense question. Do not ask for facts available in the repo.

## 2. Preserve the outer universe

Before edits:

- Locate the repo root and read applicable instructions.
- For Git, record `HEAD`, branch, diff base, and `git status --short`. Do not dump every large diff into context.
- Classify dirty paths as `island-relevant`, `protected-outside`, or `unknown`. Inspect only relevant paths; treat outside paths as a no-touch fence.
- Hash relevant untracked files before touching them. For a non-Git repo, record bounded path and hash baselines.
- Never count pre-existing changes as progress from this run.

## 3. Build the island

Establish one stable `work-id` and a compact Goal Contract:

- Objective and observable acceptance.
- In-scope surfaces and protected-outside paths.
- Relevant entry points, docs, domain terms, decisions, tests, and proof commands.
- Unknowns that are independently discoverable versus decisions only the user can make.

For each material claim, distinguish:

- committed baseline
- dirty candidate state
- docs claim
- runtime or test truth

Resolve contradictions with the cheapest decisive readonly probe or reversible experiment. Ask only when competing product meanings, scope, safety, or irreversible choices remain.

Keep a short task in chat only. When the island must survive sessions or produces downstream artifacts, follow the repo convention or write a compact `docs/work/<work-id>/ISLAND.md`. Make it a map to evidence coordinates, not a second source of truth.

## 4. Route without widening

After the island boundary is stable:

1. Stop with the island map when the finish boundary is `island-only`.
2. Otherwise read the installed `matt-flow` `SKILL.md` completely.
3. Treat this explicit wrapper invocation as explicit delegation to `matt-flow`.
4. Pass it the Goal Contract, scope fence, protected paths, truth distinctions, current artifacts, and requested finish.
5. Let `matt-flow` select and load only the minimum original Matt skills needed.

Do not pause for ceremonial approval between stages. If evidence reveals a dependency outside the island, expand only that edge, record why, and keep everything else protected.

## Done

For every run, report:

- work-id, objective, finish boundary, and scope fence
- baseline evidence and protected dirty state
- resolved contradictions and remaining material unknowns
- selected Matt route, or the recommended next route for `island-only`

If execution continued beyond island discovery, also satisfy `matt-flow` and Global completion contracts. Never claim the surrounding repository is clean or understood.
