# LunariumCoin bootstrap launcher.
# Downloads and installs the official blockchain bootstrap on first run so the
# wallet starts already close to synced, then launches lunariumcoin-qt.exe.
# Safe to run again later: if blocks are already present, the download is skipped.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DataDir   = Join-Path $env:APPDATA "LunariumCoin"
$BlocksDir = Join-Path $DataDir "blocks"
$BootstrapUrl = "https://bootstrap.lunariumcoin.com/blockchain"
$TempZip   = Join-Path $env:TEMP "lunariumcoin-bootstrap.zip"
$TempExtract = Join-Path $env:TEMP "lunariumcoin-bootstrap-extract"
$WalletExe = Join-Path $ScriptDir "lunariumcoin-qt.exe"

function Has-ExistingBlockchain {
    if (-not (Test-Path $BlocksDir)) { return $false }
    $files = Get-ChildItem -Path $BlocksDir -Filter "blk*.dat" -ErrorAction SilentlyContinue
    return ($files -and $files.Count -gt 0)
}

if (Has-ExistingBlockchain) {
    Write-Host "Blockchain data already present, skipping bootstrap download."
} else {
    Write-Host "==========================================================="
    Write-Host " LunariumCoin - First run setup"
    Write-Host "==========================================================="
    Write-Host "No local blockchain data found."
    Write-Host "Downloading the official bootstrap so you don't have to sync"
    Write-Host "from scratch (~1.1 GB, from bootstrap.lunariumcoin.com)."
    Write-Host ""

    New-Item -ItemType Directory -Force -Path $DataDir | Out-Null

    try {
        Add-Type -AssemblyName System.Net.Http
        $client = New-Object System.Net.Http.HttpClient
        $client.Timeout = [System.TimeSpan]::FromHours(2)
        $response = $client.GetAsync($BootstrapUrl, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
        $response.EnsureSuccessStatusCode() | Out-Null
        $totalBytes = $response.Content.Headers.ContentLength

        $stream = $response.Content.ReadAsStreamAsync().Result
        $fileStream = [System.IO.File]::Create($TempZip)
        $buffer = New-Object byte[] 1MB
        $totalRead = 0
        $lastPercent = -1

        while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $fileStream.Write($buffer, 0, $read)
            $totalRead += $read
            if ($totalBytes -gt 0) {
                $percent = [int](($totalRead / $totalBytes) * 100)
                if ($percent -ne $lastPercent) {
                    Write-Progress -Activity "Downloading blockchain bootstrap" -Status "$percent% ($([math]::Round($totalRead/1MB))MB / $([math]::Round($totalBytes/1MB))MB)" -PercentComplete $percent
                    $lastPercent = $percent
                }
            }
        }
        $fileStream.Close()
        $stream.Close()
        $client.Dispose()
        Write-Progress -Activity "Downloading blockchain bootstrap" -Completed
        Write-Host "Download complete. Extracting..."

        if (Test-Path $TempExtract) { Remove-Item -Recurse -Force $TempExtract }
        New-Item -ItemType Directory -Force -Path $TempExtract | Out-Null
        Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force

        foreach ($folder in @("blocks", "chainstate", "sporks")) {
            $src = Join-Path $TempExtract $folder
            if (Test-Path $src) {
                $dst = Join-Path $DataDir $folder
                if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
                Move-Item -Path $src -Destination $dst
            }
        }

        Write-Host "Bootstrap installed successfully."
    } catch {
        Write-Host ""
        Write-Host "Bootstrap download/install failed: $($_.Exception.Message)"
        Write-Host "The wallet will still start, it will just sync from scratch over the network."
    } finally {
        if (Test-Path $TempZip) { Remove-Item -Force $TempZip -ErrorAction SilentlyContinue }
        if (Test-Path $TempExtract) { Remove-Item -Recurse -Force $TempExtract -ErrorAction SilentlyContinue }
    }
}

Write-Host "Starting LunariumCoin wallet..."
Start-Process -FilePath $WalletExe
