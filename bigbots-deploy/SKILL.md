---
name: bigbots-deploy
description: Use when the user explicitly asks for "/bigbots deploy", "/bigbots-deploy", stronger-than-mini parallel subagents, GPT-5.5 medium subagents, distributed project research, blind-spot hunting, creative direction, or parallel execution of an already-approved implementation plan.
---

# BIGBOTS-DEPLOY

`/bigbots deploy` is the standard-model version of `lilbots-deploy`.

Default behavior:

- Fill up to **3 useful role slots**, but first reuse any suitable existing subagents in the current thread
- Use model **`gpt-5.5`**
- Use reasoning effort **`medium`**
- Keep the main agent responsible for grounding, synthesis, decisions, review, and final verification

Use this only when the user explicitly asks for `/bigbots deploy`, asks for GPT-5.5 standard agents, or wants the same workflow as `lilbots-deploy` but stronger than mini.

## Authorization Gate

Subagents are allowed here only because `/bigbots deploy` is an explicit user request for parallel agent work. If the user did not explicitly ask for subagents, do not use this skill.

Before spawning or reusing agents, the main agent must:

1. Identify the immediate critical-path task it will keep locally.
2. Identify which subtasks are independent sidecar work.
3. Skip any role that would duplicate local work or block the next local step.
4. Stop and report a blocker if fewer than two independent sidecar tasks exist; do not spawn agents for theater.

## Modes

### Mode A: Research Mode (default)

Use this when the task is to:

- inspect a project from multiple angles
- find blind spots, risks, blockers, and fake-complete states
- brainstorm creative but grounded directions
- review a messy frontier before deciding the main line

Reuse suitable existing **`gpt-5.5` medium** subagents first, and only spawn enough new ones to fill useful distinct roles:

1. Architecture Archaeologist
2. Blind-Spot / Risk Hunter
3. First-Principles Creative Officer

The main agent must synthesize the results into one report. Do not paste three raw outputs as the final answer.

### Mode B: Plan Execution Mode

Use this only when the main agent already has:

- an approved design
- a concrete implementation plan
- a task list with clear ownership
- disjoint write scopes that can safely run in parallel

Reuse suitable existing **`gpt-5.5` medium** worker subagents first, and only spawn enough new ones to fill useful execution slots. Each worker must receive one bounded task, one responsibility area, and an explicit warning that other workers may be editing nearby code.

Do not use execution mode when the plan is still vague. First make the plan locally, then delegate.

## Core Rules

1. The main agent decides the main line. Subagents provide inputs or bounded implementation.
2. Always do minimal grounding before spawning agents: read current repo truth, `AGENTS.md`, `_ctx/INDEX.md` if present, status docs, terminal/process state, and relevant files.
3. Before spawning, check whether the current thread already has suitable subagents; reuse them with `send_input` / `resume_agent` when possible.
4. Only spawn missing agents needed to fill uncovered roles or scopes.
5. Choose each subagent's `agent_type` from the subtask, not just the mode label: use `explorer` for idea-finding, evidence gathering, and comparison; use `worker` for bounded implementation, code edits, or concrete output.
6. When tasks are independent, keep useful role slots running in parallel; do not force all three when one would be filler.
7. Keep roles different. Do not launch three generic reviewers.
8. Do not outsource product or architecture decisions.
9. Do not wait idly after spawning. While agents run, continue non-overlapping local work.
10. Final output must distinguish:
   - verified
   - high-confidence
   - needs verification
11. If the result should persist, update the correct thread/workstream continuity, not a generic repo-wide note.

## Research Roles

### 1. Architecture Archaeologist

Ask this agent to find:

- current main line
- real coupling
- stale compatibility layers
- obsolete files or concepts
- naming drift
- technical debt that blocks forward motion

Output focus:

- structural findings
- removable complexity
- evidence from files, commands, or runtime state

### 2. Blind-Spot / Risk Hunter

Ask this agent to find:

- hidden blockers
- state that disagrees with runtime behavior
- verification gaps
- fragile assumptions
- fake-complete states
- places likely to break later

