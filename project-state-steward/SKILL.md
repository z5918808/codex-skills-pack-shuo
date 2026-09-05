---
name: project-state-steward
description: "Maintain declared canonical project state across decisions, milestones, handoffs, and long-running repository work."
---

# Project State Steward

## Purpose

Keep a long-running repository executable across sessions with one current state and one next action. Do not rely on chat memory, modification time, or filenames containing `latest` or `final`.

Use repository files and named validators only. Never add or require lifecycle hooks.

## Resolve Authority

- Follow system and developer instructions, current user authorization, and applicable `AGENTS.md` rules.
- Follow a repository-specific state protocol when it differs from this generic workflow.
- Use current runtime, controller, command, and live-verification evidence for factual truth.
- Treat a repository-declared canonical `PROJECT_STATUS.md` as current project intent.
- Treat `_ctx/INDEX.md` as a pointer registry, not a duplicate status file.
- Use the active `MILESTONE.md` as the bounded execution contract.
- Use only ADRs referenced by canonical state as active decisions.
- Treat session logs, reports, dossiers, archived runs, superseded ADRs, and chat as historical evidence only.

## Enter The Workflow

1. Locate the repository root and inspect existing state markers read-only.
2. If no canonical state or `_ctx` marker exists, do not create a governance system unless the user or repository instructions request one.
3. Read `PROJECT_STATUS.md`, then `_ctx/INDEX.md`, then only the active milestone, active ADRs, and exact artifacts they reference.
4. Inspect current runtime or controller evidence when available.
5. Resolve material conflicts before new implementation. Runtime evidence wins for facts; canonical state wins for current project intent within applicable instructions and authorization.
6. Identify exactly one next executable action.

Do not broadly read archives unless the active state links to them or the task requires historical investigation.

## Checkpoint Material Changes

Create a state checkpoint immediately after any material change to:

- decision, scope, priority, or acceptance;
- blocker, milestone, active run, or owner;
- verified completion state;
- next executable action;
- handoff or closeout state.

Do not wait until the final response when a changed decision would make the current state misleading.

Update canonical files only when the current task authorizes repository writes and the repository grants state-write authority. For Q&A, review-only work, or missing write authority, return a proposed `STATE_DELTA` instead of editing canonical state.

## Preserve Single-Writer State

- Allow only the designated main writer to merge canonical state.
- Require subagents and review-only agents to return `STATE_DELTA` rather than edit canonical files.
- Increment `state_revision` monotonically once per logical state-update batch.
- Use exact run IDs, commit hashes, and artifact paths.
- Never select authority through modification time or ambiguous names.
- Never create a second canonical status, event store, memory system, or fallback state.

Return non-writer updates in this form:

```text
STATE_DELTA
- observed_facts:
- completed:
- failed:
- blockers:
- proposed_decisions:
- proposed_next_action:
- evidence_paths:
- files_changed:
- verification_run:
```

## Change A Decision

When the repository uses ADRs and a decision changes, update one logical batch:

1. Create a new ADR that names the superseded ADR.
2. Mark the previous ADR as superseded without deleting its history.
3. Replace the active ADR reference in canonical state.
4. Update affected goal, scope, risk, acceptance, blocker, and next action.
5. Update `_ctx/INDEX.md` only when an active pointer changes.
6. Append a compact historical entry when the repository uses a session log.
7. Increment `state_revision`.

## Close Out

Before claiming completion or handing off:

1. Verify the active milestone acceptance conditions with current evidence.
2. Separate verified facts from claims and assumptions.
3. Reconcile canonical outcome, completed work, blockers, active decisions, evidence paths, and exactly one next executable action.
4. Update the active milestone only when its execution contract or state changed.
5. Update the pointer index only when a pointer changed.
6. Append the historical log when the repository uses one.
7. Run the repository's named state validator when it exists.
8. If no validator exists, reread the changed control files and label the result `weak verification`; never claim enforcement.

Return a compact receipt:

```text
- state_revision:
- canonical_files_updated:
- verified_outcome:
- unresolved_blockers:
- next_executable_action:
- next_decision_gate:
- validator_result:
```
