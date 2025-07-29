# Install Enhanced PowerShell 7 Profile
# This script copies the enhanced profile to your PowerShell 7 profile location

param(
    [switch]$Backup,
    [switch]$Force
)

Write-Host "🚀 Installing Enhanced PowerShell 7 Profile" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

$profilePath = $PROFILE
$enhancedProfilePath = Join-Path $PSScriptRoot "enhanced-profile.ps1"

Write-Host "PowerShell 7 Profile Location: $profilePath" -ForegroundColor Yellow
Write-Host "Enhanced Profile Source: $enhancedProfilePath" -ForegroundColor Yellow

# Check if source file exists
if (!(Test-Path $enhancedProfilePath)) {
    Write-Host "❌ Enhanced profile source file not found: $enhancedProfilePath" -ForegroundColor Red
    exit 1
}

# Create profile directory if it doesn't exist
$profileDir = Split-Path $profilePath
if (!(Test-Path $profileDir)) {
    Write-Host "📁 Creating profile directory: $profileDir" -ForegroundColor Green
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Backup existing profile if requested
if ($Backup -and (Test-Path $profilePath)) {
    $backupPath = "$profilePath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "💾 Backing up existing profile to: $backupPath" -ForegroundColor Green
    Copy-Item $profilePath $backupPath
}

# Check if profile exists and prompt if not forcing
if ((Test-Path $profilePath) -and !$Force) {
    Write-Host "⚠️ PowerShell 7 profile already exists." -ForegroundColor Yellow
    $response = Read-Host "Do you want to replace it? (y/N)"
    if ($response -notmatch '^[Yy]') {
        Write-Host "❌ Installation cancelled." -ForegroundColor Red
        exit 0
    }
}

# Copy the enhanced profile
try {
    Write-Host "📋 Installing enhanced profile..." -ForegroundColor Green
    Copy-Item $enhancedProfilePath $profilePath -Force
    Write-Host "✅ Enhanced PowerShell 7 profile installed successfully!" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Restart PowerShell 7 or run: . `$PROFILE" -ForegroundColor White
    Write-Host "2. Test the installation with: Show-GitAliases" -ForegroundColor White
    Write-Host "3. Explore available commands:" -ForegroundColor White
    Write-Host "   • Show-GitAliases" -ForegroundColor Gray
    Write-Host "   • Show-DockerAliases" -ForegroundColor Gray
    Write-Host "   • Show-KubernetesAliases" -ForegroundColor Gray
    Write-Host "   • K8s-QuickStart" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Failed to install enhanced profile: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "💡 Tip: Use 'Install-Profile.ps1 -Backup' to backup your existing profile before installation." -ForegroundColor Cyan
