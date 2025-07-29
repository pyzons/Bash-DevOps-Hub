# PowerShell-DevOps-Hub Repository Reorganization Script
# This script reorganizes the repository structure for better organization
# Run this script from the root of the repository

param(
    [switch]$DryRun,
    [switch]$Force
)

Write-Host "🔄 PowerShell-DevOps-Hub Repository Reorganization Script" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# Ensure we're in the correct directory
$repoRoot = "C:\app\PowerShell-DevOps-Hub"
if ((Get-Location).Path -ne $repoRoot) {
    Write-Host "⚠️ Changing to repository root: $repoRoot" -ForegroundColor Yellow
    Set-Location $repoRoot
}

# Backup current state
$backupDir = "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
if (!$DryRun) {
    Write-Host "💾 Creating backup in: $backupDir" -ForegroundColor Green
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    # List of files to backup (exclude .git and existing directories)
    $filesToBackup = Get-ChildItem -File | Where-Object { $_.Name -notlike "reorganize-repo.ps1" }
    foreach ($file in $filesToBackup) {
        Copy-Item $file.FullName -Destination $backupDir -Force
    }
}

# Define the reorganization plan
$reorganizationPlan = @{
    # Documentation files
    "docs/chat-ai/" = @(
        "CHAT-CONTEXT-PRESERVATION.md",
        "CHAT-SESSION-SUMMARY.md", 
        "COMPLETE-CHAT-HISTORY-20250728.md",
        "EXTRACT-CHAT-METHODS.md",
        "SCREENSHOT-BACKUP-METHOD.md"
    )
    "docs/setup/" = @(
        "DOCKER-SETUP.md",
        "KUBERNETES-SETUP.md",
        "KIND-WINDOWS-BEST-PRACTICES.md",
        "WSL2-vs-DOCKER-DESKTOP.md",
        "REBOOT-RECOVERY-GUIDE.md",
        "HOW-TO-CONTINUE.md"
    )
    
    # Configuration files
    "config/docker/" = @(
        "docker-compose.example.yml",
        "Dockerfile.example",
        ".dockerignore.example"
    )
    "config/kubernetes/" = @(
        "kind-dev-config.yaml",
        "kind-prod-config.yaml"
    )
    
    # Scripts
    "scripts/powershell/" = @(
        "enhanced-profile.ps1",
        "Install-Profile.ps1",
        "Microsoft.PowerShell_profile.ps1",
        "setup-omp.ps1",
        "test_profile.ps1",
        "RECREATE-CHAT-CONTEXT.ps1"
    )
    "scripts/migration/" = @(
        "migrate-to-new-repo.ps1",
        "rename-workspace.ps1"
    )
    "scripts/setup/" = @(
        "github-setup-commands.txt"
    )
}

# Files to keep in root
$keepInRoot = @(
    "README.md",
    ".gitignore",
    "PowerShell-DevOps-Hub.code-workspace",
    "ws.code-workspace"
)

Write-Host ""
Write-Host "📋 Reorganization Plan:" -ForegroundColor Yellow

function Show-Plan {
    foreach ($targetDir in $reorganizationPlan.Keys | Sort-Object) {
        Write-Host "  📁 $targetDir" -ForegroundColor Cyan
        foreach ($file in $reorganizationPlan[$targetDir]) {
            if (Test-Path $file) {
                Write-Host "    📄 $file" -ForegroundColor White
            } else {
                Write-Host "    ❌ $file (not found)" -ForegroundColor Red
            }
        }
    }
    
    Write-Host "  📁 ROOT (keeping these files):" -ForegroundColor Green
    foreach ($file in $keepInRoot) {
        if (Test-Path $file) {
            Write-Host "    📄 $file" -ForegroundColor White
        } else {
            Write-Host "    ❌ $file (not found)" -ForegroundColor Red
        }
    }
}

Show-Plan

if ($DryRun) {
    Write-Host ""
    Write-Host "🔍 DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host "Run without -DryRun parameter to execute the reorganization" -ForegroundColor Yellow
    return
}

Write-Host ""
if (!$Force) {
    $confirm = Read-Host "Do you want to proceed with reorganization? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "❌ Operation cancelled" -ForegroundColor Red
        return
    }
}

Write-Host ""
Write-Host "🚀 Starting reorganization..." -ForegroundColor Green

# Create directory structure and move files
$totalMoved = 0
foreach ($targetDir in $reorganizationPlan.Keys) {
    Write-Host "📁 Processing directory: $targetDir" -ForegroundColor Cyan
    
    # Create target directory
    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "  ✅ Created directory: $targetDir" -ForegroundColor Green
    }
    
    # Move files
    foreach ($file in $reorganizationPlan[$targetDir]) {
        if (Test-Path $file) {
            try {
                Move-Item $file -Destination $targetDir -Force
                Write-Host "  ✅ Moved: $file → $targetDir" -ForegroundColor Green
                $totalMoved++
            } catch {
                Write-Host "  ❌ Failed to move $file : $_" -ForegroundColor Red
            }
        } else {
            Write-Host "  ⚠️ File not found: $file" -ForegroundColor Yellow
        }
    }
}

# Clean up empty directories (if any)
$emptyDirs = Get-ChildItem -Directory | Where-Object { 
    (Get-ChildItem $_.FullName -Recurse -File).Count -eq 0 -and 
    $_.Name -notlike "backup-*" -and
    $_.Name -ne ".git" -and
    $_.Name -ne ".vscode" -and
    $_.Name -ne "test-repo"
}

foreach ($dir in $emptyDirs) {
    Write-Host "🗑️ Removing empty directory: $($dir.Name)" -ForegroundColor Gray
    Remove-Item $dir.FullName -Recurse -Force
}

Write-Host ""
Write-Host "✅ Reorganization completed!" -ForegroundColor Green
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  • Files moved: $totalMoved" -ForegroundColor White
Write-Host "  • Backup created: $backupDir" -ForegroundColor White
Write-Host ""

# Show final structure
Write-Host "📁 New repository structure:" -ForegroundColor Yellow
Get-ChildItem -Directory | Sort-Object Name | ForEach-Object {
    Write-Host "  📁 $($_.Name)/" -ForegroundColor Cyan
    Get-ChildItem $_.FullName -File | Sort-Object Name | ForEach-Object {
        Write-Host "    📄 $($_.Name)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "📄 Files remaining in root:" -ForegroundColor Yellow
Get-ChildItem -File | Where-Object { $_.Name -notlike "backup-*" -and $_.Name -ne "reorganize-repo.ps1" } | Sort-Object Name | ForEach-Object {
    Write-Host "  📄 $($_.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Green
Write-Host "1. Review the changes and test your setup" -ForegroundColor White
Write-Host "2. Update any scripts that reference old file paths" -ForegroundColor White
Write-Host "3. Commit the changes to git: git add . && git commit -m 'Reorganize repository structure'" -ForegroundColor White
Write-Host "4. If satisfied, remove the backup folder and this script" -ForegroundColor White
Write-Host ""
Write-Host "⚠️ Important: Update enhanced-profile.ps1 paths after reorganization!" -ForegroundColor Yellow
