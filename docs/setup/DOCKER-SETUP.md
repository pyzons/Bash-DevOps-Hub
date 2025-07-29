# Docker Development Environment Setup

## VS Code Extensions for Docker Development

### Essential Extensions (Already Installed ✅)
- **Docker**: `ms-azuretools.vscode-docker` - Full Docker support
- **Remote - Containers**: `ms-vscode-remote.remote-containers` - Dev containers
- **Kubernetes**: `ms-kubernetes-tools.vscode-kubernetes-tools` - Container orchestration
- **YAML**: `redhat.vscode-yaml` - Docker Compose file support

### Recommended Additional Extensions
```bash
# Install these for enhanced Docker development
code --install-extension bradlc.vscode-tailwindcss       # If using Tailwind in containers
code --install-extension esbenp.prettier-vscode          # Code formatting
code --install-extension ms-vscode.vscode-json           # JSON support
code --install-extension formulahendry.auto-rename-tag   # HTML tag management
```

## PowerShell Docker Aliases (Now Available!)

### Basic Docker Commands
```powershell
d        # docker
dps      # docker ps (running containers)
dpsa     # docker ps -a (all containers)
di       # docker images
drun     # docker run
dexec    # docker exec -it (interactive shell)
dlog     # docker logs
dlogf    # docker logs -f (follow logs)
dstop    # docker stop
dstart   # docker start
drm      # docker rm (remove container)
drmi     # docker rmi (remove image)
dbuild   # docker build
dpull    # docker pull
dpush    # docker push
dprune   # docker system prune (cleanup)
```

### Docker Compose Commands
```powershell
dc         # docker-compose
dcup       # docker-compose up
dcupd      # docker-compose up -d (detached)
dcdown     # docker-compose down
dcps       # docker-compose ps
dclogs     # docker-compose logs
dclogsf    # docker-compose logs -f
dcbuild    # docker-compose build
dcpull     # docker-compose pull
dcrestart  # docker-compose restart
```

### Special Functions
```powershell
Show-DockerAliases  # Display all Docker aliases
Docker-Stats        # Show Docker system info and running containers
Docker-CleanAll     # Clean up all Docker resources (images, containers, volumes)
```

## Quick Start Examples

### 1. Run a Simple Web Server
```powershell
# Pull and run nginx
drun -d -p 8080:80 --name my-nginx nginx

# Check running containers
dps

# View logs
dlog my-nginx

# Stop and remove
dstop my-nginx
drm my-nginx
```

### 2. Development with Docker Compose
```powershell
# Start services in background
dcupd

# View running services
dcps

# Follow logs for all services
dclogsf

# Stop all services
dcdown
```

### 3. Interactive Development
```powershell
# Run interactive Ubuntu container
drun -it ubuntu bash

# Execute command in running container
dexec my-container bash
```

## VS Code Docker Features

### 1. **Docker Explorer**
- View and manage containers, images, networks, volumes
- Right-click for quick actions

### 2. **Dockerfile IntelliSense**
- Syntax highlighting and autocompletion
- Best practice suggestions

### 3. **Docker Compose Support**
- YAML validation and completion
- Service definition assistance

### 4. **Remote Container Development**
- Develop inside containers
- Consistent development environments
- Access to container file system

## Recommended Project Structure

```
project/
├── .devcontainer/
│   └── devcontainer.json     # VS Code dev container config
├── .vscode/
│   ├── tasks.json           # Build and run tasks
│   └── launch.json          # Debug configurations
├── docker-compose.yml       # Multi-service setup
├── Dockerfile              # Container image definition
├── .dockerignore           # Files to ignore in builds
└── src/                    # Your application code
```

## Docker Best Practices

### 1. **Use .dockerignore**
```
node_modules/
.git/
.DS_Store
*.log
.env.local
```

### 2. **Multi-stage Builds**
```dockerfile
# Build stage
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Runtime stage
FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### 3. **Health Checks**
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

## Troubleshooting

### Common Issues
1. **Docker Desktop not running**: Start Docker Desktop application
2. **Permission issues**: Run PowerShell as Administrator if needed
3. **Port conflicts**: Use different port mappings (-p host:container)
4. **Memory issues**: Increase Docker Desktop memory allocation

### Useful Debug Commands
```powershell
# Check Docker system info
docker system info

# View Docker disk usage
docker system df

# Clean up everything (use carefully!)
Docker-CleanAll

# Check container resource usage
docker stats
```
