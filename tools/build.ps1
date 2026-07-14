# Build de sOC the Game — versiona como yyyy.MM.dd.<build> y exporta.
# Uso:   pwsh tools/build.ps1              (Windows Desktop -> build/sOC.exe)
#        pwsh tools/build.ps1 -Preset "Android" -Out "build/sOC.apk"
# Cumple ADR-025 (rev.): la versión es yyyy.MM.dd.N; cada compilación incrementa N.
# El número de compilación N se reinicia a 1 cuando cambia el día (la fecha ya identifica el día).
param(
    [string]$Preset = "Windows Desktop",
    [string]$Out = "build/sOC.exe",
    [switch]$Debug
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$proj = Join-Path $root "project.godot"

# --- Bump de versión (yyyy.MM.dd.N; N+1 por compilación, o N=1 si cambia el día) ---
$today = Get-Date -Format "yyyy.MM.dd"
$content = Get-Content $proj -Raw
if ($content -match 'config/version="(\d{4}\.\d{2}\.\d{2})\.(\d+)"') {
    $prevDate = $Matches[1]
    $n = if ($prevDate -eq $today) { [int]$Matches[2] + 1 } else { 1 }
} else {
    # Migración desde el esquema antiguo (x.y.z) o versión ausente.
    $n = 1
}
$new = "$today.$n"
$content = [regex]::Replace($content, 'config/version="[^"]*"', "config/version=`"$new`"")
Set-Content -Path $proj -Value $content -NoNewline -Encoding UTF8
Write-Host "Versión -> $new"

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
