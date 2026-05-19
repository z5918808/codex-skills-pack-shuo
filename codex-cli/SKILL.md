---
name: codex-cli
description: Use when the user invokes /codex-cli or asks Codex App to launch, delegate, monitor, or run the current task through Codex CLI instead of only the app session.
---

# Codex CLI

Use this skill when the App session should hand work to Codex CLI as a sidecar.

This does not turn CLI slash commands into App-native commands. It launches or runs a separate CLI session and keeps the App session responsible for setup, monitoring, and reporting.

## Default Decision

Pick the lightest CLI mode:

- Interactive terminal: use when the user wants to see or type into Codex CLI.
- Non-interactive sidecar: use when the App should run CLI work and collect output.
- Do not use CLI: use when the App can finish directly with lower risk.

## Required Checks

Before launching CLI:

1. Verify `codex --version`.
2. Identify the workspace directory from the current task.
3. Use `-C <workspace>` or `Start-Process -WorkingDirectory`.
4. Do not build commands with unquoted paths.
5. Do not use `Set-Location <path with spaces>` inside a raw command string.
6. Check for existing sidecar processes when a duplicate would be harmful.

## Helper Script

Preferred entry:

```powershell
& "<codex-skills-dir>\codex-cli\scripts\Start-CodexCli.ps1" -Workspace "C:\path\to\repo" -Interactive
```

For App-controlled sidecar work:

```powershell
& "<codex-skills-dir>\codex-cli\scripts\Start-CodexCli.ps1" -Workspace "C:\path\to\repo" -Prompt "Do the smallest verified step for this task."
```

For read-only review:

```powershell
& "<codex-skills-dir>\codex-cli\scripts\Start-CodexCli.ps1" -Workspace "C:\path\to\repo" -Prompt "Inspect these files and report risks." -ReadOnly
```

The script writes logs under `%LOCALAPPDATA%\CodexCliSidecars\codex-cli\`.

## App Session Contract

When using CLI from the App:

- Tell the user that CLI is a separate session.
- Pass enough context in the prompt for CLI to start.
- Keep logs and final output path.
- Read back the CLI final message before reporting success.
- If CLI is interactive, do not claim App is controlling it after launch.

## Common Failure

Bad:

```powershell
Set-Location -LiteralPath <project-root>; codex
```

Good:

```powershell
Start-Process powershell.exe -WorkingDirectory "<project-root>" -ArgumentList @("-NoExit", "-Command", "codex")
```

Better for non-interactive work:

```powershell
codex exec -C "<project-root>" --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "Inspect project status and report the next smallest action."
```

Codex CLI 0.128.0 note:

- `codex exec` no longer accepts `-a never`.
- On this Windows environment, sandboxed `codex exec` can fail with `CreateProcessWithLogonW failed: 1326`.
- App-controlled sidecars therefore use `--dangerously-bypass-approvals-and-sandbox`; use `-ReadOnly` and a narrow prompt for review-only tasks.

## Completion

Final response must include:

- CLI mode used.
- Workspace.
- Whether CLI process is still running.
- Log or output path when available.
- Verified result or blocker.
