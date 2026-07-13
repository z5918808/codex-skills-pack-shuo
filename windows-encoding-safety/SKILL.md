---
name: windows-encoding-safety
description: Use when Windows work risks UTF-8, PowerShell, native CLI, .cmd, JSON, mojibake, or mixed stdout and stderr issues.
---

# Windows Encoding Safety

## Rule

Treat Windows process I/O as encoding-risk until proven otherwise. Preserve raw evidence first, then parse.

## Use The Helper

Prefer dot-sourcing the user-level helper:

```powershell
. "$env:USERPROFILE\.codex\scripts\codex-utf8.ps1"
Set-CodexUtf8
```

Available helpers:
- `Set-CodexUtf8`
- `Write-CodexUtf8NoBom`
- `Read-CodexUtf8`
- `Invoke-CodexNativeUtf8`
- `Get-CodexJsonPayload`
- `ConvertFrom-CodexNoisyJson`

If the helper is missing, say so and inline the smallest equivalent code for the current task.

## Defaults

1. Set `[Console]::InputEncoding`, `[Console]::OutputEncoding`, and `$OutputEncoding` to UTF-8 before native process I/O.
2. For `.exe`, `.cmd`, Python, Node, and nested PowerShell calls, split stdout and stderr.
3. Save raw stdout/stderr before parsing when output matters.
4. Write durable files as UTF-8 no BOM with explicit encoding.
5. For JSON, parse a saved raw payload. If output has warning prefixes or trailing chatter, extract the outer parseable JSON object/array first.
6. Do not treat noisy stdout or `.cmd` shim errors as product failure until a direct PowerShell/native probe confirms it.
7. For validators involving UTF-8 frontmatter or non-ASCII text, set `PYTHONUTF8=1`; if dependency `yaml` is missing, do an equivalent frontmatter check instead of installing packages by default.

## Bad Patterns

- Unix heredoc in PowerShell.
- Relying on shell default `Set-Content` encoding.
- Passing huge prompts as command-line arguments when stdin is available.
- Parsing mixed stdout/stderr as JSON.
- Assuming `HTTP 200`, green command exit, or self-generated JSON is truth without inspecting raw output.
- Testing Unicode by embedding Chinese literals in a file that may itself be read with the wrong encoding.

## Good Patterns

Native process with durable split logs:

```powershell
. "$env:USERPROFILE\.codex\scripts\codex-utf8.ps1"
$run = Invoke-CodexNativeUtf8 `
  -FilePath "tool.exe" `
  -Arguments @("--json") `
  -WorkingDirectory $pwd.Path `
  -StdoutPath ".\work\tool.stdout.json" `
  -StderrPath ".\work\tool.stderr.log"

$json = ConvertFrom-CodexNoisyJson -Text $run.Stdout
```

UTF-8 no BOM write:

```powershell
. "$env:USERPROFILE\.codex\scripts\codex-utf8.ps1"
Write-CodexUtf8NoBom -Path ".\work\report.md" -Value $markdown
```

Unicode smoke without source-file encoding ambiguity:

```powershell
$zh = -join ([char]0x4E2D, [char]0x6587)
"ok $zh"
```

## Done Check

Before claiming fixed:
- Verify the raw file contains expected non-ASCII text.
- Verify stdout and stderr are separated.
- Verify JSON parse comes from raw saved output or from `Get-CodexJsonPayload`.
- Verify PowerShell syntax with parser when editing `.ps1`.
- Keep generated test artifacts in `work/` and clean them after validation unless they are deliverables.
