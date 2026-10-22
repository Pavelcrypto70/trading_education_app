# Smoke-check that store-critical source gates still look correct.
# Does not replace a device QA pass on playRelease AAB.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$fail = @()

function Assert-FileContains([string]$path, [string]$needle, [string]$why) {
  $text = Get-Content -Raw -LiteralPath $path
  if ($text -notlike "*$needle*") { $script:fail += "MISSING in ${path}: $needle ($why)" }
}

function Assert-FileNotContains([string]$path, [string]$needle, [string]$why) {
  # Only for files that must stay free of broker CTAs in always-on store paths.
  $text = Get-Content -Raw -LiteralPath $path
  if ($text -like "*$needle*") { $script:fail += "LEAK in ${path}: $needle ($why)" }
}

Assert-FileContains "lib\config\desk_key_config.dart" "static bool get enabled => kIsWeb" "Desk key web-only"
Assert-FileContains "lib\config\desk_key_config.dart" "ownerUnlockEnabled => kIsWeb" "Owner unlock web-only"
Assert-FileContains "lib\services\desk_key_service.dart" "if (!DeskKeyConfig.enabled) return false" "isActive gated"
Assert-FileContains "lib\config\partner_links.dart" "if (!kIsWeb) return const []" "Partners web-only"
Assert-FileContains "lib\config\app_config.dart" "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14" "Trial 1-14"

Assert-FileNotContains "lib\screens\stage_soon_screen.dart" "Tiger.com" "Stage 5 store-safe"
Assert-FileNotContains "store\PLAY_STORE_LISTING.md" "Tiger.com" "Listing without broker"
Assert-FileNotContains "store\PLAY_STORE_LISTING.md" "5 уроков бесплатно" "Listing must say 14 free"

if ($fail.Count -gt 0) {
  Write-Host "STORE SAFE CHECK FAILED:" -ForegroundColor Red
  $fail | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "STORE SAFE CHECK OK ($(($fail).Count) issues)" -ForegroundColor Green
exit 0
