#!/bin/bash
# Bash DevOps Hub Repository Reorganization Script
# Organizes files and docs by sub-projects and tasks for better structure

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_status() {
    printf "${1}${2}${NC}\n"
}

print_status $CYAN "🏗️  Bash DevOps Hub - Repository Reorganization"
print_status $CYAN "================================================"

# Create backup
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
print_status $YELLOW "💾 Creating backup: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Copy current state to backup
cp -r . "$BACKUP_DIR/" 2>/dev/null || true
print_status $GREEN "✅ Backup created"

# Define the new organized structure
print_status $BLUE "📋 New Organization Structure:"
print_status $BLUE "=============================="

# 1. INSTALLATION SUB-PROJECT
print_status $CYAN "🚀 1. Installation & Setup"
mkdir -p "01-installation"
mkdir -p "01-installation/installers"
mkdir -p "01-installation/scripts"
mkdir -p "01-installation/docs"

# Move installation-related files
INSTALLATION_FILES=(
    "install-no-hang.sh"
    "install-simple.sh" 
    "install-enhanced-profile.sh"
)

for file in "${INSTALLATION_FILES[@]}"; do
    if [ -f "$file" ]; then
        mv "$file" "01-installation/installers/"
        print_status $GREEN "  ✅ Moved: $file → 01-installation/installers/"
    fi
done

# Move installation scripts
if [ -f "scripts/bash/install-profile.sh" ]; then
    mv "scripts/bash/install-profile.sh" "01-installation/scripts/"
    print_status $GREEN "  ✅ Moved: scripts/bash/install-profile.sh → 01-installation/scripts/"
fi

# Installation docs
cat > "01-installation/README.md" << 'EOF'
# 🚀 Installation & Setup

This directory contains all installation-related files for the Bash DevOps Hub.

## Quick Start
```bash
# Recommended: No-hang installer
./installers/install-no-hang.sh

# Alternative installers
./installers/install-simple.sh
./installers/install-enhanced-profile.sh
```

## Files
- `installers/` - Main installation scripts
- `scripts/` - Installation component scripts
- `docs/` - Installation documentation
EOF

# 2. BASH PROFILE SUB-PROJECT
print_status $CYAN "🐚 2. Bash Profile & Configuration"
mkdir -p "02-bash-profile"
mkdir -p "02-bash-profile/profile"
mkdir -p "02-bash-profile/configs"
mkdir -p "02-bash-profile/tests"

# Move bash profile files
if [ -f "scripts/bash/enhanced-profile.sh" ]; then
    mv "scripts/bash/enhanced-profile.sh" "02-bash-profile/profile/"
    print_status $GREEN "  ✅ Moved: scripts/bash/enhanced-profile.sh → 02-bash-profile/profile/"
fi

if [ -f "scripts/bash/test-profile.sh" ]; then
    mv "scripts/bash/test-profile.sh" "02-bash-profile/tests/"
    print_status $GREEN "  ✅ Moved: scripts/bash/test-profile.sh → 02-bash-profile/tests/"
fi

# Profile README
cat > "02-bash-profile/README.md" << 'EOF'
# 🐚 Bash Profile & Configuration

Enhanced bash profile with 50+ aliases and functions for Git, Docker, and Kubernetes.

## Main Profile
- `profile/enhanced-profile.sh` - Main enhanced bash profile
- `tests/test-profile.sh` - Profile testing utilities
- `configs/` - Additional configuration files

## Features
- Git shortcuts (gs, ga, gc, gp, etc.)
- Docker aliases (d, dps, dcup, etc.)
- Kubernetes shortcuts (k, kgs, kgp, etc.)
- System utilities (sysinfo, extract, mkcd)
- Starship prompt integration
EOF

# 3. PROMPT & THEMING SUB-PROJECT
print_status $CYAN "⭐ 3. Prompt & Theming"
mkdir -p "03-prompt-theming"
mkdir -p "03-prompt-theming/starship"
mkdir -p "03-prompt-theming/configs"

# Move Starship setup
if [ -f "scripts/bash/setup-starship.sh" ]; then
    mv "scripts/bash/setup-starship.sh" "03-prompt-theming/starship/"
    print_status $GREEN "  ✅ Moved: scripts/bash/setup-starship.sh → 03-prompt-theming/starship/"
fi

# Prompt README
cat > "03-prompt-theming/README.md" << 'EOF'
# ⭐ Prompt & Theming

Modern terminal prompt configuration with Starship.

