---
name: coding-standards
description: Use when reviewing or shaping code quality, naming, boundaries, errors, tests, comments, or project conventions.
---

# Coding Standards

## Priority

Follow repository instructions, formatter, linter, type checker, tests, and established local patterns before generic advice. Do not impose a new style system during an unrelated change.

Judge code in this order:

1. correct behavior and preserved evidence;
2. safety, permissions, data integrity, and failure handling;
3. clear ownership and interfaces;
4. readability and testability;
5. measured performance;
6. consistency and polish.

## Change Rule

Require a change now only when it fixes a demonstrated defect, closes a safety or maintenance risk, or makes the requested behavior verifiable. Defer speculative abstractions and unrelated cleanup.

No metric is a verdict by itself. File length, function length, nesting depth, duplication count, mutation, or dependency count are prompts to inspect, not automatic failures.

## Names and Types

- Name by domain meaning and observable effect, not implementation trivia.
- Keep units and state explicit when ambiguity is costly.
- Use types to encode valid states and boundary contracts; validate untrusted runtime input separately.
- Avoid `any` or broad casts that erase uncertainty. Narrow unknown values at the boundary.
- Keep public interfaces smaller and more stable than their implementations.

## Boundaries

- Give each module one clear owner and reason to change.
- Keep I/O, policy, and transformation separable when that improves testing or replacement.
- Prefer direct code while one implementation is clear. Add an abstraction when callers share a real invariant or must vary independently.
- Extract duplication only when the copies represent the same rule and should change together. Similar syntax is not sufficient.
- Split a long function when it mixes responsibilities, hides invariants, or resists testing—not merely because of a line threshold.

## Data and Mutation

- Make shared state transitions explicit and controlled.
- Prefer immutable values at public and concurrent boundaries.
- Local mutation is acceptable when ownership is private, invariants are clear, and it improves simplicity or measured performance.
- Do not mutate caller-owned inputs, cached data, or props unless the contract explicitly allows it.

## Errors and Async Work

- Preserve the original cause, status, and relevant context when translating errors.
- Classify expected, retryable, permanent, cancelled, and unknown outcomes when behavior differs.
- Never log secrets or return internal details to untrusted callers.
- Run work concurrently only when operations are independent and the downstream system can absorb the fan-out.
- Bound concurrency, retries, time, and memory. Propagate cancellation where useful.
- A timeout is not proof of failure when a remote side effect may have succeeded.

## Comments and Documentation

- Comment why a non-obvious constraint or tradeoff exists.
- Do not narrate syntax or preserve historical storytelling in code.
- Document public contracts, failure behavior, units, side effects, and compatibility constraints when types cannot express them.
- Remove stale comments in the same scope as the change.

## Tests and Verification

- Test observable behavior and invariants, not implementation shape.
- Reproduce a bug before fixing it when practical.
- Cover the smallest failure surface that could invalidate the change.
- Run the most relevant formatter, static check, and tests; broaden only with risk.
- Performance changes require before/after measurement on the same fixture.
- If a check cannot run, inspect the critical path and state what remains unverified.

## Reject These Review Habits

- demanding DRY abstractions before the shared invariant is known;
- splitting readable code to satisfy a line-count rule;
- forbidding all mutation or requiring spread copies everywhere;
- adding memoization, caching, retries, or concurrency without evidence and bounds;
- replacing useful provider errors with generic messages that destroy the cause;
- mixing broad refactors into a narrow fix;
- calling code “clean” without a rerunnable proof.

Finish with the smallest change that is correct, locally consistent, and verifiable.
