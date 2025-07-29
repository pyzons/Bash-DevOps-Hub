# PowerShell 7 Enhanced Profile Installer
# This script installs the enhanced PowerShell profile

param(
    [switch]$Force,
    [switch]$Backup
)

Write-Host "🚀 PowerShell 7 Enhanced Profile Installer" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check if PowerShell 7
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This profile requires PowerShell 7 or later. Current version: $($PSVersionTable.PSVersion)"
    exit 1
}

# Get profile path
$ProfilePath = $PROFILE
Write-Host "Profile location: $ProfilePath" -ForegroundColor Yellow

# Backup existing profile if requested
if ($Backup -and (Test-Path $ProfilePath)) {
    $BackupPath = "$ProfilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $ProfilePath $BackupPath
    Write-Host "✅ Backup created: $BackupPath" -ForegroundColor Green
}

# Check if profile already exists
if ((Test-Path $ProfilePath) -and -not $Force) {
    $response = Read-Host "Profile already exists. Overwrite? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "❌ Installation cancelled." -ForegroundColor Red
        exit 0
    }
}

# Install the enhanced profile
try {
    $EnhancedProfilePath = Join-Path $PSScriptRoot "enhanced-profile.ps1"
    if (-not (Test-Path $EnhancedProfilePath)) {
        Write-Error "Enhanced profile file not found: $EnhancedProfilePath"
        exit 1
    }

    # Create profile directory if it doesn't exist
    $ProfileDir = Split-Path $ProfilePath -Parent
    if (-not (Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }

    # Copy the enhanced profile
    Copy-Item $EnhancedProfilePath $ProfilePath -Force
    Write-Host "✅ Enhanced profile installed successfully!" -ForegroundColor Green

    # Reload the profile
    Write-Host "🔄 Reloading profile..." -ForegroundColor Yellow
    . $PROFILE

    Write-Host "🎉 Installation complete! Your PowerShell experience is now enhanced." -ForegroundColor Green
    Write-Host "💡 Type 'Show-GitAliases' to see available Git shortcuts." -ForegroundColor Cyan

} catch {
    Write-Error "Failed to install profile: $_"
    exit 1
}