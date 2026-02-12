# --- Defaults ---
$DefaultDistroName = "ubicoders_u24"
$DefaultTarFile = ".\$DefaultDistroName.tar"

Write-Host "=== WSL Setup ===" -ForegroundColor Cyan
Write-Host ""

# --- Distro Name ---
$input = Read-Host "  Distro name? ($DefaultDistroName) (Y/n)"
if ($input -eq "n" -or $input -eq "N") {
    $DistroName = Read-Host "  Enter distro name"
} else {
    $DistroName = $DefaultDistroName
}

# --- Install Folder ---
$DefaultInstallFolder = ".\$DistroName"
$input = Read-Host "  Install folder? ($DefaultInstallFolder) (Y/n)"
if ($input -eq "n" -or $input -eq "N") {
    $InstallFolder = Read-Host "  Enter install folder"
} else {
    $InstallFolder = $DefaultInstallFolder
}

# --- Tar File ---
$input = Read-Host "  Tar file? ($DefaultTarFile) (Y/n)"
if ($input -eq "n" -or $input -eq "N") {
    $TarFile = Read-Host "  Enter tar file path"
} else {
    $TarFile = $DefaultTarFile
}

# --- Username (always required) ---
$UserName = Read-Host "  Enter new username"
if (-not $UserName) {
    Write-Host "Username is required." -ForegroundColor Red
    exit 1
}

# --- Password (always required, masked) ---
$Password = Read-Host "  Enter password" -AsSecureString
$Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
if (-not $Password) {
    Write-Host "Password is required." -ForegroundColor Red
    exit 1
}

# --- Validate inputs ---
if (-not (Test-Path $TarFile)) {
    Write-Error "Tar file not found: $TarFile"
    exit 1
}

# Check if distro already exists
$existing = wsl --list --quiet 2>$null | Where-Object { $_.Trim() -replace "`0","" -eq $DistroName }
if ($existing) {
    Write-Error "Distro '$DistroName' already exists. Unregister it first with: wsl --unregister $DistroName"
    exit 1
}

# --- Step 1: Create install folder ---
if (-not (Test-Path $InstallFolder)) {
    Write-Host "Creating install folder: $InstallFolder"
    New-Item -ItemType Directory -Path $InstallFolder -Force | Out-Null
}

# --- Step 2: Import the distro ---
Write-Host "Importing distro '$DistroName' from '$TarFile'..."
wsl --import $DistroName $InstallFolder $TarFile
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to import distro."
    exit 1
}
Write-Host "Import complete."

# --- Step 3: Create user, set sudo, configure wsl.conf ---
Write-Host "Creating user '$UserName' and configuring distro..."

$setupScript = @"
set -e
useradd -m -s /bin/bash $UserName
echo "${UserName}:${Password}" | chpasswd
usermod -aG sudo $UserName
cat > /etc/wsl.conf << 'WSLCONF'
[user]
default=$UserName
WSLCONF
"@

wsl -d $DistroName -u root -- bash -c $setupScript
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to configure user."
    exit 1
}
Write-Host "User '$UserName' created with sudo access."

# --- Step 4: Add ROS 2 source to user's .bashrc ---
Write-Host "Adding ROS 2 (Jazzy) to '$UserName' bashrc..."

$ros2Script = @"
echo 'source /opt/ros/jazzy/setup.bash' >> /home/$UserName/.bashrc
chown ${UserName}:${UserName} /home/$UserName/.bashrc
"@

wsl -d $DistroName -u root -- bash -c $ros2Script
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to add ROS 2 source, but continuing..."
} else {
    Write-Host "ROS 2 (Jazzy) added to .bashrc."
}

# --- Step 5: Update packages ---
Write-Host "Updating packages (this may take a while)..."

$updateScript = @"
set -e
apt-get update -y
apt-get upgrade -y
"@

wsl -d $DistroName -u root -- bash -c $updateScript
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Package update had issues, but continuing..."
}
Write-Host "Packages updated."

# --- Step 5: Restart the distro ---
Write-Host "Restarting distro '$DistroName'..."
wsl --terminate $DistroName

Write-Host ""
Write-Host "Setup complete! Launch your distro with:"
Write-Host "  wsl -d $DistroName"
