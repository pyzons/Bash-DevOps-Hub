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
function cdws { Set-Location "C:\app\PowerShell-DevOps-Hub" }
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

# Enhanced KIND functions for Windows 11 best practices
function kind-dev-setup {
    Write-Host "🚀 Setting up KIND development cluster..." -ForegroundColor Cyan
    kind-create dev
    Write-Host "⏱️ Waiting for cluster to be ready..." -ForegroundColor Yellow
    kubectl wait --for=condition=Ready nodes --all --timeout=60s 2>$null
    if ($?) {
        Write-Host "✅ Cluster ready for development!" -ForegroundColor Green
        kgn
    }
    else {
        Write-Host "⚠️ Cluster created but still initializing..." -ForegroundColor Yellow
    }
}

function kind-backup-resources {
    param($namespace = "default")
    $backupDir = "C:\app\PowerShell-DevOps-Hub\k8s-backups"
    if (!(Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force }
    
    Write-Host "💾 Backing up Kubernetes resources..." -ForegroundColor Cyan
    $backupFile = "$backupDir\all-resources-$(Get-Date -Format 'yyyyMMdd-HHmm').yaml"
    kubectl get all -n $namespace -o yaml > $backupFile
    Write-Host "✅ Resources backed up to $backupFile" -ForegroundColor Green
    return $backupFile
}

function kind-restore-resources {
    param($backupFile)
    if (Test-Path $backupFile) {
        Write-Host "🔄 Restoring Kubernetes resources..." -ForegroundColor Cyan
        kap $backupFile
        Write-Host "✅ Resources restored!" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Backup file not found: $backupFile" -ForegroundColor Red
        Write-Host "💡 Available backups:" -ForegroundColor Yellow
        Get-ChildItem "C:\app\PowerShell-DevOps-Hub\k8s-backups" -Filter "*.yaml" | Select-Object Name, LastWriteTime
    }
}

function kind-cleanup-all {
    Write-Host "🧹 Cleaning up all KIND clusters..." -ForegroundColor Yellow
    $clusters = kind get clusters 2>$null
    if ($clusters) {
        foreach ($cluster in $clusters) {
            Write-Host "  Deleting cluster: $cluster" -ForegroundColor Gray
            kind delete cluster --name $cluster
        }
        Write-Host "✅ All KIND clusters deleted!" -ForegroundColor Green
    }
    else {
        Write-Host "✅ No KIND clusters to clean up" -ForegroundColor Green
    }
}

function Check-DockerReady {
    Write-Host "🔍 Checking Docker status..." -ForegroundColor Cyan
    $dockerReady = docker info --format "{{.ServerVersion}}" 2>$null
    if ($dockerReady) {
        Write-Host "✅ Docker is ready (v$dockerReady)" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "❌ Docker is not ready. Please start Docker Desktop." -ForegroundColor Red
        return $false
    }
}

function Resume-Work {
    Write-Host "🚀 Resuming Development Environment..." -ForegroundColor Cyan
    Write-Host ""
    
    # Navigate to workspace
    Set-Location "C:\app\PowerShell-DevOps-Hub"
    Write-Host "📁 Workspace: $(Get-Location)" -ForegroundColor Yellow
    
    # Check Docker
    if (Check-DockerReady) {
        Write-Host ""
        
        # Check Git status
        Write-Host "📊 Git Status:" -ForegroundColor Yellow
        $gitStatus = git status --porcelain
        if ($gitStatus) {
            Write-Host "⚠️ Uncommitted changes detected" -ForegroundColor Orange
            git status --short
        }
        else {
            Write-Host "✅ Git working directory clean" -ForegroundColor Green
        }
        
        # Check KIND clusters
        Write-Host ""
        Write-Host "☸️ KIND Clusters:" -ForegroundColor Yellow
        $clusters = kind get clusters 2>$null
        if ($clusters) {
            Write-Host "✅ Active clusters: $($clusters -join ', ')" -ForegroundColor Green
            Write-Host "💡 Run K8s-Status to see details" -ForegroundColor Cyan
        }
        else {
            Write-Host "❌ No KIND clusters running" -ForegroundColor Red
            Write-Host "💡 Run kind-dev-setup to create development cluster" -ForegroundColor Cyan
        }
        
        # Check backups
        Write-Host ""
        Write-Host "💾 Available Backups:" -ForegroundColor Yellow
        $backupDir = "C:\app\PowerShell-DevOps-Hub\k8s-backups"
        if (Test-Path $backupDir) {
            $backups = Get-ChildItem $backupDir -Filter "*.yaml" | Sort-Object LastWriteTime -Descending | Select-Object -First 3
            if ($backups) {
                foreach ($backup in $backups) {
                    Write-Host "  📄 $($backup.Name) ($(($backup.LastWriteTime).ToString('MM/dd HH:mm')))" -ForegroundColor White
                }
            }
            else {
                Write-Host "  No backups found" -ForegroundColor Gray
            }
        }
        
        Write-Host ""
        Write-Host "🎯 Ready to continue! Use K8s-QuickStart for workflow reminders." -ForegroundColor Green
    }
}

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
    Write-Host "kind-create         - Create KIND cluster" -ForegroundColor White
    Write-Host "kind-delete         - Delete KIND cluster" -ForegroundColor White
    Write-Host "kind-list           - List KIND clusters" -ForegroundColor White
    Write-Host "kind-load           - Load Docker image into KIND" -ForegroundColor White
    Write-Host ""
    Write-Host "Enhanced KIND Functions:" -ForegroundColor Yellow
    Write-Host "kind-dev-setup      - Create development cluster with readiness check" -ForegroundColor White
    Write-Host "kind-backup-resources - Backup cluster resources to file" -ForegroundColor White
    Write-Host "kind-restore-resources - Restore resources from backup file" -ForegroundColor White
    Write-Host "kind-cleanup-all    - Delete all KIND clusters" -ForegroundColor White
    Write-Host "Check-DockerReady   - Verify Docker Desktop is running" -ForegroundColor White
    Write-Host "Resume-Work         - Complete environment status and resume guide" -ForegroundColor White
}

function K8s-QuickStart {
    Write-Host "🚀 Kubernetes Quick Start with KIND (Windows 11)" -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Daily Workflow:" -ForegroundColor Yellow
    Write-Host "1. Check Docker:   Check-DockerReady" -ForegroundColor White
    Write-Host "2. Setup cluster:  kind-dev-setup" -ForegroundColor White
    Write-Host "3. Deploy app:     kap deployment.yaml" -ForegroundColor White
    Write-Host "4. Check status:   K8s-Status" -ForegroundColor White
    Write-Host "5. Backup work:    kind-backup-resources" -ForegroundColor White
    Write-Host ""
    Write-Host "After Reboot:" -ForegroundColor Yellow
    Write-Host "1. Wait for Docker Desktop to start" -ForegroundColor White
    Write-Host "2. Run: kind-dev-setup" -ForegroundColor White
    Write-Host "3. Restore: kind-restore-resources backup-file.yaml" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 KIND clusters are ephemeral - they don't survive reboots!" -ForegroundColor Cyan
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
Write-Host "• Check-DockerReady      - Verify Docker status" -ForegroundColor Gray
Write-Host "• kind-dev-setup         - Create development cluster" -ForegroundColor Gray
Write-Host "• Resume-Work            - Complete environment status check" -ForegroundColor Gray
