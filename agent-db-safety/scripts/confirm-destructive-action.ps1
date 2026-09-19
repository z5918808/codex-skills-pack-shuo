param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("delete", "truncate", "drop", "destroy", "reset", "purge", "update")]
  [string]$Action,

  [Parameter(Mandatory = $true)]
  [string]$Environment,

  [Parameter(Mandatory = $true)]
  [string]$Resource,

  [Parameter(Mandatory = $true)]
  [int]$ExpectedCount,

  [int]$MaxRows = 10,

  [string]$AuthorizationPath,

  [string]$AuditLog = ".\logs\destructive-actions.jsonl"
)

$ErrorActionPreference = "Stop"

function Fail($Message) {
  throw $Message
}

if ($ExpectedCount -lt 0) {
  Fail "ExpectedCount cannot be negative."
}

$authorizationSource = "legacy-confirmation"
$authorizationHash = $null
$effectiveLimit = $MaxRows
if ($AuthorizationPath) {
  $recordText = Get-Content -LiteralPath $AuthorizationPath -Raw -Encoding UTF8
  $record = $recordText | ConvertFrom-Json -AsHashtable
  if ($record -isnot [System.Collections.IDictionary]) {
    Fail "Authorization must be a JSON object."
  }
  foreach ($field in @("source", "action", "environment", "resource")) {
    if ($record[$field] -isnot [string] -or [string]::IsNullOrWhiteSpace($record[$field])) {
      Fail "Authorization requires a nonempty $field."
    }
  }
  if ($record.action -cne $Action -or $record.environment -cne $Environment -or $record.resource -cne $Resource) {
    Fail "Authorization action, environment, or resource mismatch."
  }
  if (($record.maxRows -isnot [int] -and $record.maxRows -isnot [long]) -or $record.maxRows -lt 0) {
    Fail "Authorization maxRows must be a nonnegative integer."
  }
  $effectiveLimit = $record.maxRows
  if ($PSBoundParameters.ContainsKey("MaxRows")) {
    $effectiveLimit = [Math]::Min($effectiveLimit, $MaxRows)
  }
  if ($Environment -ieq "production" -and
      ($record.backupEvidence -isnot [string] -or [string]::IsNullOrWhiteSpace($record.backupEvidence))) {
    Fail "Production authorization requires backupEvidence."
  }
  $authorizationSource = $record.source
  $authorizationHash = (Get-FileHash -LiteralPath $AuthorizationPath -Algorithm SHA256).Hash
} else {
  $confirm = [Environment]::GetEnvironmentVariable("CONFIRM_DESTRUCTIVE_ACTION")
  $expected = "$($Action.ToUpperInvariant()) $Environment $Resource $ExpectedCount"
  if ($Environment -ieq "production") {
    $expected = "$expected I_HAVE_BACKUP"
  }
  if ($confirm -cne $expected) {
    Fail "Missing or mismatched legacy confirmation. Supply current scoped authorization via -AuthorizationPath."
  }
}
if ($effectiveLimit -lt 0 -or $ExpectedCount -gt $effectiveLimit) {
  Fail "ExpectedCount=$ExpectedCount exceeds the applicable authorized limit=$effectiveLimit."
}

$audit = [ordered]@{
  timestamp = (Get-Date).ToUniversalTime().ToString("o")
  action = $Action
  environment = $Environment
  resource = $Resource
  expectedCount = $ExpectedCount
  maxRows = $effectiveLimit
  authorizationSource = $authorizationSource
  authorizationHash = $authorizationHash
  confirmed = $true
}

$parent = Split-Path -Parent $AuditLog
if ($parent -and -not (Test-Path $parent)) {
  New-Item -ItemType Directory -Path $parent | Out-Null
}

($audit | ConvertTo-Json -Compress) | Add-Content -LiteralPath $AuditLog -Encoding utf8
Write-Host "Authorization fields validated and audit logged; no database operation executed."
