---
name: strategic-autoresearch
description: Use for ambiguous or recurring problems, hard reviews, autoresearch, or stepping back to prove one repair.
---

# Strategic Autoresearch

Find the real bottleneck, prove it cheaply, delete complexity, and commit one move.

```text
Escape → Bound → Test → Delete → Commit
```

Produce a decision, not a long report.

## 1. Escape the local story

Separate:

- `Verified`: directly observed facts.
- `Story`: the current explanation.
- `Context trap`: recent bugs, diffs, summaries, or wording that may bias the diagnosis.

Frame the game board:

```text
The strategic bottleneck is <problem> because it limits <outcome>.
```

If unsupported, label it a hypothesis.

## 2. Bound the research

Define before testing:

```text
Goal:
Success signal:
Editable surface:
Frozen surface:
Loop budget:
Stop condition:
```

Budgets:

- Quick: 1–2 loops.
- Standard: 2–4 loops.
- Autonomous: only with explicit request, isolated workspace, fixed metric, safe rollback, and fixed budget.

Do not experiment without a success signal and stop condition.

## 3. Test one hypothesis per loop

```text
Hypothesis:
Cheapest decisive test:
Evidence:
Verified:
Inferred / missing:
Decision: keep / partial / discard / pivot / stop
Next:
```

Prefer:

1. Authoritative existing evidence.
2. Read-only runtime probe.
3. Reversible isolated experiment.
4. Bounded real-world test.

Stop when the next move is clear. If a loop adds no information, change method or stop.

## 4. Delete before adding

Ask in order:

1. Can the requirement disappear?
2. Can a step, wrapper, state copy, handoff, or artifact disappear?
3. Can the interface shrink?
4. Can logic return to one canonical owner?
5. Only then: what test, guard, command, or automation is missing?

Look for:

- Multiple sources of truth.
- Unverified claims treated as facts.
- Hidden scheduling or assembly work.
- Thin wrappers and duplicated rules.
- Patch chains that add joins or handoffs.
- Temporary processes presented as persistent systems.
- Automation applied before workflow deletion.

Severity when useful:

- `P0`: unsafe or destructive.
- `P1`: false truth or repeated wrong execution.
- `P2`: major recovery, verification, or handoff cost.
- `P3`: local friction or presentation debt.

## 5. Commit one move

Rank repairs by:

1. Bottleneck removed.
2. Repeated failure class absorbed.
3. Verification made earlier and cheaper.
4. Interface and state reduced.
5. Migration kept small and reversible.

Recommend exactly one first move:

```text
Move:
Job:
Deleted / simplified:
Canonical owner and state:
Smallest useful implementation:
Acceptance evidence:
Stop rule:
```

If several projects remain equally important, synthesis is incomplete.

## Hard Rules

- Claims require files, commands, logs, run IDs, or runtime observations.
- Keep verified facts, inference, and missing evidence separate.
- Do not let the newest bug define the system.
- Do not create artifacts merely to organize uncertainty.
- Do not automate unnecessary workflow.
- Reviews are read-only unless implementation is explicitly requested.
- Run risk preflight before touching production, destructive actions, databases, money, inventory, credentials, orders, or customer data.
- Stop at the defined condition.

## Output

Use the smallest format that preserves the decision:

```text
Verdict:
Game board:
Context trap:
Verified:
Inferred / missing:
Evidence loops:
Delete first:
One move:
Acceptance evidence:
Defer:
Stop reason:
```

For hard reviews, add:

```text
severity | problem | evidence | impact | recommendation
```

The findings table supports the conclusion; it does not replace the one-move decision.
