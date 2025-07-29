#!/bin/bash
# Enhanced Bash Profile Main Installer
# This script replaces the PowerShell Install-EnhancedProfile.ps1

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

show_banner() {
    print_color $CYAN "┌────────────────────────────────────────────────────────────┐"
    print_color $CYAN "│                🚀 Enhanced Bash Profile Setup              │"
    print_color $CYAN "│                                                            │"
    print_color $CYAN "│     Complete Development Environment for Linux/WSL2       │"
    print_color $CYAN "└────────────────────────────────────────────────────────────┘"
    echo
}

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -f, --force       Force installation (overwrite existing)"
    echo "  -b, --backup      Create backup of existing configuration"
    echo "  -s, --skip-starship  Skip Starship prompt installation"
    echo "  -y, --yes         Automatic yes to prompts (non-interactive mode)"
    echo "  -h, --help        Show this help message"
    echo
    echo "What this installer does:"
    echo "  • Installs enhanced bash profile with Git/Docker/K8s aliases"
    echo "  • Configures Starship for beautiful prompts"
    echo "  • Sets up bash completion and history enhancements"
    echo "  • Provides comprehensive development shortcuts"
}

# Default options
FORCE=false
BACKUP=false
SKIP_STARSHIP=false
NON_INTERACTIVE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -b|--backup)
            BACKUP=true
            shift
            ;;
        -s|--skip-starship)
            SKIP_STARSHIP=true
            shift
            ;;
        -y|--yes)
            NON_INTERACTIVE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

show_banner

# Check prerequisites
print_color $YELLOW "🔍 Checking prerequisites..."

if [ -z "$BASH_VERSION" ]; then
    print_color $RED "❌ This installer must be run with bash"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    print_color $RED "❌ Git is required but not installed"
    print_color $YELLOW "Please install git first:"
    print_color $YELLOW "  sudo apt-get install git (Ubuntu/Debian)"
    print_color $YELLOW "  sudo yum install git (RHEL/CentOS)"
    exit 1
fi

print_color $GREEN "✅ Prerequisites check passed"

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR" && pwd)"

print_color $YELLOW "📁 Project directory: $PROJECT_ROOT"

# Step 1: Install enhanced bash profile
print_color $CYAN "📦 Step 1: Installing Enhanced Bash Profile..."

if [ -f "$PROJECT_ROOT/01-installation/scripts/install-profile.sh" ]; then
    chmod +x "$PROJECT_ROOT/01-installation/scripts/install-profile.sh"
    
    # Build arguments for install script
    INSTALL_ARGS=""
    if [ "$FORCE" = true ]; then
        INSTALL_ARGS="$INSTALL_ARGS --force"
    fi
    if [ "$BACKUP" = true ]; then
        INSTALL_ARGS="$INSTALL_ARGS --backup"
    fi
    
    if bash "$PROJECT_ROOT/01-installation/scripts/install-profile.sh" $INSTALL_ARGS; then
        print_color $GREEN "✅ Enhanced bash profile installed"
    else
        print_color $RED "❌ Failed to install enhanced bash profile"
        exit 1
    fi
else
    print_color $RED "❌ Enhanced profile installer not found"
    exit 1
fi

# Step 2: Install Starship (unless skipped)
if [ "$SKIP_STARSHIP" = false ]; then
    print_color $CYAN "⭐ Step 2: Installing Starship Prompt..."
    
    if [ -f "$PROJECT_ROOT/scripts/bash/setup-starship.sh" ]; then
        chmod +x "$PROJECT_ROOT/scripts/bash/setup-starship.sh"
        
        if bash "$PROJECT_ROOT/scripts/bash/setup-starship.sh"; then
            print_color $GREEN "✅ Starship setup completed"
        else
            print_color $YELLOW "⚠️  Starship setup had issues, but continuing..."
        fi
    else
        print_color $YELLOW "⚠️  Starship installer not found, skipping..."
    fi
else
    print_color $YELLOW "⏭️  Skipping Starship installation as requested"
