# Build de Android a 1080p (APK ligero para testers): reescala las texturas a
# 1080p temporalmente, exporta el APK y REVIERTE a 4K. Así el APK pesa/consume
# poco en móvil mientras Windows y el editor conservan el 4K nativo.
# Uso:  pwsh tools/build_android.ps1
param([string]$Out = "build/sOC.apk")
$ErrorActionPreference = "Stop"
$root  = Split-Path -Parent $PSScriptRoot
$godot = Join-Path $env:TEMP "godot47\Godot_v4.7-stable_win64_console.exe"
if (-not (Test-Path $godot)) { throw "No está Godot 4.7 en $godot" }

function Invoke-Reimport { & $godot --headless --editor --path $root --quit-after 900 | Out-Null }

try {
    Write-Host "1/4  Reescalando texturas a 1080p (size_limit=1920)..."
    & python (Join-Path $root "tools/set_texture_size_limit.py") 1920
    Write-Host "2/4  Reimportando a 1080p..."
    Invoke-Reimport
    Write-Host "3/4  Exportando APK Android (debug)..."
    & pwsh -NoProfile -File (Join-Path $root "tools/build.ps1") -Preset "Android" -Out $Out -Debug
}
finally {
    Write-Host "4/4  Revirtiendo a 4K (size_limit=0) + reimport..."
    & python (Join-Path $root "tools/set_texture_size_limit.py") 0
    Invoke-Reimport
    Write-Host "Proyecto restaurado a 4K. Build en: $Out"
}
