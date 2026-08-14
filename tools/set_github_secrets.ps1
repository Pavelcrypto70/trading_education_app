# Sets GitHub Actions secrets for Trade Master
# Prerequisites: gh auth login (run once)
# Usage: .\tools\set_github_secrets.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$DefinesFile = Join-Path $ProjectRoot "dart_defines.json"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI not found. Install: winget install GitHub.cli" -ForegroundColor Red
    Write-Host "Or set secrets manually: https://github.com/Pavelcrypto70/trading_education_app/settings/secrets/actions"
    exit 1
}

$auth = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Run first: gh auth login" -ForegroundColor Yellow
    gh auth login
}

if (-not (Test-Path $DefinesFile)) {
    Write-Error "dart_defines.json not found"
}

$defines = Get-Content $DefinesFile -Raw | ConvertFrom-Json

Write-Host "Setting secrets on Pavelcrypto70/trading_education_app..." -ForegroundColor Cyan

$defines.SUPABASE_URL | gh secret set SUPABASE_URL --repo Pavelcrypto70/trading_education_app
$defines.SUPABASE_ANON_KEY | gh secret set SUPABASE_ANON_KEY --repo Pavelcrypto70/trading_education_app
"akwiexmyblpuckvbqjsd" | gh secret set SUPABASE_PROJECT_REF --repo Pavelcrypto70/trading_education_app

if ($env:SUPABASE_ACCESS_TOKEN) {
    $env:SUPABASE_ACCESS_TOKEN | gh secret set SUPABASE_ACCESS_TOKEN --repo Pavelcrypto70/trading_education_app
    Write-Host "SUPABASE_ACCESS_TOKEN set from environment" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "SUPABASE_ACCESS_TOKEN not set in this shell." -ForegroundColor Yellow
    Write-Host "Get token: https://supabase.com/dashboard/account/tokens" -ForegroundColor Yellow
    $token = Read-Host "Paste Supabase access token (or Enter to skip)"
    if ($token) {
        $token | gh secret set SUPABASE_ACCESS_TOKEN --repo Pavelcrypto70/trading_education_app
    }
}

if ($env:PAGES_DEPLOY_TOKEN) {
    $env:PAGES_DEPLOY_TOKEN | gh secret set PAGES_DEPLOY_TOKEN --repo Pavelcrypto70/trading_education_app
    Write-Host "PAGES_DEPLOY_TOKEN set from environment" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "PAGES_DEPLOY_TOKEN — GitHub PAT with 'repo' scope" -ForegroundColor Yellow
    Write-Host "Create: https://github.com/settings/tokens/new?scopes=repo" -ForegroundColor Yellow
    $pat = Read-Host "Paste GitHub PAT for deploy (or Enter to skip)"
    if ($pat) {
        $pat | gh secret set PAGES_DEPLOY_TOKEN --repo Pavelcrypto70/trading_education_app
    }
}

Write-Host ""
Write-Host "Done. Verify: gh secret list --repo Pavelcrypto70/trading_education_app" -ForegroundColor Green
