#!/bin/bash
# Enhanced Bash Profile Installer Component
# This script installs the enhanced bash profile from the new organized structure

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script options
FORCE=false
BACKUP=false

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -f, --force    Force installation (overwrite existing profile)"
    echo "  -b, --backup   Create backup of existing profile"
    echo "  -h, --help     Show this help message"
}

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

print_color $CYAN "🚀 Enhanced Bash Profile Installer Component"
print_color $CYAN "==========================================="

# Get paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENHANCED_PROFILE="$REPO_ROOT/02-bash-profile/profile/enhanced-profile.sh"
BASHRC="$HOME/.bashrc"

# Verify the enhanced profile exists
if [ ! -f "$ENHANCED_PROFILE" ]; then
    print_color $RED "❌ Enhanced profile not found: $ENHANCED_PROFILE"
    exit 1
fi

print_color $GREEN "✅ Found enhanced profile: $ENHANCED_PROFILE"

# Create backup if requested or if bashrc exists and force not used
if [ -f "$BASHRC" ]; then
    if [ "$BACKUP" = true ] || [ "$FORCE" = false ]; then
        BACKUP_FILE="$BASHRC.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$BASHRC" "$BACKUP_FILE"
        print_color $GREEN "✅ Backup created: $BACKUP_FILE"
    fi
fi

# Remove existing enhanced profile installation if it exists
if grep -q "Enhanced Bash Profile Configuration" "$BASHRC" 2>/dev/null; then
    print_color $YELLOW "🔄 Removing existing enhanced profile installation..."
    
    # Use sed to remove the section between markers
    if sed -i '/# Enhanced Bash Profile Configuration/,/# End Enhanced Bash Profile Configuration/d' "$BASHRC" 2>/dev/null; then
        print_color $GREEN "✅ Existing installation removed"
    else
        # Fallback method
        awk '
        /# Enhanced Bash Profile Configuration/ { skip=1; next }
        /# End Enhanced Bash Profile Configuration/ { skip=0; next }
        !skip { print }
        ' "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
        print_color $GREEN "✅ Existing installation removed (fallback method)"
    fi
fi

# Install the enhanced profile
print_color $YELLOW "📦 Installing enhanced bash profile..."

{
    echo ""
    echo "# Enhanced Bash Profile Configuration"
    echo "# Installed on: $(date)"
    echo "# Source: Bash DevOps Hub"
    echo ""
    cat "$ENHANCED_PROFILE"
    echo ""
    echo "# End Enhanced Bash Profile Configuration"
    echo ""
} >> "$BASHRC"

print_color $GREEN "✅ Enhanced bash profile installed successfully!"

# Verify installation
if grep -q "Enhanced Bash Profile Configuration" "$BASHRC"; then
    print_color $GREEN "✅ Installation verified in ~/.bashrc"
else
    print_color $RED "❌ Installation verification failed"
    exit 1
fi

print_color $CYAN "🎉 Installation Complete!"
print_color $YELLOW "Next steps:"
print_color $CYAN "1. Restart your terminal OR run: source ~/.bashrc"
print_color $CYAN "2. Try some aliases: gs (git status), ll (list files)"
print_color $CYAN "3. View available shortcuts: show-git-aliases"

print_color $GREEN "✨ Enhanced bash profile is ready to use!"
