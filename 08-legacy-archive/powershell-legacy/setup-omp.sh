#!/bin/bash
# Starship Prompt Setup Script for Enhanced Bash Profile
# This script installs and configures Starship - a modern, fast, customizable prompt

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

print_color $CYAN "⭐ Starship Prompt Setup for Enhanced Bash Profile"
print_color $CYAN "================================================="

# Check if Starship is already installed
if command -v starship &> /dev/null; then
    print_color $GREEN "✅ Starship is already installed!"
    STARSHIP_VERSION=$(starship --version | awk '{print $2}')
    print_color $YELLOW "Current version: $STARSHIP_VERSION"
    
    read -p "Would you like to update to the latest version? (y/N): " update_starship
    if [[ ! "$update_starship" =~ ^[Yy]$ ]]; then
        print_color $YELLOW "Proceeding with configuration..."
    else
        print_color $YELLOW "📦 Updating Starship..."
        curl -sS https://starship.rs/install.sh | sh
        print_color $GREEN "✅ Starship updated!"
    fi
else
    print_color $YELLOW "📦 Installing Starship..."
    
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        print_color $RED "❌ curl is required but not installed."
        print_color $YELLOW "Please install curl first:"
        print_color $YELLOW "  sudo apt-get install curl (Ubuntu/Debian)"
        print_color $YELLOW "  sudo yum install curl (RHEL/CentOS)"
        exit 1
    fi
    
    # Install Starship
    curl -sS https://starship.rs/install.sh | sh
    
    # Add Starship to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    print_color $GREEN "✅ Starship installed!"
fi

# Create Starship configuration directory
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

print_color $YELLOW "📁 Creating Starship configuration..."

# Create enhanced Starship configuration
cat > "$CONFIG_DIR/starship.toml" << 'EOF'
# Starship Configuration for Enhanced Bash Profile
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Inserts a blank line between shell prompts
add_newline = true

# Main prompt format
format = """
[┌─](bold green)$username$hostname$directory$git_branch$git_status$docker_context$kubernetes$cmd_duration
[└─](bold green)$character"""

# Right prompt format (shows on the right side)
right_format = """$time$memory_usage"""

# Username
[username]
style_user = "bold yellow"
style_root = "bold red"
format = "[$user]($style)"
disabled = false
show_always = true

# Hostname
[hostname]
ssh_only = false
format = "@[$hostname](bold blue) "
disabled = false

# Directory
[directory]
format = "in [$path]($style)[$read_only]($read_only_style) "
style = "bold cyan"
read_only = "🔒"
truncation_length = 3
truncate_to_repo = true

# Git branch
[git_branch]
format = "on [$symbol$branch]($style) "
symbol = "🌱 "
style = "bold purple"

# Git status
[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"
conflicted = "🏳"
up_to_date = "✓"
untracked = "🤷"
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
stashed = "📦"
modified = "📝"
staged = '[++\($count\)](green)'
renamed = "👅"
deleted = "🗑"

# Docker context
[docker_context]
format = "via [🐳 $context](blue bold)"
only_with_files = true

# Kubernetes
[kubernetes]
format = 'on [⎈ $context\($namespace\)](dimmed green) '
disabled = false
[kubernetes.context_aliases]
"docker-desktop" = "docker"
"kind-.*" = "kind"

# Command duration
[cmd_duration]
format = "took [$duration]($style) "
style = "bold yellow"
min_time = 2_000

# Time
[time]
disabled = false
format = '🕙[\[ $time \]]($style) '
time_format = "%T"
style = "bold white"

# Memory usage
[memory_usage]
disabled = false
threshold = 70
format = "via $symbol [${ram}( | ${swap})]($style) "
style = "bold dimmed red"
symbol = "🐏"

# Character (prompt symbol)
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
EOF

print_color $GREEN "✅ Starship configuration created!"

# Check if Starship is already configured in .bashrc
BASHRC="$HOME/.bashrc"
if grep -q "starship init bash" "$BASHRC"; then
    print_color $GREEN "✅ Starship is already configured in .bashrc"
else
    print_color $YELLOW "🔧 Configuring Starship in .bashrc..."
    
    # Add Starship initialization to .bashrc
    cat >> "$BASHRC" << 'EOF'

# Starship prompt configuration
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi
EOF
    
    print_color $GREEN "✅ Starship configured in .bashrc"
fi

# Show configuration info
print_color $CYAN "⭐ Starship Configuration Complete!"
print_color $YELLOW "Configuration file: $CONFIG_DIR/starship.toml"

print_color $CYAN "💡 Starship Management Commands:"
print_color $YELLOW "  starship config     - Edit configuration"
print_color $YELLOW "  starship explain    - Explain current prompt"
print_color $YELLOW "  starship preset     - Use a preset configuration"
print_color $YELLOW "  starship print-config - Print current configuration"

print_color $CYAN "🎨 Available Presets:"
print_color $YELLOW "  starship preset bracketed-segments -o ~/.config/starship.toml"
print_color $YELLOW "  starship preset gruvbox-rainbow -o ~/.config/starship.toml"
print_color $YELLOW "  starship preset jetpack -o ~/.config/starship.toml"
print_color $YELLOW "  starship preset nerd-font-symbols -o ~/.config/starship.toml"
print_color $YELLOW "  starship preset no-runtime-versions -o ~/.config/starship.toml"
print_color $YELLOW "  starship preset pastel-powerline -o ~/.config/starship.toml"
print_color $YELLOW "  starship preset tokyo-night -o ~/.config/starship.toml"

# Install a Nerd Font for better icons (optional)
print_color $CYAN "🔤 Font Recommendation:"
print_color $YELLOW "For best experience, install a Nerd Font:"
print_color $YELLOW "  https://www.nerdfonts.com/font-downloads"
print_color $YELLOW "  Recommended: Fira Code Nerd Font, JetBrains Mono Nerd Font"

# Offer to reload the profile
read -p "Would you like to reload your bash profile to apply Starship? (Y/n): " reload_bash
if [[ ! "$reload_bash" =~ ^[Nn]$ ]]; then
    exec bash
else
    print_color $GREEN "✅ Setup complete! Restart your terminal or run 'exec bash' to see the new prompt."
fi

print_color $CYAN "🎉 Starship setup complete!"
print_color $GREEN "Your enhanced bash profile now includes a beautiful, fast, and informative prompt!"
print_color $PURPLE "✨ Starship is much faster and more customizable than traditional prompts!"
