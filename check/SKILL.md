---
name: check
description: Use when the user invokes /check or asks to inspect whether the current App-side goal, previous terminal, native Codex CLI /goal, generic Codex CLI sidecar, background worker, artifact state, or last agent step is still running, completed, blocked, or verifiable.
---

# Check

`/check` is the App-side evidence gate.

It uses the same evidence discipline as `$goal` / Outcome Contract: read live truth first, classify state second, then decide the next smallest action. The default scene is now this Codex App. Native CLI is only one possible evidence source, not the center of gravity.

## Core Rule

Always check live state first. Do not guess from chat memory.

If the normal goal is App-side, `/check` must start with current workspace evidence and the latest App-side work state. Do not let stale native CLI metadata override newer App artifacts, pasted CLI output, or project status files.

If the user pasted terminal/CLI output in the same request, treat that pasted output as primary evidence. Use helper metadata only to identify paths/processes; do not override pasted completion output with stale process state.

Default selection is current workspace only. Do not silently fall back to `last-run.json`, sidecar logs, or artifacts from another workspace.

If a completed CLI window has a captured transcript, read that transcript before planning the next step. If a run predates transcript capture and no readable log exists, say that honestly and ask the user to paste the latest visible output. Do not invent completed CLI contents.

## What `/check` Covers

- Current App-side `$goal` / `/goal` progress.
- Latest project artifacts, summary/state files, status docs, logs, and test/audit evidence.
- Active background workers, monitor logs, and terminal/process state.
- Native Codex CLI `/goal` only when explicitly requested, recently launched, or relevant to the user's pasted output.
- Generic Codex CLI sidecars.
- The previous visible terminal or last agent step.

## What To Check

Check in this order unless the user explicitly asks for native CLI first:

1. Pasted user output in the current request:
   - completion markers
   - artifacts
   - tests/audits
   - blockers/errors
2. Current App-side workspace truth:
   - `AGENTS.md` if needed to interpret local rules
   - `_ctx/INDEX.md` if present, and `_ctx/MANIFEST.jsonl` for provenance before trusting summaries
   - `PROJECT_STATUS.md`, `docs/SESSION_LOG.md`, startup/status docs
   - latest named artifact directories, especially `summary.json`, `state.json`, continuation kits, next-goal contracts, review pages, row-level outputs
   - no-apply / no-write / no-upload flags when relevant
3. Active work and processes:
   - current app terminal output when available
   - background worker / monitor logs
   - live processes tied to the workspace
