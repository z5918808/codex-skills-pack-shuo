[CmdletBinding()]
param(
    [string]$RepoPath = ".",
    [string]$TemplatePath,
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Resolve-DirectoryPath {
    param([string]$Path)

    $resolved = Resolve-Path -Path $Path -ErrorAction Stop
    $item = Get-Item -Path $resolved.Path -ErrorAction Stop
    if (-not $item.PSIsContainer) {
        throw "RepoPath is not a directory: $Path"
    }
    return $item.FullName
}

function Resolve-TemplatePath {
    param([string]$ExplicitTemplatePath)

    if ($ExplicitTemplatePath) {
        $resolved = Resolve-Path -Path $ExplicitTemplatePath -ErrorAction Stop
        return $resolved.Path
    }

    $homeTemplate = Join-Path $env:USERPROFILE ".codex\templates\repo\AGENTS.md"
    if (Test-Path -Path $homeTemplate -PathType Leaf) {
        return (Resolve-Path -Path $homeTemplate).Path
    }

    $skillDir = Split-Path -Parent $PSScriptRoot
    $bundledTemplate = Join-Path $skillDir "assets\default-repo-AGENTS.md"
    if (Test-Path -Path $bundledTemplate -PathType Leaf) {
        return (Resolve-Path -Path $bundledTemplate).Path
    }

    throw "No repo AGENTS.md template found."
}

$repoRoot = Resolve-DirectoryPath -Path $RepoPath
$template = Resolve-TemplatePath -ExplicitTemplatePath $TemplatePath
$target = Join-Path $repoRoot "AGENTS.md"

if ((Test-Path -Path $target -PathType Leaf) -and -not $Force) {
    Write-Output "exists: $target"
    Write-Output "template: $template"
    Write-Output "No changes made. Use -Force only after reading the existing file."
    exit 0
}

if ($DryRun) {
    Write-Output "dry-run: would copy template"
    Write-Output "from: $template"
    Write-Output "to: $target"
    exit 0
}

Copy-Item -Path $template -Destination $target -Force:$Force

if (-not (Test-Path -Path $target -PathType Leaf)) {
    throw "Failed to create AGENTS.md at $target"
}

Write-Output "created: $target"
Write-Output "template: $template"
