$ErrorActionPreference = 'Stop'
$guard = Join-Path $PSScriptRoot 'confirm-destructive-action.ps1'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('db-authorization-test-' + [guid]::NewGuid())
$null = New-Item -ItemType Directory -Path $testRoot
$recordPath = Join-Path $testRoot 'authorization.json'
$auditPath = Join-Path $testRoot 'audit.jsonl'
$oldConfirmation = $env:CONFIRM_DESTRUCTIVE_ACTION
$passed = 0

function Check-Case($Name, $Record, $Arguments, $Allowed) {
  if ($null -ne $Record) {
    $Record | ConvertTo-Json | Set-Content -LiteralPath $recordPath -Encoding utf8
    $Arguments.AuthorizationPath = $recordPath
  }
  $Arguments.AuditLog = $auditPath
  $before = if (Test-Path -LiteralPath $auditPath) { @(Get-Content -LiteralPath $auditPath).Count } else { 0 }
  $succeeded = $true
  try { & $guard @Arguments | Out-Null } catch { $succeeded = $false }
  if ($succeeded -ne $Allowed) { throw "Unexpected outcome: $Name" }
  $after = if (Test-Path -LiteralPath $auditPath) { @(Get-Content -LiteralPath $auditPath).Count } else { 0 }
  if (($after - $before) -ne [int]$Allowed) { throw "Incorrect audit count: $Name" }
  $script:passed++
}

try {
  $env:CONFIRM_DESTRUCTIVE_ACTION = $null
  $baseRecord = @{ source = 'fixture:authorized-turn'; action = 'delete'; environment = 'staging'; resource = 'bookings'; maxRows = 42 }
  $baseArgs = @{ Action = 'delete'; Environment = 'staging'; Resource = 'bookings'; ExpectedCount = 42 }
  Check-Case 'existing authorization above ten' $baseRecord.Clone() $baseArgs.Clone() $true
  Check-Case 'missing authorization' $null $baseArgs.Clone() $false
  $changed = $baseArgs.Clone(); $changed.ExpectedCount = 43
  Check-Case 'over authorized count' $baseRecord.Clone() $changed $false
  $changed = $baseArgs.Clone(); $changed.MaxRows = 10
  Check-Case 'explicit narrower cap' $baseRecord.Clone() $changed $false
  foreach ($field in @('action', 'environment', 'resource')) {
    $record = $baseRecord.Clone(); $record[$field] = 'other'
    Check-Case "mismatched $field" $record $baseArgs.Clone() $false
  }
  $record = $baseRecord.Clone(); $record.source = ''
  Check-Case 'missing source' $record $baseArgs.Clone() $false
  foreach ($limit in @(-1, 42.5, '42')) {
    $record = $baseRecord.Clone(); $record.maxRows = $limit
    Check-Case "invalid limit $limit" $record $baseArgs.Clone() $false
  }
  $changed = $baseArgs.Clone(); $changed.ExpectedCount = -1
  Check-Case 'negative preview count' $baseRecord.Clone() $changed $false
  $record = $baseRecord.Clone(); $record.environment = 'production'
  $changed = $baseArgs.Clone(); $changed.Environment = 'production'
  Check-Case 'production missing backup' $record $changed.Clone() $false
  $record.backupEvidence = 'fixture:verified-backup'
  Check-Case 'authorized production with backup' $record $changed.Clone() $true
  $env:CONFIRM_DESTRUCTIVE_ACTION = 'DELETE staging bookings 42'
  $record = $baseRecord.Clone(); $record.resource = 'other'
  Check-Case 'invalid record cannot fall back' $record $baseArgs.Clone() $false
  Check-Case 'legacy default cap retained' $null $baseArgs.Clone() $false
  $changed = $baseArgs.Clone(); $changed.MaxRows = 42
  Check-Case 'legacy caller supported' $null $changed $true
  $firstAudit = Get-Content -LiteralPath $auditPath -TotalCount 1 | ConvertFrom-Json
  if ($firstAudit.authorizationSource -ne $baseRecord.source -or $firstAudit.authorizationHash.Length -ne 64) {
    throw 'Authorization provenance missing from audit.'
  }
  Write-Output "$passed authorization cases passed. No database connections made."
} finally {
  $env:CONFIRM_DESTRUCTIVE_ACTION = $oldConfirmation
  # Delete only the exact files created by this test, then its now-empty directory.
  foreach ($ownedFile in @($recordPath, $auditPath)) {
    if (Test-Path -LiteralPath $ownedFile) { Remove-Item -LiteralPath $ownedFile }
  }
  Remove-Item -LiteralPath $testRoot
}
