param(
  [switch]$SkipSignTool,
  [switch]$SkipMsixHelper
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $repoRoot

$isccCommand = Get-Command iscc -ErrorAction SilentlyContinue
$iscc = if ($isccCommand) {
  $isccCommand.Source
} else {
  @(
    'C:\Program Files (x86)\Inno Setup 6\ISCC.exe',
    'C:\Program Files\Inno Setup 6\ISCC.exe'
  ) | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
}
if (-not $iscc) {
  throw 'ISCC.exe not found. Install Inno Setup 6 or add it to PATH.'
}

$pubspecVersion = Select-String -Path app\pubspec.yaml -Pattern '^version:\s*([^+\s]+)' | ForEach-Object { $_.Matches[0].Groups[1].Value }
$releaseDir = Join-Path $repoRoot "release\$pubspecVersion"
$releaseExe = Join-Path $releaseDir 'release-installer.exe'
$payloadDir = Join-Path $repoRoot 'build\windows\installer\payload'
$resultDir = Join-Path $repoRoot 'build\windows\installer\result'

if (-not $SkipMsixHelper) {
  $makepri = Get-ChildItem 'C:\Program Files (x86)\Windows Kits\10\bin\10.*\x64\makepri.exe' | Select-Object -Last 1
  & $makepri.FullName new /pr support\build\msix\content /cf support\build\msix\priconfig.xml /mn support\build\msix\content\AppxManifest.xml /of support\build\msix\content\resources.pri /o
  & 'C:\Program Files (x86)\Windows Kits\10\App Certification Kit\makeappx.exe' pack /o /d support\build\msix\content /nv /p app\windows\localsend_msix_helper.msix
}

if (Get-Command fvm -ErrorAction SilentlyContinue) {
  $flutterCommand = 'fvm'
  $flutterArgs = @('flutter')
} else {
  $flutterCommand = '..\support\submodules\flutter\bin\flutter.bat'
  $flutterArgs = @()
}

cd app

& $flutterCommand @flutterArgs clean
& $flutterCommand @flutterArgs pub get
& $flutterCommand @flutterArgs build windows --release

if (Test-Path -LiteralPath $payloadDir) {
  Remove-Item -LiteralPath $payloadDir -Force -Recurse
}
New-Item -ItemType Directory -Force -Path $payloadDir
Copy-Item -Path "build\windows\x64\runner\Release\*" -Destination $payloadDir -Recurse
Copy-Item -Path "assets\packaging\logo.ico" -Destination $payloadDir

cd ..

Copy-Item -Path "support\build\windows\x64\*" -Destination $payloadDir -Recurse
if (Test-Path -LiteralPath $resultDir) {
  Remove-Item -LiteralPath $resultDir -Force -Recurse
}
New-Item -ItemType Directory -Force -Path $resultDir
$isccArgs = @("/DPayloadDir=`"$payloadDir`"", "/DResultDir=`"$resultDir`"", '.\support\scripts\compile_windows_exe-inno.iss')
if ($SkipSignTool) {
  $isccArgs += '/DSkipSignTool'
}
if ($SkipMsixHelper) {
  $isccArgs += '/DSkipMsixHelper'
}
& $iscc @isccArgs

New-Item -ItemType Directory -Force -Path $releaseDir
Copy-Item -Path (Join-Path $resultDir 'localsend.exe') -Destination $releaseExe -Force

Write-Output "Generated Windows x64 exe installer: $releaseExe"
