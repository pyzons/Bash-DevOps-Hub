# 🚀 PowerShell 7 + Starship Integration

Complete PowerShell 7 setup that mirrors your bash DevOps Hub experience on Windows 11.

## 📋 What's Included

- **Automated Starship installation** with identical theme to WSL2/bash
- **50+ PowerShell aliases** matching your bash shortcuts
- **Git workflow shortcuts** (gs, ga, gc, gp, etc.)
- **Docker integration** (d, dps, dcup, dcdown)
- **System utilities** (sysinfo, meminfo, diskinfo)
- **Cross-platform consistency** with your bash setup

## 🎯 Quick Start

### One-Command Installation (Recommended)
```powershell
# Run in PowerShell 7 (pwsh) - fully automated, zero prompts
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1'))
```

### Manual Installation
```powershell
# Download the repository
git clone https://github.com/pyzons/Bash-DevOps-Hub.git
cd Bash-DevOps-Hub\10-powershell-integration\installers

# Run the setup script
.\setup-powershell7-starship.ps1
```

### Alternative Download Method
```powershell
# Download just the installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1" -OutFile "setup-starship.ps1"
.\setup-starship.ps1
```

## 🔧 What Gets Installed

### Core Components
- ✅ **Starship prompt** - Beautiful, fast, cross-platform prompt
- ✅ **Enhanced PowerShell profile** - 50+ aliases and functions
- ✅ **Identical configuration** - Same theme as your bash setup
- ✅ **Git integration** - All your favorite Git shortcuts
- ✅ **System utilities** - Performance monitoring and system info

### Aliases Added
```powershell
# Git shortcuts (identical to bash)
gs      # git status
ga      # git add
gc      # git commit -m
gp      # git push
glog    # git log --oneline -10

# System utilities
ll      # enhanced directory listing
sysinfo # system information
meminfo # memory usage
diskinfo# disk usage

# Docker (if installed)
d       # docker
dps     # docker ps
dcup    # docker-compose up -d
dcdown  # docker-compose down

# Navigation
..      # cd ..
...     # cd ..\..
~       # cd $HOME
```

## 📊 Status & Testing

After installation, test your setup:

```powershell
# Check overall status
pwsh-status

# Test Git shortcuts
gs                    # Should show git status

# View available shortcuts  
show-git-aliases      # List all Git shortcuts
show-docker-aliases   # List all Docker shortcuts
show-system-aliases   # List all system shortcuts

# Test Starship
starship --version    # Should show Starship version
```

## 🔄 Synchronization Workflow

### From WSL2/Linux to Windows 11:
```bash
# In your WSL2/Linux environment
cd Bash-DevOps-Hub
git add .
git commit -m "Update PowerShell integration"
git push origin main
```

### On Windows 11 PowerShell 7:
```powershell
# Pull latest changes
git pull origin main

# Run the updated installer
cd 10-powershell-integration\installers
.\setup-powershell7-starship.ps1
```

### Keep Both Environments in Sync:
```powershell
# Create a sync script for easy updates
# Save as sync-from-repo.ps1
git pull origin main
Write-Host "Repository updated!" -ForegroundColor Green
Write-Host "Run the installer if there are PowerShell changes:" -ForegroundColor Yellow
Write-Host "  .\10-powershell-integration\installers\setup-powershell7-starship.ps1" -ForegroundColor Cyan
```

## 🎨 Theme Consistency

Your PowerShell 7 prompt will look identical to your bash setup:
- Same color scheme (yellow username, blue hostname, green success symbol)
- Same Git branch symbol (🌱)
- Same directory truncation
- Same command duration display

## 📁 Folder Structure

```
10-powershell-integration/
├── installers/
│   └── setup-powershell7-starship.ps1    # Main installation script
├── configs/
│   ├── starship.toml                      # Starship configuration
│   └── profile-template.ps1               # PowerShell profile template
├── docs/
│   ├── INSTALLATION-GUIDE.md              # Detailed installation instructions
│   ├── TROUBLESHOOTING.md                 # Common issues and solutions
│   └── SYNC-WORKFLOW.md                   # Repository sync procedures
└── README.md                              # This file
```

## 🆘 Troubleshooting

### Common Issues:

**Issue: Execution Policy Error**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Issue: Starship Not Found**
```powershell
# Try manual installation
winget install starship
# Then run installer again
```

**Issue: Profile Not Loading**
```powershell
# Check profile location
$PROFILE
# Reload profile
. $PROFILE
```

**Issue: Git Commands Not Working**
```powershell
# Install Git if not present
winget install Git.Git
# Restart PowerShell
```

## 🔗 Related Documentation

- [WSL2 Setup Guide](../09-chat-recovery/WSL2-SETUP-GUIDE.md)
- [Bash Profile Documentation](../02-bash-profile/README.md)
- [Starship Configuration](../03-prompt-theming/README.md)

## 📈 What's Next

After successful installation:
1. **Customize further** - Add your own aliases to the profile
2. **Team sharing** - Share the installation script with your team
3. **Backup sync** - Set up automated profile backup
4. **Advanced features** - Explore additional PowerShell modules

---

**🎯 Goal**: Identical development experience between bash (WSL2/Linux) and PowerShell 7 (Windows 11)  
**📍 Repository**: https://github.com/pyzons/Bash-DevOps-Hub  
**⭐ Result**: Seamless cross-platform development workflow!
