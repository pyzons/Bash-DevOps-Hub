#!/bin/bash
# Non-Hanging Bash Profile Installer
# This version has zero interactive prompts and won't hang

# Exit on any error
set -e

# Redirect all interactive input to prevent hanging
exec < /dev/null

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    printf "${1}${2}${NC}\n"
}

print_status $CYAN "🚀 Enhanced Bash Profile - Non-Hanging Installer"
print_status $CYAN "================================================"

# Step 1: Basic checks (no hanging)
print_status $YELLOW "🔍 Checking system..."

if [ -z "$BASH_VERSION" ]; then
    print_status $RED "❌ Must run with bash"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    print_status $RED "❌ Git required"
    exit 1
fi

print_status $GREEN "✅ System check passed"

# Step 2: Backup existing bashrc (no prompts)
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
    BACKUP="$BASHRC.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$BASHRC" "$BACKUP" 2>/dev/null || true
    print_status $GREEN "✅ Backup created: $BACKUP"
fi

# Step 3: Get script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to repository root and find the profile script
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROFILE_SCRIPT="$REPO_ROOT/02-bash-profile/profile/enhanced-profile.sh"

if [ ! -f "$PROFILE_SCRIPT" ]; then
    print_status $RED "❌ Profile script not found: $PROFILE_SCRIPT"
    exit 1
fi

print_status $YELLOW "📁 Found profile script: $PROFILE_SCRIPT"

# Step 4: Remove existing installation (no prompts)
if grep -q "Enhanced Bash Profile Configuration" "$BASHRC" 2>/dev/null; then
    print_status $YELLOW "🔄 Removing old installation..."
    # Use sed to remove the section between markers
    sed -i '/# Enhanced Bash Profile Configuration/,/# End Enhanced Bash Profile Configuration/d' "$BASHRC" 2>/dev/null || {
        # Fallback method if sed fails
        awk '
        /# Enhanced Bash Profile Configuration/ { skip=1; next }
        /# End Enhanced Bash Profile Configuration/ { skip=0; next }
        !skip { print }
        ' "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
    }
    print_status $GREEN "✅ Old installation removed"
fi

# Step 5: Install new profile (no hanging operations)
print_status $YELLOW "📦 Installing enhanced profile..."

{
    echo ""
    echo "# Enhanced Bash Profile Configuration"
    echo "# Installed on: $(date)"
    echo "# Source: $0"
    echo ""
    cat "$PROFILE_SCRIPT"
    echo ""
    echo "# End Enhanced Bash Profile Configuration"
    echo ""
} >> "$BASHRC"

print_status $GREEN "✅ Enhanced profile installed"

# Step 6: Install Starship (non-interactive)
print_status $YELLOW "⭐ Installing Starship prompt..."

if command -v curl >/dev/null 2>&1; then
    # Install Starship with forced yes and silent output
    STARSHIP_INSTALL_CMD="curl -sS https://starship.rs/install.sh | sh -s -- --yes"
    if eval "$STARSHIP_INSTALL_CMD" >/dev/null 2>&1; then
        print_status $GREEN "✅ Starship installed"
    else
        print_status $YELLOW "⚠️  Starship installation skipped (may already be installed)"
    fi
else
    print_status $YELLOW "⚠️  curl not available, skipping Starship"
fi

# Step 7: Configure Starship (no prompts)
CONFIG_DIR="$HOME/.config"
STARSHIP_CONFIG="$CONFIG_DIR/starship.toml"

mkdir -p "$CONFIG_DIR" 2>/dev/null || true

if [ ! -f "$STARSHIP_CONFIG" ]; then
    print_status $YELLOW "🎨 Creating Starship configuration..."
    
    cat > "$STARSHIP_CONFIG" << 'STARSHIP_EOF'
# Starship configuration for Enhanced Bash Profile
add_newline = true

format = """
$username$hostname$directory$git_branch$git_status$docker_context$kubernetes$character"""

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[username]
style_user = "bold yellow"
format = "[$user]($style)"
disabled = false
show_always = true

[hostname]
ssh_only = false
format = "@[$hostname](bold blue):"
disabled = false

[directory]
format = "[$path]($style)"
style = "bold cyan"
truncation_length = 3

[git_branch]
format = " on [$symbol$branch]($style)"
symbol = "🌱 "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style))'
style = "bold red"

[docker_context]
format = " via [🐳 $context](blue bold)"

[kubernetes]
format = ' on [⎈ $context](dimmed green)'
disabled = false
STARSHIP_EOF

    print_status $GREEN "✅ Starship configured"
fi

# Step 8: Add Starship init to bashrc (check first to avoid duplicates)
if ! grep -q "starship init bash" "$BASHRC" 2>/dev/null; then
    print_status $YELLOW "🔧 Adding Starship to bash configuration..."
    {
        echo ""
        echo "# Starship prompt initialization"
        echo 'if command -v starship >/dev/null 2>&1; then'
        echo '    eval "$(starship init bash)"'
        echo 'fi'
    } >> "$BASHRC"
    print_status $GREEN "✅ Starship added to configuration"
fi

# Step 9: Final status (no hanging operations)
print_status $CYAN "🎉 Installation Complete!"
print_status $GREEN "========================"

print_status $YELLOW "✨ What's installed:"
print_status $CYAN "  • Enhanced bash profile with 50+ aliases"
print_status $CYAN "  • Git shortcuts: gs, ga, gc, gp, glog, etc."
print_status $CYAN "  • Docker aliases: d, dps, dcup, dcdown, etc."
print_status $CYAN "  • Kubernetes shortcuts: k, kgs, kgp, etc."
print_status $CYAN "  • System utilities: sysinfo, extract, mkcd"
print_status $CYAN "  • Starship prompt with custom configuration"

print_status $YELLOW "🚀 Next steps:"
print_status $CYAN "  1. Run: source ~/.bashrc"
print_status $CYAN "  2. Or restart your terminal"
print_status $CYAN "  3. Try: gs (git status), ll (list files)"
print_status $CYAN "  4. View aliases: show-git-aliases"

print_status $GREEN "🎊 Installation successful - No hanging, no prompts!"

# Exit cleanly without any hanging operations
exit 0
