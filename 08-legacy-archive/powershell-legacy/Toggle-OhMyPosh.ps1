# Toggle Oh My Posh Theme Script
# This script helps you switch between different Oh My Posh themes or disable Oh My Posh

param(
    [string]$Theme = "",
    [switch]$List,
    [switch]$Disable,
    [switch]$Enable
)

Write-Host "🎨 Oh My Posh Theme Manager" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

if ($List) {
    Write-Host "📋 Available Oh My Posh themes:" -ForegroundColor Yellow
    oh-my-posh theme list
    exit 0
}

if ($Disable) {
    Write-Host "❌ Disabling Oh My Posh..." -ForegroundColor Yellow
    Write-Host "Note: You need to restart PowerShell for this to take effect" -ForegroundColor Gray
    Write-Host "Or manually reload your profile with: . `$PROFILE" -ForegroundColor Gray
    # Here you could modify the profile to comment out Oh My Posh initialization
    exit 0
}

if ($Enable) {
    Write-Host "✅ Enabling Oh My Posh..." -ForegroundColor Green
    oh-my-posh init pwsh | Invoke-Expression
    Write-Host "Oh My Posh enabled for current session!" -ForegroundColor Green
    exit 0
}

if ($Theme) {
    Write-Host "🎯 Switching to theme: $Theme" -ForegroundColor Green
    $env:POSH_THEME = $Theme
    oh-my-posh init pwsh | Invoke-Expression
    Write-Host "Theme applied! Current session now using: $Theme" -ForegroundColor Green
    Write-Host "💡 To make this permanent, set POSH_THEME environment variable" -ForegroundColor Cyan
    exit 0
}

# Show current status
Write-Host "📊 Current Oh My Posh Status:" -ForegroundColor Yellow
Write-Host "Version: $(oh-my-posh --version)" -ForegroundColor White
Write-Host "Shell: $(oh-my-posh get shell)" -ForegroundColor White

if ($env:POSH_THEME) {
    Write-Host "Current Theme: $env:POSH_THEME" -ForegroundColor White
} else {
    Write-Host "Current Theme: Default" -ForegroundColor White
}

Write-Host ""
Write-Host "💡 Usage Examples:" -ForegroundColor Cyan
Write-Host "  .\Toggle-OhMyPosh.ps1 -List                    # List all themes" -ForegroundColor Gray
Write-Host "  .\Toggle-OhMyPosh.ps1 -Theme agnoster           # Switch to agnoster theme" -ForegroundColor Gray
Write-Host "  .\Toggle-OhMyPosh.ps1 -Theme paradox            # Switch to paradox theme" -ForegroundColor Gray
Write-Host "  .\Toggle-OhMyPosh.ps1 -Enable                   # Enable Oh My Posh" -ForegroundColor Gray
Write-Host "  .\Toggle-OhMyPosh.ps1 -Disable                  # Disable Oh My Posh" -ForegroundColor Gray
