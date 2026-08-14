# Деплой web-сборки на https://pavelcrypto70.github.io
# Использование:
#   1) Заполните dart_defines.json (или задайте env SUPABASE_URL / SUPABASE_ANON_KEY)
#   2) .\tools\deploy_pages.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$BuildDir = Join-Path $ProjectRoot "build\web"
$DeployDir = Join-Path $ProjectRoot ".deploy\github-io\repo"
$DefinesFile = Join-Path $ProjectRoot "dart_defines.json"

$dartDefines = @()
if ($env:SUPABASE_URL) {
    $dartDefines += "--dart-define=SUPABASE_URL=$($env:SUPABASE_URL)"
}
if ($env:SUPABASE_ANON_KEY) {
    $dartDefines += "--dart-define=SUPABASE_ANON_KEY=$($env:SUPABASE_ANON_KEY)"
}
if ($dartDefines.Count -eq 0 -and (Test-Path $DefinesFile)) {
    $dartDefines += "--dart-define-from-file=$DefinesFile"
    Write-Host ">> Using keys from dart_defines.json"
} elseif ($dartDefines.Count -eq 0) {
    Write-Host ">> Warning: no Supabase keys - building offline demo mode" -ForegroundColor Yellow
}

Write-Host ">> flutter build web --release (local CanvasKit, no Google CDN)"
Push-Location $ProjectRoot
$buildArgs = @(
    "build", "web", "--release",
    "--tree-shake-icons",
    "--no-web-resources-cdn"
) + $dartDefines
flutter @buildArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Pop-Location

if (-not (Test-Path $BuildDir)) {
    Write-Error "Build folder not found: $BuildDir"
}

if (Test-Path (Split-Path $DeployDir -Parent)) {
    Remove-Item -Recurse -Force (Split-Path $DeployDir -Parent)
}

Write-Host ">> Clone Pavelcrypto70.github.io"
New-Item -ItemType Directory -Path (Split-Path $DeployDir -Parent) -Force | Out-Null
git clone --depth 1 https://github.com/Pavelcrypto70/Pavelcrypto70.github.io.git $DeployDir

Get-ChildItem -Path $DeployDir -Force | Where-Object { $_.Name -ne ".git" } | Remove-Item -Recurse -Force
Copy-Item -Path (Join-Path $BuildDir "*") -Destination $DeployDir -Recurse -Force

Push-Location $DeployDir
git add -A
$status = git status --porcelain
if (-not $status) {
    Write-Host "Nothing to deploy."
    Pop-Location
    exit 0
}

git commit -m "Deploy Trade Master web build $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$remoteMain = git ls-remote origin refs/heads/main | ForEach-Object { ($_ -split '\s+')[0] }
git push origin main
if ($LASTEXITCODE -ne 0) {
    git push --force-with-lease=main:$remoteMain origin main
}
Pop-Location

Write-Host ">> Done: https://pavelcrypto70.github.io"
