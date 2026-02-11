$DistroName = "ubicoders_u24"
$TarFile = ".\ubicoders_u24.tar"
$InstallFolder = ".\ubicoders_u24"

Write-Host "=== Diagnose: $DistroName ===" -ForegroundColor Cyan
Write-Host ""

# 1. Check tar file
Write-Host "[1] Tar file '$TarFile'" -NoNewline
if (Test-Path $TarFile) {
    $size = [math]::Round((Get-Item $TarFile).Length / 1MB, 1)
    Write-Host " => FOUND (${size} MB)" -ForegroundColor Green
} else {
    Write-Host " => NOT FOUND" -ForegroundColor Red
}

# 2. Check install folder
Write-Host "[2] Install folder '$InstallFolder'" -NoNewline
if (Test-Path $InstallFolder) {
    Write-Host " => EXISTS" -ForegroundColor Green
} else {
    Write-Host " => NOT FOUND" -ForegroundColor Red
}

# 3. Check WSL distro registered
Write-Host "[3] WSL distro '$DistroName'" -NoNewline
$distros = wsl --list --quiet 2>$null | ForEach-Object { $_.Trim() -replace "`0","" } | Where-Object { $_ -eq $DistroName }
if ($distros) {
    Write-Host " => REGISTERED" -ForegroundColor Green

    # Show running state
    $verbose = wsl --list --verbose 2>$null
    $entry = $verbose | Where-Object { $_ -match $DistroName }
    if ($entry) {
        Write-Host "     $($entry.Trim())" -ForegroundColor DarkGray
    }
} else {
    Write-Host " => NOT REGISTERED" -ForegroundColor Red
}


Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Cyan
