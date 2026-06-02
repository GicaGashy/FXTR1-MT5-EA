[CmdletBinding()]
param(
    [string]$MetaEditorPath,

    [string]$Mt5Mql5Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$localSettingsPath = Join-Path $PSScriptRoot "local-settings.ps1"
$copyScript = Join-Path $PSScriptRoot "copy-to-mt5.ps1"
$buildDir = Join-Path $repoRoot "build"
$logPath = Join-Path $buildDir "FXTR1_EA.log"

if (Test-Path -LiteralPath $localSettingsPath -PathType Leaf) {
    . $localSettingsPath
}

if ([string]::IsNullOrWhiteSpace($MetaEditorPath)) {
    $defaultMetaEditorPath = Get-Variable -Name "FXTR1_DefaultMetaEditorPath" -ErrorAction SilentlyContinue
    if ($null -ne $defaultMetaEditorPath) {
        $MetaEditorPath = $defaultMetaEditorPath.Value
    }
}

if ([string]::IsNullOrWhiteSpace($Mt5Mql5Path)) {
    $defaultMt5Path = Get-Variable -Name "FXTR1_DefaultMt5Mql5Path" -ErrorAction SilentlyContinue
    if ($null -ne $defaultMt5Path) {
        $Mt5Mql5Path = $defaultMt5Path.Value
    }
}

if ([string]::IsNullOrWhiteSpace($MetaEditorPath)) {
    throw "MetaEditorPath is required. Pass -MetaEditorPath or set FXTR1_DefaultMetaEditorPath in tools/local-settings.ps1."
}

if ([string]::IsNullOrWhiteSpace($Mt5Mql5Path)) {
    throw "Mt5Mql5Path is required. Pass -Mt5Mql5Path or set FXTR1_DefaultMt5Mql5Path in tools/local-settings.ps1."
}

if (-not (Test-Path -LiteralPath $MetaEditorPath -PathType Leaf)) {
    throw "MetaEditor64.exe was not found: $MetaEditorPath"
}

if ((Split-Path -Leaf $MetaEditorPath) -ine "MetaEditor64.exe") {
    throw "MetaEditorPath must point to MetaEditor64.exe for compilation, not: $MetaEditorPath"
}

if (-not (Test-Path -LiteralPath $Mt5Mql5Path -PathType Container)) {
    throw "MT5 MQL5 folder does not exist: $Mt5Mql5Path"
}

if (-not (Test-Path -LiteralPath $copyScript -PathType Leaf)) {
    throw "Copy script was not found: $copyScript"
}

$metaEditorFullPath = (Resolve-Path -LiteralPath $MetaEditorPath).Path
$mt5Mql5FullPath = (Resolve-Path -LiteralPath $Mt5Mql5Path).Path
$eaPath = Join-Path $mt5Mql5FullPath "Experts\FXTR1_EA.mq5"

Write-Host "[FXTR1] Copying source files before compile."
& $copyScript -Mt5Mql5Path $mt5Mql5FullPath

if (-not (Test-Path -LiteralPath $eaPath -PathType Leaf)) {
    throw "EA file was not found after copy: $eaPath"
}

Write-Host "[FXTR1] Creating build directory: $buildDir"
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

if (Test-Path -LiteralPath $logPath -PathType Leaf) {
    Remove-Item -LiteralPath $logPath -Force
}

Write-Host "[FXTR1] Compiling EA: $eaPath"
Write-Host "[FXTR1] Compiler log: $logPath"

$arguments = @(
    "/compile:`"$eaPath`"",
    "/log:`"$logPath`""
)

$process = Start-Process -FilePath $metaEditorFullPath -ArgumentList $arguments -NoNewWindow -Wait -PassThru

if (-not (Test-Path -LiteralPath $logPath -PathType Leaf)) {
    Write-Host "[FXTR1] Compile log was not created."
    if ($process.ExitCode -ne 0) {
        exit $process.ExitCode
    }

    exit 1
}

$logContent = Get-Content -Raw -Path $logPath
if ($logContent -match "(?im)^\s*(error|errors)\b|:\s*error\b|Result:\s*[1-9][0-9]*\s+errors?\b") {
    Write-Host "[FXTR1] Compilation failed. See log: $logPath"
    exit 1
}

if ($logContent -notmatch "(?im)^Result:\s*0\s+errors?\b") {
    Write-Host "[FXTR1] Could not confirm successful compilation from log. MetaEditor exit code: $($process.ExitCode)."
    exit 1
}

if ($process.ExitCode -ne 0) {
    Write-Host "[FXTR1] MetaEditor exited with code $($process.ExitCode), but the compiler log reports 0 errors."
}

Write-Host "[FXTR1] Compilation completed successfully."
