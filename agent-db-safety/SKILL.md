---
name: agent-db-safety
description: Prevent AI coding agents from destructive database mistakes. Use when Codex is handling staging, production, database tokens, broad-scope API keys, migrations, destructive operations, bulk deletes, truncates, resets, purges, rollbacks, data repair, or any task where an agent might read/write production data while intending to work on staging.
---

# Agent DB Safety

Use this skill before touching database credentials, environment files, migrations, cleanup scripts, data repair jobs, or any destructive/bulk operation.

## Non-negotiable Rules

1. Treat staging and production as separate worlds. Never infer environment from filename, branch, or vibes.
2. If a staging task reveals a production or broad-scope token, stop and report it. Do not use it.
3. Default AI agent access to read-only. Grant staging write only when the task needs it.
4. Never let an agent hold long-lived production write/admin tokens.
5. Run dry-run before `delete`, `truncate`, `drop`, `destroy`, `reset`, `purge`, rollback, or bulk update.
6. Require explicit human confirmation for any destructive operation.
7. Require extra confirmation and backup proof for production destructive operations.
8. Refuse operations affecting more than 10 rows unless the user explicitly approves a higher limit.
9. Log destructive approvals with timestamp, environment, resource, expected count, and confirmation.
10. Verify the result after execution before claiming completion.

## Workflow

1. Identify environment: `APP_ENV`, database host/project/name, token scope.
2. Check mismatch risk: staging task must not point at production host, production project id, or production token.
3. Dry-run: count affected rows and show representative sample without writing.
4. Confirm: require exact confirmation string.
5. Execute with guard script and bounded row limit.
6. Verify and record outcome.

Confirmation format:

```text
DELETE staging bookings 42
DELETE production bookings 42 I_HAVE_BACKUP
```

## Use Bundled Scripts

Use `scripts/check-env-safety.ps1` before a database-writing task to verify environment and database target.

Use `scripts/confirm-destructive-action.ps1` before destructive operations. It rejects missing confirmation, row counts over the limit, and production operations without backup confirmation.

## Minimum Environment Contract

Projects should define:

```text
APP_ENV=staging
DATABASE_URL=...
DATABASE_EXPECTED_HOST=...
DATABASE_EXPECTED_NAME=...
ALLOW_PRODUCTION_WRITE=false
MAX_DESTRUCTIVE_ROWS=10
CONFIRM_DESTRUCTIVE_ACTION=
```

## Agent Prompt Snippet

When giving another agent database work, include:

```text
You are not allowed to execute destructive operations directly.
Before delete, truncate, drop, reset, purge, rollback, or bulk update:
1. identify environment and target resource,
2. run dry-run only,
3. report affected row count and sample records,
4. wait for explicit human confirmation,
5. use the project safety guard script.

If you find a broad-scope or production token during a staging task, stop immediately.
Report the token location and risk. Do not use it.
```
