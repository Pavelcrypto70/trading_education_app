# Creates android/keystore/upload-keystore.jks + android/key.properties (gitignored).
# Run once on a secure machine. Back up the .jks and passwords offline.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$kt = @(
    "$env:JAVA_HOME\bin\keytool.exe",
    "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
    "C:\Program Files\Java\jdk-17\bin\keytool.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $kt) {
    Write-Error "keytool not found. Install Android Studio or set JAVA_HOME."
}

$outDir = Join-Path $root "android\keystore"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$jks = Join-Path $outDir "upload-keystore.jks"
$props = Join-Path $root "android\key.properties"

if (Test-Path $jks) {
    Write-Error "Already exists: $jks — refuse to overwrite. Delete manually if you intend to rotate."
}

$pass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 28 | ForEach-Object { [char]$_ })

& $kt -genkeypair -v `
    -keystore $jks `
    -alias upload `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000 `
    -storepass $pass `
    -keypass $pass `
    -dname "CN=Trade Master, OU=Mobile, O=TradeMaster Education, L=Moscow, ST=Moscow, C=RU"

@"
storePassword=$pass
keyPassword=$pass
keyAlias=upload
storeFile=keystore/upload-keystore.jks
"@ | Set-Content -Encoding ASCII -Path $props

Write-Host ""
Write-Host "Created:"
Write-Host "  $jks"
Write-Host "  $props"
Write-Host ""
Write-Host "BACK UP the .jks file and passwords offline (password manager)."
Write-Host "Losing them blocks Play App Signing uploads forever for this upload key."
Write-Host ""
Write-Host "Play AAB:"
Write-Host "  flutter build appbundle --flavor play --release --dart-define-from-file=dart_defines.json"
