param(
  [string]$ExpectedEnv = "staging",
  [switch]$AllowProductionWrite
)

$ErrorActionPreference = "Stop"

function Fail($Message) {
  Write-Error $Message
  exit 1
}

function RequireEnv($Name) {
  $value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($value)) {
    Fail "Missing required environment variable: $Name"
  }
  return $value
}

$appEnv = RequireEnv "APP_ENV"
$databaseUrl = RequireEnv "DATABASE_URL"
$expectedHost = RequireEnv "DATABASE_EXPECTED_HOST"
$expectedName = RequireEnv "DATABASE_EXPECTED_NAME"

if ($appEnv -ne $ExpectedEnv) {
  Fail "Environment mismatch. Expected '$ExpectedEnv', got '$appEnv'. Refusing to continue."
}

if ($databaseUrl -notlike "*$expectedHost*") {
  Fail "DATABASE_URL does not contain expected host '$expectedHost'. Refusing to continue."
}

if ($databaseUrl -notlike "*$expectedName*") {
  Fail "DATABASE_URL does not contain expected database/project name '$expectedName'. Refusing to continue."
}

if ($appEnv -eq "production") {
  $allow = [Environment]::GetEnvironmentVariable("ALLOW_PRODUCTION_WRITE")
  if (-not $AllowProductionWrite -or $allow -ne "true") {
    Fail "Production write is locked. Set ALLOW_PRODUCTION_WRITE=true and pass -AllowProductionWrite only after human approval."
  }
}

Write-Host "Safety check passed for APP_ENV=$appEnv, host=$expectedHost, database=$expectedName."
