[CmdletBinding()]
param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
    [int]$ArchiveOlderThanDays = 7,
    [switch]$Apply,
    [switch]$KeepPinned,
    [switch]$SkipRotateLogs,
    [int]$MinLogMB = 256,
    [switch]$RepairStateDbFromLatestManifest,
    [switch]$RepairStateDbFromAllApplyManifests,
    [switch]$MigrateExistingArchivesToStorage,
    [string]$ArchiveStorageRoot,
    [string]$RepairManifestPath
)

$ErrorActionPreference = "Stop"

function New-Directory {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function ConvertTo-MB {
    param([double]$Bytes)
    return [math]::Round(($Bytes / 1MB), 2)
}

function Get-ThreadIdFromFileName {
    param([string]$Name)
    $match = [regex]::Match($Name, "([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})")
    if ($match.Success) { return $match.Groups[1].Value }
    return $null
}

function Get-RelativePath {
    param(
        [string]$Root,
        [string]$Path
    )
    $prefix = $Root.TrimEnd("\", "/")
    return $Path.Substring($prefix.Length).TrimStart("\", "/")
}

function Read-PinnedThreadIds {
    param([string]$GlobalStatePath)
    if (-not (Test-Path -LiteralPath $GlobalStatePath)) { return @() }
    try {
        $raw = Get-Content -LiteralPath $GlobalStatePath -Raw
        $match = [regex]::Match($raw, '"pinned-thread-ids"\s*:\s*\[(?<items>.*?)\]', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if (-not $match.Success) { return @() }
        $ids = @()
        foreach ($idMatch in [regex]::Matches($match.Groups["items"].Value, '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')) {
            $ids += $idMatch.Value
        }
        return $ids
    } catch {
        Write-Warning "Could not read pinned-thread-ids: $($_.Exception.Message)"
        return @()
    }
}

function Read-SessionIndex {
    param([string]$SessionIndexPath)
    $map = @{}
    if (-not (Test-Path -LiteralPath $SessionIndexPath)) { return $map }
    Get-Content -LiteralPath $SessionIndexPath | ForEach-Object {
        try {
            $row = $_ | ConvertFrom-Json
            if ($row.id) { $map[$row.id] = $row }
        } catch {
        }
    }
    return $map
}

function Get-CodexAppProcessRows {
    $rows = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
        $name = [string]$_.Name
        $path = [string]$_.ExecutablePath
        $cmd = [string]$_.CommandLine

        ($name -in @("Codex.exe", "codex.exe")) -and (
            $path -like "*\WindowsApps\OpenAI.Codex_*" -or
            $cmd -like "*\WindowsApps\OpenAI.Codex_*" -or
            $cmd -like "*app-server --analytics-default-enabled*"
        )
    } | Select-Object ProcessId, Name, ExecutablePath, CommandLine)

    if ($rows.Count -eq 0) {
        $rows = @(Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $_.ProcessName -in @("Codex", "codex") -and $_.Path -like "*\WindowsApps\OpenAI.Codex_*"
        } | ForEach-Object {
            [pscustomobject]@{
                ProcessId = $_.Id
                Name = $_.ProcessName + ".exe"
                ExecutablePath = $_.Path
                CommandLine = ""
            }
        })
    }

    @($rows | Sort-Object ProcessId -Unique)
}

function Assert-CodexClosedForApply {
    $processes = @(Get-CodexAppProcessRows)
    if ($processes.Count -gt 0) {
        $summary = $processes | Select-Object ProcessId, Name, ExecutablePath
        throw "Codex is running. Close Codex App before -Apply. Running processes: $($summary | ConvertTo-Json -Compress)"
    }
}

function Copy-BackupItem {
    param(
        [string]$Source,
        [string]$DestinationRoot
    )
    if (-not (Test-Path -LiteralPath $Source)) { return $null }
    $name = Split-Path -Leaf $Source
    $destination = Join-Path $DestinationRoot $name
    Copy-Item -LiteralPath $Source -Destination $destination -Recurse -Force
    return $destination
}

function Move-DirectoryChildren {
    param(
        [string]$SourceRoot,
        [string]$DestinationRoot
    )
    $moved = @()
    if (-not (Test-Path -LiteralPath $SourceRoot)) { return $moved }
    New-Directory $DestinationRoot
    $children = @(Get-ChildItem -LiteralPath $SourceRoot -Force -ErrorAction SilentlyContinue)
    foreach ($child in $children) {
        $target = Join-Path $DestinationRoot $child.Name
        if (Test-Path -LiteralPath $target) {
            $targetItem = Get-Item -LiteralPath $target -Force
            if ($child.PSIsContainer -and $targetItem.PSIsContainer) {
                $moved += Move-DirectoryChildren -SourceRoot $child.FullName -DestinationRoot $target
                $remaining = @(Get-ChildItem -LiteralPath $child.FullName -Force -ErrorAction SilentlyContinue)
                if ($remaining.Count -eq 0) {
                    Remove-Item -LiteralPath $child.FullName -Force
                }
                continue
            }
            throw "Archive migration target already exists; refusing to overwrite: $target"
        }
        Move-Item -LiteralPath $child.FullName -Destination $target
        $moved += [pscustomobject]@{
            from = $child.FullName
            to = $target
            is_directory = $child.PSIsContainer
        }
    }
    return $moved
}

function Get-PythonCommand {
    $py = Get-Command python -ErrorAction SilentlyContinue
    if ($py) { return $py.Source }
    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) { return $py.Source }
    return $null
}

