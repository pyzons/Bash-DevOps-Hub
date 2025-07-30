# 📖 PowerShell 7 + Starship Installation Guide

## 🎯 Overview
This guide provides step-by-step instructions for setting up PowerShell 7 with Starship prompt that matches your bash DevOps Hub experience.

## 📋 Prerequisites

### Required:
- ✅ **Windows 11** (or Windows 10 version 1903+)
- ✅ **PowerShell 7.0+** installed
- ✅ **Internet connection** for downloads

### Optional but Recommended:
- ✅ **Windows Terminal** for best experience
- ✅ **Git** for version control
- ✅ **Docker Desktop** for container aliases

## 🔍 Pre-Installation Checks

### Verify PowerShell 7:
```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Should show 7.x.x or higher
# If not installed, run:
winget install Microsoft.PowerShell
```

### Check Windows Terminal:
```powershell
# Check if Windows Terminal is available
wt --version

# If not installed, run:
winget install Microsoft.WindowsTerminal
```

## 🚀 Installation Methods

### Method 1: One-Command Install (Recommended)
```powershell
# Copy and paste this single line - fully automated
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1'))
```

**What this does:**
- Downloads and runs the installer automatically
- Zero prompts or user interaction required
- Installs Starship via winget (or direct download as fallback)
- Creates PowerShell profile with 50+ aliases
- Configures Starship with identical theme to bash setup
- Sets appropriate execution policy

### Method 2: Download and Run Locally
```powershell
# Download the installer script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1" -OutFile "setup-starship.ps1"

# Run the installer
.\setup-starship.ps1

# Clean up
Remove-Item setup-starship.ps1
```

### Method 3: Clone Repository Method
```powershell
# Clone the entire repository
git clone https://github.com/pyzons/Bash-DevOps-Hub.git
cd Bash-DevOps-Hub

# Navigate to PowerShell integration
cd 10-powershell-integration\installers

# Run the installer
.\setup-powershell7-starship.ps1
```

## 🔧 Manual Installation (Advanced Users)

If you prefer to install components manually:

### Step 1: Install Starship
```powershell
# Using winget (recommended)
winget install starship

# Or using Chocolatey
choco install starship

# Or using Scoop
scoop install starship
```

### Step 2: Create PowerShell Profile
```powershell
# Check if profile exists
Test-Path $PROFILE

# Create profile directory if needed
$ProfileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force
}

# Create basic profile
@"
# Initialize Starship
Invoke-Expression (&starship init powershell)

# Basic aliases
function gs { git status }
function ll { Get-ChildItem -Force | Format-Table -AutoSize }
"@ | Out-File -FilePath $PROFILE -Encoding UTF8
```

### Step 3: Configure Starship
```powershell
# Create config directory
$ConfigDir = "$env:USERPROFILE\.config"
New-Item -ItemType Directory -Path $ConfigDir -Force

# Download Starship config
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/configs/starship.toml" -OutFile "$ConfigDir\starship.toml"
```

## ✅ Post-Installation Verification

### Test Basic Functionality:
```powershell
# Restart PowerShell first
exit
# Then open new PowerShell 7 session

# Test Starship
starship --version

# Test aliases
gs          # Should work if in a git repository
ll          # Should show enhanced directory listing

# Check status
pwsh-status # Should show comprehensive status
```

### Verify Profile Loading:
```powershell
# Check profile location
$PROFILE

# View profile content (first few lines)
Get-Content $PROFILE | Select-Object -First 10

# Reload profile manually
. $PROFILE
```

### Test Git Integration:
```powershell
# In a git repository, test:
gs          # git status
show-git-aliases  # Show all Git shortcuts
```

## 🎨 Customization Options

### Add Custom Aliases:
```powershell
# Edit your profile
code $PROFILE

# Add custom functions at the end:
function myalias { Write-Host "My custom command" }
```

### Modify Starship Theme:
```powershell
# Edit Starship config
code "$env:USERPROFILE\.config\starship.toml"

# Reload after changes
```

### Windows Terminal Integration:
```powershell
# Set PowerShell 7 as default in Windows Terminal
# Open Windows Terminal settings (Ctrl + ,)
# Set "defaultProfile" to PowerShell 7 GUID
```

## 🔄 Keeping Updated

### Update Starship:
```powershell
# Using winget
winget upgrade starship

# Using Chocolatey
choco upgrade starship

# Using Scoop
scoop update starship
```

### Update Profile from Repository:
```powershell
# If you cloned the repository
cd Bash-DevOps-Hub
git pull origin main

# Re-run installer to get updates
cd 10-powershell-integration\installers
.\setup-powershell7-starship.ps1
```

## 🆘 Troubleshooting

### Common Installation Issues:

**Execution Policy Error:**
```powershell
# Error: "cannot be loaded because running scripts is disabled"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

**Starship Not Found After Installation:**
```powershell
# Check if Starship is in PATH
$env:PATH -split ';' | Where-Object { $_ -like '*starship*' }

# If not found, try:
refreshenv  # If using Chocolatey
# Or restart PowerShell
```

**Profile Not Loading:**
```powershell
# Check profile path
$PROFILE

# Verify file exists
Test-Path $PROFILE

# Check for syntax errors
powershell -NoProfile -Command "& { . '$PROFILE' }"
```

**Git Commands Not Working:**
```powershell
# Install Git if missing
winget install Git.Git

# Restart PowerShell after installation
# Verify Git is available
git --version
```

**Starship Theme Not Applying:**
```powershell
# Check config file location
$env:STARSHIP_CONFIG

# If empty, config should be at:
"$env:USERPROFILE\.config\starship.toml"

# Verify file exists
Test-Path "$env:USERPROFILE\.config\starship.toml"
```

### Performance Issues:

**Slow Prompt Loading:**
```powershell
# Check if profile has performance issues
Measure-Command { . $PROFILE }

# If slow, comment out modules one by one to identify culprit
```

**Git Status Slow:**
```powershell
# Configure Git for performance
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
```

## 📞 Getting Help

### Resources:
- **Repository Issues**: https://github.com/pyzons/Bash-DevOps-Hub/issues
- **Starship Documentation**: https://starship.rs/
- **PowerShell Documentation**: https://docs.microsoft.com/powershell/

### Creating Support Issues:
Include this information when reporting problems:
```powershell
# System information
$PSVersionTable
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion

# Installation verification
starship --version
Test-Path $PROFILE
pwsh-status
```

---

**🎯 Success Criteria**: You should have a beautiful, fast prompt that looks identical to your bash setup, with all the same shortcuts and functionality working seamlessly in PowerShell 7!
