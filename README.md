# 🚀 Bash DevOps Hub

A comprehensive, cross-platform development environment with Git, Docker, and Kubernetes integration. Provides identical experiences across bash (Linux/WSL2) and PowerShell 7 (Windows 11).

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
├── 09-chat-recovery/            # Chat Recovery & Context Preservation
│   ├── CHAT-RECOVERY-INSTRUCTIONS.md  # Main recovery guide
│   ├── COMPLETE-CHAT-HISTORY.md       # Full conversation history
│   ├── POWERSHELL7-RECOVERY-GUIDE.md  # PowerShell 7 specific recovery
│   └── WSL2-SETUP-GUIDE.md            # WSL2 setup instructions
├── 10-powershell-integration/   # PowerShell 7 Cross-Platform Setup
│   ├── installers/              # PowerShell installation scripts
│   ├── configs/                 # Starship and profile configurations
│   └── docs/                    # PowerShell-specific documentation
└── README.md                    # This file
```

## 🎯 Cross-Platform Support

- ✅ **Linux/Ubuntu** - Native bash environment
- ✅ **WSL2 Windows 11** - Linux compatibility with Windows integration  
- ✅ **PowerShell 7 Windows 11** - Native Windows with identical functionality
- ✅ **Cloud Ubuntu** - Remote development environments

## 🚀 Quick Start

### Bash (Linux/WSL2):
```bash
# Clone repository
git clone https://github.com/pyzons/Bash-DevOps-Hub.git
cd Bash-DevOps-Hub

# Install enhanced profile
cd 01-installation/installers
./install-no-hang.sh

# WSL2 optimization (if on Windows)
./optimize-wsl2.sh
```

### PowerShell 7 (Windows 11):
```powershell
# One-command installation
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pyzons/Bash-DevOps-Hub/main/10-powershell-integration/installers/setup-powershell7-starship.ps1'))
```

### Test Your Installation:
```bash
# Bash testing
gs               # Git status
ll               # Enhanced directory listing
show-git-aliases # View all shortcuts
wsl2-status      # WSL2 environment check (if applicable)
```

```powershell
# PowerShell 7 testing
gs               # Git status (identical to bash)
ll               # Enhanced directory listing
show-git-aliases # View all shortcuts
pwsh-status      # PowerShell environment check
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
