---
name: smart-go
description: Use when the user invokes /smart-go, $smart-go, "smart go", or asks Codex to research first and then autonomously continue, choose between a go-style segment and a broader outcome-driver mode, drive the current workspace, reduce uncertainty before execution, or push a project to verified progress without starting from blind planning. Do not use this as a replacement for Codex App's native Goal UI.
---

# Smart Go

`/smart-go` is a research-first execution driver.

It combines the useful parts of:

- `autoresearch`: reduce decision-relevant uncertainty with bounded evidence loops.
- `go`: continue the current mainline through a meaningful verified segment.
- `outcome-driver`: choose or define one high-leverage outcome when the direction is broad, missing, or roadmap-level.

Core stance: **research just enough to choose the right driver, then execute to evidence.**

Do not turn Smart Go into an analysis ceremony. The research phase exists to prevent wrong execution, not to delay execution.

Second core stance: **structure before finish.**

Do not perfect a local detail while the load-bearing project structure is still incomplete. Avoid polishing one tile when the columns, floor slab, plumbing, wiring, or inspection path are not yet in place.

Third core stance: **experiment loop, not wandering loop.**

Borrow the useful autoresearch pattern: fixed metric, fixed budget, frozen ground truth, narrow editable surface, experiment ledger, keep/discard/crash decision, then rebound quickly.

Smart Go is not allowed to "keep working" by drifting. It may keep working only by running evidence loops that can decide keep, discard, pivot, or stop.

## Codex App Native Goal Boundary

Codex App may provide a native Goal UI. That is an App feature, not a custom skill.

Smart Go must not:

- recreate a custom `goal` skill
- call a deleted or repo-local `goal` skill
- shadow the App native Goal button
- pretend Smart Go is native Goal
- open or automate native Goal unless another skill explicitly owns that workflow

Use Smart Go when the user invokes Smart Go or asks for research-first execution.

If the user explicitly asks to use Codex App native Goal, do not execute the work as Smart Go. Produce only a compact handoff for the App Goal entry:

```text
Objective:
Baseline:
Metric / success evidence:
Editable surface:
Frozen surface:
Structure priority:
Safety gates:
First verification:
Stop / handoff condition:
```

Then tell the user to start it with the App's native Goal UI.

If the user asks Smart Go to continue after a native Goal run, first inspect the latest verifiable status with the normal check workflow, then decide whether to resume with Smart Go rules.

## Core Rule

Always run a bounded autoresearch pass before committing to a `go` segment or broader outcome-driver mode.

The pass must answer:

1. What is the live project reality?
2. What uncertainty matters for choosing the next action?
3. Is this a continuation segment (`go`) or a broader outcome-driver run?
4. What evidence will prove the chosen path worked?
5. What stop gate would make execution unsafe or wasteful?
6. Is the next action structural progress or local finish work?
7. What metric or evidence decides keep vs discard?
8. What surface may change, and what surface must stay frozen?

After that, choose one path and execute unless a stop gate triggers.

Do not present multiple options by default. Give one chosen path with a short reason.

## Structure Before Finish

Classify work before execution:

| Class | Meaning | Smart Go default |
| --- | --- | --- |
| Foundation | Goal, scope, safety boundary, repo truth, architecture, data path, test harness, artifact route, recovery path. | Do first when missing or unstable. |
| Frame | Main pipeline, end-to-end slice, core API/data/UI path, runner, conductor, state machine, verification spine. | Prioritize until the system can stand. |
| Rough-in | Integration points, adapters, schemas, manifests, status docs, review packs, resumability, no-apply gates. | Do enough to connect the frame. |
| Inspection | Tests, audits, smoke checks, counts, logs, screenshots, dry-runs, recovery checks. | Required before calling progress real. |
| Finish | Naming polish, edge-case cleanup, visual or prose refinement, micro-optimization, local refactor, single-item perfection. | Defer unless it unlocks structure or verification. |

Default priority:

1. foundation
2. frame
3. rough-in
4. inspection
5. finish

Finish work is allowed only when one is true:

- the relevant structure is already verified
- the polish removes a blocker for verification, review, or handoff
- the user explicitly asked for polish
- the finish item is tiny and prevents immediate confusion without delaying structural progress

If the agent notices it is polishing a local detail while larger structure is incomplete, stop the local loop and reselect the next structural action.

Use this internal check:

