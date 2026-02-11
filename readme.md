# WSL Custom Distro Manager

Import, configure, and manage custom WSL (Windows Subsystem for Linux) distributions using pre-built Ubuntu images.

---

## 1. How to Use This Project

This project provides scripts to quickly spin up custom Ubuntu WSL distros with a pre-configured user, sudo access, and ROS 2 (Jazzy).

**What's included:**

| File | Purpose |
|------|---------|
| `ubi-setup.ps1` | Interactive setup script — imports a distro, creates a user, updates packages |
| `ubi-doctor.ps1` | Diagnostic script — checks if tar file, install folder, and distro registration are healthy |

**Quick start:**

1. Download the Ubuntu image (see Section 2)
2. Run the setup script (see Section 4)
3. Launch your distro: `wsl -d ubicoders_u24`

---

## 2. Downloading the Ubuntu Image

Download the pre-built **ubicoders** image:

- Get the `ubicoders_u24.tar` file and place it in this project folder.

If you need a vanilla Ubuntu 24.04 WSL image instead, download from the official source:

- https://cloud-images.ubuntu.com/wsl/releases/24.04/current/
- Choose `ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz`

---

## 3. Common WSL Commands

All commands below are run from **PowerShell** or **Command Prompt**.

### List Distros

```powershell
wsl --list --verbose
# or shorthand
wsl -l -v
```

### Launch a Distro

```powershell
# Launch the default distro
wsl

# Launch a specific distro
wsl -d <DistroName>

# Run a single command in a distro
wsl -d <DistroName> -- ls /home
```

### Shut Down a Distro

```powershell
# Stop a specific running distro
wsl --terminate <DistroName>

# Shut down all running distros and the WSL VM
wsl --shutdown
```

### Delete (Unregister) a Distro

```powershell
wsl --unregister <DistroName>
```

> **Warning:** This deletes the distro's entire filesystem. Export it first if you need a backup.

### Export (Freeze/Snapshot) a Distro

```powershell
wsl --export <DistroName> <OutputFile.tar>
```

Example:

```powershell
wsl --export ubicoders_u24 ubicoders_u24_backup.tar
```

### Import (Upload/Restore) a Distro

```powershell
wsl --import <NewDistroName> <InstallFolder> <TarFile>
```

Example:

```powershell
wsl --import ubicoders_u24 .\ubicoders_u24 .\ubicoders_u24.tar
```

### Set the Default Distro

```powershell
wsl --set-default <DistroName>
```

### Check WSL Version and Status

```powershell
wsl --version
wsl --update
wsl --status
```

---

## 4. Using ubi-setup.ps1

The setup script walks you through importing a distro and configuring it interactively.

**Run it:**

```powershell
.\ubi-setup.ps1
```

**What it prompts you for:**

| Prompt | Default | Notes |
|--------|---------|-------|
| Distro name | `ubicoders_u24` | Press Enter to accept, or `n` to type a custom name |
| Install folder | `.\<DistroName>` | Where the distro's virtual disk is stored |
| Tar file | `.\ubicoders_u24.tar` | Path to the image file |
| Username | *(required)* | The Linux user to create |
| Password | *(required, masked)* | Password for the new user |

**What it does (in order):**

1. Creates the install folder if it doesn't exist
2. Imports the distro from the tar file via `wsl --import`
3. Creates the user with sudo access and sets it as the default login user
4. Adds `source /opt/ros/jazzy/setup.bash` to the user's `.bashrc`
5. Runs `apt-get update && apt-get upgrade`
6. Restarts the distro

After setup completes, launch with:

```powershell
wsl -d ubicoders_u24
```

**Troubleshooting:** Run `.\ubi-doctor.ps1` to check if the tar file, install folder, and distro registration are all in place.

---

## 5. Changing ubi-setup.ps1 Defaults

To customize the defaults for your own image, edit the default values at the top of `ubi-setup.ps1`:

```powershell
# Line 5 — Default distro name
$default = "ubicoders_u24"

# Line 14 — Default install folder (uses distro name)
$default = ".\$DistroName"

# Line 23 — Default tar file path
$default = ".\ubicoders_u24.tar"
```

**Common customizations:**

- **Different image:** Change the tar file default on line 23 to point to your own `.tar` file.
- **Different distro name:** Change the name on line 5 (the install folder will follow automatically).
- **Skip ROS 2 setup:** Remove or comment out the ROS 2 block (lines 96–108) if your image doesn't include ROS.
- **Add extra packages:** Add more `apt-get install` commands to the update block (around line 113).
- **Run additional setup scripts:** Add a new step after the package update to run any post-install scripts inside the distro.
