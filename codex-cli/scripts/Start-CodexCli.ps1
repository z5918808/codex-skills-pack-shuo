param(
    [string]$Workspace = (Get-Location).Path,
    [string]$Prompt = "",
    [switch]$Interactive,
    [switch]$ReadOnly,
    [string]$LogDir = ""
)

$ErrorActionPreference = "Stop"

$codex = Get-Command codex -ErrorAction Stop
$resolvedWorkspace = (Resolve-Path -LiteralPath $Workspace).Path

if (-not $LogDir) {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $LogDir = Join-Path $env:LOCALAPPDATA "CodexCliSidecars\codex-cli\$stamp"
}
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$version = (& $codex.Source --version) 2>&1
$version | Out-File -LiteralPath (Join-Path $LogDir "version.txt") -Encoding utf8

if ($Interactive) {
    $proc = Start-Process powershell.exe `
        -WorkingDirectory $resolvedWorkspace `
        -ArgumentList @("-NoExit", "-Command", "codex") `
        -PassThru

    [pscustomobject]@{
        mode = "interactive"
        pid = $proc.Id
        workspace = $resolvedWorkspace
        log_dir = $LogDir
        version = ($version -join "`n")
    } | ConvertTo-Json -Depth 4
    exit 0
}

if (-not $Prompt.Trim()) {
    throw "Prompt is required unless -Interactive is used."
}

$promptPath = Join-Path $LogDir "prompt.md"
$stdoutPath = Join-Path $LogDir "stdout.log"
$lastPath = Join-Path $LogDir "last-message.md"
$runnerPath = Join-Path $LogDir "run.ps1"

$Prompt | Out-File -LiteralPath $promptPath -Encoding utf8

$effectivePrompt = $Prompt
if ($ReadOnly) {
    $effectivePrompt = @"
READ-ONLY SIDEcar REQUEST:
- Do not modify files.
- Do not start long-running workers.
- Inspect only and report verified findings.

$Prompt
"@
    $effectivePrompt | Out-File -LiteralPath $promptPath -Encoding utf8
}

@"
`$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
    `$PSNativeCommandUseErrorActionPreference = `$false
}
Get-Content -LiteralPath "$promptPath" -Raw | codex exec -C "$resolvedWorkspace" --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check --output-last-message "$lastPath" - *> "$stdoutPath"
`$LASTEXITCODE | Out-File -LiteralPath "$(Join-Path $LogDir "exit-code.txt")" -Encoding utf8
"@ | Out-File -LiteralPath $runnerPath -Encoding utf8

$proc = Start-Process powershell.exe `
    -WindowStyle Hidden `
    -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $runnerPath) `
    -PassThru

[pscustomobject]@{
    mode = "sidecar"
    pid = $proc.Id
    workspace = $resolvedWorkspace
    log_dir = $LogDir
    prompt = $promptPath
    stdout = $stdoutPath
    last_message = $lastPath
    read_only = [bool]$ReadOnly
    version = ($version -join "`n")
} | ConvertTo-Json -Depth 4