fi

# Step 3: Run tests
print_color $CYAN "🧪 Step 3: Running Profile Tests..."

if [ -f "$PROJECT_ROOT/02-bash-profile/tests/test-profile.sh" ]; then
    chmod +x "$PROJECT_ROOT/02-bash-profile/tests/test-profile.sh"
    
    if bash "$PROJECT_ROOT/02-bash-profile/tests/test-profile.sh"; then
        print_color $GREEN "✅ All profile tests passed"
    else
        print_color $YELLOW "⚠️  Some tests failed, but installation completed"
    fi
else
    print_color $YELLOW "⚠️  Test script not found, skipping tests..."
fi

# Step 4: Show completion message and next steps
print_color $CYAN "🎉 Installation Complete!"
print_color $GREEN "================================"
echo

print_color $YELLOW "📋 What was installed:"
print_color $WHITE "  • Enhanced bash profile with 50+ aliases and functions"
print_color $WHITE "  • Git workflow shortcuts (gs, ga, gc, gp, etc.)"
print_color $WHITE "  • Docker development aliases (d, dps, dcup, etc.)"
print_color $WHITE "  • Kubernetes shortcuts (k, kgs, kgp, etc.)"
print_color $WHITE "  • Improved bash history and completion"
if [ "$SKIP_STARSHIP" = false ]; then
    print_color $WHITE "  • Starship prompt with beautiful themes"
fi

echo
print_color $YELLOW "🚀 Next Steps:"
print_color $WHITE "  1. Restart your terminal or run: source ~/.bashrc"
print_color $WHITE "  2. Try some aliases: gs (git status), ll (list files)"
print_color $WHITE "  3. View all aliases: show-git-aliases, show-docker-aliases"
print_color $WHITE "  4. Get system info: sysinfo"

echo
print_color $YELLOW "💡 Pro Tips:"
print_color $WHITE "  • Use 'cdws' to quickly navigate to this workspace"
print_color $WHITE "  • Use 'extract filename' to extract any archive type"
print_color $WHITE "  • Use 'mkcd dirname' to create and enter a directory"

echo
print_color $YELLOW "📚 Documentation:"
print_color $WHITE "  • README.md - Full feature overview"
print_color $WHITE "  • docs/setup/ - Setup guides for Docker, Kubernetes"
print_color $WHITE "  • 02-bash-profile/ - Enhanced bash profile and tests"

echo
print_color $YELLOW "🔧 Customization:"
print_color $WHITE "  • Edit ~/.bashrc to customize further"
print_color $WHITE "  • Change Starship theme in ~/.config/starship.toml"
print_color $WHITE "  • Add your own aliases to ~/.bash_aliases"

# Offer to reload profile
echo
if [ "$NON_INTERACTIVE" = true ]; then
    print_color $YELLOW "🔄 Reloading bash profile (non-interactive mode)..."
    if source ~/.bashrc 2>/dev/null; then
        print_color $GREEN "✅ Profile reloaded successfully!"
    else
        print_color $YELLOW "⚠️  Please restart your terminal to apply changes"
    fi
else
    read -t 10 -p "Would you like to reload your bash profile now to start using it? (Y/n): " reload_profile

    if [[ ! "$reload_profile" =~ ^[Nn]$ ]]; then
        print_color $YELLOW "🔄 Reloading bash profile..."
        if source ~/.bashrc 2>/dev/null; then
            print_color $GREEN "✅ Profile reloaded successfully!"
            echo
            print_color $CYAN "🎊 Welcome to your enhanced bash environment!"
            print_color $GREEN "Type 'show-git-aliases' to see your new Git shortcuts!"
        else
            print_color $YELLOW "⚠️  Please restart your terminal to apply changes"
        fi
    else
        print_color $YELLOW "Please restart your terminal or run 'source ~/.bashrc' to apply changes"
    fi
fi

print_color $CYAN "Thank you for using Enhanced Bash Profile! 🚀"
