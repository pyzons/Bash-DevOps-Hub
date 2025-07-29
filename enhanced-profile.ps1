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

# Docker aliases and functions for faster workflow
Set-Alias -Name d -Value docker
function dps { docker ps $args }
function dpsa { docker ps -a $args }
function di { docker images $args }
function drmi { docker rmi $args }
function drun { docker run $args }
function dexec { docker exec -it $args }
function dlog { docker logs $args }
function dlogf { docker logs -f $args }
function dstop { docker stop $args }
function dstart { docker start $args }
function drm { docker rm $args }
function dprune { docker system prune $args }
function dbuild { docker build $args }
function dpull { docker pull $args }
function dpush { docker push $args }

# Docker Compose aliases
Set-Alias -Name dc -Value docker-compose
function dcup { docker-compose up $args }
function dcupd { docker-compose up -d $args }
function dcdown { docker-compose down $args }
function dcps { docker-compose ps $args }
function dclogs { docker-compose logs $args }
function dclogsf { docker-compose logs -f $args }
function dcbuild { docker-compose build $args }
function dcpull { docker-compose pull $args }
function dcrestart { docker-compose restart $args }

# Advanced Docker functions
function Show-DockerAliases {
    Write-Host "Available Docker Aliases:" -ForegroundColor Green
    Write-Host "Basic Docker Commands:" -ForegroundColor Yellow
    Write-Host "d      - docker" -ForegroundColor White
    Write-Host "dps    - docker ps" -ForegroundColor White
    Write-Host "dpsa   - docker ps -a" -ForegroundColor White
    Write-Host "di     - docker images" -ForegroundColor White
    Write-Host "drun   - docker run" -ForegroundColor White
    Write-Host "dexec  - docker exec -it" -ForegroundColor White
    Write-Host "dlog   - docker logs" -ForegroundColor White
    Write-Host "dlogf  - docker logs -f" -ForegroundColor White
    Write-Host "dstop  - docker stop" -ForegroundColor White
    Write-Host "dstart - docker start" -ForegroundColor White
    Write-Host "drm    - docker rm" -ForegroundColor White
    Write-Host "drmi   - docker rmi" -ForegroundColor White
    Write-Host "dbuild - docker build" -ForegroundColor White
    Write-Host "dpull  - docker pull" -ForegroundColor White
    Write-Host "dpush  - docker push" -ForegroundColor White
    Write-Host "dprune - docker system prune" -ForegroundColor White
    Write-Host ""
    Write-Host "Docker Compose Commands:" -ForegroundColor Yellow
    Write-Host "dc       - docker-compose" -ForegroundColor White
    Write-Host "dcup     - docker-compose up" -ForegroundColor White
    Write-Host "dcupd    - docker-compose up -d" -ForegroundColor White
    Write-Host "dcdown   - docker-compose down" -ForegroundColor White
    Write-Host "dcps     - docker-compose ps" -ForegroundColor White
    Write-Host "dclogs   - docker-compose logs" -ForegroundColor White
    Write-Host "dclogsf  - docker-compose logs -f" -ForegroundColor White
    Write-Host "dcbuild  - docker-compose build" -ForegroundColor White
    Write-Host "dcpull   - docker-compose pull" -ForegroundColor White
    Write-Host "dcrestart- docker-compose restart" -ForegroundColor White
}

function Docker-CleanAll {
    Write-Host "🧹 Cleaning up Docker resources..." -ForegroundColor Yellow
    docker system prune -af --volumes
    Write-Host "✅ Docker cleanup completed!" -ForegroundColor Green
}

function Docker-Stats {
    Write-Host "📊 Docker System Information:" -ForegroundColor Cyan
    docker system df
    Write-Host ""
    Write-Host "🏃 Running Containers:" -ForegroundColor Cyan
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

# Enhanced prompt (optional - remove if you use Oh My Posh)
function prompt {
    $location = Get-Location
    $gitInfo = if (Get-GitStatus -eq $null) { "" } else { " $(Write-VcsStatus)" }
    "PS $location$gitInfo> "
}

Write-Host "PowerShell 7 Profile with Docker Integration Loaded!" -ForegroundColor Green
Write-Host "💡 Type 'Show-GitAliases' for Git shortcuts or 'Show-DockerAliases' for Docker commands." -ForegroundColor Cyan
