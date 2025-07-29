# KIND Best Practices for Windows 11

## 🔄 Logout/Reboot Strategy

### ⚡ **Quick Answer**: KIND clusters DON'T survive reboots by design
KIND clusters are **ephemeral** - they're deleted when Docker Desktop stops or the system reboots. This is actually a **FEATURE**, not a bug!

## 🎯 **Recommended Workflow**

### Option 1: **Ephemeral Development** (Recommended)
```powershell
# Daily workflow - Fresh start every time
kind-create dev          # Create new cluster
kap your-app.yaml       # Deploy your app
# Work with your cluster
# At end of day - just shutdown, cluster auto-deletes
```

### Option 2: **Persistent Development** (For long projects)
```powershell
# Create cluster with specific config
kind-create persistent --config kind-config.yaml
# Save your manifests to files
kubectl get all -o yaml > my-app-backup.yaml
# Reboot/logout
# Next day: Recreate and restore
kind-create persistent
kap my-app-backup.yaml
```

## 🛠️ **Enhanced PowerShell Functions**

Let's add some power user functions to your profile:

### Smart Cluster Management
```powershell
function kind-dev-setup {
    Write-Host "🚀 Setting up KIND development cluster..." -ForegroundColor Cyan
    kind-create dev
    Write-Host "⏱️ Waiting for cluster to be ready..." -ForegroundColor Yellow
    kubectl wait --for=condition=Ready nodes --all --timeout=60s
    Write-Host "✅ Cluster ready for development!" -ForegroundColor Green
    kgn
}

function kind-backup-resources {
    param($namespace = "default")
    $backupDir = "c:\app\ws\k8s-backups"
    if (!(Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir }
    
    Write-Host "💾 Backing up Kubernetes resources..." -ForegroundColor Cyan
    kubectl get all -n $namespace -o yaml > "$backupDir\all-resources-$(Get-Date -Format 'yyyyMMdd-HHmm').yaml"
    Write-Host "✅ Resources backed up to $backupDir" -ForegroundColor Green
}

function kind-restore-resources {
    param($backupFile)
    if (Test-Path $backupFile) {
        Write-Host "🔄 Restoring Kubernetes resources..." -ForegroundColor Cyan
        kap $backupFile
        Write-Host "✅ Resources restored!" -ForegroundColor Green
    } else {
        Write-Host "❌ Backup file not found: $backupFile" -ForegroundColor Red
    }
}
```

## 🏗️ **Cluster Configurations**

### Development Cluster Config
Create `c:\app\ws\kind-dev-config.yaml`:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: dev
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
```

### Production-like Cluster Config
Create `c:\app\ws\kind-prod-config.yaml`:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: prod-sim
nodes:
- role: control-plane
- role: worker
- role: worker
```

## 📋 **Daily Workflow Checklist**

### Morning Startup:
1. ✅ Docker Desktop running
2. ✅ `kind-dev-setup` (creates fresh cluster)
3. ✅ Deploy your apps: `kap my-manifests/`
4. ✅ Check status: `K8s-Status`

### End of Day:
1. ✅ Backup important resources: `kind-backup-resources`
2. ✅ Commit your YAML files to Git
3. ✅ Optional: `kind-delete dev` (or just shutdown)

### After Reboot:
1. ✅ Wait for Docker Desktop to start
2. ✅ `kind-dev-setup`
3. ✅ `kind-restore-resources path\to\backup.yaml`

## 🚨 **Important Windows 11 Considerations**

### Docker Desktop Behavior:
- **Auto-starts** on Windows login (configurable)
- **Takes 30-60 seconds** to fully initialize
- KIND clusters **depend on Docker being ready**

### Best Practices:
1. **Wait for Docker**: Always verify Docker is running before creating clusters
2. **Use Fast SSDs**: KIND benefits from fast disk I/O
3. **Sufficient RAM**: Allocate at least 4GB to Docker Desktop
4. **WSL2 Backend**: Ensure Docker uses WSL2 (faster than Hyper-V)

## 🔧 **Troubleshooting**

### Common Issues:
```powershell
# Docker not ready
docker info | grep -i "server version" # Should show version

# KIND cluster stuck
kind-delete --all  # Nuclear option - delete all clusters

# kubectl context issues
kubectl config get-contexts
kubectl config use-context kind-dev
```

### Performance Optimization:
```powershell
# Check Docker resource allocation
docker system df
docker system prune -f  # Clean up regularly
```

## 💡 **Pro Tips**

1. **Infrastructure as Code**: Keep all your Kubernetes manifests in Git
2. **Quick Recovery**: Use the backup/restore functions for important work
3. **Multiple Clusters**: Create different clusters for different projects
4. **Resource Limits**: Don't run too many KIND clusters simultaneously

## 🎯 **Recommended Setup for Your Workflow**

Since you have a solid development environment, I recommend:

1. **Ephemeral clusters** for daily development
2. **Automated setup** with the enhanced functions
3. **Git-backed manifests** for reproducibility
4. **Regular backups** for important experiments

This approach gives you the benefits of clean, reproducible environments while maintaining the flexibility to preserve important work when needed.
