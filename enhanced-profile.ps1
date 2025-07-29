# PowerShell 7 Profile Enhancements
# This file contains recommended optimizations for your PowerShell 7 setup

# Import posh-git for Git integration in prompt
Import-Module posh-git

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
Set-Alias -Name la -Value 'Get-ChildItem -Force'
Set-Alias -Name .. -Value 'Set-Location ..'
Set-Alias -Name ... -Value 'Set-Location ..\..'

# Function to quickly navigate to common directories
function cdws { Set-Location "c:\app\ws" }
function cdprof { Set-Location (Split-Path $PROFILE) }

# Enhanced prompt (optional - remove if you use Oh My Posh)
function prompt {
    $location = Get-Location
    $gitInfo = if (Get-GitStatus -eq $null) { "" } else { " $(Write-VcsStatus)" }
    "PS $location$gitInfo> "
}

Write-Host "PowerShell 7 Profile Loaded Successfully!" -ForegroundColor Green
