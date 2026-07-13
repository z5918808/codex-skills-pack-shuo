# Repo AGENTS.md

This file is repo-local. Replace TODOs with live repository truth.

## Completion Gate

Before claiming done, Codex must provide evidence:

- changed files
- verification command or inspection path
- pass/fail result
- unverified risk

Preferred verification entrypoint:

- TODO: fill repo-specific test, lint, typecheck, build, or browser check command

If the preferred entrypoint is still TODO:

- inspect repo scripts, Makefile, CI config, README, and package metadata first
- run the narrowest reasonable check
- if no check can run, re-read changed files and report weak verification

## Debug Workflow

Use systematic debugging when:

- the same error appears twice
- a fix fails once
- evidence contradicts the current hypothesis

Debug output should capture:

- symptom
- suspected layer
- evidence checked
- root cause
- fix
- regression guard, if available

Do not keep retrying the same strategy after repeated failure.

## Factory Output

Create factory output only when it absorbs a repeated failure class or makes future work cheaper.

Allowed types:

- verification matrix
- debug route
- recovery route
- handoff
- automation contract
- goal contract
- connector SOP

Do not create factory output for one-off local fixes.

## Durable Memory

Use `_ctx/` only for work that needs continuity across sessions.

Default files:

- `_ctx/NOW.md`
- `_ctx/DECISIONS.md`
- `_ctx/OPEN_LOOPS.md`
- `_ctx/PROJECTS.md`

Write durable memory only when there is a decision, blocker, owner, deadline, active workstream, or useful handoff state.

If nothing meaningful changed, do not churn `_ctx`.

## Long-Run / Goals

Use long-run mode only when explicitly requested or when repo workflow requires durable continuation.

A goal must define:

- outcome
- stop condition
- verifier
- allowed actions
- human approval boundary
- checkpoint location

Do not treat vague ambition as a goal.

## Connectors

Connector work must define:

- source surface, such as Slack, Gmail, Calendar, browser, or desktop
- allowed read actions
- allowed write actions
- approval boundary
- evidence location
- fallback if the connector fails

Do not send messages, mutate calendars, or perform external side effects without explicit approval unless repo instructions allow it.

## Risk Boundary

High-risk operations require preview, rollback path, and confirmation:

- database writes
- production changes
- destructive file operations
- bulk update or delete
- customer, order, payment, or inventory data
- credentials or secrets

If a required guard script, rule, hook, or workflow is missing, report the gap instead of pretending it is enforced.

## Repo Notes

TODO: add repo-specific architecture notes, ownership, verification commands, release paths, and known pitfalls.
