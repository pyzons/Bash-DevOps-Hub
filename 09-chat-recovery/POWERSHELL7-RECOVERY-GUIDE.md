# 🚀 PowerShell 7 Recovery Guide - Cross-Platform DevOps Hub

## 🎯 Purpose
This guide helps you quickly set up the PowerShell 7 version of the Bash DevOps Hub on any Windows 11 machine, maintaining identical functionality and experience to your bash environment.

## 📋 Quick Recovery Commands

### Instant Setup (One Command):
```powershell
# Fully automated PowerShell 7 + Starship setup
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1'))
```

### Repository-Based Setup:
```powershell
# Clone the full repository
git clone https://github.com/pyzons/Bash-DevOps-Hub.git
cd Bash-DevOps-Hub

# Run PowerShell setup
cd 10-powershell-integration\installers
.\setup-powershell7-starship.ps1

# Set up sync workflow
.\sync-devops-hub.ps1  # Check status and setup sync
```

## 🔄 Context Recovery for Chat Continuation

When continuing your development session in PowerShell 7, use this context prompt:

```
I need to continue a cross-platform development session. Here's the context:

Repository: https://github.com/pyzons/Bash-DevOps-Hub
Project: Cross-platform DevOps Hub with bash and PowerShell 7 integration
Status: Complete setup with 10 sub-projects, working across Linux, WSL2, and PowerShell 7

Current Setup Includes:
- Enhanced bash profile (Linux/WSL2) with 50+ aliases ✅
- PowerShell 7 integration (Windows 11) with identical functionality ✅
- Starship prompt configuration (identical across platforms) ✅
- Docker and Kubernetes integration ✅
- Cross-platform synchronization workflows ✅
- Complete documentation and recovery system ✅

Environment Status:
- Local Ubuntu/Linux: Complete ✅
- WSL2 Windows 11: Complete ✅  
- PowerShell 7 Windows 11: Complete ✅
- Cloud Ubuntu: Available ✅

I'm currently working in PowerShell 7 on Windows 11. What's the next step for advancing this cross-platform development workflow?
```

## 📊 Verification After Recovery

### Test Your PowerShell 7 Setup:
```powershell
# Check overall status
pwsh-status

# Test identical functionality to bash
gs                      # Git status (same as bash)
ll                      # Enhanced directory listing
show-git-aliases        # Should show 15+ Git shortcuts
show-docker-aliases     # Should show 10+ Docker shortcuts

# Test Starship prompt
starship --version      # Should match bash version

# Test cross-platform sync
.\sync-devops-hub.ps1   # Repository sync status
```

### Verify Cross-Platform Consistency:
```powershell
# These should work identically to your bash setup:
gs && git log --oneline -5    # Git shortcuts
sysinfo                       # System information
meminfo                       # Memory usage
diskinfo                      # Disk usage information
```

## 🔧 Advanced Recovery Scenarios

### Scenario 1: New Windows 11 Machine
```powershell
# One-command setup on fresh machine
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1'))

# Verify and test
pwsh-status
```

### Scenario 2: Sync from WSL2/Linux Updates
```powershell
# Pull latest changes from your WSL2 work
git pull origin main

# Check for PowerShell-specific updates
$PowerShellUpdates = git diff --name-only HEAD~1 HEAD | Where-Object { $_ -like "*10-powershell-integration*" }
if ($PowerShellUpdates) {
    Write-Host "PowerShell updates detected, re-running installer..." -ForegroundColor Yellow
    .\10-powershell-integration\installers\setup-powershell7-starship.ps1
}
```

### Scenario 3: Team Member Setup
```powershell
# Share this command with team members for instant setup
$SetupCommand = @"
# Bash DevOps Hub - PowerShell 7 Setup
Write-Host 'Setting up cross-platform DevOps environment...' -ForegroundColor Cyan
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1'))
Write-Host 'Setup complete! Type pwsh-status to verify.' -ForegroundColor Green
"@

Write-Host $SetupCommand
```

## 📋 Feature Comparison: Bash vs PowerShell 7

| Feature | Bash (WSL2/Linux) | PowerShell 7 | Status |
|---------|-------------------|---------------|---------|
| **Starship Prompt** | ✅ Identical theme | ✅ Identical theme | ✅ Consistent |
| **Git Shortcuts** | `gs`, `ga`, `gc`, `gp` | `gs`, `ga`, `gc`, `gp` | ✅ Identical |
| **Directory Listing** | `ll` (ls -alF) | `ll` (Get-ChildItem formatted) | ✅ Equivalent |
| **System Info** | `sysinfo` (uname, free, df) | `sysinfo` (Get-ComputerInfo) | ✅ Platform-native |
| **Docker Aliases** | `d`, `dps`, `dcup` | `d`, `dps`, `dcup` | ✅ Identical |
| **Navigation** | `..`, `...`, `cd ~` | `..`, `...`, `~` | ✅ Equivalent |
| **Status Check** | `wsl2-status` | `pwsh-status` | ✅ Platform-specific |
| **Repository Sync** | `./sync-devops-hub.sh` | `.\sync-devops-hub.ps1` | ✅ Platform-native |

## 🆘 Recovery Troubleshooting

### Common Issues and Solutions:

**Issue: PowerShell Execution Policy**
```powershell
# Solution:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

**Issue: Starship Not Installing**
```powershell
# Manual installation:
winget install starship
# Then re-run: .\setup-powershell7-starship.ps1
```

**Issue: Profile Not Loading**
```powershell
# Check profile location:
$PROFILE

# Reload profile:
. $PROFILE

# Test profile syntax:
powershell -NoProfile -Command "& { . '$PROFILE' }"
```

**Issue: Git Commands Not Working**
```powershell
# Install Git:
winget install Git.Git

# Restart PowerShell and test:
git --version
gs  # Should work now
```

## 🔄 Daily Workflow Recovery

### Morning Setup Routine:
```powershell
# 1. Check repository status
cd Bash-DevOps-Hub
.\10-powershell-integration\installers\sync-devops-hub.ps1

# 2. Pull any updates from other environments
.\sync-devops-hub.ps1 -Pull

# 3. Verify everything is working
pwsh-status
show-git-aliases
```

### End of Day Sync:
```powershell
# Push any changes made during the day
.\sync-devops-hub.ps1 -Push -CommitMessage "PowerShell environment updates from $(Get-Date -Format 'yyyy-MM-dd')"
```

## 📚 Related Documentation

- **Main README**: [../README.md](../README.md)
- **PowerShell Integration**: [../10-powershell-integration/README.md](../10-powershell-integration/README.md)
- **Installation Guide**: [../10-powershell-integration/docs/INSTALLATION-GUIDE.md](../10-powershell-integration/docs/INSTALLATION-GUIDE.md)
- **Sync Workflows**: [../10-powershell-integration/docs/SYNC-WORKFLOW.md](../10-powershell-integration/docs/SYNC-WORKFLOW.md)
- **WSL2 Recovery**: [WSL2-SETUP-GUIDE.md](WSL2-SETUP-GUIDE.md)
- **Complete Chat History**: [COMPLETE-CHAT-HISTORY.md](COMPLETE-CHAT-HISTORY.md)

---

**🎯 Goal**: Seamless recovery of your cross-platform development environment in PowerShell 7  
**📍 Repository**: https://github.com/pyzons/Bash-DevOps-Hub  
**⭐ Result**: Identical development experience across all platforms with full chat context preservation!
