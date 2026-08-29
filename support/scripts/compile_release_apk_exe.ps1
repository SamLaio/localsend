param(
  [string]$ReleaseVersion = '1.18.2_re_1',
  [string]$SigningEnvFile = 'D:\project\apkKey\localsend.local.ps1',
  [switch]$SkipAndroid,
  [switch]$SkipWindows
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $repoRoot

$pubspecVersion = Select-String -Path app\pubspec.yaml -Pattern '^version:\s*([^+\s]+)' | ForEach-Object { $_.Matches[0].Groups[1].Value }
if (-not $ReleaseVersion) {
  $ReleaseVersion = $pubspecVersion
}
$env:RELEASE_VERSION_NAME = $ReleaseVersion
$releaseDir = Join-Path $repoRoot "release\$ReleaseVersion"
$releaseApk = Join-Path $releaseDir 'release.apk'
$releaseZip = Join-Path $releaseDir 'release.zip'

if (Get-Command fvm -ErrorAction SilentlyContinue) {
  $flutterCommand = 'fvm'
  $flutterArgs = @('flutter')
} else {
  $flutterCommand = Join-Path $repoRoot 'support\submodules\flutter\bin\flutter.bat'
  $flutterArgs = @()
}

function Invoke-Flutter {
  param([string[]]$Arguments)
  & $flutterCommand @flutterArgs @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Flutter command failed: $flutterCommand $($flutterArgs + $Arguments -join ' ')"
  }
}

function Remove-PathWithRetry {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }

  $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
  $allowedRoot = Join-Path $repoRoot 'build\windows'
  if (-not $resolvedPath.StartsWith($allowedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to remove path outside Windows build staging: $resolvedPath"
  }

  for ($attempt = 1; $attempt -le 5; $attempt++) {
    try {
      Remove-Item -LiteralPath $resolvedPath -Force -Recurse
      return
    } catch {
      if ($attempt -eq 5) {
        throw
      }
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
      Start-Sleep -Milliseconds 700
    }
  }
}

function Copy-FileWithRetry {
  param(
    [string]$Source,
    [string]$Destination
  )

  for ($attempt = 1; $attempt -le 5; $attempt++) {
    try {
      Copy-Item -LiteralPath $Source -Destination $Destination -Force
      return
    } catch {
      if ($attempt -eq 5) {
        throw
      }
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
      Start-Sleep -Milliseconds 700
    }
  }
}

if (-not $SkipAndroid) {
  if (Test-Path -LiteralPath $SigningEnvFile -PathType Leaf) {
    . $SigningEnvFile
  }

  foreach ($name in 'SIGNING_KEYSTORE_PATH', 'SIGNING_STORE_PASSWORD', 'SIGNING_KEY_ALIAS', 'SIGNING_KEY_PASSWORD') {
    if (-not [Environment]::GetEnvironmentVariable($name, 'Process')) {
      throw "Missing Android signing environment variable: $name"
    }
  }

  New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null

  Push-Location app
  try {
    Invoke-Flutter @('pub', 'get')
    Invoke-Flutter @('build', 'apk', '--release', '--split-per-abi', '--target-platform', 'android-arm64')
  } finally {
    Pop-Location
  }

  $arm64Apk = Join-Path $repoRoot 'app\build\app\outputs\flutter-apk\app-arm64-v8a-release.apk'
  if (-not (Test-Path -LiteralPath $arm64Apk -PathType Leaf)) {
    throw "Android arm64 APK not found: $arm64Apk"
  }
  Copy-FileWithRetry -Source $arm64Apk -Destination $releaseApk
  Write-Output "Generated Android arm64 APK: $releaseApk"
}

if (-not $SkipWindows) {
  Push-Location app
  try {
    Invoke-Flutter @('pub', 'get')
    Invoke-Flutter @('build', 'windows', '--release')
  } finally {
    Pop-Location
  }

  $windowsBundle = Join-Path $repoRoot 'app\build\windows\x64\runner\Release'
  $windowsAppExe = Join-Path $windowsBundle 'localsend_app.exe'
  if (-not (Test-Path -LiteralPath $windowsAppExe -PathType Leaf)) {
    throw "Windows x64 app executable not found: $windowsAppExe"
  }

  $windowsStage = Join-Path $repoRoot 'build\windows\portable-release'
  if (Test-Path -LiteralPath $windowsStage) {
    Remove-PathWithRetry -Path $windowsStage
  }
  New-Item -ItemType Directory -Force -Path $windowsStage | Out-Null
  Copy-Item -Path (Join-Path $windowsBundle '*') -Destination $windowsStage -Recurse -Force
  Copy-Item -Path (Join-Path $repoRoot 'support\build\windows\x64\*') -Destination $windowsStage -Recurse -Force
  Move-Item -LiteralPath (Join-Path $windowsStage 'localsend_app.exe') -Destination (Join-Path $windowsStage 'release.exe') -Force

  New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null
  Compress-Archive -Path (Join-Path $windowsStage '*') -DestinationPath $releaseZip -Force
  Remove-PathWithRetry -Path $windowsStage

  if (-not (Test-Path -LiteralPath $releaseZip -PathType Leaf)) {
    throw "Windows x64 portable ZIP not found: $releaseZip"
  }
  Write-Output "Generated Windows 10+ x64 portable ZIP: $releaseZip"
}

Write-Output "Release directory: $releaseDir"
