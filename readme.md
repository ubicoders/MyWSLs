# WSL Custom Distro Guide

A guide for importing, configuring, and managing custom WSL (Windows Subsystem for Linux) distributions.

https://cloud-images.ubuntu.com/wsl/releases/24.04/current/


---

## Setting Up a Custom Distro

### Step 1: Download the Image

Download an Ubuntu 24 ubicoders image

Choose the `ubicoders_u24.tar` file.

### Step 3: Run the Setup Script

The setup script imports the distro, creates a user with sudo access, updates packages, and restarts the distro.

```powershell
.\setup-wsl.ps1
```

then follow the CLI instruction.

