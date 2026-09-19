---
name: agent-db-safety
description: "Check target, authorization, and recovery for database writes, migration rollout, and destructive or bulk data changes."
---

# Agent DB Safety

Use this skill when preparing or executing database writes, migration rollout, or destructive/bulk data changes. Reading code, editing an unrelated environment file, or discussing a database does not by itself activate this workflow.

## Non-negotiable Rules

1. Treat staging and production as separate worlds. Never infer environment from filename, branch, or vibes.
2. If a staging task reveals a production or broad-scope token, stop and report it. Do not use it.
3. Default AI agent access to read-only. Grant staging write only when the task needs it.
4. Never let an agent hold long-lived production write/admin tokens.
5. Run dry-run before `delete`, `truncate`, `drop`, `destroy`, `reset`, `purge`, rollback, or bulk update.
6. Reuse current user authorization covering the action, environment, resource, and bounded impact. Ask only for missing or expanded authority; never ask the user to repeat an already-authorized operation in a special format.
7. Production destructive operations still require applicable backup/recovery evidence and authorization. Existing authorization survives routine handoffs; narrower project boundaries still apply.
8. Enforce the authorized row limit. Ten rows is the legacy default, not a universal ceiling; a larger operation requires an existing authorized bound or clarification of the missing scope.
9. Record the authorization source, timestamp, environment, resource, and expected count without credentials or raw private conversation text.
10. Verify the result after execution before claiming completion.

## Workflow

1. Identify environment: `APP_ENV`, database host/project/name, token scope.
2. Check mismatch risk: staging task must not point at production host, production project id, or production token.
3. Dry-run: count affected rows and show representative sample without writing.
4. Resolve existing authorization and its source; clarify only a material gap. Never treat this skill or a self-written record as user authorization.
5. Execute with guard script and bounded row limit.
6. Verify and record outcome.

For an already-authorized operation, pass `-AuthorizationPath` pointing to a local JSON record derived from the original user instruction:

```json
{
  "source": "thread:<actual-thread-id>/turn:<actual-authorizing-turn>",
  "action": "delete",
  "environment": "staging",
  "resource": "bookings",
  "maxRows": 42
}
```

Use an exact database/resource identity when preparing the record. For production, also supply `backupEvidence` referencing the applicable verified backup/recovery evidence. The caller must verify that the source grants this operation in the current task and that the preview matches the authorized selection; this script checks the record's fields, not the truth or freshness of the authorization. It does not intercept database APIs.

## Use Bundled Scripts

Use `scripts/check-env-safety.ps1` before a database-writing task to verify environment and database target.

Use `scripts/confirm-destructive-action.ps1` before destructive operations. It rejects missing authorization, mismatched targets/actions, counts above the authorized bound, and missing production backup evidence. `-MaxRows`, when explicitly supplied, is an additional cap. Existing `CONFIRM_DESTRUCTIVE_ACTION` callers remain supported as a legacy input; new authorized work uses the source record instead of requesting another confirmation string. An invalid source record fails without falling back to that legacy input.

For changes to this guard, run `scripts/test-confirm-destructive-action.ps1`; its fixtures exercise authorization boundaries without database access.

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
4. resolve and reference current user authorization; ask only if its scope is missing or exceeded,
5. use the project safety guard script.

If you find a broad-scope or production token during a staging task, stop immediately.
Report the token location and risk. Do not use it.
```
