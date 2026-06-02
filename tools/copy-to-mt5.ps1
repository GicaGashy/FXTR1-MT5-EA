[CmdletBinding()]
param(
    [string]$Mt5Mql5Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$localSettingsPath = Join-Path $PSScriptRoot "local-settings.ps1"
$sourceExperts = Join-Path $repoRoot "src\Experts"
$sourceInclude = Join-Path $repoRoot "src\Include"

if (Test-Path -LiteralPath $localSettingsPath -PathType Leaf) {
    . $localSettingsPath
}

if ([string]::IsNullOrWhiteSpace($Mt5Mql5Path)) {
    $defaultMt5Path = Get-Variable -Name "FXTR1_DefaultMt5Mql5Path" -ErrorAction SilentlyContinue
    if ($null -ne $defaultMt5Path) {
        $Mt5Mql5Path = $defaultMt5Path.Value
    }
}

if ([string]::IsNullOrWhiteSpace($Mt5Mql5Path)) {
    throw "Mt5Mql5Path is required. Pass -Mt5Mql5Path or set FXTR1_DefaultMt5Mql5Path in tools/local-settings.ps1."
}

if (-not (Test-Path -LiteralPath $Mt5Mql5Path -PathType Container)) {
    throw "MT5 MQL5 folder does not exist: $Mt5Mql5Path"
}

if (-not (Test-Path -LiteralPath $sourceExperts -PathType Container)) {
    throw "Source Experts folder is missing: $sourceExperts"
}

if (-not (Test-Path -LiteralPath $sourceInclude -PathType Container)) {
    throw "Source Include folder is missing: $sourceInclude"
}

$mt5Mql5FullPath = (Resolve-Path -LiteralPath $Mt5Mql5Path).Path
$targetExperts = Join-Path $mt5Mql5FullPath "Experts"
$targetInclude = Join-Path $mt5Mql5FullPath "Include"

Write-Host "[FXTR1] Repository root: $repoRoot"
Write-Host "[FXTR1] MT5 MQL5 folder: $mt5Mql5FullPath"

Write-Host "[FXTR1] Creating target folder: $targetExperts"
New-Item -ItemType Directory -Path $targetExperts -Force | Out-Null

Write-Host "[FXTR1] Creating target folder: $targetInclude"
New-Item -ItemType Directory -Path $targetInclude -Force | Out-Null

Write-Host "[FXTR1] Copying Experts from $sourceExperts to $targetExperts"
Copy-Item -Path (Join-Path $sourceExperts "*") -Destination $targetExperts -Recurse -Force

Write-Host "[FXTR1] Copying Include files from $sourceInclude to $targetInclude"
Copy-Item -Path (Join-Path $sourceInclude "*") -Destination $targetInclude -Recurse -Force

Write-Host "[FXTR1] Copy complete."