function Invoke-StateHelper {
    param(
        [string[]]$Arguments
    )
    $helper = Join-Path (Split-Path -Parent $PSCommandPath) "codex-cleanup-state.py"
    if (-not (Test-Path -LiteralPath $helper)) {
        throw "State helper missing: $helper"
    }
    $python = Get-PythonCommand
    if (-not $python) {
        throw "Python is required for SQLite state sync but was not found."
    }
    $output = & $python $helper @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "State helper failed with exit code $LASTEXITCODE"
    }
    return ($output | Out-String).Trim()
}

function Get-LatestApplyManifest {
    param([string]$ReportsRoot)
    $reports = @(Get-ChildItem -LiteralPath $ReportsRoot -Filter "codex-cleanup-report-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
    foreach ($report in $reports) {
        try {
            $json = Get-Content -LiteralPath $report.FullName -Raw | ConvertFrom-Json
            if ($json.mode -eq "apply" -and $json.manifest_path -and (Test-Path -LiteralPath $json.manifest_path)) {
                return $json.manifest_path
            }
        } catch {
        }
    }
    return $null
}

function Get-AllApplyManifests {
    param([string]$ReportsRoot)
    $seen = @{}
    $rows = @()
    $reports = @(Get-ChildItem -LiteralPath $ReportsRoot -Filter "codex-cleanup-report-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)
    foreach ($report in $reports) {
        try {
            $json = Get-Content -LiteralPath $report.FullName -Raw | ConvertFrom-Json
            if ($json.mode -eq "apply" -and $json.manifest_path -and (Test-Path -LiteralPath $json.manifest_path)) {
                $manifest = [string]$json.manifest_path
                if (-not $seen.ContainsKey($manifest)) {
                    $seen[$manifest] = $true
                    $rows += [pscustomobject]@{
                        report_path = $report.FullName
                        manifest_path = $manifest
                    }
                }
            }
        } catch {
        }
    }
    return $rows
}

function Get-ConfigHealth {
    param([string]$ConfigPath)
    $rows = @()
    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        return [pscustomobject]@{ exists = $false }
    }
    Get-Content -LiteralPath $ConfigPath | ForEach-Object {
        if ($_ -match '^\[projects\.([''"])(.+)\1\]') {
            $projectPath = $Matches[2]
            $rows += [pscustomobject]@{
                path = $projectPath
                exists = (Test-Path -LiteralPath $projectPath)
                is_temp = ($projectPath -match '\\Temp\\|/Temp/|\\AppData\\Local\\Temp\\|/AppData/Local/Temp/')
                lower = $projectPath.ToLowerInvariant()
            }
        }
    }
    $dups = @($rows | Group-Object lower | Where-Object Count -gt 1 | ForEach-Object { $_.Group })
    return [pscustomobject]@{
        exists = $true
        project_entries = $rows.Count
        missing_entries = @($rows | Where-Object { -not $_.exists }).Count
        temp_entries = @($rows | Where-Object { $_.is_temp }).Count
        case_duplicate_entries = $dups.Count
        duplicate_paths = @($dups | Select-Object -First 20 -ExpandProperty path)
        missing_paths = @($rows | Where-Object { -not $_.exists } | Select-Object -First 20 -ExpandProperty path)
    }
}

function Get-DirectoryHealth {
    param([string]$CodexHome)
    $names = @("sessions", "archived_sessions", "archived_logs", "backups", "cleanup_reports", "generated_images", ".tmp", "tmp", "pet-runs", "plugins", "skills", "memories", "automations")
    $rows = @()
    foreach ($name in $names) {
        $path = Join-Path $CodexHome $name
        if (Test-Path -LiteralPath $path) {
            $files = @(Get-ChildItem -LiteralPath $path -Recurse -Force -File -ErrorAction SilentlyContinue)
            $bytes = 0
            if ($files.Count -gt 0) {
                $bytes = ($files | Measure-Object Length -Sum).Sum
            }
            $rows += [pscustomobject]@{
                name = $name
                files = $files.Count
                mb = ConvertTo-MB $bytes
            }
        }
    }
    return @($rows | Sort-Object mb -Descending)
}

if (-not (Test-Path -LiteralPath $CodexHome)) {
    throw "CodexHome not found: $CodexHome"
}

if ($Apply.IsPresent -or $RepairStateDbFromLatestManifest.IsPresent -or $RepairStateDbFromAllApplyManifests.IsPresent -or $MigrateExistingArchivesToStorage.IsPresent -or $RepairManifestPath) {
    Assert-CodexClosedForApply
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$sessionsRoot = Join-Path $CodexHome "sessions"
$effectiveArchiveStorageRoot = $CodexHome
if ($ArchiveStorageRoot) {
    $effectiveArchiveStorageRoot = [System.IO.Path]::GetFullPath($ArchiveStorageRoot)
    $driveRoot = [System.IO.Path]::GetPathRoot($effectiveArchiveStorageRoot)
    if (-not $driveRoot -or -not (Test-Path -LiteralPath $driveRoot)) {
        throw "ArchiveStorageRoot drive not found: $ArchiveStorageRoot"
    }
}
$archiveRoot = Join-Path $effectiveArchiveStorageRoot "archived_sessions"
$looseArchiveRoot = Join-Path $archiveRoot ("loose\" + $timestamp)
$reportsRoot = Join-Path $CodexHome "cleanup_reports"
$logsArchiveRoot = Join-Path $effectiveArchiveStorageRoot ("archived_logs\" + $timestamp)
$backupRoot = Join-Path $effectiveArchiveStorageRoot ("backups\cleanup-" + $timestamp)
$globalStatePath = Join-Path $CodexHome ".codex-global-state.json"
$sessionIndexPath = Join-Path $CodexHome "session_index.jsonl"
$configPath = Join-Path $CodexHome "config.toml"
$cutoffUtc = (Get-Date).ToUniversalTime().AddDays(-1 * $ArchiveOlderThanDays)

New-Directory $reportsRoot
New-Directory (Join-Path $archiveRoot "manifests")

$pinnedIds = @(Read-PinnedThreadIds $globalStatePath)
$sessionIndex = Read-SessionIndex $sessionIndexPath
$sessionFiles = @()
if (Test-Path -LiteralPath $sessionsRoot) {
    $sessionFiles = @(Get-ChildItem -LiteralPath $sessionsRoot -Recurse -Force -File -Filter "*.jsonl" -ErrorAction SilentlyContinue)
}

$candidates = @()
foreach ($file in $sessionFiles) {
    $threadId = Get-ThreadIdFromFileName $file.Name
    $isPinned = $false
    if ($threadId -and ($pinnedIds -contains $threadId)) { $isPinned = $true }

    $updatedUtc = $file.LastWriteTimeUtc
    $threadName = $null
    if ($threadId -and $sessionIndex.ContainsKey($threadId)) {
        $row = $sessionIndex[$threadId]
        $threadName = $row.thread_name
        if ($row.updated_at) {
            $updatedUtc = ([datetime]$row.updated_at).ToUniversalTime()
        }
    }

    $oldEnough = $updatedUtc -lt $cutoffUtc
    $skipForPinned = $KeepPinned.IsPresent -and $isPinned
    if ($oldEnough -and -not $skipForPinned) {
        $relativePath = Get-RelativePath -Root $sessionsRoot -Path $file.FullName
        $targetPath = Join-Path $looseArchiveRoot $relativePath
        $candidates += [pscustomobject]@{
            thread_id = $threadId
            thread_name = $threadName
            is_pinned = $isPinned
            updated_utc = $updatedUtc.ToString("o")
            size_bytes = $file.Length
            size_mb = ConvertTo-MB $file.Length
            original_path = $file.FullName
            relative_path = $relativePath
            archive_path = $targetPath
            status = "candidate"
        }
    }
}

$activeBytes = 0
if ($sessionFiles.Count -gt 0) {
    $activeBytes = ($sessionFiles | Measure-Object -Property Length -Sum).Sum
}

$candidateBytes = 0
if ($candidates.Count -gt 0) {
    $candidateBytes = ($candidates | Measure-Object -Property size_bytes -Sum).Sum
}

$pinnedCandidateCount = @($candidates | Where-Object { $_.is_pinned }).Count
$pinnedCandidateBytes = 0
if ($pinnedCandidateCount -gt 0) {
    $pinnedCandidateBytes = (($candidates | Where-Object { $_.is_pinned }) | Measure-Object -Property size_bytes -Sum).Sum
}

$logFiles = @(Get-ChildItem -LiteralPath $CodexHome -Force -File -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -match "^logs?_.*\.sqlite($|-wal$|-shm$)" -or
    ($_.Name -match "\.log$" -and $_.Length -ge ($MinLogMB * 1MB))
})

$oversizedLogBases = @{}
foreach ($log in $logFiles) {
    if ($log.Name -match "^(.+\.sqlite)") {
        $baseName = $matches[1]
        if ($log.Name -eq $baseName -and $log.Length -ge ($MinLogMB * 1MB)) {
            $oversizedLogBases[$baseName] = $true
        }
    }
}

$logsToRotate = @()
foreach ($log in $logFiles) {
    $include = $false
    if ($log.Name -match "^(.+\.sqlite)") {
        $baseName = $matches[1]
        if ($oversizedLogBases.ContainsKey($baseName)) { $include = $true }
    } elseif ($log.Length -ge ($MinLogMB * 1MB)) {
        $include = $true
    }
    if ($include) { $logsToRotate += $log }
}

$extendedPathHits = @()
foreach ($path in @($configPath, $globalStatePath, $sessionIndexPath)) {
    if (Test-Path -LiteralPath $path) {
        $hits = @(Select-String -LiteralPath $path -SimpleMatch "\\?\" -ErrorAction SilentlyContinue)
        foreach ($hit in $hits) {
            $extendedPathHits += [pscustomobject]@{
                path = $hit.Path
                line_number = $hit.LineNumber
                line = $hit.Line
            }
        }
    }
}

$manifestPath = Join-Path $reportsRoot ("codex-cleanup-candidates-" + $timestamp + ".jsonl")
$reportPath = Join-Path $reportsRoot ("codex-cleanup-report-" + $timestamp + ".json")

if ($MigrateExistingArchivesToStorage.IsPresent) {
    if (-not $ArchiveStorageRoot) {
        throw "-MigrateExistingArchivesToStorage requires -ArchiveStorageRoot"
    }
    New-Directory $backupRoot
    Get-ChildItem -LiteralPath $CodexHome -Force -File -Filter "state_*.sqlite*" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-BackupItem -Source $_.FullName -DestinationRoot $backupRoot | Out-Null
    }

    $sourceArchiveRoot = Join-Path $CodexHome "archived_sessions"
    $sourceLogsRoot = Join-Path $CodexHome "archived_logs"
    $sourceBackupsRoot = Join-Path $CodexHome "backups"
    $targetArchiveRoot = Join-Path $effectiveArchiveStorageRoot "archived_sessions"
    $targetLogsRoot = Join-Path $effectiveArchiveStorageRoot "archived_logs"
    $targetBackupsRoot = Join-Path $effectiveArchiveStorageRoot "backups"

    $movedItems = @()
    if ([System.IO.Path]::GetFullPath($sourceArchiveRoot).TrimEnd("\") -ne [System.IO.Path]::GetFullPath($targetArchiveRoot).TrimEnd("\")) {
        $movedItems += Move-DirectoryChildren -SourceRoot $sourceArchiveRoot -DestinationRoot $targetArchiveRoot
    }
    if ([System.IO.Path]::GetFullPath($sourceLogsRoot).TrimEnd("\") -ne [System.IO.Path]::GetFullPath($targetLogsRoot).TrimEnd("\")) {
        $movedItems += Move-DirectoryChildren -SourceRoot $sourceLogsRoot -DestinationRoot $targetLogsRoot
    }
    if ([System.IO.Path]::GetFullPath($sourceBackupsRoot).TrimEnd("\") -ne [System.IO.Path]::GetFullPath($targetBackupsRoot).TrimEnd("\")) {
        $movedItems += Move-DirectoryChildren -SourceRoot $sourceBackupsRoot -DestinationRoot $targetBackupsRoot
    }

    $movedManifestPath = Join-Path $backupRoot "moved-cold-archives.jsonl"
    foreach ($item in $movedItems) {
        $item | ConvertTo-Json -Compress | Add-Content -LiteralPath $movedManifestPath
    }

    $rewriteManifest = Join-Path $backupRoot "rewrite-rollout-archive-prefix.jsonl"
    $rewriteRestoreScript = Join-Path $backupRoot "restore-rollout-archive-prefix.py"
    $rewriteRaw = Invoke-StateHelper -Arguments @(
        "--codex-home", $CodexHome,
        "--rewrite-rollout-prefix-old", $sourceArchiveRoot,
        "--rewrite-rollout-prefix-new", $targetArchiveRoot,
        "--rewrite-rollout-prefix-manifest", $rewriteManifest,
        "--apply",
        "--restore-script", $rewriteRestoreScript
    )
    $rewriteSync = $rewriteRaw | ConvertFrom-Json
    $stateInspectAfterMigrationRaw = Invoke-StateHelper -Arguments @("--codex-home", $CodexHome, "--inspect")
    $stateInspectAfterMigration = $stateInspectAfterMigrationRaw | ConvertFrom-Json

    $result = [pscustomobject]@{
        mode = "migrate-archives"
        codex_home = $CodexHome
        archive_storage_root = $effectiveArchiveStorageRoot
        source_archive_root = $sourceArchiveRoot
        target_archive_root = $targetArchiveRoot
        source_logs_root = $sourceLogsRoot
        target_logs_root = $targetLogsRoot
        source_backups_root = $sourceBackupsRoot
        target_backups_root = $targetBackupsRoot
        moved_items = $movedItems.Count
        moved_manifest_path = $movedManifestPath
        rewrite_sync = $rewriteSync
        state_health = $stateInspectAfterMigration
        report_path = $reportPath
        backup_root = $backupRoot
    }
    $result | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $reportPath -Encoding UTF8
    Write-Host "Mode: migrate-archives"
    Write-Host ("Archive storage root: " + $effectiveArchiveStorageRoot)
    Write-Host ("Moved cold archive items: " + $movedItems.Count)
    Write-Host ("DB rollout paths rewritten: " + $rewriteSync.db_rows_updated + " / " + $rewriteSync.candidate_rows)
    Write-Host ("State DB active missing rollout paths: " + $stateInspectAfterMigration.active_missing_rollout_paths)
    Write-Host ("Report: " + $reportPath)
    Write-Host ("Backup: " + $backupRoot)
    return
}

if ($RepairStateDbFromAllApplyManifests.IsPresent) {
    New-Directory $backupRoot
    Get-ChildItem -LiteralPath $CodexHome -Force -File -Filter "state_*.sqlite*" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-BackupItem -Source $_.FullName -DestinationRoot $backupRoot | Out-Null
    }
    $repairManifests = @(Get-AllApplyManifests -ReportsRoot $reportsRoot)
    if ($repairManifests.Count -eq 0) {
        throw "No apply manifests found for state DB repair."
    }

    $stateSyncResults = @()
    $totalRowsUpdated = 0
    $index = 0
    foreach ($item in $repairManifests) {
        $index += 1
        $restoreScript = Join-Path $backupRoot ("restore-sessions-" + $index.ToString("000") + ".py")
        $stateSyncRaw = Invoke-StateHelper -Arguments @("--codex-home", $CodexHome, "--manifest", $item.manifest_path, "--apply", "--restore-script", $restoreScript)
        $stateSync = $stateSyncRaw | ConvertFrom-Json
        $totalRowsUpdated += [int]$stateSync.db_rows_updated
        $stateSyncResults += [pscustomobject]@{
            report_path = $item.report_path
            manifest_path = $item.manifest_path
            state_sync = $stateSync
        }
    }

    $missingActiveManifest = Join-Path $backupRoot "missing-active-rollout-paths.jsonl"
    $missingActiveRestoreScript = Join-Path $backupRoot "restore-missing-active-rollout-paths.py"
    $missingActiveSyncRaw = Invoke-StateHelper -Arguments @(
        "--codex-home", $CodexHome,
        "--archive-missing-active-older-than-days", ([string]$ArchiveOlderThanDays),
        "--missing-active-manifest", $missingActiveManifest,
        "--apply",
        "--restore-script", $missingActiveRestoreScript
    )
    $missingActiveSync = $missingActiveSyncRaw | ConvertFrom-Json
    $totalRowsUpdated += [int]$missingActiveSync.db_rows_updated

    $finalStateInspectRaw = Invoke-StateHelper -Arguments @("--codex-home", $CodexHome, "--inspect")
    $finalStateInspect = $finalStateInspectRaw | ConvertFrom-Json
    $result = [pscustomobject]@{
        mode = "repair-state-db-all"
        codex_home = $CodexHome
        archive_storage_root = $effectiveArchiveStorageRoot
        manifest_count = $repairManifests.Count
        report_path = $reportPath
        backup_root = $backupRoot
        db_rows_updated = $totalRowsUpdated
        missing_active_sync = $missingActiveSync
        final_state_health = $finalStateInspect
        state_sync_results = $stateSyncResults
    }
    $result | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $reportPath -Encoding UTF8
    Write-Host "Mode: repair-state-db-all"
    Write-Host ("Archive storage root: " + $effectiveArchiveStorageRoot)
    Write-Host ("Manifests: " + $repairManifests.Count)
    Write-Host ("DB rows updated: " + $totalRowsUpdated)
    Write-Host ("Missing active rows archived: " + $missingActiveSync.db_rows_updated + " / " + $missingActiveSync.candidate_rows)
    Write-Host ("Active missing rollout paths after repair: " + $finalStateInspect.active_missing_rollout_paths)
    Write-Host ("Report: " + $reportPath)
    Write-Host ("Backup: " + $backupRoot)
    return
}

if ($RepairStateDbFromLatestManifest.IsPresent -or $RepairManifestPath) {
    New-Directory $backupRoot
    Get-ChildItem -LiteralPath $CodexHome -Force -File -Filter "state_*.sqlite*" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-BackupItem -Source $_.FullName -DestinationRoot $backupRoot | Out-Null
    }
    $repairManifest = $RepairManifestPath
    if (-not $repairManifest) {
        $repairManifest = Get-LatestApplyManifest -ReportsRoot $reportsRoot
    }
    if (-not $repairManifest) {
        throw "No apply manifest found for state DB repair."
    }
    $stateSyncRaw = Invoke-StateHelper -Arguments @("--codex-home", $CodexHome, "--manifest", $repairManifest, "--apply", "--restore-script", (Join-Path $backupRoot "restore-sessions.py"))
    $stateSync = $stateSyncRaw | ConvertFrom-Json
    $result = [pscustomobject]@{
        mode = "repair-state-db"
        codex_home = $CodexHome
        archive_storage_root = $effectiveArchiveStorageRoot
        manifest_path = $repairManifest
        report_path = $reportPath
        backup_root = $backupRoot
        state_sync = $stateSync
    }
    $result | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $reportPath -Encoding UTF8
    Write-Host "Mode: repair-state-db"
    Write-Host ("Archive storage root: " + $effectiveArchiveStorageRoot)
    Write-Host ("Manifest: " + $repairManifest)
    Write-Host ("DB rows updated: " + $stateSync.db_rows_updated)
    Write-Host ("Active missing rollout paths after repair: " + $stateSync.post_inspect.active_missing_rollout_paths)
    Write-Host ("Report: " + $reportPath)
    Write-Host ("Backup: " + $backupRoot)
    return
}

foreach ($candidate in $candidates) {
    $candidate | ConvertTo-Json -Compress | Add-Content -LiteralPath $manifestPath
}

$backupItems = @()
$movedSessions = 0
$movedSessionBytes = 0
$rotatedLogs = 0
$rotatedLogBytes = 0
$stateSync = $null
$stateInspect = $null
$configHealth = Get-ConfigHealth -ConfigPath $configPath
$directoryHealth = Get-DirectoryHealth -CodexHome $CodexHome

try {
    $stateInspectRaw = Invoke-StateHelper -Arguments @("--codex-home", $CodexHome, "--inspect")
    $stateInspect = $stateInspectRaw | ConvertFrom-Json
} catch {
    $stateInspect = [pscustomobject]@{
        error = $_.Exception.Message
    }
}

if ($Apply.IsPresent) {
    New-Directory $backupRoot
    foreach ($item in @("config.toml", ".codex-global-state.json", "session_index.jsonl", "auth.json", "memories", "skills", "plugins", "automations")) {
        $source = Join-Path $CodexHome $item
        $copied = Copy-BackupItem -Source $source -DestinationRoot $backupRoot
        if ($copied) { $backupItems += $copied }
    }
    Get-ChildItem -LiteralPath $CodexHome -Force -File -Filter "state_*.sqlite*" -ErrorAction SilentlyContinue | ForEach-Object {
        $copied = Copy-BackupItem -Source $_.FullName -DestinationRoot $backupRoot
        if ($copied) { $backupItems += $copied }
    }

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate.original_path) {
            New-Directory (Split-Path -Parent $candidate.archive_path)
            Move-Item -LiteralPath $candidate.original_path -Destination $candidate.archive_path
            if (Test-Path -LiteralPath $candidate.archive_path) {
                $candidate.status = "archived_moved"
                $movedSessions += 1
                $movedSessionBytes += [int64]$candidate.size_bytes
            } else {
                $candidate.status = "move_failed_target_missing"
            }
        } else {
            $candidate.status = "source_missing_before_move"
        }
    }

    if ($movedSessions -gt 0) {
        $stateSyncRaw = Invoke-StateHelper -Arguments @("--codex-home", $CodexHome, "--manifest", $manifestPath, "--apply", "--restore-script", (Join-Path $backupRoot "restore-sessions.py"))
        $stateSync = $stateSyncRaw | ConvertFrom-Json
    }

    if (-not $SkipRotateLogs.IsPresent -and $logsToRotate.Count -gt 0) {
        New-Directory $logsArchiveRoot
        foreach ($log in $logsToRotate) {
            if (Test-Path -LiteralPath $log.FullName) {
                $target = Join-Path $logsArchiveRoot $log.Name
                Move-Item -LiteralPath $log.FullName -Destination $target
                if (Test-Path -LiteralPath $target) {
                    $rotatedLogs += 1
                    $rotatedLogBytes += [int64]$log.Length
                }
            }
        }
    }
}

$result = [pscustomobject]@{
    mode = $(if ($Apply.IsPresent) { "apply" } else { "dry-run" })
    codex_home = $CodexHome
    archive_storage_root = $effectiveArchiveStorageRoot
    cutoff_utc = $cutoffUtc.ToString("o")
    archive_older_than_days = $ArchiveOlderThanDays
    keep_pinned = $KeepPinned.IsPresent
    active_session_files = $sessionFiles.Count
    active_session_mb = ConvertTo-MB $activeBytes
    candidate_files = $candidates.Count
    candidate_mb = ConvertTo-MB $candidateBytes
    pinned_candidate_files = $pinnedCandidateCount
    pinned_candidate_mb = ConvertTo-MB $pinnedCandidateBytes
    moved_session_files = $movedSessions
    moved_session_mb = ConvertTo-MB $movedSessionBytes
    log_files_to_rotate = $logsToRotate.Count
    log_mb_to_rotate = ConvertTo-MB (($logsToRotate | Measure-Object -Property Length -Sum).Sum)
    rotated_log_files = $rotatedLogs
    rotated_log_mb = ConvertTo-MB $rotatedLogBytes
    state_sync = $stateSync
    state_health = $stateInspect
    config_health = $configHealth
    directory_health = $directoryHealth
    backup_root = $(if ($Apply.IsPresent) { $backupRoot } else { $null })
    loose_archive_root = $(if ($Apply.IsPresent) { $looseArchiveRoot } else { $null })
    logs_archive_root = $(if ($Apply.IsPresent -and -not $SkipRotateLogs.IsPresent) { $logsArchiveRoot } else { $null })
    manifest_path = $manifestPath
    report_path = $reportPath
    extended_path_hits = $extendedPathHits
    top_candidates = @($candidates | Sort-Object size_bytes -Descending | Select-Object -First 25)
}

$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8

Write-Host ("Mode: " + $result.mode)
Write-Host ("Cutoff UTC: " + $result.cutoff_utc)
Write-Host ("Archive storage root: " + $result.archive_storage_root)
Write-Host ("Active sessions: " + $result.active_session_files + " files / " + $result.active_session_mb + " MB")
Write-Host ("Archive candidates: " + $result.candidate_files + " files / " + $result.candidate_mb + " MB")
Write-Host ("Pinned candidates: " + $result.pinned_candidate_files + " files / " + $result.pinned_candidate_mb + " MB")
Write-Host ("Logs to rotate: " + $result.log_files_to_rotate + " files / " + $result.log_mb_to_rotate + " MB")
if ($stateInspect -and $stateInspect.active_missing_rollout_paths -ne $null) {
    Write-Host ("State DB active missing rollout paths: " + $stateInspect.active_missing_rollout_paths)
}
if ($configHealth -and $configHealth.case_duplicate_entries -gt 0) {
    Write-Host ("Config case-duplicate project entries: " + $configHealth.case_duplicate_entries)
}
Write-Host ("Report: " + $reportPath)
Write-Host ("Manifest: " + $manifestPath)

if ($Apply.IsPresent) {
    Write-Host ("Moved sessions: " + $result.moved_session_files + " files / " + $result.moved_session_mb + " MB")
    if ($stateSync) {
        Write-Host ("DB rows updated: " + $stateSync.db_rows_updated)
        Write-Host ("Active missing rollout paths: " + $stateSync.post_inspect.active_missing_rollout_paths)
    }
    Write-Host ("Rotated logs: " + $result.rotated_log_files + " files / " + $result.rotated_log_mb + " MB")
    Write-Host ("Backup: " + $backupRoot)
} else {
    Write-Host "Dry-run only. Close Codex App, then rerun with -Apply to archive."
}
