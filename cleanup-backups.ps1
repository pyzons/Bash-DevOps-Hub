# PowerShell-DevOps-Hub Backup Cleanup Script
# This script cleans up old backup files to save disk space

param(
    [int]$DaysToKeep = 30,
    [switch]$DryRun,
    [switch]$Force
)

Write-Host "🧹 PowerShell-DevOps-Hub Backup Cleanup Script" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# Define backup directories to clean
$backupDirectories = @(
    "C:\app\PowerShell-DevOps-Hub\k8s-backups",
    "C:\app\PowerShell-DevOps-Hub\backup-*"
)

$cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
Write-Host "🗓️ Cleaning backups older than: $($cutoffDate.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow

$totalFilesFound = 0
$totalSizeFreed = 0

foreach ($backupPath in $backupDirectories) {
    if ($backupPath -contains "*") {
        # Handle wildcard paths
        $matchingDirs = Get-ChildItem -Path (Split-Path $backupPath) -Directory -Filter (Split-Path $backupPath -Leaf) -ErrorAction SilentlyContinue
        foreach ($dir in $matchingDirs) {
            $oldFiles = Get-ChildItem -Path $dir.FullName -File | Where-Object { $_.LastWriteTime -lt $cutoffDate }
            
            if ($oldFiles) {
                Write-Host "📁 Processing directory: $($dir.FullName)" -ForegroundColor Cyan
                
                foreach ($file in $oldFiles) {
                    $totalFilesFound++
                    $fileSize = $file.Length
                    $totalSizeFreed += $fileSize
                    
                    if ($DryRun) {
                        Write-Host "  [DRY RUN] Would delete: $($file.Name) ($(($fileSize / 1MB).ToString('0.2')) MB)" -ForegroundColor Gray
                    } else {
                        Write-Host "  🗑️ Deleting: $($file.Name) ($(($fileSize / 1MB).ToString('0.2')) MB)" -ForegroundColor Red
                        Remove-Item $file.FullName -Force
                    }
                }
            }
        }
    } else {
        # Handle specific directory paths
        if (Test-Path $backupPath) {
            $oldFiles = Get-ChildItem -Path $backupPath -File | Where-Object { $_.LastWriteTime -lt $cutoffDate }
            
            if ($oldFiles) {
                Write-Host "📁 Processing directory: $backupPath" -ForegroundColor Cyan
                
                foreach ($file in $oldFiles) {
                    $totalFilesFound++
                    $fileSize = $file.Length
                    $totalSizeFreed += $fileSize
                    
                    if ($DryRun) {
                        Write-Host "  [DRY RUN] Would delete: $($file.Name) ($(($fileSize / 1MB).ToString('0.2')) MB)" -ForegroundColor Gray
                    } else {
                        Write-Host "  🗑️ Deleting: $($file.Name) ($(($fileSize / 1MB).ToString('0.2')) MB)" -ForegroundColor Red
                        Remove-Item $file.FullName -Force
                    }
                }
            }
        } else {
            Write-Host "📁 Directory not found: $backupPath" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "📊 Cleanup Summary:" -ForegroundColor Green
Write-Host "Files processed: $totalFilesFound" -ForegroundColor White
Write-Host "Space $(if ($DryRun) { 'would be freed' } else { 'freed' }): $(($totalSizeFreed / 1MB).ToString('0.2')) MB" -ForegroundColor White

if ($DryRun) {
    Write-Host ""
    Write-Host "💡 This was a dry run. Use -Force to actually delete files." -ForegroundColor Cyan
    Write-Host "Example: .\cleanup-backups.ps1 -DaysToKeep 30 -Force" -ForegroundColor Gray
}

if ($totalFilesFound -eq 0) {
    Write-Host "✅ No old backup files found to clean up!" -ForegroundColor Green
} else {
    if (!$DryRun) {
        Write-Host "✅ Backup cleanup completed!" -ForegroundColor Green
    }
}
