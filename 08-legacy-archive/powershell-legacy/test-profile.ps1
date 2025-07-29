# PowerShell 7 Profile Enhancements - Test Version
# This file contains recommended optimizations for your PowerShell 7 setup

# Enhanced PSReadLine configuration
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord

# Useful aliases for Git
Set-Alias -Name g -Value git
function gs { git status $args }
function ga { git add $args }
function gc { git commit $args }
function gp { git push $args }
function gl { git log --oneline $args }
function gd { git diff $args }
function gb { git branch $args }
function gco { git checkout $args }

# Useful aliases for common commands
Set-Alias -Name ll -Value Get-ChildItem
function la { Get-ChildItem -Force $args }
function .. { Set-Location .. }
function ... { Set-Location ../.. }

# Function to quickly navigate to common directories
function cdws { Set-Location "C:\app\PowerShell-DevOps-Hub" }
function cdprof { Set-Location (Split-Path $PROFILE) }

Write-Host "Basic PowerShell Profile Loaded!" -ForegroundColor Green
