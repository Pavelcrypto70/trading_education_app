# Galaxy Store free build (no billing UI / no BILLING permission).
# Payment source stays in repo for --flavor play.
#
# NOTE: Windows + Cyrillic home path breaks Flutter AOT. We build via ASCII copy at C:\dev\tea_galaxy.

$ErrorActionPreference = "Stop"
$src = Split-Path $PSScriptRoot -Parent
$dest = "C:\dev\tea_galaxy"
$outDir = Join-Path $src "build\galaxy_store"

Write-Host "==> Syncing project to ASCII path: $dest" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $dest | Out-Null
robocopy $src $dest /MIR /XD .dart_tool build node_modules .git android\.gradle android\app\build /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
# robocopy exit 0-7 = success
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with code $LASTEXITCODE" }

Set-Location $dest
Write-Host "==> Building Galaxy Store release (ENABLE_BILLING=false)" -ForegroundColor Cyan

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build appbundle --flavor galaxy --release `
  --dart-define=ENABLE_BILLING=false `
  --dart-define=STORE_CHANNEL=galaxy
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build apk --flavor galaxy --release `
  --dart-define=ENABLE_BILLING=false `
  --dart-define=STORE_CHANNEL=galaxy
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
Copy-Item "build\app\outputs\bundle\galaxyRelease\*.aab" $outDir -Force
Copy-Item "build\app\outputs\flutter-apk\app-galaxy-release.apk" $outDir -Force

Write-Host ""
Write-Host "AAB+APK copied to: $outDir" -ForegroundColor Green
Get-ChildItem $outDir | Format-Table Name, Length
Write-Host "Checklist: store\GALAXY_STORE_CHECKLIST.md" -ForegroundColor Green
Write-Host "Telegram seeds: store\TELEGRAM_SEED_POSTS.md" -ForegroundColor Green
