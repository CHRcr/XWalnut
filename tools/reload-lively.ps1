param()
$ErrorActionPreference = 'Stop'

function Get-ContentHash([string]$Path) {
    $stream = [IO.File]::OpenRead($Path)
    $hash = [Security.Cryptography.SHA256]::Create()
    try { return [Convert]::ToBase64String($hash.ComputeHash($stream)) }
    finally { $stream.Dispose(); $hash.Dispose() }
}

# Copy runtime files to the active XWalnut library entry, then reload its page.
# Lively's official CLI: seekwp --monitor <id> --value 0 reloads web wallpapers.
# https://github.com/rocksdanister/lively/wiki/Command-Line-Controls
$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot 'app'
$livelyRoot = Join-Path $env:LOCALAPPDATA 'Lively Wallpaper'
$layout = @(Get-Content -LiteralPath (Join-Path $livelyRoot 'WallpaperLayout.json') -Raw | ConvertFrom-Json)
$settings = Get-Content -LiteralPath (Join-Path $livelyRoot 'Settings.json') -Raw | ConvertFrom-Json
$libraryRoot = [IO.Path]::GetFullPath((Join-Path $settings.WallpaperDir 'wallpapers')).TrimEnd('\') + '\'
$livelyExe = Get-Process -Name Lively -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Path
if (-not $livelyExe) { throw 'Open Lively and apply XWalnut before running this command.' }

$targets = @{}
foreach ($entry in $layout) {
    if (-not $entry.LivelyInfoPath) { continue }
    $target = [IO.Path]::GetFullPath($entry.LivelyInfoPath).TrimEnd('\')
    if (-not $target.StartsWith($libraryRoot, [StringComparison]::OrdinalIgnoreCase)) { continue }
    $infoPath = Join-Path $target 'LivelyInfo.json'
    if (-not (Test-Path -LiteralPath $infoPath)) { continue }
    $info = Get-Content -LiteralPath $infoPath -Raw | ConvertFrom-Json
    if ($info.Title -ne 'XWalnut' -or $info.FileName -ne 'index.html') { continue }
    $monitor = [int]$entry.LivelyScreen.Index
    if ($monitor -lt 1) { throw 'The active wallpaper has no valid monitor index.' }
    if (-not $targets.ContainsKey($target)) { $targets[$target] = @() }
    $targets[$target] += $monitor
}
if ($targets.Count -eq 0) { throw 'No active XWalnut wallpaper was found in the Lively library.' }

$sources = @((Join-Path $sourceRoot 'index.html'), (Join-Path $sourceRoot 'THIRD_PARTY_NOTICES.md'))
foreach ($folder in @('css', 'js', 'assets')) {
    $sources += @(Get-ChildItem -LiteralPath (Join-Path $sourceRoot $folder) -File -Recurse | Select-Object -ExpandProperty FullName)
}
$backupRoot = Join-Path $repoRoot ('dist\.lively-hot-update\' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
foreach ($target in $targets.Keys) {
    $copied = 0
    foreach ($source in $sources) {
        $relative = $source.Substring($sourceRoot.Length + 1)
        $destination = Join-Path $target $relative
        if (Test-Path -LiteralPath $destination) {
            if ((Get-ContentHash $source) -eq (Get-ContentHash $destination)) { continue }
            $backup = Join-Path (Join-Path $backupRoot (Split-Path $target -Leaf)) $relative
            New-Item -ItemType Directory -Path (Split-Path $backup -Parent) -Force | Out-Null
            Copy-Item -LiteralPath $destination -Destination $backup
        }
        New-Item -ItemType Directory -Path (Split-Path $destination -Parent) -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $destination -Force
        $copied++
    }
    Write-Host "Updated $copied runtime files: $target"
    foreach ($monitor in ($targets[$target] | Select-Object -Unique)) {
        $reload = Start-Process -FilePath $livelyExe -ArgumentList @('seekwp', '--monitor', [string]$monitor, '--value', '0') -WindowStyle Hidden -PassThru -Wait
        if ($reload.ExitCode -ne 0) { throw "Lively reload failed on monitor $monitor (exit $($reload.ExitCode))." }
        Write-Host "Requested web wallpaper reload on monitor $monitor."
    }
}
Write-Host 'Media and saved Lively properties were preserved.'
if (Test-Path -LiteralPath $backupRoot) { Write-Host "Previous runtime files: $backupRoot" }
