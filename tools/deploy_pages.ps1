# Деплой web-сборки на https://pavelcrypto70.github.io
# Использование: .\tools\deploy_pages.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$BuildDir = Join-Path $ProjectRoot "build\web"
$DeployDir = Join-Path $env:TEMP "Pavelcrypto70.github.io-deploy"

Write-Host ">> flutter build web --release"
Push-Location $ProjectRoot
flutter build web --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Pop-Location

if (-not (Test-Path $BuildDir)) {
    Write-Error "Build folder not found: $BuildDir"
}

if (Test-Path $DeployDir) {
    Remove-Item -Recurse -Force $DeployDir
}

Write-Host ">> Clone Pavelcrypto70.github.io"
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
git push origin main
Pop-Location

Write-Host ">> Done: https://pavelcrypto70.github.io"
