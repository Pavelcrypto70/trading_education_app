# Full deploy: Supabase functions + GitHub secrets + web
# Usage: .\tools\deploy_all.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $ProjectRoot

Write-Host "=== Trade Master — Full Deploy ===" -ForegroundColor Cyan

# 1. Supabase functions
if ($env:SUPABASE_ACCESS_TOKEN) {
    & "$PSScriptRoot\deploy_supabase_functions.ps1"
} else {
    Write-Host "[1/3] Skip Edge Functions — set SUPABASE_ACCESS_TOKEN first" -ForegroundColor Yellow
    Write-Host "      Or add secret in GitHub and run workflow 'Deploy Supabase Edge Functions'"
}

# 2. GitHub secrets
if (Get-Command gh -ErrorAction SilentlyContinue) {
    & "$PSScriptRoot\set_github_secrets.ps1"
} else {
    Write-Host "[2/3] GitHub CLI not installed — set secrets manually:" -ForegroundColor Yellow
    Write-Host "      See tools/GITHUB_SECRETS_VALUES.md"
}

# 3. Web deploy
$deploy = Read-Host "[3/3] Deploy web to pavelcrypto70.github.io now? (y/n)"
if ($deploy -eq "y") {
    & "$PSScriptRoot\deploy_pages.ps1"
}

Pop-Location
Write-Host "=== Done ===" -ForegroundColor Cyan
