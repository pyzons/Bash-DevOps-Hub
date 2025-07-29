#!/bin/bash
# Simple Enhanced Bash Profile Installer (No Hanging Version)
# This script installs the enhanced bash profile without interactive prompts

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

print_color $CYAN "🚀 Enhanced Bash Profile - Simple Installer"
print_color $CYAN "==========================================="

# Check prerequisites
print_color $YELLOW "🔍 Checking prerequisites..."

if [ -z "$BASH_VERSION" ]; then
    print_color $RED "❌ This installer must be run with bash"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    print_color $RED "❌ Git is required but not installed"
    exit 1
fi

print_color $GREEN "✅ Prerequisites check passed"

# Backup existing .bashrc
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
    BACKUP_PATH="$BASHRC.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$BASHRC" "$BACKUP_PATH"
    print_color $GREEN "✅ Backup created: $BACKUP_PATH"
fi

# Get the enhanced profile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENHANCED_PROFILE="$REPO_ROOT/02-bash-profile/profile/enhanced-profile.sh"

if [ ! -f "$ENHANCED_PROFILE" ]; then
    print_color $RED "❌ Enhanced profile not found: $ENHANCED_PROFILE"
    exit 1
fi

# Remove existing enhanced profile configuration if it exists
if grep -q "Enhanced Bash Profile Configuration" "$BASHRC" 2>/dev/null; then
    print_color $YELLOW "🔄 Removing existing enhanced profile configuration..."
    # Create a temporary file without the enhanced profile section
    awk '
    /# Enhanced Bash Profile Configuration/ { skip=1 }
    /# End Enhanced Bash Profile Configuration/ { skip=0; next }
    !skip
    ' "$BASHRC" > "$BASHRC.tmp"
    mv "$BASHRC.tmp" "$BASHRC"
fi

# Add enhanced profile
print_color $YELLOW "📦 Installing enhanced bash profile..."
{
    echo ""
    echo "# Enhanced Bash Profile Configuration"
    echo "# Added by Enhanced Bash Profile Installer"
    echo "# $(date)"
    echo ""
    cat "$ENHANCED_PROFILE"
    echo ""
    echo "# End Enhanced Bash Profile Configuration"
} >> "$BASHRC"

print_color $GREEN "✅ Enhanced bash profile installed!"

# Install Starship (optional)
print_color $YELLOW "⭐ Installing Starship prompt (optional)..."
if command -v curl >/dev/null 2>&1; then
    # Install Starship silently
    curl -sS https://starship.rs/install.sh | sh -s -- --yes >/dev/null 2>&1 || true
    
    # Create basic Starship config
    mkdir -p ~/.config
    if [ ! -f ~/.config/starship.toml ]; then
        cat > ~/.config/starship.toml << 'EOF'
# Basic Starship configuration for enhanced bash profile
add_newline = true

format = """
[┌─](bold green)$username$hostname$directory$git_branch$git_status$docker_context$kubernetes
[└─](bold green)$character"""

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[username]
style_user = "bold yellow"
style_root = "bold red"
format = "[$user]($style)"
disabled = false
show_always = true

[hostname]
ssh_only = false
format = "@[$hostname](bold blue) "
disabled = false

[directory]
format = "in [$path]($style) "
style = "bold cyan"
truncation_length = 3

[git_branch]
format = "on [$symbol$branch]($style) "
symbol = "🌱 "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"

[docker_context]
format = "via [🐳 $context](blue bold) "
only_with_files = false

[kubernetes]
format = 'on [⎈ $context](dimmed green) '
disabled = false
EOF
        print_color $GREEN "✅ Starship installed and configured!"
    fi
    
    # Add Starship to bashrc if not already there
    if ! grep -q "starship init bash" "$BASHRC"; then
        echo "" >> "$BASHRC"
        echo "# Starship prompt" >> "$BASHRC"
        echo 'if command -v starship &> /dev/null; then' >> "$BASHRC"
        echo '    eval "$(starship init bash)"' >> "$BASHRC"
        echo 'fi' >> "$BASHRC"
        print_color $GREEN "✅ Starship configured in .bashrc"
    fi
else
    print_color $YELLOW "⚠️  curl not available, skipping Starship installation"
fi

# Final message
print_color $CYAN "🎉 Installation Complete!"
print_color $GREEN "================================"
print_color $YELLOW "What was installed:"
print_color $WHITE "  • Enhanced bash profile with 50+ aliases"
print_color $WHITE "  • Git shortcuts (gs, ga, gc, gp, etc.)"
print_color $WHITE "  • Docker aliases (d, dps, dcup, etc.)"
print_color $WHITE "  • Kubernetes shortcuts (k, kgs, kgp, etc.)"
print_color $WHITE "  • System utilities (sysinfo, extract, mkcd)"
print_color $WHITE "  • Starship prompt (if curl was available)"

print_color $YELLOW "🚀 Next Steps:"
print_color $WHITE "  1. Restart your terminal OR run: source ~/.bashrc"
print_color $WHITE "  2. Try: gs (git status), ll (list files)"
print_color $WHITE "  3. View aliases: show-git-aliases"
print_color $WHITE "  4. Get system info: sysinfo"

print_color $GREEN "Installation completed successfully! 🎊"