4. App-controlled Codex CLI sidecar state:
   - latest `%LOCALAPPDATA%\CodexCliSidecars\codex-cli\<timestamp>\`
   - `last-message.md`, `exit-code.txt`, `stdout.log`
5. Native Codex CLI `/goal` state, when relevant:
   - latest matching `%LOCALAPPDATA%\CodexCliSidecars\native-goal-cli\<timestamp>\run.json`
   - prefer current workspace
   - do not use `last-run.json` automatically when it belongs to another workspace
   - `goal-command.txt`
   - `native-goal-prompt.md`
   - `terminal-transcript.txt`
   - `codex-exit-code.txt` / `codex-exit.json`
   - saved `pid`
   - active child `codex --enable goals` process if discoverable

After reading available evidence, classify the state before proposing action.

## App-Side Status Meanings

- `complete-and-verified`: evidence proves the mainline moved, verification passed, safety boundary held, and handoff/artifact/state exists.
- `progress-made-verification-missing`: output exists, but tests, audit, counts, reload, UI evidence, or other required verification is missing.
- `blocked-by-missing-evidence`: the next outcome cannot be chosen safely because the evidence anchor, state file, artifact, log, or decision artifact is absent.
- `blocked-by-safety-boundary`: next action risks write/apply/upload/destructive/live external side effect without confirmation, recovery, or guardrail.
- `stale-tool-state`: process, sidecar metadata, native CLI metadata, or automation status exists but does not reflect current project truth.
- `pivot-recommended`: evidence shows the current target is low-yield, wrong bottleneck, exceeded appetite, or no longer the highest-leverage outcome.
- `app-goal-running`: an App-side worker, terminal command, or monitor tied to the objective is still active and has useful live output.
- `artifact-ambiguous`: multiple plausible latest artifacts exist or the chosen artifact cannot be justified from evidence.
- `output-unavailable`: a process/window exists but no transcript/log/output can be read.

## Native CLI Status Meanings

- `running`: saved process id and active child Codex process still exist.
- `finished`: saved process id no longer exists, sidecar exit code exists, or transcript/exit marker proves completion.
- `blocked`: logs or last message contain clear failure, error, unknown command, missing auth, sandbox, permission, or tool blocker.
- `native-goal-cli-finished-transcript-available`: native goal window appears done or no active child Codex process is attached, and `/check` can read captured terminal content.
- `no-current-workspace-native-goal-match`: native goal metadata exists, but not for the requested workspace; list candidates and do not infer status from another workspace.
- `terminal-open-idle-after-codex-exit-transcript-available`: PowerShell is still open, Codex has exited, and `/check` can read captured terminal content.
- `terminal-open-idle-after-codex-exit-output-unavailable`: PowerShell is still open and Codex has exited, but no readable transcript is available.
- `terminal-open-output-unavailable`: terminal exists but there is no readable transcript/log.
- `terminal-closed-output-unavailable`: terminal is gone and no transcript/log exists.
- `live-process-found`: no saved state exists, but a likely Codex CLI / terminal process is running.

Interactive CLI limitation:

- A visible CLI window does not automatically stream its transcript back to the App unless the launcher started transcript capture.
- Old reused CLI windows may not have captured output.
- PowerShell `-NoExit` means the window can remain open after Codex exits. Do not report "running" from terminal process existence alone; check for an active child Codex process when possible.
- `pending_user_paste=true` means the App copied a command but cannot prove it was pasted. In App-first mode, this is not a blocker unless the active objective is explicitly native CLI.

## Next-Step Rule

Do not plan the next action until after reading the best available evidence:

1. pasted user terminal/CLI output
2. latest workspace artifact/status evidence
3. current terminal / monitor / process state
4. sidecar `last-message.md`
5. sidecar `stdout.log`
6. native goal transcript excerpt

If evidence proves completion, summarize the completed work and the verification. If evidence proves a blocker, name the blocker and the smallest safe next step. If evidence is missing, say what cannot be verified and ask for the exact missing output only when it cannot be recovered locally.

Do not open a new goal, start a new worker, or continue roadmap execution from `/check` unless the user explicitly asks for continuation. `/check` is inspection and interpretation.

## Decision Rule

- If verified completion exists, close it even if old CLI metadata is stale.
- If output exists but verification is missing, verify before continuing.
- If no reliable evidence exists, create or request the smallest evidence artifact.
- If the current lane no longer attacks the bottleneck, recommend pivot.
- If the minimum safety line is met, do not recommend more safety work unless it directly unblocks mainline / scale movement.
- If a tool path becomes noise, classify it as stale-tool-state and return to project evidence.

## Native CLI Helper

Use this helper only for native CLI evidence:

```powershell
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1"
```

Optional:

```powershell
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1" -Detailed
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1" -List
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1" -Workspace "C:\path\to\workspace"
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1" -RunId "<run-id>"
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1" -GlobalLatest
```

Use `-GlobalLatest` only when the user explicitly asks for the newest run across workspaces. Use `-RunId` when the user points to one candidate.

## Output Shape

```text
目前判斷:
status:
target:
progress:
evidence:
can verify:
cannot verify:
artifact/log summary:
blocker:
next smallest action:
handoff:
/Explain:
```

Keep it short. The point is to tell the user what is verified, what is not, and the next smallest action.
