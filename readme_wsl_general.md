
## Common WSL Commands

All commands below are run from **PowerShell** or **Command Prompt**.

### List Distros

```powershell
# List all installed distros and their status
wsl --list --verbose
# or shorthand
wsl -l -v
```

### Run a Distro

```powershell
# Launch the default distro
wsl

# Launch a specific distro
wsl -d <DistroName>

# Run a single command in a distro
wsl -d <DistroName> -- ls /home
```

### Terminate a Distro

```powershell
# Stop a specific running distro
wsl --terminate <DistroName>

# Shut down all running distros and the WSL VM
wsl --shutdown
```

### Export (Freeze/Snapshot) a Distro

```powershell
# Export a distro to a tar file (backup / snapshot)
wsl --export <DistroName> <OutputFile.tar>
```

Example:

```powershell
wsl --export ubicoders_u24 ubicoders_u24_backup.tar
```

### Import (Restore) a Distro

```powershell
# Import a previously exported tar as a new distro
wsl --import <NewDistroName> <InstallFolder> <TarFile>
```

### Delete (Unregister) a Distro

```powershell
# Permanently remove a distro and all its data
wsl --unregister <DistroName>
```

> **Warning:** This deletes the distro's entire filesystem. Export it first if you need a backup.

### Set the Default Distro

```powershell
wsl --set-default <DistroName>
```

### Check WSL Version and Status

```powershell
# Show WSL version info
wsl --version

# Update WSL to the latest version
wsl --update

# Check status
wsl --status
```
