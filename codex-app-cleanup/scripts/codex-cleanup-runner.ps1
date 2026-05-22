param(
    [ValidateSet("Apply", "RepairStateDb")]
    [string]$Mode = "Apply",
    [string]$ArchiveStorageRoot = "E:\CodexArchive"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$cleanupScript = Join-Path $scriptDir "codex-cleanup.ps1"

function Write-Step {
    param([string]$Text)
    Write-Host ""
    Write-Host ("== " + $Text) -ForegroundColor Cyan
}

function Get-CodexProcesses {
    $rows = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
        $name = [string]$_.Name
        $path = [string]$_.ExecutablePath
        $cmd = [string]$_.CommandLine

        ($name -in @("Codex.exe", "codex.exe")) -and (
            $path -like "*\WindowsApps\OpenAI.Codex_*" -or
            $cmd -like "*\WindowsApps\OpenAI.Codex_*" -or
            $cmd -like "*app-server --analytics-default-enabled*"
        )
    })

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

function Show-CodexProcesses {
    param([object[]]$Processes)
    if ($Processes.Count -eq 0) { return }

    Write-Host ("偵測到 Codex App 行程：" + $Processes.Count)
    foreach ($process in $Processes) {
        $kind = "app"
        if ([string]$process.CommandLine -like "*app-server --analytics-default-enabled*") {
            $kind = "app-server"
        } elseif ([string]$process.CommandLine -like "*--type=*") {
            $kind = "electron-child"
        }
        Write-Host ("  PID " + $process.ProcessId + " / " + $process.Name + " / " + $kind)
    }
}

function Wait-CodexExit {
    param([int]$Seconds = 10)
    for ($i = 1; $i -le $Seconds; $i += 1) {
        Start-Sleep -Seconds 1
        $remaining = @(Get-CodexProcesses)
        if ($remaining.Count -eq 0) {
            Write-Host "Codex App 已關閉。"
            return $true
        }
        Write-Host ("等待關閉：" + $i + "/" + $Seconds + " 秒；剩餘 " + $remaining.Count + " 個行程")
    }
    return $false
}

function Stop-CodexProcessesHard {
    param([object[]]$Processes)
    foreach ($process in $Processes) {
        Stop-Process -Id $process.ProcessId -Force -ErrorAction SilentlyContinue
    }
}

function Close-CodexApp {
    Write-Step "步驟 1：準備關閉 Codex App"
    Write-Host "這個清理必須在 Codex App 關閉後執行，否則 state DB / sessions 可能被鎖住。"
    Write-Host "請先確認這個對話已經告一段落。"
    Write-Host ""
    $answer = Read-Host "按 Enter 讓此視窗關閉 Codex App；輸入 N 取消"
    if ($answer -match "^[Nn]$") {
        Write-Host "已取消，未做任何清理。" -ForegroundColor Yellow
        exit 0
    }

    $processes = Get-CodexProcesses
    if ($processes.Count -eq 0) {
        Write-Host "沒有偵測到正在執行的 Codex App 行程。"
        Write-Host "如果你還看得到 Codex 視窗，請先手動關閉；這代表偵測路徑還需要再修。"
        $confirm = Read-Host "確認 Codex App 已關閉後按 Enter；輸入 N 取消"
        if ($confirm -match "^[Nn]$") {
            Write-Host "已取消，未做任何清理。" -ForegroundColor Yellow
            exit 0
        }
        if ((Get-CodexProcesses).Count -gt 0) {
            throw "重新檢查後仍偵測到 Codex App，停止清理。"
        }
        return
    }

    Show-CodexProcesses -Processes $processes

    Write-Host ""
    Write-Host "預設直接強制結束這些 Codex App 行程，這是 cleanup 最穩的路徑。"
    $closeMode = Read-Host "按 Enter 強制關閉；輸入 G 先嘗試溫和關閉 8 秒；輸入 N 取消"
    if ($closeMode -match "^[Nn]$") {
        Write-Host "已取消，未做任何清理。" -ForegroundColor Yellow
        exit 0
    }

    if ($closeMode -match "^[Gg]$") {
        Write-Host "嘗試溫和關閉主視窗..."
        foreach ($process in $processes) {
            try {
                $live = Get-Process -Id $process.ProcessId -ErrorAction SilentlyContinue
                if ($live -and $live.MainWindowHandle -ne 0) {
                    [void]$live.CloseMainWindow()
                }
            } catch {
                Write-Host ("無法送出正常關閉訊號：" + $process.ProcessId) -ForegroundColor Yellow
            }
        }
        if (Wait-CodexExit -Seconds 8) { return }
        Write-Host "溫和關閉未完成，改用強制結束。" -ForegroundColor Yellow
    }

    Write-Host "強制結束 Codex App 行程..."
    Stop-CodexProcessesHard -Processes @(Get-CodexProcesses)
    [void](Wait-CodexExit -Seconds 10)

    $remaining = @(Get-CodexProcesses)
    if ($remaining.Count -gt 0) {
        Show-CodexProcesses -Processes $remaining
        throw "Codex App 仍在執行，停止清理。"
    }
}

