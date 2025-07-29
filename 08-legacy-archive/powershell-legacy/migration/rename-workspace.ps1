# PowerShell-DevOps-Hub Directory Rename Script
# Run this after repository migration is complete

Write-Host "📁 PowerShell-DevOps-Hub Directory Rename" -ForegroundColor Green
Write-Host "=" * 50

# Check if VS Code is running
$vscodeProcess = Get-Process "Code" -ErrorAction SilentlyContinue
if ($vscodeProcess) {
    Write-Host "⚠️  VS Code is currently running!" -ForegroundColor Yellow
    Write-Host "Please close VS Code before running this script." -ForegroundColor White
    Write-Host "Current VS Code processes:" -ForegroundColor Cyan
    $vscodeProcess | Select-Object ProcessName, Id | Format-Table
    exit 1
}

# Navigate to parent directory
Set-Location c:\app

# Check if target directory already exists
if (Test-Path "PowerShell-DevOps-Hub") {
    Write-Host "⚠️  Directory 'PowerShell-DevOps-Hub' already exists!" -ForegroundColor Yellow
    $response = Read-Host "Do you want to overwrite it? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "❌ Operation cancelled" -ForegroundColor Red
        exit 1
    }
    Remove-Item "PowerShell-DevOps-Hub" -Recurse -Force
}

# Rename directory
try {
    Rename-Item -Path "ws" -NewName "PowerShell-DevOps-Hub"
    Write-Host "✅ Directory renamed successfully!" -ForegroundColor Green
    Write-Host "📍 New location: c:\app\PowerShell-DevOps-Hub" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Failed to rename directory: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Make sure VS Code is closed and no processes are using the directory" -ForegroundColor Yellow
    exit 1
}

# Update git remote URL in case it changed
Set-Location "PowerShell-DevOps-Hub"
Write-Host "🔧 Updating workspace configuration..." -ForegroundColor Yellow

# Verify the workspace file exists
if (Test-Path "PowerShell-DevOps-Hub.code-workspace") {
    Write-Host "✅ Workspace configuration found" -ForegroundColor Green
} else {
    Write-Host "⚠️  Workspace configuration not found" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 DIRECTORY RENAME COMPLETE!" -ForegroundColor Green
Write-Host "=" * 50
Write-Host "📍 New workspace location: c:\app\PowerShell-DevOps-Hub" -ForegroundColor Cyan
Write-Host "📂 Open workspace: PowerShell-DevOps-Hub.code-workspace" -ForegroundColor Cyan
Write-Host ""
Write-Host "To open your workspace:" -ForegroundColor Yellow
Write-Host "code PowerShell-DevOps-Hub.code-workspace" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Your PowerShell-DevOps-Hub is ready!" -ForegroundColor Green
