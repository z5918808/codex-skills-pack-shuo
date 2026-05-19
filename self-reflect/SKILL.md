---
name: self-reflect
description: Use when the user invokes /self-reflect, $self-reflect, asks whether a strategy is truly reliable, wants Codex to find loopholes before acting, requests an anti-overclaim audit, asks for a confidence loop, or says "are you 100% confident" and wants fixes until the plan is evidence-backed.
---

# Self Reflect

`/self-reflect` is a strategy confidence audit loop.

It is not praise, vibes, or generic second-guessing. It exists to prevent confident wrong plans.

Core behavior:

1. State the current strategy.
2. Ask whether it is actually 100% evidence-backed.
3. If not, find loopholes.
4. Patch the strategy.
5. Verify the patch against facts, code, docs, tests, logs, constraints, or user goals.
6. Repeat until no decision-relevant loopholes remain, a real blocker appears, or further looping has low value.

Never say "100% confident" unless every material assumption is verified or explicitly out of scope.

## Core Rule

Do not flatter the user or the previous assistant answer.

Treat the existing strategy as guilty until evidence clears it.

The loop must separate:

- verified facts
- assumptions
- loopholes
- fixes
- remaining risks
- confidence after fixes

If confidence is not truly 100%, say the real confidence and what would be needed to increase it.

## Confidence Meaning

`100%` means:

- all material assumptions are verified
- all known loopholes are patched or accepted as out of scope
- safety gates are respected
- the strategy has a concrete verification path
- no contradictory live evidence remains
- remaining uncertainty would not change the next action

If any of these are false, do not claim 100%.

Use these confidence labels:

| Label | Meaning |
| --- | --- |
| Low | Strategy is mostly speculative or missing key facts. |
| Medium | Main direction is plausible, but important loopholes remain. |
| High | Strategy is likely good; remaining risks are bounded and non-blocking. |
| Operationally 100% | Not metaphysical certainty; all decision-relevant loopholes visible in the current evidence have been handled. |

Prefer `High` over fake `100%`.

## Loop Protocol

Use 1-3 loops by default. Continue only when the next loop has a specific evidence target and is likely to change the strategy.

```text
Loop N:
Current strategy:
Confidence:
Loopholes found:
Evidence checked:
Fixes:
Revised strategy:
Residual risk:
Decision:
- keep
- patch-again
- pivot
- blocked
- stop
```

The first loop must be harsh. Look for:

- hidden assumptions
- missing evidence
- wrong workspace / stale session
- outdated docs
- unsupported user-intent inference
- safety or permission gaps
- production / database / irreversible risk
- verification gap
- unclear success metric
- over-scoped plan
- local polish replacing structural progress
- dependency on tools that may not work
- conflict between skill files, metadata, repo-local shadows, and live behavior

## Evidence Order

Use the strongest available evidence before confidence claims:

1. User's explicit latest request.
2. Live files, diffs, logs, process state, terminal output, browser output, test output.
3. Project instructions: `AGENTS.md`, `_ctx/INDEX.md`, `PROJECT_STATUS.md`, handoff/status docs.
4. Relevant skill files and helper scripts when the strategy depends on skills.
5. Prior chat memory only as a hint.

When the question is about current facts, software versions, GitHub repos, laws, prices, schedules, products, or external docs, browse or inspect current sources.

## Patch Rules

A fix must be concrete:

- edit the strategy
- narrow scope
- add a verification step
- add a safety gate
- choose a better driver
- define missing evidence
- change the order of operations
- stop and ask the user only when the decision is genuinely user-owned

Bad fixes:

- "be careful"
- "monitor closely"
- "consider risks"
- "ensure quality"
- "communicate clearly"

These are decorations unless they specify exactly what will be checked or changed.

## Stop Conditions

Stop the loop when:

- no material loopholes remain
- remaining risks are explicitly non-blocking
- the next action is clear and verifiable
- a safety or user-decision gate blocks progress
- the next loop would only rephrase existing concerns

Do not loop forever to perform confidence theater.

## Output Format

Default concise format:

```text
目前策略:
信心:
漏洞:
修正:
驗證:
剩餘風險:
結論:
下一步:
```

For larger strategy work:

```text
Confidence Audit
- Current strategy:
- Initial confidence:
- Loopholes:
- Fixes:
- Evidence checked:
- Revised strategy:
- Final confidence:
- Residual risks:
- Stop / next action:
```

When invoked before execution, end with either:

- `Proceed:` plus the exact next action
- `Patch again:` plus the exact missing evidence
- `Blocked:` plus the real blocker

## Anti-Patterns

- Saying "you're absolutely right" before checking facts.
- Pretending a plan is 100% because it sounds coherent.
- Listing vague risks without changing the strategy.
- Repeating the same self-critique loop after no new evidence appears.
- Treating low confidence as a reason to freeze when a small verification step exists.
- Overfitting to one local detail while the structural risk remains unresolved.
