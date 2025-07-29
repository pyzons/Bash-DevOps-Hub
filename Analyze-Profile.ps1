# PowerShell 7 Profile Analysis Script
# Comprehensive analysis of the current PowerShell 7 profile

Write-Host "🔍 PowerShell 7 Profile Analysis" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Basic Profile Information
Write-Host ""
Write-Host "📍 Basic Information:" -ForegroundColor Yellow
Write-Host "Profile Path: $PROFILE" -ForegroundColor White
Write-Host "Profile Exists: $(Test-Path $PROFILE)" -ForegroundColor White
if (Test-Path $PROFILE) {
    $profileInfo = Get-Item $PROFILE
    Write-Host "Profile Size: $($profileInfo.Length) bytes" -ForegroundColor White
    Write-Host "Last Modified: $($profileInfo.LastWriteTime)" -ForegroundColor White
}

# Module Analysis
Write-Host ""
Write-Host "📦 Loaded Modules:" -ForegroundColor Yellow
Get-Module | Select-Object Name, Version, Path | Format-Table -AutoSize

# Git Functions Analysis
Write-Host ""
Write-Host "🔧 Git Functions & Aliases:" -ForegroundColor Yellow
$gitCommands = @('g', 'gs', 'ga', 'gc', 'gp', 'gl', 'gd', 'gb', 'gco')
foreach ($cmd in $gitCommands) {
    $command = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($command) {
        $type = $command.CommandType
        $definition = if ($command.Definition.Length -gt 50) { 
            $command.Definition.Substring(0, 47) + "..." 
        } else { 
            $command.Definition 
        }
        Write-Host "  $cmd ($type): $definition" -ForegroundColor White
    } else {
        Write-Host "  $cmd: Not found" -ForegroundColor Red
    }
}

# Docker Functions Analysis
Write-Host ""
Write-Host "🐳 Docker Functions & Aliases:" -ForegroundColor Yellow
$dockerCommands = @('d', 'dps', 'dpsa', 'di', 'drun', 'dexec', 'dlog', 'dstop', 'dstart', 'drm', 'dprune')
foreach ($cmd in $dockerCommands) {
    $command = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($command) {
        $type = $command.CommandType
        $definition = if ($command.Definition.Length -gt 50) { 
            $command.Definition.Substring(0, 47) + "..." 
        } else { 
            $command.Definition 
        }
        Write-Host "  $cmd ($type): $definition" -ForegroundColor White
    } else {
        Write-Host "  $cmd: Not found" -ForegroundColor Red
    }
}

# Kubernetes Functions Analysis
Write-Host ""
Write-Host "☸️ Kubernetes Functions & Aliases:" -ForegroundColor Yellow
$k8sCommands = @('k', 'kgp', 'kgs', 'kgd', 'kgn', 'kga', 'kdp', 'kds', 'kl', 'kex')
foreach ($cmd in $k8sCommands) {
    $command = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($command) {
        $type = $command.CommandType
        $definition = if ($command.Definition.Length -gt 50) { 
            $command.Definition.Substring(0, 47) + "..." 
        } else { 
            $command.Definition 
        }
        Write-Host "  $cmd ($type): $definition" -ForegroundColor White
    } else {
        Write-Host "  $cmd: Not found" -ForegroundColor Red
    }
}

# Enhanced Functions Analysis
Write-Host ""
Write-Host "⚡ Enhanced Profile Functions:" -ForegroundColor Yellow
$enhancedFunctions = Get-Command -CommandType Function | Where-Object { 
    $_.Name -match '^(Show-|K8s-|kind-|Check-|Resume-Work|Docker-)' -and $_.Source -eq ''
}
$enhancedFunctions | Select-Object Name, @{Name='Description'; Expression={
    switch -Regex ($_.Name) {
        '^Show-' { 'Display helper function' }
        '^K8s-' { 'Kubernetes management' }
        '^kind-' { 'KIND cluster management' }
        '^Check-' { 'System check function' }
        '^Docker-' { 'Docker utility function' }
        'Resume-Work' { 'Development environment setup' }
        default { 'Custom function' }
    }
}} | Format-Table -AutoSize

# PSReadLine Configuration Check
Write-Host ""
Write-Host "📝 PSReadLine Configuration:" -ForegroundColor Yellow
try {
    if (Get-Module PSReadLine) {
        Write-Host "  PSReadLine Version: $((Get-Module PSReadLine).Version)" -ForegroundColor White
        $options = Get-PSReadLineOption
        Write-Host "  Edit Mode: $($options.EditMode)" -ForegroundColor White
        Write-Host "  Prediction Source: $($options.PredictionSource)" -ForegroundColor White
        Write-Host "  Prediction View: $($options.PredictionViewStyle)" -ForegroundColor White
    } else {
        Write-Host "  PSReadLine not loaded" -ForegroundColor Red
    }
} catch {
    Write-Host "  Error reading PSReadLine configuration: $($_.Exception.Message)" -ForegroundColor Red
}

# Common Directory Functions
Write-Host ""
Write-Host "📁 Directory Navigation Functions:" -ForegroundColor Yellow
$dirCommands = @('ll', 'la', '..', '...', 'cdws', 'cdprof')
foreach ($cmd in $dirCommands) {
    $command = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($command) {
        $type = $command.CommandType
        $definition = if ($command.Definition.Length -gt 50) { 
            $command.Definition.Substring(0, 47) + "..." 
        } else { 
            $command.Definition 
        }
        Write-Host "  $cmd ($type): $definition" -ForegroundColor White
    } else {
        Write-Host "  $cmd: Not found" -ForegroundColor Red
    }
}

# Profile Health Check
Write-Host ""
Write-Host "🏥 Profile Health Check:" -ForegroundColor Yellow
$healthIssues = @()

# Check for alias conflicts
$conflicts = @()
if ((Get-Command gc).CommandType -eq 'Alias' -and (Get-Command gc).Definition -ne 'git commit $args') {
    $conflicts += 'gc (conflicts with Get-Content)'
}
if ((Get-Command gp).CommandType -eq 'Alias' -and (Get-Command gp).Definition -ne 'git push $args') {
    $conflicts += 'gp (conflicts with Get-ItemProperty)'
}
if ((Get-Command gl).CommandType -eq 'Alias' -and (Get-Command gl).Definition -ne 'git log --oneline $args') {
    $conflicts += 'gl (conflicts with Get-Location)'
}

if ($conflicts.Count -gt 0) {
    Write-Host "  ⚠️ Alias Conflicts Detected:" -ForegroundColor Yellow
    $conflicts | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
    $healthIssues += "Alias conflicts"
} else {
    Write-Host "  ✅ No alias conflicts detected" -ForegroundColor Green
}

# Check if Show-GitAliases works
try {
    $null = Get-Command Show-GitAliases -ErrorAction Stop
    Write-Host "  ✅ Show-GitAliases function available" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Show-GitAliases function not available" -ForegroundColor Red
    $healthIssues += "Show-GitAliases missing"
}

# Summary
Write-Host ""
Write-Host "📊 Analysis Summary:" -ForegroundColor Yellow
if ($healthIssues.Count -eq 0) {
    Write-Host "  ✅ Profile is healthy and fully functional!" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ Issues found: $($healthIssues -join ', ')" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 Profile Analysis Complete!" -ForegroundColor Green
