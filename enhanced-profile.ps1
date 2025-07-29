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

# Kubernetes and KIND aliases
Set-Alias -Name k -Value kubectl
function kgp { kubectl get pods $args }
function kgs { kubectl get services $args }
function kgd { kubectl get deployments $args }
function kgn { kubectl get nodes $args }
function kga { kubectl get all $args }
function kdp { kubectl describe pod $args }
function kds { kubectl describe service $args }
function kdd { kubectl describe deployment $args }
function kl { kubectl logs $args }
function klf { kubectl logs -f $args }
function kex { kubectl exec -it $args }
function kap { kubectl apply -f $args }
function kdel { kubectl delete $args }

# KIND-specific functions
function kind-create { 
    param($name = "kind")
    kind create cluster --name $name $args 
}
function kind-delete { 
    param($name = "kind")
    kind delete cluster --name $name $args 
}
function kind-list { kind get clusters $args }
function kind-load { kind load docker-image $args }

# Advanced Kubernetes functions
function Show-KubernetesAliases {
    Write-Host "Available Kubernetes & KIND Aliases:" -ForegroundColor Green
    Write-Host ""
    Write-Host "Basic Kubectl Commands:" -ForegroundColor Yellow
    Write-Host "k       - kubectl" -ForegroundColor White
    Write-Host "kgp     - kubectl get pods" -ForegroundColor White
    Write-Host "kgs     - kubectl get services" -ForegroundColor White
    Write-Host "kgd     - kubectl get deployments" -ForegroundColor White
    Write-Host "kgn     - kubectl get nodes" -ForegroundColor White
    Write-Host "kga     - kubectl get all" -ForegroundColor White
    Write-Host "kdp     - kubectl describe pod" -ForegroundColor White
    Write-Host "kds     - kubectl describe service" -ForegroundColor White
    Write-Host "kdd     - kubectl describe deployment" -ForegroundColor White
    Write-Host "kl      - kubectl logs" -ForegroundColor White
    Write-Host "klf     - kubectl logs -f" -ForegroundColor White
    Write-Host "kex     - kubectl exec -it" -ForegroundColor White
    Write-Host "kap     - kubectl apply -f" -ForegroundColor White
    Write-Host "kdel    - kubectl delete" -ForegroundColor White
    Write-Host ""
    Write-Host "KIND Commands:" -ForegroundColor Yellow
    Write-Host "kind-create  - Create KIND cluster" -ForegroundColor White
    Write-Host "kind-delete  - Delete KIND cluster" -ForegroundColor White
    Write-Host "kind-list    - List KIND clusters" -ForegroundColor White
    Write-Host "kind-load    - Load Docker image into KIND" -ForegroundColor White
}

function K8s-QuickStart {
    Write-Host "🚀 Kubernetes Quick Start with KIND" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Create cluster: kind-create my-cluster" -ForegroundColor Yellow
    Write-Host "2. Check nodes:    kgn" -ForegroundColor Yellow
    Write-Host "3. Deploy app:     kap deployment.yaml" -ForegroundColor Yellow
    Write-Host "4. Check pods:     kgp" -ForegroundColor Yellow
    Write-Host "5. View services:  kgs" -ForegroundColor Yellow
    Write-Host "6. Clean up:       kind-delete my-cluster" -ForegroundColor Yellow
}

function K8s-Status {
    Write-Host "☸️ Kubernetes Cluster Status:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🖥️ Current Context:" -ForegroundColor Yellow
    kubectl config current-context
    Write-Host ""
    Write-Host "🏗️ Nodes:" -ForegroundColor Yellow
    kubectl get nodes
    Write-Host ""
    Write-Host "🏃 All Resources:" -ForegroundColor Yellow
    kubectl get all
}

# Enhanced prompt (optional - remove if you use Oh My Posh)
function prompt {
    $location = Get-Location
    $gitInfo = if (Get-GitStatus -eq $null) { "" } else { " $(Write-VcsStatus)" }
    "PS $location$gitInfo> "
}

Write-Host "PowerShell 7 with Docker & Kubernetes Integration Loaded!" -ForegroundColor Green
Write-Host "💡 Available commands:" -ForegroundColor Cyan
Write-Host "• Show-GitAliases        - Git shortcuts" -ForegroundColor Gray
Write-Host "• Show-DockerAliases     - Docker commands" -ForegroundColor Gray
Write-Host "• Show-KubernetesAliases - Kubernetes & KIND shortcuts" -ForegroundColor Gray
Write-Host "• K8s-QuickStart         - Kubernetes quick start guide" -ForegroundColor Gray