```text
Am I making the building stand, connect, pass inspection, or merely making one tile perfect?
```

If the answer is "one tile perfect", pivot unless a stop gate says that tile blocks the structure.

## Autoresearch Experiment Contract

Before executing non-trivial work, define the experiment boundary.

```text
Baseline:
Metric / success evidence:
Editable surface:
Frozen surface:
Budget:
Run artifact / ledger:
Keep rule:
Discard rule:
Crash / rebound rule:
```

Rules:

- Establish a baseline before claiming improvement.
- Freeze the evaluation surface. Do not move the goalpost while trying to win the metric.
- Keep the editable surface narrow enough that diffs are reviewable.
- Prefer one high-signal experiment over many vague changes.
- Log enough evidence that the next agent can see what was tried and why it was kept/discarded.
- If a change improves the metric but adds ugly complexity, weigh complexity cost against gain.
- If equal quality comes from simpler code/process, keep the simplification.
- If the run crashes from a trivial typo/import/path issue, fix and rerun once or twice.
- If the idea is fundamentally broken, mark crash/discard and rebound to the next experiment.
- Do not let repeated crash-fixing become the main task unless the crash blocks the structural milestone.

Smart Go adaptation of `keep / discard / crash`:

| Status | Meaning | Action |
| --- | --- | --- |
| keep | Evidence improved, blocker removed, structure advanced, or equal result got simpler. | Preserve change and continue from new baseline. |
| keep-partial | Useful artifact or narrowed blocker exists, but success metric not fully met. | Save evidence, define next structural step. |
| discard | No improvement, worse result, polish-only change, or complexity cost exceeds benefit. | Do not build on it; revert only own safe changes when separable. |
| crash | Tool/runtime/test failed before result, or experiment invalid. | Fix once if trivial; otherwise log and rebound. |
| pivot | Evidence shows target/driver was wrong. | Rechoose driver or structural priority. |

Default Smart Go budget:

- Quick run: one baseline check + one experiment.
- Normal run: one baseline check + up to three experiments.
- Long unattended loop: only when the user explicitly asks for continuous/autonomous looping and safety gates allow it.

Unlike the original autoresearch repo, Smart Go must not loop forever by default. In normal Codex App work, stop at a verified checkpoint, real blocker, or safety gate.

## Driver Selection

Choose `go` when:

- there is an existing mainline, continuity note, status file, handoff, latest assistant next step, or live terminal/artifact state
- the next meaningful segment is clear enough
- success can be verified in this turn
- the task is mostly continuation, repair, cleanup, testing, report generation, or checkpoint completion

Choose outcome-driver mode when:

- the target is broad, missing, strategic, roadmap-level, or ambiguous
- the project needs one selected high-leverage outcome before execution
- the work should start with an Outcome Contract
- multiple local actions may be needed to produce a verified milestone

Outcome-driver mode is internal to Smart Go. Do not recreate or depend on a custom `goal` skill, and do not pretend to be Codex App native Goal. If the user explicitly wants App native Goal, produce a compact handoff and stop.

## Research Phase

Use the lightest autoresearch mode that can choose safely.

Default: quick loop.

Use standard loop when:

- multiple files/status sources conflict
- repo-local skill shadowing or stale session behavior may affect the run
- several plausible workstreams compete
- the output should be saved as durable project state

Research contract:

```text
Research question:
Evidence needed:
Stop condition:
Chosen driver criteria:
Structure class:
Finish-work risk:
Baseline:
Metric / success evidence:
Editable surface:
Frozen surface:
Safety gates:
```

Evidence sources, in order:

1. User's latest explicit request.
2. Live workspace state.
3. `AGENTS.md`.
4. `_ctx/INDEX.md` and `_ctx/MANIFEST.jsonl` if present.
5. `PROJECT_STATUS.md`, `AGENT_STARTUP_SOP.md`, `docs/SESSION_LOG.md`, handoff/status docs if present.
6. Terminal/process/log state when relevant.
7. Relevant skill files when the task is about skills.

Stop research as soon as evidence is enough to choose a driver and define success evidence.

## Execution Phase

Before executing, say one short line:

```text
目前判斷：先用 <go/outcome-driver>，因為 <verified reason>。下一段 / outcome 是 <concrete target>。
```

For non-trivial work, also name the structural priority:

```text
結構優先級：<foundation/frame/rough-in/inspection/finish>，原因：<why this advances the building instead of polishing a tile>。
```

