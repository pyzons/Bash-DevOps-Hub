# Cleanup Script - Remove Backup Files and Directories
# This script removes all backup directories and temporary files created during reorganization

param(
    [switch]$DryRun,
    [switch]$Force
)

Write-Host "🧹 PowerShell-DevOps-Hub Backup Cleanup Script" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Ensure we're in the correct directory
$repoRoot = "C:\app\PowerShell-DevOps-Hub"
if ((Get-Location).Path -ne $repoRoot) {
    Write-Host "⚠️ Changing to repository root: $repoRoot" -ForegroundColor Yellow
    Set-Location $repoRoot
}

# Find all backup directories and files
$itemsToRemove = @()

# Find backup directories (backup-YYYYMMDD-HHMMSS format)
$backupDirs = Get-ChildItem -Directory | Where-Object { $_.Name -match "^backup-\d{8}-\d{6}$" }
foreach ($dir in $backupDirs) {
    $itemsToRemove += @{
        Path = $dir.FullName
        Type = "Directory"
        Name = $dir.Name
        Size = (Get-ChildItem $dir.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
    }
}

# Find the backups directory (created for K8s backups but empty)
$backupsDir = Get-ChildItem -Directory -Name "backups" -ErrorAction SilentlyContinue
if ($backupsDir) {
    $backupsDirPath = Join-Path $repoRoot "backups"
    $itemsToRemove += @{
        Path = $backupsDirPath
        Type = "Directory" 
        Name = "backups"
        Size = (Get-ChildItem $backupsDirPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    }
}

# Find any other backup-related files
$backupFiles = Get-ChildItem -File | Where-Object { 
    $_.Name -like "*backup*" -or 
    $_.Name -like "*.bak" -or
    $_.Name -like "*~"
}
foreach ($file in $backupFiles) {
    $itemsToRemove += @{
        Path = $file.FullName
        Type = "File"
        Name = $file.Name  
        Size = $file.Length
    }
}

# Show what will be removed
Write-Host ""
Write-Host "📋 Items to be removed:" -ForegroundColor Yellow

if ($itemsToRemove.Count -eq 0) {
    Write-Host "✅ No backup files or directories found to clean up!" -ForegroundColor Green
    return
}

$totalSize = 0
foreach ($item in $itemsToRemove) {
    $sizeStr = if ($item.Size -gt 1MB) { 
        "{0:N1} MB" -f ($item.Size / 1MB) 
    } elseif ($item.Size -gt 1KB) { 
        "{0:N1} KB" -f ($item.Size / 1KB) 
    } else { 
        "$($item.Size) bytes" 
    }
    
    $icon = if ($item.Type -eq "Directory") { "📁" } else { "📄" }
    Write-Host "  $icon $($item.Name) ($sizeStr)" -ForegroundColor White
    $totalSize += $item.Size
}

$totalSizeStr = if ($totalSize -gt 1MB) { 
    "{0:N1} MB" -f ($totalSize / 1MB) 
} elseif ($totalSize -gt 1KB) { 
    "{0:N1} KB" -f ($totalSize / 1KB) 
} else { 
    "$totalSize bytes" 
}

Write-Host ""
Write-Host "💾 Total space to be freed: $totalSizeStr" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host ""
    Write-Host "🔍 DRY RUN MODE - No files will be deleted" -ForegroundColor Yellow
    Write-Host "Run without -DryRun parameter to execute the cleanup" -ForegroundColor Yellow
    return
}

Write-Host ""
if (!$Force) {
    $confirm = Read-Host "Do you want to proceed with cleanup? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "❌ Cleanup cancelled" -ForegroundColor Red
        return
    }
}

Write-Host ""
Write-Host "🚀 Starting cleanup..." -ForegroundColor Green

$removedCount = 0
$freedSpace = 0

foreach ($item in $itemsToRemove) {
    try {
        if ($item.Type -eq "Directory") {
            Remove-Item $item.Path -Recurse -Force
            Write-Host "  🗑️ Removed directory: $($item.Name)" -ForegroundColor Green
        } else {
            Remove-Item $item.Path -Force
            Write-Host "  🗑️ Removed file: $($item.Name)" -ForegroundColor Green
        }
        $removedCount++
        $freedSpace += $item.Size
    } catch {
        Write-Host "  ❌ Failed to remove $($item.Name): $_" -ForegroundColor Red
    }
}

$freedSpaceStr = if ($freedSpace -gt 1MB) { 
    "{0:N1} MB" -f ($freedSpace / 1MB) 
} elseif ($freedSpace -gt 1KB) { 
    "{0:N1} KB" -f ($freedSpace / 1KB) 
} else { 
    "$freedSpace bytes" 
}

Write-Host ""
Write-Host "✅ Cleanup completed!" -ForegroundColor Green
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  • Items removed: $removedCount" -ForegroundColor White  
Write-Host "  • Space freed: $freedSpaceStr" -ForegroundColor White

# Show current directory structure
Write-Host ""
Write-Host "📁 Current repository structure:" -ForegroundColor Yellow
Get-ChildItem | Sort-Object Name | ForEach-Object {
    if ($_.PSIsContainer) {
        Write-Host "  📁 $($_.Name)/" -ForegroundColor Cyan
    } else {
        Write-Host "  📄 $($_.Name)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "🎯 Ready for git sync!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. git add ." -ForegroundColor White
Write-Host "2. git commit -m 'Clean up repository structure'" -ForegroundColor White  
Write-Host "3. git push" -ForegroundColor White
Write-Host ""
Write-Host "💡 You can now safely delete this cleanup script and the reorganize script" -ForegroundColor Yellow
