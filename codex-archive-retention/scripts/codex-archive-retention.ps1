param(
    [string]$ArchiveRoot = "E:\CodexArchive\archived_sessions",
    [string]$ReportRoot = "E:\CodexArchive\reports",
    [int]$LargestLimit = 30,
    [int]$LowValueLimit = 80,
    [int]$SampleLines = 80,
    [int]$DeepScanLimit = 20,
    [int]$DeepTailKB = 256,
    [switch]$DeepScan
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function New-Directory {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function ConvertTo-MB {
    param([double]$Bytes)
    [math]::Round(($Bytes / 1MB), 2)
}

function Get-ThreadIdFromPath {
    param([string]$Path)
    $match = [regex]::Match($Path, "([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})")
    if ($match.Success) { return $match.Groups[1].Value }
    return $null
}

function Get-ArchiveMonth {
    param([System.IO.FileInfo]$File)
    $match = [regex]::Match($File.FullName, "\\sessions\\(?<year>20\d{2})\\(?<month>\d{2})\\")
    if ($match.Success) { return "$($match.Groups['year'].Value)-$($match.Groups['month'].Value)" }
    $match = [regex]::Match($File.FullName, "\\archived_sessions\\.*?\\(?<year>20\d{2})\\(?<month>\d{2})\\")
    if ($match.Success) { return "$($match.Groups['year'].Value)-$($match.Groups['month'].Value)" }
    return $File.LastWriteTime.ToString("yyyy-MM")
}

function Read-JsonlSampleText {
    param(
        [string]$Path,
        [int]$Limit,
        [int]$TailKB,
        [bool]$IncludeTail = $false
    )
    $lines = @()
    try {
        Get-Content -LiteralPath $Path -TotalCount $Limit -ErrorAction Stop | ForEach-Object {
            $lines += $_
        }
        if ($IncludeTail) {
            $file = Get-Item -LiteralPath $Path -ErrorAction Stop
            $readBytes = [Math]::Min([int64]($TailKB * 1024), [int64]$file.Length)
            if ($readBytes -gt 0) {
                $buffer = New-Object byte[] $readBytes
                $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
                try {
                    [void]$stream.Seek(-1 * $readBytes, [System.IO.SeekOrigin]::End)
                    [void]$stream.Read($buffer, 0, $readBytes)
                } finally {
                    $stream.Dispose()
                }
                $lines += [System.Text.Encoding]::UTF8.GetString($buffer)
            }
        }
    } catch {
        return ""
    }
    return ($lines -join "`n")
}

function Get-ArchiveClassification {
    param(
        [System.IO.FileInfo]$File,
        [string]$SampleText
    )
    $signals = @()
    $score = 0

    $lowValuePatterns = @(
        "請只回 OK",
        "只回 OK",
        "Codex wrapper 正常",
        "Codex inspect 仍可用",
        "test",
        "smoke",
        "hello",
        "status 指令",
        "子代理",
        "subagent",
        "only reply OK",
        "reply OK",
        "只做診斷",
        "請只回答",
        "不要表演",
        "diagnose only",
        "不要修改檔案"
    )
    foreach ($pattern in $lowValuePatterns) {
        if ($SampleText -match [regex]::Escape($pattern) -or $File.Name -match [regex]::Escape($pattern)) {
            $score += 2
            $signals += $pattern
        }
    }

    if ($File.Length -lt 256KB) {
        $score += 1
        $signals += "small-file"
    }

    $keepPatterns = @(
        "production",
        "prod",
        "database",
        "backup",
        "restore",
        "order",
        "payment",
        "token",
        "API key",
        "Shopify",
        "migration",
        "handoff",
        "incident",
        "事故",
        "資料庫",
        "訂單",
        "金錢",
        "客戶"
    )
    foreach ($pattern in $keepPatterns) {
        if ($SampleText -match [regex]::Escape($pattern)) {
            $score -= 3
            $signals += "keep-signal:$pattern"
        }
    }

    if ($score -ge 4) {
        return [pscustomobject]@{ class = "likely-low-value"; score = $score; signals = ($signals -join ", ") }
    }
    if ($score -le -3) {
        return [pscustomobject]@{ class = "keep-review"; score = $score; signals = ($signals -join ", ") }
    }
    return [pscustomobject]@{ class = "review"; score = $score; signals = ($signals -join ", ") }
}

if (-not (Test-Path -LiteralPath $ArchiveRoot)) {
    throw "ArchiveRoot not found: $ArchiveRoot"
}

New-Directory $ReportRoot
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$jsonPath = Join-Path $ReportRoot ("codex-archive-retention-" + $timestamp + ".json")
$mdPath = Join-Path $ReportRoot ("codex-archive-retention-" + $timestamp + ".md")

$allFiles = @(Get-ChildItem -LiteralPath $ArchiveRoot -Recurse -Force -File -ErrorAction SilentlyContinue)
$allBytes = 0
if ($allFiles.Count -gt 0) {
    $allBytes = ($allFiles | Measure-Object -Property Length -Sum).Sum
}
$files = @($allFiles | Where-Object {
    $_.Name -like "rollout-*.jsonl" -and $_.FullName -notmatch "\\manifests\\"
})
$deepScanPaths = @{}
if ($DeepScan.IsPresent) {
    $deepFiles = @($files | Sort-Object Length -Descending | Select-Object -First $DeepScanLimit)
    foreach ($file in $deepFiles) {
        $deepScanPaths[$file.FullName] = $true
    }
}

$items = @()
foreach ($file in $files) {
    $includeTail = $DeepScan.IsPresent -and $deepScanPaths.ContainsKey($file.FullName)
    $sample = Read-JsonlSampleText -Path $file.FullName -Limit $SampleLines -TailKB $DeepTailKB -IncludeTail $includeTail
    $classification = Get-ArchiveClassification -File $file -SampleText $sample
    $items += [pscustomobject]@{
        thread_id = Get-ThreadIdFromPath $file.FullName
        month = Get-ArchiveMonth -File $file
        size_bytes = $file.Length
        size_mb = ConvertTo-MB $file.Length
        last_write_time = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        class = $classification.class
        score = $classification.score
        signals = $classification.signals
        path = $file.FullName
    }
}

$totalBytes = 0
if ($items.Count -gt 0) {
    $totalBytes = ($items | Measure-Object -Property size_bytes -Sum).Sum
}

$byMonth = @(
    $items |
        Group-Object month |
        ForEach-Object {
            $bytes = ($_.Group | Measure-Object -Property size_bytes -Sum).Sum
            [pscustomobject]@{
                month = $_.Name
                files = $_.Count
                mb = ConvertTo-MB $bytes
                likely_low_value_files = @($_.Group | Where-Object { $_.class -eq "likely-low-value" }).Count
                keep_review_files = @($_.Group | Where-Object { $_.class -eq "keep-review" }).Count
            }
        } |
        Sort-Object month
)

$largest = @($items | Sort-Object size_bytes -Descending | Select-Object -First $LargestLimit)
$lowValue = @($items | Where-Object { $_.class -eq "likely-low-value" } | Sort-Object @{Expression="score"; Descending=$true}, @{Expression="size_bytes"; Descending=$true} | Select-Object -First $LowValueLimit)
$keepReview = @($items | Where-Object { $_.class -eq "keep-review" } | Sort-Object size_bytes -Descending | Select-Object -First $LowValueLimit)

$result = [pscustomobject]@{
    mode = "dry-run"
    archive_root = $ArchiveRoot
    report_root = $ReportRoot
    generated_at = (Get-Date).ToString("o")
    deep_scan = $DeepScan.IsPresent
    deep_scan_limit = $DeepScanLimit
    deep_tail_kb = $DeepTailKB
    deep_scanned_files = $deepScanPaths.Count
    sample_lines = $SampleLines
    all_files = $allFiles.Count
    all_total_mb = ConvertTo-MB $allBytes
    session_jsonl_files = $items.Count
    total_mb = ConvertTo-MB $totalBytes
    extensions = @($allFiles | Group-Object Extension | Sort-Object Count -Descending | ForEach-Object {
        $bytes = ($_.Group | Measure-Object -Property Length -Sum).Sum
        [pscustomobject]@{ extension = $_.Name; files = $_.Count; mb = ConvertTo-MB $bytes }
    })
    by_month = $byMonth
    largest = $largest
    likely_low_value = $lowValue
    keep_review = $keepReview
}

$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonPath -Encoding UTF8

$md = @()
$md += "# Codex Archive Retention Report"
$md += ""
$md += "- Mode: dry-run"
$md += "- Archive root: $ArchiveRoot"
$md += "- All files: $($allFiles.Count)"
$md += "- All total: $(ConvertTo-MB $allBytes) MB"
$md += "- Session JSONL files: $($items.Count)"
$md += "- Session JSONL total: $(ConvertTo-MB $totalBytes) MB"
$md += "- Deep scan: $($DeepScan.IsPresent)"
$md += "- Deep scanned files: $($deepScanPaths.Count)"
$md += "- Deep scan limit: $DeepScanLimit"
$md += "- Deep tail KB: $DeepTailKB"
$md += "- Sample lines: $SampleLines"
$md += "- Generated: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))"

$md += ""
$md += "## By Extension"
$md += ""
$md += "| Extension | Files | MB |"
$md += "|---|---:|---:|"
foreach ($row in $result.extensions) {
    $name = if ($row.extension) { $row.extension } else { "(none)" }
    $md += "| $name | $($row.files) | $($row.mb) |"
}
$md += ""
$md += "## By Month"
$md += ""
$md += "| Month | Files | MB | Likely Low Value | Keep Review |"
$md += "|---|---:|---:|---:|---:|"
foreach ($row in $byMonth) {
    $md += "| $($row.month) | $($row.files) | $($row.mb) | $($row.likely_low_value_files) | $($row.keep_review_files) |"
}

$md += ""
$md += "## Largest Files"
$md += ""
$md += "| MB | Month | Class | Signals | Path |"
$md += "|---:|---|---|---|---|"
foreach ($row in $largest) {
    $md += "| $($row.size_mb) | $($row.month) | $($row.class) | $($row.signals) | $($row.path) |"
}

$md += ""
$md += "## Likely Low Value"
$md += ""
$md += "| Score | MB | Month | Signals | Path |"
$md += "|---:|---:|---|---|---|"
foreach ($row in $lowValue) {
    $md += "| $($row.score) | $($row.size_mb) | $($row.month) | $($row.signals) | $($row.path) |"
}

$md += ""
$md += "## Keep Review"
$md += ""
$md += "| Score | MB | Month | Signals | Path |"
$md += "|---:|---:|---|---|---|"
foreach ($row in $keepReview) {
    $md += "| $($row.score) | $($row.size_mb) | $($row.month) | $($row.signals) | $($row.path) |"
}

$md += ""
$md += "## Policy"
$md += ""
$md += "- This report does not delete or move files."
$md += "- Delete only after reviewing `likely-low-value` candidates."
$md += "- Keep production, database, order, payment, token, incident, migration, and handoff related records unless explicitly confirmed."

$md -join "`n" | Set-Content -LiteralPath $mdPath -Encoding UTF8

Write-Host "Mode: dry-run"
Write-Host ("Archive root: " + $ArchiveRoot)
Write-Host ("All files: " + $allFiles.Count)
Write-Host ("All total MB: " + (ConvertTo-MB $allBytes))
Write-Host ("Session JSONL files: " + $items.Count)
Write-Host ("Session JSONL MB: " + (ConvertTo-MB $totalBytes))
Write-Host ("Deep scan: " + $DeepScan.IsPresent)
Write-Host ("Deep scanned files: " + $deepScanPaths.Count)
Write-Host ("Months: " + $byMonth.Count)
Write-Host ("Likely low-value shown: " + $lowValue.Count)
Write-Host ("Keep-review shown: " + $keepReview.Count)
Write-Host ("Markdown report: " + $mdPath)
Write-Host ("JSON report: " + $jsonPath)