## Starship Prompt
- `starship/setup-starship.sh` - Starship installation and configuration
- `configs/` - Custom prompt configurations and themes

## Features
- Fast, cross-platform prompt
- Git status integration
- Custom themes and presets
- Kubernetes context display
- Docker context display
EOF

# 4. DEVELOPMENT TOOLS SUB-PROJECT
print_status $CYAN "🔧 4. Development Tools & Utilities"
mkdir -p "04-dev-tools"
mkdir -p "04-dev-tools/analysis"
mkdir -p "04-dev-tools/utilities"

# Move analysis tools
if [ -f "analyze-profile.sh" ]; then
    mv "analyze-profile.sh" "04-dev-tools/analysis/"
    print_status $GREEN "  ✅ Moved: analyze-profile.sh → 04-dev-tools/analysis/"
fi

# Dev tools README
cat > "04-dev-tools/README.md" << 'EOF'
# 🔧 Development Tools & Utilities

Tools for analyzing and maintaining the Bash DevOps Hub.

## Analysis Tools
- `analysis/analyze-profile.sh` - Profile analysis and diagnostics

## Utilities
- `utilities/` - Various development utilities and helpers

## Usage
```bash
# Analyze current profile
./analysis/analyze-profile.sh
```
EOF

# 5. DOCKER INTEGRATION SUB-PROJECT
print_status $CYAN "🐳 5. Docker Integration"
mkdir -p "05-docker-integration"
mkdir -p "05-docker-integration/configs"
mkdir -p "05-docker-integration/examples"
mkdir -p "05-docker-integration/docs"