function Run-Cleanup {
    param([string[]]$Arguments)
    $finalArgs = @()
    if ($ArchiveStorageRoot) {
        $finalArgs += @("-ArchiveStorageRoot", $ArchiveStorageRoot)
    }
    $finalArgs += $Arguments
    & pwsh -NoProfile -ExecutionPolicy Bypass -File $cleanupScript @finalArgs
    if ($LASTEXITCODE -ne 0) {
        throw ("清理腳本失敗，exit code: " + $LASTEXITCODE)
    }
}

function Get-LatestCleanupReport {
    param([string[]]$Modes)
    $reportsRoot = Join-Path $env:USERPROFILE ".codex\cleanup_reports"
    $reports = @(Get-ChildItem -LiteralPath $reportsRoot -Filter "codex-cleanup-report-*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
    foreach ($report in $reports) {
        try {
            $json = Get-Content -LiteralPath $report.FullName -Raw | ConvertFrom-Json
            if ($json.mode -in $Modes) {
                return [pscustomobject]@{
                    path = $report.FullName
                    json = $json
                }
            }
        } catch {
        }
    }
    return $null
}

function Show-FinalSummary {
    $verify = Get-LatestCleanupReport -Modes @("dry-run")
    $applyReport = Get-LatestCleanupReport -Modes @("apply")
    $repairReport = Get-LatestCleanupReport -Modes @("repair-state-db-all", "repair-state-db")
    $migrationReport = Get-LatestCleanupReport -Modes @("migrate-archives")

    Write-Step "Final summary"
    if (-not $verify) {
        Write-Host "找不到 verify report，不能宣稱完成。" -ForegroundColor Red
        return
    }

    $v = $verify.json
    $candidateFiles = [int]$v.candidate_files
    $candidateMb = [double]$v.candidate_mb
    $logsToRotate = [int]$v.log_files_to_rotate
    $activeMissing = $null
    if ($v.state_health -and $v.state_health.active_missing_rollout_paths -ne $null) {
        $activeMissing = [int]$v.state_health.active_missing_rollout_paths
    }
    $configDuplicates = $null
    if ($v.config_health -and $v.config_health.case_duplicate_entries -ne $null) {
        $configDuplicates = [int]$v.config_health.case_duplicate_entries
    }

    $hardBlockers = @()
    if ($candidateFiles -gt 0) { $hardBlockers += ("archive candidates left: " + $candidateFiles + " files / " + $candidateMb + " MB") }
    if ($logsToRotate -gt 0) { $hardBlockers += ("logs still need rotate: " + $logsToRotate) }
    if ($activeMissing -ne $null -and $activeMissing -gt 0) { $hardBlockers += ("state DB active missing rollout paths: " + $activeMissing) }

    $progress = 100
    if ($hardBlockers.Count -gt 0) {
        $progress = 80
        if ($candidateFiles -gt 0 -or $logsToRotate -gt 0) { $progress = 65 }
    }

    Write-Host ("進度：" + $progress + "%")
    if ($v.archive_storage_root) {
        Write-Host ("Archive storage root: " + $v.archive_storage_root)
    }
    Write-Host ("Active sessions: " + $v.active_session_files + " files / " + $v.active_session_mb + " MB")
    Write-Host ("Archive candidates left: " + $candidateFiles + " files / " + $candidateMb + " MB")
    Write-Host ("Logs to rotate: " + $logsToRotate)
    if ($activeMissing -ne $null) {
        Write-Host ("State DB active missing rollout paths: " + $activeMissing)
    }
    if ($configDuplicates -ne $null) {
        Write-Host ("Config case-duplicate project entries: " + $configDuplicates)
    }
    if ($applyReport) {
        Write-Host ("Latest apply report: " + $applyReport.path)
    }
    if ($migrationReport) {
        Write-Host ("Latest migration report: " + $migrationReport.path)
    }
    if ($repairReport) {
        Write-Host ("Latest repair report: " + $repairReport.path)
    }
    Write-Host ("Verify report: " + $verify.path)

    if ($hardBlockers.Count -eq 0) {
        Write-Host "PASS：清理已收斂，可以重新打開 Codex App。" -ForegroundColor Green
    } else {
        Write-Host "FAIL：流程跑完，但還沒完全收斂。" -ForegroundColor Red
        foreach ($blocker in $hardBlockers) {
            Write-Host ("  - " + $blocker) -ForegroundColor Yellow
        }
        Write-Host "先不要把這次當成 make Codex fast 完成態。"
    }
}

if (-not (Test-Path -LiteralPath $cleanupScript)) {
    throw ("找不到清理腳本：" + $cleanupScript)
}

Write-Host "Codex Cleanup Runner" -ForegroundColor Green
Write-Host ("模式：" + $Mode)
Write-Host ("Archive storage root：" + $ArchiveStorageRoot)

if ($ArchiveStorageRoot) {
    $archiveDrive = [System.IO.Path]::GetPathRoot([System.IO.Path]::GetFullPath($ArchiveStorageRoot))
    if (-not $archiveDrive -or -not (Test-Path -LiteralPath $archiveDrive)) {
        throw ("Archive storage drive 不存在：" + $ArchiveStorageRoot)
    }
    New-Item -ItemType Directory -Force -Path $ArchiveStorageRoot | Out-Null
}

Close-CodexApp

if ($Mode -eq "Apply") {
    Write-Step "步驟 2/5：Migrate existing archives to storage"
    Run-Cleanup -Arguments @("-MigrateExistingArchivesToStorage")

    Write-Step "步驟 3/5：Apply 歸檔與備份"
    Run-Cleanup -Arguments @("-Apply")

    Write-Step "步驟 4/5：Repair State DB"
    Run-Cleanup -Arguments @("-RepairStateDbFromAllApplyManifests")

    Write-Step "步驟 5/5：Verify dry-run"
    Run-Cleanup -Arguments @()
    Show-FinalSummary
} else {
    Write-Step "步驟 2/3：Repair State DB"
    Run-Cleanup -Arguments @("-RepairStateDbFromAllApplyManifests")

    Write-Step "步驟 3/3：Verify dry-run"
    Run-Cleanup -Arguments @()
    Show-FinalSummary
}

Write-Host ""
Write-Host "流程已結束；依 Final summary 的 PASS/FAIL 判斷是否真正完成。" -ForegroundColor Green
Write-Host "此視窗會保留，方便你檢查上面的 Report / Manifest / Backup 路徑。"