Then execute.

If using `go` behavior:

- make a 3-7 step segment plan only when needed
- execute to a meaningful checkpoint
- verify with files, tests, logs, browser state, reports, or explicit inspection
- decide keep / keep-partial / discard / crash / pivot before continuing
- stop after the checkpoint instead of expanding endlessly

If using outcome-driver behavior:

- create a compact Outcome Contract
- execute one meaningful milestone
- verify before claiming progress
- decide keep / keep-partial / discard / crash / pivot before continuing
- stop at complete, partial progress, real blocker, safety stop, or explicit pause

## Polish Budget

Give finish work a strict budget.

Default polish budget: 10-20% of the current segment.

Do not spend more than the polish budget unless:

- verification already passed
- the user explicitly asked for polish
- polish is required to unblock review, adoption, or a handoff

When polish pressure appears, ask internally:

```text
Will this make the next structural milestone easier, or only make the current local area prettier?
```

If it only makes the local area prettier, record it as a later cleanup item and continue structural work.

Examples:

- Good Smart Go move: create the runner, connect the manifest, prove 10 rows, write the next checkpoint.
- Bad Smart Go move: spend the whole run renaming helper variables after only 2 rows work.
- Good Smart Go move: add one clear status note so the next agent can resume.
- Bad Smart Go move: rewrite the entire report style while the pipeline has no verification.

## Safety Gates

Stop and ask before:

- production deploy
- database migration or mutation
- destructive file/system operation
- payment, order, inventory, or customer-data action
- credential, token, secret, or key handling
- legal, compliance-sensitive, or security-sensitive action with real-world exposure
- irreversible external side effect

Also stop when:

- choosing between mutually exclusive product directions would cause meaningful rework
- live state contradicts memory and evidence is insufficient
- the next step would run over 10 minutes without an external worker / monitor pattern
- verification cannot be defined
- the metric or frozen evaluation surface keeps changing
- editable surface expands until the diff is no longer reviewable
- the task belongs to a different workspace or stale session and cannot be mapped safely

## Artifact Policy

Do not create a report for every Smart Go run.

Save an artifact only when:

- research produced durable findings
- execution changed project state
- the next session needs continuity
- a blocker/handoff would otherwise be lost
- user asked for a report

Preferred routes:

- `_ctx/workstreams/<topic>/status.md` when `_ctx/INDEX.md` exists
- existing `PROJECT_STATUS.md` or `docs/SESSION_LOG.md` when the project already uses them
- `reports/smart-go-YYYYMMDD-<topic>.md` only when no better project route exists

## Completion Standard

Done means:

1. Research question was answered enough to choose a path.
2. `go` or outcome-driver mode was chosen with evidence.
3. The chosen path prioritized foundation/frame/rough-in/inspection before finish work unless finish work was explicitly justified.
4. Baseline, metric/evidence, editable surface, and frozen surface were clear enough for the run.
5. One meaningful segment or milestone was executed, or a real blocker was proven.
6. Verification was run or the inability to verify was explicit.
7. The result was classified keep / keep-partial / discard / crash / pivot.
8. Changed files/artifacts and evidence were reported.
9. Next smallest structural action is clear.
10. Progress percentage is tied to evidence, not local polish.

## Report Format

Use concise Traditional Chinese by default:

```text
目前判斷:
研究結論:
選擇 driver:
結構優先級:
實驗邊界:
進度:
已做:
驗證:
keep/discard:
blocker / 風險:
下一步:
/Explain:
```

If only a quick check was needed, collapse the report into 3-5 lines.

## Anti-Patterns

- Researching until the answer feels impressive instead of actionable.
- Running `/go` blindly when live state is unclear.
- Turning every task into broad outcome ceremony when a go segment is enough.
- Presenting 3 options by default.
- Claiming completion without verification.
- Using stale skill metadata, stale session memory, or another workspace's state as current truth.
- Recreating, calling, or shadowing a custom `goal` skill after the App native Goal UI exists.
- Perfecting a local tile while the foundation, frame, rough-in, or inspection path is missing.
- Spending the whole segment on polish that does not unblock structure, verification, review, or handoff.
- Changing the metric after the experiment starts.
- Expanding the editable surface until nobody can tell what caused the result.
- Treating crash-fixing as progress when the original idea should be discarded.
- Keeping a tiny metric gain that adds a lot of brittle complexity.
