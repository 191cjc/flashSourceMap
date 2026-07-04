param(
  [string]$CefRoot = $env:CEF_ROOT,
  [string]$BuildRoot = "",
  [string]$InstallRoot = ""
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$HostSource = Join-Path $ProjectRoot "native\cef-host"
if (-not $BuildRoot) {
  $BuildRoot = Join-Path $ProjectRoot "workspace\native-host\build"
}
if (-not $InstallRoot) {
  $InstallRoot = Join-Path $ProjectRoot "workspace\native-host"
}

$CefName = "cef_binary_87.1.14+ga29e9a3+chromium-87.0.4280.141_windows64"
$CefCache = Join-Path $ProjectRoot "workspace\native-cef-host"
$CefArchive = Join-Path $CefCache "$CefName.tar.bz2"
$CefUrl = "https://cef-builds.spotifycdn.com/cef_binary_87.1.14%2Bga29e9a3%2Bchromium-87.0.4280.141_windows64.tar.bz2"

function Require-Command($Name, $Hint) {
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if (-not $cmd) {
    throw "$Name was not found. $Hint"
  }
  return $cmd.Source
}

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

function Find-CMake {
  $cmd = Get-Command "cmake" -ErrorAction SilentlyContinue
  if ($cmd) {
    return $cmd.Source
  }

  $vswhere = Find-VsWhere
  if ($vswhere) {
    $requirements = @(
      "Microsoft.VisualStudio.Workload.VCTools",
      "Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
    )
    foreach ($requirement in $requirements) {
      $vsInstall = & $vswhere -latest -products * -requires $requirement -property installationPath
      if ($LASTEXITCODE -eq 0 -and $vsInstall) {
        $vsCMake = Join-Path $vsInstall "Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
        if (Test-Path $vsCMake) {
          return $vsCMake
        }
      }
    }

    $vsInstall = & $vswhere -latest -products * -property installationPath
    if ($LASTEXITCODE -eq 0 -and $vsInstall) {
      $vsCMake = Join-Path $vsInstall "Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
      if (Test-Path $vsCMake) {
        return $vsCMake
      }
    }
  }

  return $null
}

function Copy-CefRuntimeResource($CefRoot, $InstallRoot, $Name) {
  $targetDir = Join-Path $InstallRoot "Release"
  $source = Join-Path (Join-Path $CefRoot "Release") $Name
  if (-not (Test-Path $source)) {
    $source = Join-Path (Join-Path $CefRoot "Resources") $Name
  }
  if (-not (Test-Path $source)) {
    return
  }

  $target = Join-Path $targetDir $Name
  if ((Get-Item $source).PSIsContainer) {
    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
  } else {
    Copy-Item -LiteralPath $source -Destination $target -Force
  }
}

if (-not $CefRoot) {
  $CefRoot = Join-Path $CefCache $CefName
}

$CMakeExe = Find-CMake
if (-not $CMakeExe) {
  throw "cmake was not found. Install CMake 3.19+ or Visual Studio Build Tools with the CMake component."
}

if (-not (Test-Path (Join-Path $CefRoot "include\cef_app.h"))) {
  New-Item -ItemType Directory -Force -Path $CefCache | Out-Null
  if (-not (Test-Path $CefArchive)) {
    Require-Command "curl.exe" "Install curl or download $CefUrl manually to $CefArchive." | Out-Null
    Write-Host "[native-host] Downloading CEF standard distribution: $CefUrl"
    & curl.exe -L $CefUrl -o $CefArchive
    if ($LASTEXITCODE -ne 0) {
      throw "CEF download failed with exit code $LASTEXITCODE"
    }
  }

  Write-Host "[native-host] Extracting CEF standard distribution..."
  Require-Command "tar.exe" "Install tar or extract $CefArchive manually under $CefCache." | Out-Null
  & tar.exe -xf $CefArchive -C $CefCache
  if ($LASTEXITCODE -ne 0) {
    throw "CEF extraction failed with exit code $LASTEXITCODE"
  }
}

if (-not (Test-Path (Join-Path $CefRoot "include\cef_app.h"))) {
  throw "CEF_ROOT does not contain include\cef_app.h: $CefRoot"
}

New-Item -ItemType Directory -Force -Path $BuildRoot | Out-Null
New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null

Write-Host "[native-host] Configuring..."
& $CMakeExe -S $HostSource -B $BuildRoot -A x64 -DCEF_ROOT="$CefRoot" -DCMAKE_INSTALL_PREFIX="$InstallRoot"
if ($LASTEXITCODE -ne 0) {
  throw "CMake configure failed with exit code $LASTEXITCODE"
}

Write-Host "[native-host] Building..."
& $CMakeExe --build $BuildRoot --config Release --parallel
if ($LASTEXITCODE -ne 0) {
  throw "CMake build failed with exit code $LASTEXITCODE"
}

Write-Host "[native-host] Installing..."
& $CMakeExe --install $BuildRoot --config Release
if ($LASTEXITCODE -ne 0) {
  throw "CMake install failed with exit code $LASTEXITCODE"
}

$runtimeResources = @(
  "cef.pak",
  "cef_100_percent.pak",
  "cef_200_percent.pak",
  "cef_extensions.pak",
  "devtools_resources.pak",
  "icudtl.dat",
  "locales",
  "swiftshader"
)
foreach ($resource in $runtimeResources) {
  Copy-CefRuntimeResource $CefRoot $InstallRoot $resource
}

$OutputExe = Join-Path $InstallRoot "Release\flash-native-host.exe"
if (-not (Test-Path $OutputExe)) {
  throw "Build completed but output was not found: $OutputExe"
}

Write-Host "[native-host] Ready: $OutputExe"