Output focus:

- concrete risks
- actual blockers
- evidence and severity

### 3. First-Principles Creative Officer

Ask this agent to find:

- simpler routes if current assumptions are dropped
- high-leverage rebuild options
- lighter paths that preserve the goal
- creative but executable experiments

Output focus:

- new directions
- simplification opportunities
- experiments worth trying

## Spawn Defaults

When useful agent coverage is incomplete, use `spawn_agent` only for the missing slots. If suitable agents already exist, prefer `send_input` or `resume_agent`.

For newly spawned agents, use:

- `model`: `gpt-5.5`
- `reasoning_effort`: `medium`
- `agent_type`: choose per slot based on the current subtask; default to `explorer` for research-oriented roles and `worker` for bounded execution roles
- `fork_context`: `false` unless the subagent truly needs the full thread

Do not override model/reasoning for adjacent tasks. The `gpt-5.5` medium override belongs only to this explicit `/bigbots deploy` workflow.

For worker agents, include:

- the exact files/modules they own
- the verification command or expected check
- "You are not alone in the codebase; do not revert others' edits."
- "List changed file paths in your final answer."

## Research Prompt Template

Give each research agent:

```text
You are one of up to three useful GPT-5.5 medium subagents working in parallel.

Workspace: <absolute cwd>
Theme: <current task>
Role: <one role only>

Do not make final product decisions.
Do not do a generic review.
Ground claims in files, commands, logs, or runtime evidence.

Return:
1. findings
2. evidence
3. risk / opportunity level
4. recommended next move
```

## Worker Prompt Template

Give each worker agent:

```text
You are one of up to three GPT-5.5 medium worker subagents working in parallel.

Workspace: <absolute cwd>
Main plan: <approved plan summary>
Your responsibility: <specific task>
Your write scope: <files/modules>
Verification: <commands/checks>

You are not alone in the codebase. Other workers may edit other areas.
Do not revert edits made by others.
Do not expand beyond your write scope unless required, and report any such need first.

Edit files directly in your forked workspace.
Final answer must list changed file paths, verification run, and blockers.
```

## Main-Agent Synthesis

After subagents return, the main agent must:

1. Deduplicate findings
2. Compare conflicts
3. Rank by impact, risk, and feasibility
4. Decide the recommended main line
5. Run or define verification
6. Update continuity/status if the result should survive the chat

Final research report structure:

1. `總判斷`
2. `高價值優化點`
3. `隱藏盲點 / 風險`
4. `創造性方向`
5. `建議主線`
6. `百分比現況`
7. `本地 critical path / 已委派 sidecars`

Each point should include:

- evidence level: verified / high-confidence / needs verification
- impact
- priority

## Completion Criteria

Research mode is complete only when:

1. All useful distinct `gpt-5.5` medium role slots identified by the Authorization Gate were filled, preferring reuse of existing subagents and spawning only for missing roles
2. Their outputs are meaningfully different
3. The main agent produced one synthesized report
4. The report separates verified facts from hypotheses
5. Continuity/status was updated in the correct thread/workstream when appropriate

Execution mode is complete only when:

1. A concrete plan existed before spawning
2. Work reused suitable existing workers where possible, and only spawned new workers for missing scopes
3. Workers stayed within scope or reported exceptions
4. The main agent reviewed, integrated, and verified the result
5. The final result matches the original main plan

## Prohibitions

- Do not use old mini models for `/bigbots deploy`; if the user wants the lighter path, use `lilbots-deploy` with `gpt-5.5` low.
- Do not spawn agents for theater.
- Do not force exactly three agents when fewer independent sidecar tasks exist.
- Do not blindly create three fresh agents if suitable ones already exist in the thread.
- Do not delegate the immediate blocker if the main agent needs it before the next step.
- Do not ask subagents to choose the main architecture.
- Do not paste raw subagent outputs as the final answer.
- Do not create dashboards, orchestrators, or metadata systems for this skill.
