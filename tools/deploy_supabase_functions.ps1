# Deploy Edge Functions to Supabase (verify-purchase, stripe-checkout, stripe-webhook)
# Get token: https://supabase.com/dashboard/account/tokens
# Usage:
#   $env:SUPABASE_ACCESS_TOKEN="sbp_..."
#   .\tools\deploy_supabase_functions.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ProjectRef = "akwiexmyblpuckvbqjsd"

Push-Location $ProjectRoot

if (-not $env:SUPABASE_ACCESS_TOKEN) {
    Write-Host "SUPABASE_ACCESS_TOKEN not set." -ForegroundColor Yellow
    Write-Host "1. Open https://supabase.com/dashboard/account/tokens"
    Write-Host "2. Generate new token"
    $env:SUPABASE_ACCESS_TOKEN = Read-Host "Paste token here"
}

if (-not $env:SUPABASE_ACCESS_TOKEN) {
    Write-Error "Token required"
}

Write-Host ">> Deploying Edge Functions to $ProjectRef..." -ForegroundColor Cyan

$functions = @("verify-purchase", "delete-account", "stripe-checkout", "stripe-webhook")
foreach ($fn in $functions) {
    Write-Host "   Deploying $fn..."
    npx supabase functions deploy $fn --project-ref $ProjectRef
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to deploy $fn"
    }
}

Write-Host ">> All functions deployed." -ForegroundColor Green
Pop-Location
