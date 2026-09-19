# Advanced diagnosis techniques

Apply only the technique that can distinguish the remaining causes. The shared contract is [diagnose](../../diagnose/SKILL.md).

## Reproduction and replay

Reuse an existing artifact or symptom-specific check first. When needed, build a failing test, CLI fixture, HTTP probe, browser flow, captured trace replay, or isolated harness. A useful check catches the reported symptom rather than merely completing without a crash. Do not require a deterministic command before examining evidence or forming a provisional hypothesis.

Prefer a fast, unattended loop when achievable within the task's scope. For intermittent failures, document the observed rate and uncertainty; increase attempts only with bounded cost and appropriate permission. Do not impose a fixed attempt count or reproduction rate. Human interaction is useful only when the next observation requires it; on Windows use the supported PowerShell/browser tools, not the bundled Bash template.

## Minimize when it helps

Reduce inputs, callers, or configuration when doing so separates plausible causes or produces a useful regression case. Change one relevant variable at a time. Stop minimizing once the cause can be distinguished; proving that every remaining element is indispensable is not a completion gate.

## Instrumentation and performance

Choose debugger inspection for local state, tagged boundary logs for cross-service behavior, or replay for captured events. Avoid logging everything. Remove task-owned temporary instrumentation after the investigation.

For performance regressions, measure the affected behavior under comparable conditions before proposing a repair. Use a profiler, timing harness, query plan, or differential check as appropriate. Bisection helps when known-good and failing states exist; it is not mandatory for every slow operation.

## Authorized repair

Use a regression check that exercises the actual caller pattern. If no suitable test seam exists, report that limitation and use the strongest available symptom check. Reuse a passing original-scenario result at closeout unless subsequent edits or new evidence invalidate it. Recommend architecture work only for a supported recurring cause or material testability gap; do not automatically hand off or broaden the task.