# Move Docker configs
if [ -d "config/docker" ]; then
    mv config/docker/* "05-docker-integration/configs/" 2>/dev/null || true
    print_status $GREEN "  ✅ Moved: config/docker/* → 05-docker-integration/configs/"
fi

# Move Docker docs
DOCKER_DOCS=(
    "docs/setup/DOCKER-SETUP.md"
    "docs/setup/WSL2-vs-DOCKER-DESKTOP.md"
)

for doc in "${DOCKER_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        mv "$doc" "05-docker-integration/docs/"
        print_status $GREEN "  ✅ Moved: $doc → 05-docker-integration/docs/"
    fi
done

# Docker README
cat > "05-docker-integration/README.md" << 'EOF'
# 🐳 Docker Integration

Docker configuration and integration for the Bash DevOps Hub.

## Configuration
- `configs/` - Docker Compose files, Dockerfiles, and configurations
- `examples/` - Example Docker setups and configurations
- `docs/` - Docker setup and integration documentation

## Features
- Docker aliases and shortcuts
- Container management functions
- Image and volume utilities
- Docker Compose integration
EOF

# 6. KUBERNETES INTEGRATION SUB-PROJECT
print_status $CYAN "☸️  6. Kubernetes Integration"
mkdir -p "06-kubernetes-integration"
mkdir -p "06-kubernetes-integration/configs"
mkdir -p "06-kubernetes-integration/kind"
mkdir -p "06-kubernetes-integration/docs"

# Move Kubernetes configs
if [ -d "config/kubernetes" ]; then
    mv config/kubernetes/* "06-kubernetes-integration/configs/" 2>/dev/null || true
    print_status $GREEN "  ✅ Moved: config/kubernetes/* → 06-kubernetes-integration/configs/"
fi

# Move KIND configs to specific folder
if [ -f "06-kubernetes-integration/configs/kind-dev-config.yaml" ]; then
    mv "06-kubernetes-integration/configs/kind-dev-config.yaml" "06-kubernetes-integration/kind/"
fi
if [ -f "06-kubernetes-integration/configs/kind-prod-config.yaml" ]; then
    mv "06-kubernetes-integration/configs/kind-prod-config.yaml" "06-kubernetes-integration/kind/"
fi

# Move Kubernetes docs
KUBERNETES_DOCS=(
    "docs/setup/KUBERNETES-SETUP.md"
    "docs/setup/KIND-WINDOWS-BEST-PRACTICES.md"
)

for doc in "${KUBERNETES_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        mv "$doc" "06-kubernetes-integration/docs/"
        print_status $GREEN "  ✅ Moved: $doc → 06-kubernetes-integration/docs/"
    fi
done

# Kubernetes README
cat > "06-kubernetes-integration/README.md" << 'EOF'
# ☸️ Kubernetes Integration

Kubernetes configuration and KIND setup for the Bash DevOps Hub.

## Configuration
- `configs/` - General Kubernetes configurations
- `kind/` - KIND (Kubernetes in Docker) configurations
- `docs/` - Kubernetes setup and best practices documentation

## Features
- Kubernetes aliases (k, kgs, kgp, etc.)
- KIND cluster management
- Resource management functions
- Development and production configurations
EOF

# 7. DOCUMENTATION SUB-PROJECT
print_status $CYAN "📚 7. Documentation & Guides"
mkdir -p "07-documentation"
mkdir -p "07-documentation/setup-guides"
mkdir -p "07-documentation/troubleshooting"
mkdir -p "07-documentation/chat-ai"

# Move remaining setup docs
SETUP_DOCS=(
    "docs/setup/HOW-TO-CONTINUE.md"
    "docs/setup/REBOOT-RECOVERY-GUIDE.md"
)

for doc in "${SETUP_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        mv "$doc" "07-documentation/setup-guides/"
        print_status $GREEN "  ✅ Moved: $doc → 07-documentation/setup-guides/"
    fi
done

# Move chat-ai docs
if [ -d "docs/chat-ai" ]; then
    mv docs/chat-ai/* "07-documentation/chat-ai/" 2>/dev/null || true
    print_status $GREEN "  ✅ Moved: docs/chat-ai/* → 07-documentation/chat-ai/"
fi

# Documentation README
cat > "07-documentation/README.md" << 'EOF'
# 📚 Documentation & Guides

Comprehensive documentation for the Bash DevOps Hub.

## Structure
- `setup-guides/` - Setup and continuation guides
- `troubleshooting/` - Troubleshooting and recovery guides
- `chat-ai/` - AI chat history and context preservation

## Key Documents
- Setup guides for getting started
- Recovery procedures for after system reboots
- Chat context preservation for AI assistance continuity
EOF

# 8. LEGACY ARCHIVE SUB-PROJECT
print_status $CYAN "🗄️  8. Legacy Archive"
mkdir -p "08-legacy-archive"

# Move archive folder if it exists
if [ -d "archive" ]; then
    mv archive/* "08-legacy-archive/" 2>/dev/null || true
    rmdir archive 2>/dev/null || true
    print_status $GREEN "  ✅ Moved: archive/* → 08-legacy-archive/"
fi

# Archive README
cat > "08-legacy-archive/README.md" << 'EOF'
# 🗄️ Legacy Archive

Archived files from previous versions and migrations.

## Contents
- PowerShell legacy files
- Old configuration files
- Previous version backups
- Migration artifacts

## Note
These files are kept for reference and can be safely removed if no longer needed.
EOF

# Clean up empty directories
print_status $YELLOW "🧹 Cleaning up empty directories..."
find . -type d -empty -not -path "./.git/*" -not -path "./08-legacy-archive/*" -delete 2>/dev/null || true

# Update main README with new structure
print_status $YELLOW "📝 Updating main README..."
cat > "README.md" << 'EOF'
# 🚀 Bash DevOps Hub

A comprehensive, well-organized Bash development environment with Git, Docker, and Kubernetes integration.

## 🏗️ Project Structure

```
├── 01-installation/              # Installation & Setup
│   ├── installers/              # Main installation scripts
│   ├── scripts/                 # Installation components
│   └── docs/                    # Installation documentation
├── 02-bash-profile/             # Bash Profile & Configuration
│   ├── profile/                 # Main enhanced bash profile
│   ├── configs/                 # Additional configurations
│   └── tests/                   # Profile testing utilities
├── 03-prompt-theming/           # Prompt & Theming
│   ├── starship/                # Starship prompt setup
│   └── configs/                 # Custom themes and configs
├── 04-dev-tools/                # Development Tools & Utilities
│   ├── analysis/                # Profile analysis tools
│   └── utilities/               # Development utilities
├── 05-docker-integration/       # Docker Integration
│   ├── configs/                 # Docker configurations
│   ├── examples/                # Example setups
│   └── docs/                    # Docker documentation
├── 06-kubernetes-integration/   # Kubernetes Integration
│   ├── configs/                 # Kubernetes configurations
│   ├── kind/                    # KIND cluster configs
│   └── docs/                    # Kubernetes documentation
├── 07-documentation/            # Documentation & Guides
│   ├── setup-guides/            # Setup and continuation guides
│   ├── troubleshooting/         # Recovery and troubleshooting
│   └── chat-ai/                 # AI chat context preservation
├── 08-legacy-archive/           # Legacy Archive
│   └── powershell-legacy/       # Archived PowerShell files
└── README.md                    # This file
```

## 🚀 Quick Start

1. **Install the enhanced bash profile:**
   ```bash
   cd 01-installation/installers
   ./install-no-hang.sh
   ```

2. **Restart your terminal or:**
   ```bash
   source ~/.bashrc
   ```

3. **Test the installation:**
   ```bash
   gs          # Git status
   ll          # List files
   show-git-aliases  # See all shortcuts
   ```

## 📋 Sub-Projects Overview

### 🚀 [01-installation](01-installation/)
Installation scripts and setup procedures for the Bash DevOps Hub.

### 🐚 [02-bash-profile](02-bash-profile/)
Enhanced bash profile with 50+ aliases and functions for productivity.

### ⭐ [03-prompt-theming](03-prompt-theming/)
Modern terminal prompt with Starship integration and custom themes.

### 🔧 [04-dev-tools](04-dev-tools/)
Development tools and utilities for maintaining and analyzing the setup.

### 🐳 [05-docker-integration](05-docker-integration/)
Docker integration with aliases, functions, and container management.

### ☸️ [06-kubernetes-integration](06-kubernetes-integration/)
Kubernetes and KIND integration for container orchestration.

### 📚 [07-documentation](07-documentation/)
Comprehensive guides, troubleshooting, and documentation.

### 🗄️ [08-legacy-archive](08-legacy-archive/)
Archived files from previous versions and migrations.

## ✨ Key Features

- **50+ Git aliases** for faster workflow
- **Docker integration** with container management
- **Kubernetes shortcuts** for cluster operations
- **Starship prompt** with modern themes
- **System utilities** for enhanced productivity
- **Comprehensive documentation** for all features
- **Modular organization** by sub-projects

## 🤝 Contributing

1. Choose the relevant sub-project directory
2. Follow the structure and documentation patterns
3. Test your changes with the provided utilities
4. Update documentation as needed

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

⭐ **Star this repository if it improved your bash development experience!**
EOF

# Create workspace file with new structure
print_status $YELLOW "📁 Creating organized workspace file..."
cat > "Bash-DevOps-Hub-Organized.code-workspace" << 'EOF'
{
    "folders": [
        {
            "name": "🚀 Installation",
            "path": "./01-installation"
        },
        {
            "name": "🐚 Bash Profile",
            "path": "./02-bash-profile"
        },
        {
            "name": "⭐ Prompt & Theming",
            "path": "./03-prompt-theming"
        },
        {
            "name": "🔧 Dev Tools",
            "path": "./04-dev-tools"
        },
        {
            "name": "🐳 Docker Integration",
            "path": "./05-docker-integration"
        },
        {
            "name": "☸️ Kubernetes",
            "path": "./06-kubernetes-integration"
        },
        {
            "name": "📚 Documentation",
            "path": "./07-documentation"
        },
        {
            "name": "🗄️ Legacy Archive",
            "path": "./08-legacy-archive"
        },
        {
            "name": "Root",
            "path": "."
        }
    ],
    "settings": {
        "files.exclude": {
            "**/backup-*": true,
            "**/.git": false
        }
    },
    "extensions": {
        "recommendations": [
            "ms-vscode.vscode-json",
            "redhat.vscode-yaml",
            "ms-azuretools.vscode-docker",
            "ms-kubernetes-tools.vscode-kubernetes-tools"
        ]
    }
}
EOF

# Final summary
print_status $GREEN "🎉 Repository Reorganization Complete!"
print_status $GREEN "====================================="

print_status $CYAN "📊 Summary:"
print_status $WHITE "• Files organized into 8 sub-projects"
print_status $WHITE "• Backup created: $BACKUP_DIR"
print_status $WHITE "• New workspace file: Bash-DevOps-Hub-Organized.code-workspace"
print_status $WHITE "• Updated main README with new structure"

print_status $YELLOW "🚀 Next Steps:"
print_status $WHITE "1. Review the new organization"
print_status $WHITE "2. Open: Bash-DevOps-Hub-Organized.code-workspace"
print_status $WHITE "3. Test installation: cd 01-installation/installers && ./install-no-hang.sh"
print_status $WHITE "4. Update any custom scripts with new paths"
print_status $WHITE "5. Commit changes: git add . && git commit -m 'Reorganize into sub-projects'"

print_status $GREEN "🎊 Your Bash DevOps Hub is now beautifully organized by sub-projects!"
