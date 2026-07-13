# Деплой web-сборки на https://pavelcrypto70.github.io
# Использование: .\tools\deploy_pages.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$BuildDir = Join-Path $ProjectRoot "build\web"
$DeployDir = Join-Path $ProjectRoot ".deploy\github-io\repo"

Write-Host ">> flutter build web --release"
Push-Location $ProjectRoot
flutter build web --release
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
