# Hard Guard Gaps

這份清單只在需要盤點 hard guard、補 rules / hooks / scripts、或回報 safety 缺口時讀取。它不是 enforcement 本身。

## Guard Targets

| Risk | Preferred hard guard | Minimal behavior |
| --- | --- | --- |
| `git reset --hard`, `git checkout --`, recursive delete, bulk move/delete | rules / pre-tool hook | forbidden or explicit prompt before execution |
| production write, deploy, live theme publish | preflight script / deploy workflow | environment, diff, rollback, confirmation |
| database migration or bulk update/delete | DB safety wrapper / dry-run script | affected row count, transaction or rollback path, confirmation if >10 rows |
| money, orders, inventory, booking, notifications | domain guard / API wrapper | preview affected records and require confirmation |
| secrets, tokens, broad-scope credentials | scanner / hook | detect secret-like values and block accidental exposure |
| required tests, lint, build | package script / CI / pre-commit | deterministic verification command, recorded result |
| long-run progress and pivot | long-run workflow / monitor script | checkpoint delta and pivot prompt after stale progress |
| project memory writes | project-memory gate / repo workflow | write only on resume, handoff, long-run, or explicit request |

## Reporting

When a hard guard is missing, report:

- risk class
- current soft protection
- missing deterministic guard
- smallest safe next step
- whether execution should proceed, stop, or reduce scope

Do not say a guard is enforced unless a real rule, hook, script, wrapper, CI job, or external policy exists and was verified.
