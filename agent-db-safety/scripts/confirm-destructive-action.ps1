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

  [string]$AuditLog = ".\logs\destructive-actions.jsonl"
)

$ErrorActionPreference = "Stop"

function Fail($Message) {
  Write-Error $Message
  exit 1
}

if ($ExpectedCount -lt 0) {
  Fail "ExpectedCount cannot be negative."
}

if ($ExpectedCount -gt $MaxRows) {
  Fail "ExpectedCount=$ExpectedCount exceeds MaxRows=$MaxRows. Human review required before raising the limit."
}

$confirm = [Environment]::GetEnvironmentVariable("CONFIRM_DESTRUCTIVE_ACTION")
$expected = "$($Action.ToUpperInvariant()) $Environment $Resource $ExpectedCount"

if ($Environment -eq "production") {
  $expected = "$expected I_HAVE_BACKUP"
}

if ($confirm -ne $expected) {
  Fail "Confirmation mismatch. Expected CONFIRM_DESTRUCTIVE_ACTION='$expected'."
}

$audit = [ordered]@{
  timestamp = (Get-Date).ToUniversalTime().ToString("o")
  action = $Action
  environment = $Environment
  resource = $Resource
  expectedCount = $ExpectedCount
  maxRows = $MaxRows
  confirmed = $true
}

$parent = Split-Path -Parent $AuditLog
if ($parent -and -not (Test-Path $parent)) {
  New-Item -ItemType Directory -Path $parent | Out-Null
}

($audit | ConvertTo-Json -Compress) | Add-Content $AuditLog
Write-Host "Destructive action confirmed and audit logged."
