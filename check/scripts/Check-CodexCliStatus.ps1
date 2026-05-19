param(
    [string]$Workspace = (Get-Location).Path,
    [string]$RunId = "",
    [switch]$GlobalLatest,
    [switch]$UseLastRunFallback,
    [switch]$Detailed,
    [switch]$List
)

$ErrorActionPreference = "Stop"

function Read-JsonFile {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    try {
        return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    }
    catch {
        return $null
    }
}

function Read-TextIfExists {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return "" }
    try {
        return Get-Content -LiteralPath $Path -Raw
    }
    catch {
        return ""
    }
}

function Read-TextTail {
    param(
        [string]$Path,
        [int]$MaxChars = 8000
    )
    $text = Read-TextIfExists -Path $Path
    if (-not $text) { return "" }
    if ($text.Length -le $MaxChars) { return $text }
    return $text.Substring($text.Length - $MaxChars)
}

function Normalize-PathValue {
    param([string]$PathValue)
    if (-not $PathValue) { return "" }
    try {
        return (Resolve-Path -LiteralPath $PathValue -ErrorAction Stop).Path
    }
    catch {
        return $PathValue.TrimEnd('\')
    }
}

function Get-ProcessState {
    param($PidValue)
    if ($null -eq $PidValue -or "$PidValue" -eq "") {
        return [pscustomobject]@{ exists = $false; pid = $null; name = $null; note = "no pid recorded" }
    }
    try {
        $proc = Get-Process -Id ([int]$PidValue) -ErrorAction Stop
        return [pscustomobject]@{ exists = $true; pid = $proc.Id; name = $proc.ProcessName; note = "process exists" }
    }
    catch {
        return [pscustomobject]@{ exists = $false; pid = [int]$PidValue; name = $null; note = "process not found" }
    }
}

function Get-LatestDirectory {
    param([string]$Root)
    if (-not (Test-Path -LiteralPath $Root)) { return $null }
    Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notlike 'skill-*' } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

function Get-ActiveCodexChildProcess {
    param([int]$ParentPid)
    try {
        return @(Get-CimInstance Win32_Process -ErrorAction Stop |
            Where-Object {
                $_.ParentProcessId -eq $ParentPid -and
                ([string]$_.CommandLine -match '(?i)\bcodex(\.exe|\.cmd)?\b')
            } |
            Select-Object -First 5 ProcessId, ParentProcessId, Name, CommandLine, CreationDate)
    }
    catch {
        return @()
    }
}

function Get-NativeGoalRuns {
    param([string]$Root)
    if (-not (Test-Path -LiteralPath $Root)) { return @() }
    $items = @()
    foreach ($dir in (Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue)) {
        if ($dir.Name -like 'skill-*') { continue }
        $runPath = Join-Path $dir.FullName "run.json"
        $run = Read-JsonFile -Path $runPath
        if (-not $run) { continue }
        $items += [pscustomobject]@{
            name = $dir.Name
            last_write_time = $dir.LastWriteTime
            run_path = $runPath
            run = $run
            workspace_normalized = Normalize-PathValue -PathValue $run.workspace
        }
    }
    return @($items | Sort-Object last_write_time -Descending)
}

function Get-BlockerSignals {
    param([string]$Text)
    if (-not $Text) { return @() }
    $patterns = @(
        'unknown command',
        'not recognized',
        'failed',
        'error',
        'exception',
        'traceback',
        'panic',
        'permission',
        'sandbox',
        'authentication',
        'unauthorized',
        'CreateProcessWithLogonW',
        'blocked',
        'cancelled'
    )
    $hits = @()
    foreach ($pattern in $patterns) {
        if ($Text -match "(?i)$([regex]::Escape($pattern))") {
            $hits += $pattern
        }
    }
    return @($hits | Select-Object -Unique)
}

function Convert-NativeRunSummary {
    param($Item, [string]$TargetWorkspace)
    $proc = Get-ProcessState -PidValue $Item.run.pid
    $children = if ($proc.exists) { Get-ActiveCodexChildProcess -ParentPid ([int]$proc.pid) } else { @() }
    $exitMarker = if ($Item.run.cli_exit_path) { $Item.run.cli_exit_path } elseif ($Item.run.codex_exit_json_path) { $Item.run.codex_exit_json_path } elseif ($Item.run.codex_exit_path) { $Item.run.codex_exit_path } else { "" }
    [pscustomobject]@{
        name = $Item.name
        run_id = if ($Item.run.run_id) { $Item.run.run_id } else { $Item.name }
        workspace = $Item.run.workspace
        matches_requested_workspace = ($Item.workspace_normalized -eq $TargetWorkspace)
        pid = $Item.run.pid
        terminal_open = $proc.exists
        active_codex_children = @($children | ForEach-Object { $_.ProcessId })
        exit_marker_exists = [bool]($exitMarker -and (Test-Path -LiteralPath $exitMarker))
        goal_objective = $Item.run.goal_objective
        transcript_path = $Item.run.transcript_path
        log_dir = $Item.run.log_dir
        last_write_time = $Item.last_write_time
    }
}

function Format-ShortText {
    param([string]$Text)
    if (-not $Text) { return "" }
    $lines = @(($Text -replace "`r", "") -split "`n" | Where-Object { $_.Trim() })
    if ($lines.Count -eq 0) { return "" }
    $start = [Math]::Max(0, $lines.Count - 20)
    return ($lines[$start..($lines.Count - 1)] -join "`n")
}

$nativeRoot = Join-Path $env:LOCALAPPDATA "CodexCliSidecars\native-goal-cli"
$targetWorkspace = Normalize-PathValue -PathValue $Workspace
$nativeRuns = Get-NativeGoalRuns -Root $nativeRoot

if ($List) {
    $list = @($nativeRuns | Select-Object -First 20 | ForEach-Object { Convert-NativeRunSummary -Item $_ -TargetWorkspace $targetWorkspace })
    $list | ConvertTo-Json -Depth 6
    exit 0
}

$nativeSelected = $null
$selectedBy = ""

if ($RunId.Trim()) {
    $needle = $RunId.Trim()
    $nativeSelected = @($nativeRuns | Where-Object { $_.name -eq $needle -or $_.name -like "$needle*" -or $_.run.run_id -eq $needle -or $_.run.run_id -like "$needle*" } | Select-Object -First 1)[0]
    $selectedBy = "run-id"
}

if (-not $nativeSelected) {
    $nativeSelected = @($nativeRuns | Where-Object { $_.workspace_normalized -eq $targetWorkspace } | Select-Object -First 1)[0]
    if ($nativeSelected) { $selectedBy = "current-workspace" }
}

if (-not $nativeSelected -and $GlobalLatest) {
    $nativeSelected = @($nativeRuns | Select-Object -First 1)[0]
    if ($nativeSelected) { $selectedBy = "global-latest-explicit" }
}

if (-not $nativeSelected -and $UseLastRunFallback) {
    $nativeLast = Join-Path $nativeRoot "last-run.json"
    $lastRun = Read-JsonFile -Path $nativeLast
    if ($lastRun) {
        $nativeSelected = [pscustomobject]@{
            name = "last-run"
            last_write_time = (Get-Item -LiteralPath $nativeLast).LastWriteTime
            run_path = $nativeLast
            run = $lastRun
            workspace_normalized = Normalize-PathValue -PathValue $lastRun.workspace
        }
        $selectedBy = "last-run-explicit"
    }
}

if (-not $nativeSelected -and $nativeRuns.Count -gt 0) {
    $candidates = @($nativeRuns | Select-Object -First 8 | ForEach-Object { Convert-NativeRunSummary -Item $_ -TargetWorkspace $targetWorkspace })
    $result = [pscustomobject]@{
        status = "no-current-workspace-native-goal-match"
        target = "native-goal-cli"
        requested_workspace = $targetWorkspace
        can_verify = @("native goal metadata exists in other workspaces")
        cannot_verify = @("which other-workspace run the user means without explicit workspace/run id or pasted terminal output")
        recent_candidates = $candidates
        next = "No native goal run matches the requested workspace. Do not use last-run automatically. Use -List to choose a run, -RunId <id> for a specific run, -GlobalLatest only if you intentionally want the newest run across workspaces, or paste the CLI output."
    }

    if ($Detailed) {
        $result | ConvertTo-Json -Depth 8
    }
    else {
        $candidateText = @($candidates | ForEach-Object {
            "- $($_.run_id) | workspace=$($_.workspace) | active_codex=$(@($_.active_codex_children) -join ',') | exit=$($_.exit_marker_exists) | objective=$($_.goal_objective)"
        }) -join "`n"
        @"
status: $($result.status)
target: $($result.target)
requested_workspace: $($result.requested_workspace)
can_verify: native goal metadata exists, but not for this workspace
cannot_verify: intended run without explicit workspace/run id or pasted terminal output
recent_candidates:
$candidateText
next: $($result.next)
"@
    }
    exit 0
}

if ($nativeSelected) {
    $native = $nativeSelected.run
    $proc = Get-ProcessState -PidValue $native.pid
    $children = if ($proc.exists) { Get-ActiveCodexChildProcess -ParentPid ([int]$proc.pid) } else { @() }

    $transcriptPath = $native.transcript_path
    if (-not $transcriptPath -and $native.log_dir) {
        $candidateTranscript = Join-Path $native.log_dir "terminal-transcript.txt"
        if (Test-Path -LiteralPath $candidateTranscript) { $transcriptPath = $candidateTranscript }
    }

    $exitPath = if ($native.cli_exit_path) { $native.cli_exit_path } elseif ($native.codex_exit_json_path) { $native.codex_exit_json_path } else { "" }
    $exitCodePath = $native.codex_exit_path
    if (-not $exitPath -and $native.log_dir) {
        $candidateExitJson = Join-Path $native.log_dir "codex-exit.json"
        if (Test-Path -LiteralPath $candidateExitJson) { $exitPath = $candidateExitJson }
    }
    if (-not $exitCodePath -and $native.log_dir) {
        $candidateExitCode = Join-Path $native.log_dir "codex-exit-code.txt"
        if (Test-Path -LiteralPath $candidateExitCode) { $exitCodePath = $candidateExitCode }
    }

    $goalCommand = Read-TextIfExists -Path $native.goal_command_path
    $promptText = Read-TextIfExists -Path $native.prompt_path
    $transcriptTail = Read-TextTail -Path $transcriptPath -MaxChars 10000
    $exitMarkerExists = [bool]($exitPath -and (Test-Path -LiteralPath $exitPath))
    $exitCode = $null
    if ($exitMarkerExists -and $exitPath -match '\.json$') {
        $exitJson = Read-JsonFile -Path $exitPath
        if ($exitJson -and $null -ne $exitJson.exit_code) { $exitCode = "$($exitJson.exit_code)" }
    }
    if (-not $exitCode -and $exitCodePath -and (Test-Path -LiteralPath $exitCodePath)) {
        $exitCode = (Get-Content -LiteralPath $exitCodePath -Raw).Trim()
    }
    $blockerSignals = Get-BlockerSignals -Text $transcriptTail
    $hasTranscript = [bool]$transcriptTail
    $hasActiveCodex = ($children -and $children.Count -gt 0)

    $status = if ($hasActiveCodex) {
        if ($hasTranscript) { "native-goal-cli-running-transcript-available" } else { "native-goal-cli-running-output-not-yet-readable" }
    }
    elseif ($proc.exists -and $exitMarkerExists) {
        if ($hasTranscript) { "terminal-open-idle-after-codex-exit-transcript-available" } else { "terminal-open-idle-after-codex-exit-output-unavailable" }
    }
    elseif ($hasTranscript) {
        "native-goal-cli-finished-transcript-available"
    }
    elseif ($proc.exists) {
        "terminal-open-output-unavailable"
    }
    else {
        "terminal-closed-output-unavailable"
    }

    if ($blockerSignals.Count -gt 0) {
        $status = "$status-blocker-signal"
    }

    $result = [pscustomobject]@{
        status = $status
        target = "native-goal-cli"
        selected_by = $selectedBy
        workspace = $native.workspace
        requested_workspace = $targetWorkspace
        process = $proc
        codex_children = @($children)
        goal_objective = $native.goal_objective
        goal_command_path = $native.goal_command_path
        prompt_path = $native.prompt_path
        log_dir = $native.log_dir
        transcript_path = $transcriptPath
        codex_exit_path = $exitPath
        codex_exit_code_path = $exitCodePath
        cli_exit_marker_exists = $exitMarkerExists
        terminal_title = $native.terminal_title
        exit_code = $exitCode
        goal_command_mentions_prompt_path = ($goalCommand -and $native.prompt_path -and $goalCommand.Contains([string]$native.prompt_path))
        prompt_has_context_ingestion = ($promptText -and $promptText.Contains("Context ingestion"))
        transcript_excerpt = $transcriptTail
        blocker_signals = @($blockerSignals)
        can_verify = @(
            "native goal metadata",
            "workspace selection",
            "prompt path",
            "goal command path",
            "terminal process state",
            "active child codex process when present",
            "terminal transcript when transcript_path exists"
        )
        cannot_verify = if ($hasTranscript) { @("full interactive state beyond captured transcript") } else { @("completed CLI content if this run predates transcript capture", "interactive transcript without pasted output") }
        next = if ($hasActiveCodex) {
            "Native CLI still appears active. Read transcript excerpt if present; otherwise wait or paste latest CLI screen before planning."
        }
        elseif ($hasTranscript) {
            "Native CLI appears finished or no active child Codex process is attached. Read transcript_excerpt/terminal transcript before planning next."
        }
        else {
            "No readable terminal transcript for this run. If this was an old CLI window, paste its latest screen/output; future /goal launches should write terminal-transcript.txt."
        }
    }

    if ($Detailed) {
        $result | ConvertTo-Json -Depth 8
    }
    else {
        $shortTranscript = Format-ShortText -Text $transcriptTail
        @"
status: $($result.status)
target: $($result.target)
selected_by: $($result.selected_by)
goal: $($result.goal_objective)
process: pid=$($proc.pid) $($proc.note)
active_codex_children: $(@($children | ForEach-Object { $_.ProcessId }) -join ', ')
workspace: $($result.workspace)
prompt: $($result.prompt_path)
transcript: $($result.transcript_path)
exit_code: $($result.exit_code)
blocker_signals: $($blockerSignals -join ', ')
can_verify: metadata/process/transcript-if-present
cannot_verify: $($result.cannot_verify -join '; ')
next: $($result.next)
transcript_excerpt:
$shortTranscript
"@
    }
    exit 0
}

$sidecarRoot = Join-Path $env:LOCALAPPDATA "CodexCliSidecars\codex-cli"
$latestSidecarDir = Get-LatestDirectory -Root $sidecarRoot

if ($latestSidecarDir) {
    $exitPath = Join-Path $latestSidecarDir.FullName "exit-code.txt"
    $lastPath = Join-Path $latestSidecarDir.FullName "last-message.md"
    $stdoutPath = Join-Path $latestSidecarDir.FullName "stdout.log"
    $promptPath = Join-Path $latestSidecarDir.FullName "prompt.md"

    $exitCode = if (Test-Path -LiteralPath $exitPath) { (Get-Content -LiteralPath $exitPath -Raw).Trim() } else { $null }
    $lastExists = Test-Path -LiteralPath $lastPath
    $stdoutExists = Test-Path -LiteralPath $stdoutPath
    $lastTail = Read-TextTail -Path $lastPath -MaxChars 8000
    $stdoutTail = Read-TextTail -Path $stdoutPath -MaxChars 8000
    $combinedTail = "$lastTail`n$stdoutTail"
    $blockerSignals = Get-BlockerSignals -Text $combinedTail

    $status = if ($exitCode -ne $null) {
        if ($exitCode -eq "0") { "finished" } else { "blocked-or-failed" }
    }
    else {
        "running-or-unknown"
    }

    if ($blockerSignals.Count -gt 0 -and $status -ne "finished") {
        $status = "$status-blocker-signal"
    }

    $result = [pscustomobject]@{
        status = $status
        target = "codex-cli-sidecar"
        log_dir = $latestSidecarDir.FullName
        exit_code = $exitCode
        last_message = $lastPath
        stdout = $stdoutPath
        prompt = $promptPath
        last_message_excerpt = $lastTail
        stdout_excerpt = $stdoutTail
        blocker_signals = @($blockerSignals)
        can_verify = @("exit code", "last-message.md", "stdout.log")
        cannot_verify = @()
        next = if ($exitCode -eq "0" -and $lastExists) { "Read last-message excerpt before planning next." } elseif ($exitCode) { "Inspect stdout/last-message excerpts for blocker before planning next." } else { "No exit code yet; sidecar may still be running or did not write completion state." }
    }

    if ($Detailed) { $result | ConvertTo-Json -Depth 6 }
    else {
        @"
status: $($result.status)
target: $($result.target)
log_dir: $($result.log_dir)
exit_code: $($result.exit_code)
last_message: $($result.last_message)
stdout: $($result.stdout)
blocker_signals: $($blockerSignals -join ', ')
can_verify: exit/log files
next: $($result.next)
last_message_excerpt:
$(Format-ShortText -Text $lastTail)
stdout_excerpt:
$(Format-ShortText -Text $stdoutTail)
"@
    }
    exit 0
}

try {
    $liveCodex = Get-CimInstance Win32_Process |
        Where-Object {
            $name = $_.Name
            $cmd = [string]$_.CommandLine
            $isCodexProcess = $name -match '^codex(\.exe|\.cmd)?$'
            $isCodexShell = ($name -match '^(powershell\.exe|pwsh\.exe)$') -and (
                $cmd -match '(?i)-Command\s+["'']?codex(\.cmd|\.exe)?\b' -or
                $cmd -match '(?i)\bcodex\s+--enable\s+goals\b'
            )
            ($_.ProcessId -ne $PID) -and
            ($cmd -notmatch 'Check-CodexCliStatus\.ps1') -and
            ($isCodexProcess -or $isCodexShell)
        } |
        Sort-Object CreationDate -Descending |
        Select-Object -First 8 ProcessId, ParentProcessId, Name, CommandLine, CreationDate
}
catch {
    $liveCodex = @()
}

if ($liveCodex -and $liveCodex.Count -gt 0) {
    $primary = $liveCodex | Select-Object -First 1
    $result = [pscustomobject]@{
        status = "live-process-found-output-unavailable"
        target = "live-codex-process-scan"
        process = [pscustomobject]@{
            pid = $primary.ProcessId
            name = $primary.Name
            command_line = $primary.CommandLine
            creation_date = $primary.CreationDate
        }
        candidates = $liveCodex
        can_verify = @("a Codex-related process is running", "process id", "command line")
        cannot_verify = @("which prompt was used if no run.json exists", "interactive CLI transcript", "whether the goal completed internally")
        next = "A likely Codex CLI process is running, but no saved transcript metadata was found. Paste the latest CLI screen/output if you need completion/blocker interpretation."
    }

    if ($Detailed) { $result | ConvertTo-Json -Depth 6 }
    else {
        @"
status: $($result.status)
target: $($result.target)
process: pid=$($primary.ProcessId) name=$($primary.Name)
command: $($primary.CommandLine)
can_verify: live Codex-related process exists
cannot_verify: prompt/transcript/completion without saved run metadata or pasted output
next: $($result.next)
"@
    }
    exit 0
}

[pscustomobject]@{
    status = "unknown"
    target = "none"
    can_verify = @()
    cannot_verify = @("no native goal CLI or codex-cli sidecar state found")
    next = "Run $goal first, or paste the terminal output to inspect manually."
} | ConvertTo-Json -Depth 4
