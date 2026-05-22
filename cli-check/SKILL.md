---
name: cli-check
description: Legacy alias for /app-terminal-check. Use when the user invokes /cli-check or asks to absorb, pull back, sync, summarize, or verify Codex CLI, native CLI /goal, built-in terminal, sidecar, or pasted terminal context into the main Codex App chat thread.
---

# CLI Check

`/cli-check` is a compatibility alias. Prefer the `/app-terminal-check` workflow because the App thread terminal is the primary evidence source.

If `/cli-check` is invoked, perform the same behavior as `/app-terminal-check`: read the current App thread terminal first, then use CLI sidecar/native CLI logs only as supporting evidence.

This is an ingestion/checkpoint skill, not a continuation skill. Do not start a new CLI run, resume a goal, launch a worker, or modify project files unless the user separately asks for that after the handoff.

## Evidence Order

Use the strongest available evidence in this order:

1. Current user message, pasted text, and attached screenshots.
2. Current thread terminal output via `read_thread_terminal`, when available.
3. Current workspace truth: `AGENTS.md`, `_ctx/INDEX.md`, `PROJECT_STATUS.md`, `GOAL.md`, `PROGRESS.md`, `SESSION_LOG.md`, recent artifacts, and logs.
4. Native CLI `/goal` state through the existing helper:

```powershell
& "$env:USERPROFILE\.codex\skills\check\scripts\Check-CodexCliStatus.ps1" -Workspace "<workspace>" -Detailed
```

5. Generic Codex CLI sidecar logs under `%LOCALAPPDATA%\CodexCliSidecars\codex-cli\<run>\`: `last-message.md`, `stdout.log`, `prompt.md`, `exit-code.txt`.
6. Live Codex-related processes only as weak evidence. Process existence alone never proves the CLI is still working.

If the visible CLI output is only in a screenshot, treat it as user-provided evidence and label it that way. If no transcript or log is recoverable, ask for the latest visible CLI output instead of inventing the missing context.

## What To Extract

Extract only facts that can be tied to evidence:

- CLI mode: native interactive CLI, native `/goal`, App-controlled sidecar, or unknown.
- Workspace and objective.
- Current status: running, finished, goal achieved, blocked, output unavailable, or stale tool state.
- Last useful CLI message and whether it claims completion.
- Verification evidence: tests, screenshots, artifact paths, counts, reloads, logs, exit code, or explicit "not verified".
- Risks and boundaries: no-write, no-upload, no-apply, production/live side effects, missing transcript, stale workspace, or screenshot-only evidence.
- Next smallest action for the main chat.

Do not treat "Goal achieved", exit code `0`, or a quiet terminal as enough by itself. Always say what was actually verified and what remains unverified.

## Output Shape

Reply in the user's language and keep it short. For this user, use Traditional Chinese. Use these fields, translated naturally:

```text
current judgement:
progress:
CLI context absorbed:
verified:
unverified / risks:
blocker:
next step:
/Explain:
```

Use percentages for progress when useful. If the CLI context is usable, the handoff should make the main chat able to continue without rereading the whole terminal. If it is not usable, name the missing evidence precisely.
