# Path Reference Guide - Post Reorganization

## Updated File Locations

### PowerShell Scripts
- Enhanced Profile: `scripts/powershell/enhanced-profile.ps1`
- Profile Installer: `scripts/powershell/Install-Profile.ps1`
- OMP Setup: `scripts/powershell/setup-omp.ps1`

### Configuration Files  
- Docker Compose: `config/docker/docker-compose.example.yml`
- Dockerfile: `config/docker/Dockerfile.example`
- KIND Configs: `config/kubernetes/kind-dev-config.yaml`

### Documentation
- Setup Guides: `docs/setup/`
- Chat/AI Docs: `docs/chat-ai/`

### Backup Location
- Kubernetes Backups: `backups/k8s/`

## Loading the Enhanced Profile
`powershell
# From repository root
. "scripts/powershell/enhanced-profile.ps1"

# Or set in your PowerShell profile
. "C:\app\PowerShell-DevOps-Hub\scripts\powershell\enhanced-profile.ps1"
`

## VS Code Tasks
Tasks in workspace files have been automatically updated to use new paths.
