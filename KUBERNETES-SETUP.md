# Kubernetes Development with KIND Setup

## Overview
This guide shows how to use KIND (Kubernetes in Docker) with your enhanced PowerShell and Docker setup for local Kubernetes development.

## Prerequisites ✅
- ✅ Docker Desktop (installed and running)
- ✅ kubectl (installed)
- ✅ KIND (installed)
- ✅ Enhanced PowerShell profile with Docker & Kubernetes aliases

## What is KIND?
KIND (Kubernetes IN Docker) runs local Kubernetes clusters using Docker containers as nodes. It's perfect for:
- Local development and testing
- CI/CD pipelines
- Learning Kubernetes
- Testing Kubernetes configurations

## Quick Start

### 1. Create Your First Cluster
```powershell
# Create a default cluster
kind-create

# Or create a named cluster
kind-create my-dev-cluster
```

### 2. Verify Installation
```powershell
# Check cluster nodes
kgn

# Check cluster status
K8s-Status

# List all KIND clusters
kind-list
```

### 3. Deploy Your First Application
```powershell
# Deploy nginx
k create deployment nginx --image=nginx
k expose deployment nginx --port=80 --type=NodePort

# Check deployment
kgp
kgs
```

## Available Kubernetes Aliases

### Basic kubectl Commands
| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | Short kubectl command |
| `kgp` | `kubectl get pods` | List pods |
| `kgs` | `kubectl get services` | List services |
| `kgd` | `kubectl get deployments` | List deployments |
| `kgn` | `kubectl get nodes` | List nodes |
| `kga` | `kubectl get all` | List all resources |
| `kdp` | `kubectl describe pod` | Describe pod |
| `kds` | `kubectl describe service` | Describe service |
| `kdd` | `kubectl describe deployment` | Describe deployment |
| `kl` | `kubectl logs` | Show logs |
| `klf` | `kubectl logs -f` | Follow logs |
| `kex` | `kubectl exec -it` | Execute in pod |
| `kap` | `kubectl apply -f` | Apply configuration |
| `kdel` | `kubectl delete` | Delete resource |

### KIND-specific Commands
| Function | Description |
|----------|-------------|
| `kind-create [name]` | Create KIND cluster |
| `kind-delete [name]` | Delete KIND cluster |
| `kind-list` | List KIND clusters |
| `kind-load` | Load Docker image into KIND |

### Helper Functions
| Function | Description |
|----------|-------------|
| `Show-KubernetesAliases` | Display all K8s shortcuts |
| `K8s-QuickStart` | Quick start guide |
| `K8s-Status` | Show cluster status |

## Example Workflows

### 1. Complete Development Workflow
```powershell
# Create cluster
kind-create my-app

# Verify cluster
kgn
K8s-Status

# Build and load your app image
dbuild -t my-app:latest .
kind-load my-app:latest --name my-app

# Deploy your application
kap deployment.yaml
kap service.yaml

# Monitor deployment
kgp -w
klf deployment/my-app

# Test your application
k port-forward service/my-app 8080:80

# Clean up
kind-delete my-app
```

### 2. Multi-Service Application
```powershell
# Create cluster with custom config
kind-create multi-service

# Deploy database
kap postgres-deployment.yaml
kap postgres-service.yaml

# Deploy application
kap app-deployment.yaml
kap app-service.yaml

# Check everything
kga
K8s-Status

# Check logs
klf deployment/my-app
klf deployment/postgres

# Clean up
kind-delete multi-service
```

## KIND Configuration Examples

### 1. Simple Cluster Config
Create `kind-config.yaml`:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: my-cluster
nodes:
- role: control-plane
- role: worker
- role: worker
```

Use it:
```powershell
kind create cluster --config kind-config.yaml --name my-cluster
```

### 2. Cluster with Port Mapping
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
```

### 3. Multi-Node Cluster
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: control-plane
- role: control-plane
- role: worker
- role: worker
- role: worker
```

## Sample Kubernetes Manifests

### 1. Simple Deployment
Create `nginx-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.20
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
  type: NodePort
```

Deploy it:
```powershell
kap nginx-deployment.yaml
kgp
kgs
```

### 2. ConfigMap and Secret Example
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database_url: "postgres://localhost:5432/myapp"
  log_level: "info"
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  database_password: cGFzc3dvcmQxMjM=  # base64 encoded
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        env:
        - name: DATABASE_URL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: database_url
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database_password
```

## VS Code Integration

### Extensions for Kubernetes Development
Already installed:
- ✅ **Kubernetes**: `ms-kubernetes-tools.vscode-kubernetes-tools`
- ✅ **Docker**: `ms-azuretools.vscode-docker`
- ✅ **YAML**: `redhat.vscode-yaml`

### VS Code Features
- **Kubernetes Explorer**: View and manage clusters, nodes, pods
- **YAML IntelliSense**: Auto-completion for K8s manifests
- **Helm Support**: Chart development and deployment
- **Debug Support**: Debug applications running in pods

## Troubleshooting

### Common Issues
1. **Cluster won't start**: Ensure Docker Desktop is running
2. **Images not found**: Use `kind-load` to load local images
3. **Port conflicts**: Check if ports are already in use
4. **Context issues**: Use `kubectl config get-contexts`

### Useful Debug Commands
```powershell
# Check cluster info
k cluster-info

# Get events
k get events --sort-by=.metadata.creationTimestamp

# Check node status
k describe nodes

# Check pod logs
klf pod-name

# Shell into pod
kex pod-name -- /bin/bash

# Port forward for testing
k port-forward pod/pod-name 8080:80
```

### Clean Up
```powershell
# Delete all resources in namespace
k delete all --all

# Delete namespace
k delete namespace my-namespace

# Delete KIND cluster
kind-delete cluster-name

# Clean up Docker resources
Docker-CleanAll
```

## Best Practices

### 1. Resource Management
- Always set resource limits
- Use namespaces for organization
- Clean up unused resources

### 2. Development Workflow
- Use KIND for local development
- Test with multiple replicas
- Use ConfigMaps for configuration
- Store secrets properly

### 3. Image Management
- Tag images properly
- Use `kind-load` for local images
- Keep images small and secure

### 4. Monitoring
- Use `klf` for log monitoring
- Check resource usage with `k top`
- Monitor cluster events

## Integration with Your Docker Workflow

```powershell
# Build, load, and deploy in one workflow
dbuild -t my-app:v1.0 .
kind-load my-app:v1.0
kap deployment.yaml

# Check everything
Docker-Stats
K8s-Status

# Monitor
klf deployment/my-app
```

## Next Steps

1. **Learn Helm**: Package manager for Kubernetes
2. **Explore Operators**: Automate complex applications
3. **CI/CD Integration**: Use KIND in pipelines
4. **Production Deployment**: Migrate to real clusters

Your development environment now supports the complete container orchestration stack! 🚀☸️
