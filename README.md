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
