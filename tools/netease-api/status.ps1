[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$logPath = Join-Path $env:LOCALAPPDATA "XWalnut\music-bridge.log"

try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:16311/health" -TimeoutSec 2
    if (-not $health.ok) {
        throw "The health endpoint returned an unexpected response."
    }
    Write-Host "[XWalnut] Music Bridge is running."
    Write-Host "[XWalnut] PID: $($health.pid), uptime: $($health.uptime)s, version: $($health.version)"
} catch {
    Write-Host "[XWalnut] Music Bridge is not reachable."
    Write-Host "[XWalnut] Log: $logPath"
    exit 1
}
