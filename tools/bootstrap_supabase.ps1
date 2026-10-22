# Fully automated Supabase bootstrap for Trade Master.
# Requires: $env:SUPABASE_ACCESS_TOKEN (https://supabase.com/dashboard/account/tokens)
# Optional: $env:SUPABASE_DB_PASSWORD (else generates one)
# Usage:  .\tools\bootstrap_supabase.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

$token = $env:SUPABASE_ACCESS_TOKEN
if (-not $token) {
    Write-Host "Need SUPABASE_ACCESS_TOKEN." -ForegroundColor Yellow
    Write-Host "1) Open https://supabase.com/dashboard/account/tokens"
    Write-Host "2) Generate token → paste below"
    $token = Read-Host "Paste token"
    if (-not $token) { throw "No token" }
    $env:SUPABASE_ACCESS_TOKEN = $token
}

$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

function Invoke-Supa([string]$Method, [string]$Path, $Body = $null) {
    $uri = "https://api.supabase.com/v1$Path"
    $params = @{ Uri = $uri; Method = $Method; Headers = $headers }
    if ($null -ne $Body) {
        $params.Body = ($Body | ConvertTo-Json -Depth 20 -Compress)
    }
    return Invoke-RestMethod @params
}

Write-Host "=== 1/7 Orgs ===" -ForegroundColor Cyan
$orgs = Invoke-Supa GET "/organizations"
if (-not $orgs -or $orgs.Count -eq 0) { throw "No Supabase organizations on this account" }
$orgId = $orgs[0].id
Write-Host "Org: $($orgs[0].name) ($orgId)"

Write-Host "=== 2/7 Find or create project trade-master ===" -ForegroundColor Cyan
$projects = Invoke-Supa GET "/projects"
$existing = @($projects | Where-Object { $_.name -eq "trade-master" -and $_.status -ne "INACTIVE" })
$dbPass = $env:SUPABASE_DB_PASSWORD
if (-not $dbPass) {
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $bytes = New-Object byte[] 24
    $rng.GetBytes($bytes)
    $dbPass = ([Convert]::ToBase64String($bytes) -replace '[+/=]', 'x') + "Aa1!"
}

if ($existing.Count -gt 0) {
    $proj = $existing[0]
    Write-Host "Reuse project $($proj.id) status=$($proj.status)" -ForegroundColor Green
} else {
    Write-Host "Creating project (2–3 min)..."
    $body = @{
        name                   = "trade-master"
        organization_id        = $orgId
        region                 = "ap-southeast-1"
        db_pass                = $dbPass
        plan                   = "free"
    }
    $proj = Invoke-Supa POST "/projects" $body
    Write-Host "Created ref=$($proj.id)"
    $passFile = Join-Path $ProjectRoot "supabase\.db_password.local"
    New-Item -ItemType Directory -Force -Path (Split-Path $passFile) | Out-Null
    Set-Content -LiteralPath $passFile -Value $dbPass -Encoding UTF8
    Write-Host "DB password saved to supabase\.db_password.local (gitignored)" -ForegroundColor Yellow
}

$ref = $proj.id
$deadline = (Get-Date).AddMinutes(8)
do {
    Start-Sleep -Seconds 8
    $proj = (Invoke-Supa GET "/projects") | Where-Object { $_.id -eq $ref } | Select-Object -First 1
    Write-Host "  status=$($proj.status)"
    if ($proj.status -eq "ACTIVE_HEALTHY") { break }
} while ((Get-Date) -lt $deadline)
if ($proj.status -ne "ACTIVE_HEALTHY") {
    throw "Project not healthy in time: $($proj.status)"
}

Write-Host "=== 3/7 Apply SQL migrations 001→004 ===" -ForegroundColor Cyan
$migDir = Join-Path $ProjectRoot "supabase\migrations"
$files = @(
    "001_initial_schema.sql",
    "002_grant_admin_pavel.sql",
    "003_ladder.sql",
    "004_desk_key.sql"
)
foreach ($f in $files) {
    $sql = Get-Content -LiteralPath (Join-Path $migDir $f) -Raw -Encoding UTF8
    Write-Host "  Running $f ..."
    $uri = "https://api.supabase.com/v1/projects/$ref/database/query"
    Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body (@{ query = $sql } | ConvertTo-Json -Compress) | Out-Null
    Write-Host "  OK $f" -ForegroundColor Green
}

