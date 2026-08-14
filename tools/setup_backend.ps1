# One-command backend setup for Trade Master
# Usage: .\tools\setup_backend.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$DefinesFile = Join-Path $ProjectRoot "dart_defines.json"
$ExampleFile = Join-Path $ProjectRoot "dart_defines.example.json"

Write-Host "=== Trade Master — Backend Setup ===" -ForegroundColor Cyan

# 1. dart_defines.json
if (-not (Test-Path $DefinesFile)) {
    Copy-Item $ExampleFile $DefinesFile
    Write-Host "[1/5] Created dart_defines.json from example" -ForegroundColor Yellow
    Write-Host "      Edit dart_defines.json and paste your Supabase URL + anon key." -ForegroundColor Yellow
} else {
    Write-Host "[1/5] dart_defines.json already exists" -ForegroundColor Green
}

$defines = Get-Content $DefinesFile -Raw | ConvertFrom-Json
$hasKeys = ($defines.SUPABASE_URL -notmatch "YOUR_PROJECT") -and ($defines.SUPABASE_ANON_KEY -notmatch "YOUR_ANON")

if (-not $hasKeys) {
    Write-Host ""
    Write-Host "Supabase keys not configured yet." -ForegroundColor Yellow
    Write-Host "Steps:"
    Write-Host "  1. Go to https://supabase.com/dashboard → New project"
    Write-Host "  2. SQL Editor → paste supabase/migrations/001_initial_schema.sql → Run"
    Write-Host "  3. Authentication → Providers → Email → enable Email OTP"
    Write-Host "  4. Project Settings → API → copy URL and anon key into dart_defines.json"
    Write-Host ""
    $open = Read-Host "Open dart_defines.json in notepad now? (y/n)"
    if ($open -eq "y") { notepad $DefinesFile }
    Write-Host "Re-run this script after saving keys." -ForegroundColor Yellow
    exit 0
}

Write-Host "[2/5] Supabase keys found in dart_defines.json" -ForegroundColor Green

# 2. Supabase CLI via npx
Push-Location $ProjectRoot
Write-Host "[3/5] Checking Supabase CLI..."
$npxOk = $false
try {
    $v = npx --yes supabase --version 2>&1
    if ($LASTEXITCODE -eq 0) { $npxOk = $true; Write-Host "      Supabase CLI: $v" -ForegroundColor Green }
} catch {}

if (-not $npxOk) {
    Write-Host "      Could not run npx supabase. Install Node.js or run SQL manually." -ForegroundColor Yellow
} else {
    # 3. Link project if not linked
    $linked = Test-Path (Join-Path $ProjectRoot "supabase\.temp\project-ref")
    if (-not $linked) {
        Write-Host "[4/5] Link Supabase project"
        Write-Host "      Run: npx supabase login"
        Write-Host "      Then: npx supabase link --project-ref YOUR_PROJECT_REF"
        Write-Host "      (Project ref is in dashboard URL: supabase.com/dashboard/project/REF)"
        $ref = Read-Host "Paste project ref now (or Enter to skip)"
        if ($ref) {
            npx supabase link --project-ref $ref
        }
    } else {
        Write-Host "[4/5] Supabase project linked" -ForegroundColor Green
    }

    $push = Read-Host "Push DB schema + deploy edge functions? (y/n)"
    if ($push -eq "y") {
        Write-Host "      Pushing schema..."
        npx supabase db push
        Write-Host "      Deploying functions..."
        npx supabase functions deploy verify-purchase
        npx supabase functions deploy stripe-checkout
        npx supabase functions deploy stripe-webhook
        Write-Host "      Done." -ForegroundColor Green
    }
}

Pop-Location

# 4. GitHub secrets reminder
Write-Host "[5/5] GitHub Actions secrets (trading_education_app repo):"
Write-Host "      SUPABASE_URL = $($defines.SUPABASE_URL)"
Write-Host "      SUPABASE_ANON_KEY = (same as in dart_defines.json)"
Write-Host "      PAGES_DEPLOY_TOKEN = GitHub PAT with repo scope"
Write-Host ""
Write-Host "Run app:  flutter run -d chrome --dart-define-from-file=dart_defines.json"
Write-Host "Deploy:   .\tools\deploy_pages.ps1"
Write-Host "=== Setup complete ===" -ForegroundColor Cyan
