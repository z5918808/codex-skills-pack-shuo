---
name: handoff
description: Use when the user asks to save, transfer, or prepare a paste-ready handoff so a fresh agent can continue safely.
---

# Handoff

## Modes

- `Durable` (default): update the project’s existing status or handoff route when another session must resume later.
- `Paste-only`: when the user says no file, code block, cb, or wants a prompt for another agent, return one copy-ready prompt and do not write a handoff file.

Use `report-for-outsourcing` instead when the recipient is an outside reviewer who must re-reason from zero context.

## Build From Live Truth

Inspect current files, status, git diff, tests, logs, processes, and artifacts before summarizing. Chat memory and prior closeouts are claims, not current truth.

Include only:

1. objective and acceptance criteria;
2. current stage and last verified evidence;
3. changed surface and important artifact coordinates;
4. blockers, permission boundaries, and remaining risk;
5. the next smallest executable action and how to verify it;
6. frozen or unrelated surfaces the next agent must not touch.

Reference existing plans, ADRs, issues, reports, and diffs instead of copying them. Redact secrets and customer data.

## Durable Mode

Use the project’s established memory route. If `_ctx` is explicitly in use, follow `project-memory-gate`; otherwise prefer the existing status or handoff file over creating a new system.

Keep the update delta-sized. Record explicit path, run ID, or hash when artifact identity matters. Do not use a temporary file as the project’s source of truth.

## Paste-Only Shape

Return one fenced prompt containing:

```text
Mission:
Current truth:
Verified evidence:
Changed surface:
Blockers and boundaries:
Do not touch:
Next action:
Verification:
Relevant skills or routes:
```

Do not create or update files in paste-only mode.

## Verification

Before delivery, confirm the cited files or artifacts exist, the next action follows from the evidence, and no stale claim is presented as current truth. State any item that could not be verified.
