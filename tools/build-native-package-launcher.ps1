param(
  [string]$OutputRoot = ""
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$SourceFile = Join-Path $ProjectRoot "native\package-launcher\src\main_win.cc"
if (-not $OutputRoot) {
  $OutputRoot = Join-Path $ProjectRoot "workspace\native-launcher"
}
$OutputRoot = [System.IO.Path]::GetFullPath($OutputRoot)
$OutputExe = Join-Path $OutputRoot "FlashSourceMap.exe"
$OutputObj = Join-Path $OutputRoot "main_win.obj"

function Find-VsWhere {
  $cmd = Get-Command "vswhere.exe" -ErrorAction SilentlyContinue
  if ($cmd) {
    return $cmd.Source
  }
  $defaultPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
  if (Test-Path $defaultPath) {
    return $defaultPath
  }
  return $null
}

$vswhere = Find-VsWhere
if (-not $vswhere) {
  throw "vswhere.exe was not found. Install Visual Studio Build Tools."
}

function Find-VsInstall {
  $requirements = @(
    "Microsoft.VisualStudio.Workload.VCTools",
    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
  )
  foreach ($requirement in $requirements) {
    $install = & $vswhere -latest -products * -requires $requirement -property installationPath
    if ($LASTEXITCODE -eq 0 -and $install) {
      return $install
    }
  }

  $install = & $vswhere -latest -products * -property installationPath
  if ($LASTEXITCODE -eq 0 -and $install) {
    return $install
  }

  return $null
}

$VsInstall = Find-VsInstall
if (-not $VsInstall) {
  throw "Visual Studio Build Tools with C++ tools was not found."
}

$VcVars = Join-Path $VsInstall "VC\Auxiliary\Build\vcvars64.bat"
if (-not (Test-Path $VcVars)) {
  throw "vcvars64.bat was not found: $VcVars"
}

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null

$Command = @(
  "`"$VcVars`"",
  "&&",
  "cl",
  "/nologo",
  "/EHsc",
  "/O2",
  "/MT",
  "/DUNICODE",
  "/D_UNICODE",
  "/Fo:`"$OutputObj`"",
  "`"$SourceFile`"",
  "/Fe:`"$OutputExe`"",
  "user32.lib",
  "shlwapi.lib",
  "/link",
  "/SUBSYSTEM:WINDOWS"
) -join " "

Write-Host "[native-launcher] Building $OutputExe"
& cmd.exe /d /s /c $Command
if ($LASTEXITCODE -ne 0) {
  throw "Native package launcher build failed with exit code $LASTEXITCODE"
}

if (-not (Test-Path $OutputExe)) {
  throw "Native package launcher was not created: $OutputExe"
}

Write-Host "[native-launcher] Ready: $OutputExe"