Write-Host "=== 4/7 Auth config (Email OTP + Site URL) ===" -ForegroundColor Cyan
# Best-effort: Management API auth config path varies by API version
try {
    $authBody = @{
        site_url = "https://pavelcrypto70.github.io"
        uri_allow_list = "https://pavelcrypto70.github.io,https://pavelcrypto70.github.io/**,http://localhost:8080/**"
        mailer_autoconfirm = $true
        external_email_enabled = $true
    }
    Invoke-Supa PATCH "/projects/$ref/config/auth" $authBody | Out-Null
    Write-Host "  Auth config patched" -ForegroundColor Green
} catch {
    Write-Host "  Auth API patch skipped — set Site URL in dashboard Auth → URL Configuration" -ForegroundColor Yellow
    Write-Host "  $($_.Exception.Message)"
}

Write-Host "=== 5/7 API keys → dart_defines.json ===" -ForegroundColor Cyan
$keys = Invoke-Supa GET "/projects/$ref/api-keys"
$anon = ($keys | Where-Object { $_.name -eq "anon" -or $_.system -eq $true -and $_.name -match "anon" } | Select-Object -First 1)
if (-not $anon) { $anon = $keys | Where-Object { $_.name -eq "anon" } | Select-Object -First 1 }
if (-not $anon) { $anon = $keys | Select-Object -First 1 }
$anonKey = $anon.api_key
if (-not $anonKey) { $anonKey = $anon.key }
$url = "https://$ref.supabase.co"
if ($proj.endpoint) { $url = $proj.endpoint }

$examplePath = Join-Path $ProjectRoot "dart_defines.example.json"
$definesPath = Join-Path $ProjectRoot "dart_defines.json"
$defines = Get-Content $examplePath -Raw | ConvertFrom-Json
if (Test-Path $definesPath) {
    $prev = Get-Content $definesPath -Raw | ConvertFrom-Json
    foreach ($p in $prev.PSObject.Properties) {
        if ($p.Name -notin @("SUPABASE_URL", "SUPABASE_ANON_KEY") -and $p.Value) {
            $defines | Add-Member -NotePropertyName $p.Name -NotePropertyValue $p.Value -Force
        }
    }
}
$defines.SUPABASE_URL = $url
$defines.SUPABASE_ANON_KEY = $anonKey
if (-not $defines.TIGER_REF_LINK) {
    $defines | Add-Member -NotePropertyName TIGER_REF_LINK -NotePropertyValue "https://account.tiger.com/signup?referral=deskclub" -Force
}
if (-not $defines.TIGER_REF_CODE) {
    $defines | Add-Member -NotePropertyName TIGER_REF_CODE -NotePropertyValue "deskclub" -Force
}
$defines | ConvertTo-Json | Set-Content -LiteralPath $definesPath -Encoding UTF8
Write-Host "  URL=$url" -ForegroundColor Green

Write-Host "=== 6/7 Link + Edge Functions ===" -ForegroundColor Cyan
npx --yes supabase link --project-ref $ref --yes 2>&1 | Out-Host
npx --yes supabase functions deploy verify-purchase --project-ref $ref 2>&1 | Out-Host
npx --yes supabase functions deploy delete-account --project-ref $ref 2>&1 | Out-Host

Write-Host "=== 7/7 GitHub Actions secrets ===" -ForegroundColor Cyan
if (Get-Command gh -ErrorAction SilentlyContinue) {
    $url | gh secret set SUPABASE_URL --repo Pavelcrypto70/trading_education_app
    $anonKey | gh secret set SUPABASE_ANON_KEY --repo Pavelcrypto70/trading_education_app
    $ref | gh secret set SUPABASE_PROJECT_REF --repo Pavelcrypto70/trading_education_app
    $token | gh secret set SUPABASE_ACCESS_TOKEN --repo Pavelcrypto70/trading_education_app
    Write-Host "  Secrets set" -ForegroundColor Green
} else {
    Write-Host "  gh not found — set secrets manually" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "DONE. Project ref=$ref" -ForegroundColor Cyan
Write-Host "Next: .\tools\deploy_pages.ps1"
Write-Host "Test: flutter run -d chrome --dart-define-from-file=dart_defines.json"
