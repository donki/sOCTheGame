# Build de sOC the Game — incrementa el patch de la versión y exporta.
# Uso:   pwsh tools/build.ps1              (Windows Desktop -> build/sOC.exe)
#        pwsh tools/build.ps1 -Preset "Android" -Out "build/sOC.apk"
# Cumple ADR-025: cada build sube en uno el último número de versión.
param(
    [string]$Preset = "Windows Desktop",
    [string]$Out = "build/sOC.exe",
    [switch]$Debug
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$proj = Join-Path $root "project.godot"

# --- Bump de versión (major.minor.PATCH -> PATCH+1) ---
$content = Get-Content $proj -Raw
if ($content -match 'config/version="(\d+)\.(\d+)\.(\d+)"') {
    $new = "{0}.{1}.{2}" -f $Matches[1], $Matches[2], ([int]$Matches[3] + 1)
    $content = [regex]::Replace($content, 'config/version="\d+\.\d+\.\d+"', "config/version=`"$new`"")
    Set-Content -Path $proj -Value $content -NoNewline -Encoding UTF8
    Write-Host "Versión -> $new"
} else {
    Write-Warning "No se encontró config/version=\"x.y.z\"; no se incrementa."
    $new = "?"
}

# --- Export ---
$godot = Join-Path $env:TEMP "godot47\Godot_v4.7-stable_win64_console.exe"
if (-not (Test-Path $godot)) { throw "No está el binario de Godot 4.7 en $godot" }
$outAbs = Join-Path $root $Out
New-Item -ItemType Directory -Force (Split-Path $outAbs) | Out-Null
$exportFlag = if ($Debug) { "--export-debug" } else { "--export-release" }
Write-Host "Exportando '$Preset' -> $Out ..."
& $godot --headless --path $root $exportFlag $Preset $outAbs
if ($LASTEXITCODE -ne 0) { throw "Export falló (código $LASTEXITCODE)" }
Write-Host "Build OK: $Out  (v$new)"
