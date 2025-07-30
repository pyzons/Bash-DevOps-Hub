# 🔄 Repository Sync Workflow

## 🎯 Overview
This guide explains how to keep your PowerShell 7 setup synchronized between different machines and environments using Git.

## 📋 Sync Scenarios

### Scenario 1: WSL2/Linux → Windows 11
You make changes in your WSL2 bash environment and want to sync them to Windows 11 PowerShell 7.

### Scenario 2: Windows 11 → WSL2/Linux  
You update your PowerShell setup and want to sync changes back to your bash environment.

### Scenario 3: Multiple Windows Machines
You want identical PowerShell 7 setup across multiple Windows 11 machines.

## 🚀 Basic Sync Workflow

### From WSL2/Linux (Push Changes):
```bash
# In your WSL2 bash environment
cd Bash-DevOps-Hub

# Add any new changes
git add .

# Commit with descriptive message
git commit -m "Update PowerShell integration: add new aliases"

# Push to remote repository
git push origin main
```

### To Windows 11 PowerShell 7 (Pull Changes):
```powershell
# In your Windows 11 PowerShell 7
cd Bash-DevOps-Hub

# Pull latest changes
git pull origin main

# If there are PowerShell-specific updates, re-run installer
cd 10-powershell-integration\installers
.\setup-powershell7-starship.ps1
```

## 🔧 Automated Sync Scripts

### Create Windows Sync Script

<function_calls>
<invoke name="create_file">
<parameter name="content"># PowerShell 7 Repository Sync Script
# Save as: sync-devops-hub.ps1

param(
    [switch]$Pull,
    [switch]$Push,
    [string]$CommitMessage = "Update PowerShell DevOps Hub configuration"
)

# Colors for output
function Write-Status {
    param([string]$Message, [string]$Color = "Cyan")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

Write-Status "🔄 Bash DevOps Hub - Repository Sync" "Cyan"
Write-Status "===================================" "Cyan"

# Verify we're in the right directory
if (-not (Test-Path "10-powershell-integration")) {
    Write-Error "❌ Not in Bash-DevOps-Hub directory. Please run from repository root."
    exit 1
}

# Check Git status
$GitStatus = git status --porcelain 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Not a Git repository or Git not available"
    exit 1
}

if ($Pull) {
    Write-Status "📥 Pulling latest changes from remote..." "Yellow"
    
    # Check for local changes
    if ($GitStatus) {
        Write-Warning "Local changes detected. Stashing before pull..."
        git stash push -m "Auto-stash before sync pull $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    
    # Pull changes
    git pull origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Repository updated successfully"
        
        # Check if PowerShell files were updated
        $PowerShellFiles = git diff --name-only HEAD~1 HEAD | Where-Object { $_ -like "*10-powershell-integration*" -or $_ -like "*.ps1" }
        
        if ($PowerShellFiles) {
            Write-Status "🔧 PowerShell files were updated. Consider re-running installer:" "Yellow"
            Write-Host "  .\10-powershell-integration\installers\setup-powershell7-starship.ps1" -ForegroundColor Cyan
        }
        
        # Restore stashed changes if any
        $StashList = git stash list
        if ($StashList -and $StashList[0] -like "*Auto-stash before sync pull*") {
            Write-Status "📤 Restoring local changes..." "Yellow"
            git stash pop
        }
    } else {
        Write-Error "❌ Failed to pull changes"
        exit 1
    }
}

if ($Push) {
    Write-Status "📤 Pushing local changes to remote..." "Yellow"
    
    # Check for changes to commit
    if (-not $GitStatus) {
        Write-Warning "No local changes to push"
        return
    }
    
    # Show what will be committed
    Write-Status "📋 Files to be committed:" "Yellow"
    git status --short
    
    # Add all changes
    git add .
    
    # Commit with message
    git commit -m $CommitMessage
    
    # Push to remote
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Changes pushed successfully"
    } else {
        Write-Error "❌ Failed to push changes"
        exit 1
    }
}

if (-not $Pull -and -not $Push) {
    Write-Status "📊 Repository Status:" "Yellow"
    
    # Show current branch and status
    $Branch = git branch --show-current
    Write-Host "Current branch: $Branch" -ForegroundColor Cyan
    
    # Show status
    if ($GitStatus) {
        Write-Status "📝 Local changes:" "Yellow"
        git status --short
    } else {
        Write-Success "Working directory clean"
    }
    
    # Show remote status
    git fetch origin --quiet
    $Behind = git rev-list --count HEAD..origin/main 2>$null
    $Ahead = git rev-list --count origin/main..HEAD 2>$null
    
    if ($Behind -gt 0) {
        Write-Warning "Behind remote by $Behind commits. Run with -Pull to update."
    }
    
    if ($Ahead -gt 0) {
        Write-Warning "Ahead of remote by $Ahead commits. Run with -Push to sync."
    }
    
    if ($Behind -eq 0 -and $Ahead -eq 0) {
        Write-Success "In sync with remote repository"
    }
    
    Write-Status "`n🚀 Usage:" "Cyan"
    Write-Host "  .\sync-devops-hub.ps1 -Pull                    # Pull latest changes" -ForegroundColor Gray
    Write-Host "  .\sync-devops-hub.ps1 -Push                    # Push local changes" -ForegroundColor Gray
    Write-Host "  .\sync-devops-hub.ps1 -Push -CommitMessage 'msg' # Push with custom message" -ForegroundColor Gray
}

Write-Status "`n✨ Sync operation completed!" "Green"
