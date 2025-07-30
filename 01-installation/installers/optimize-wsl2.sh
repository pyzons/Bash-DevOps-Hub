#!/bin/bash
# WSL2 Optimization Script for Bash DevOps Hub
# Optimizes the installation for Windows 11 WSL2 environment

set -e
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

print_status $CYAN "🪟 WSL2 Optimization for Bash DevOps Hub"
print_status $CYAN "========================================"

# Check if we're in WSL2
if grep -qi microsoft /proc/version; then
    print_status $GREEN "✅ Running in WSL2 environment"
else
    print_status $YELLOW "⚠️  Not detected as WSL2, continuing anyway..."
fi

# Step 1: WSL2-specific aliases
print_status $YELLOW "📝 Adding WSL2-specific aliases..."

WSL2_ALIASES="
# WSL2-specific aliases and functions
alias winpath='wslpath -w'
alias linuxpath='wslpath -u'
alias explorer='explorer.exe'
alias code='code'
alias winget='winget.exe'

# Windows integration shortcuts
winhome() {
    cd \$(wslpath -u \"\$USERPROFILE\") 2>/dev/null || cd ~
}

# Quick access to Windows drives
alias cdrive='cd /mnt/c'
alias ddrive='cd /mnt/d 2>/dev/null || echo \"D: drive not available\"'

# Performance optimizations
alias cls='clear'
alias dir='ls -la'
"

# Add WSL2 aliases to .bashrc if not already present
if ! grep -q "WSL2-specific aliases" ~/.bashrc; then
    echo "$WSL2_ALIASES" >> ~/.bashrc
    print_status $GREEN "✅ WSL2 aliases added"
else
    print_status $CYAN "ℹ️  WSL2 aliases already present"
fi

# Step 2: Configure Git for cross-platform line endings
print_status $YELLOW "🔧 Configuring Git for WSL2..."
git config --global core.autocrlf input
git config --global core.eol lf
print_status $GREEN "✅ Git configured for WSL2"

# Step 3: Docker Desktop integration check
print_status $YELLOW "🐳 Checking Docker integration..."
if command -v docker >/dev/null 2>&1; then
    print_status $GREEN "✅ Docker available"
    docker --version 2>/dev/null || print_status $YELLOW "⚠️  Docker may not be running"
else
    print_status $YELLOW "ℹ️  Docker not found - install Docker Desktop with WSL2 integration"
fi

# Step 4: Starship optimization for WSL2
print_status $YELLOW "⭐ Optimizing Starship for WSL2..."
STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Add WSL2-specific Starship config if it doesn't exist
if [ ! -f "$STARSHIP_CONFIG" ]; then
    mkdir -p ~/.config
    cat > "$STARSHIP_CONFIG" << 'EOF'
# Starship configuration optimized for WSL2
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$python\
$character"""

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = "🌱 "

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"

[hostname]
ssh_only = false
format = "[@$hostname](bold blue) "
disabled = false

[username]
format = "[$user](bold yellow)"
disabled = false
show_always = true
EOF
    print_status $GREEN "✅ Starship WSL2 config created"
else
    print_status $CYAN "ℹ️  Starship config already exists"
fi

# Step 5: Performance optimizations
print_status $YELLOW "⚡ Applying performance optimizations..."

# Add performance-related aliases
PERF_ALIASES="
# Performance and monitoring
alias topme='top -u \$USER'
alias meminfo='free -h'
alias diskinfo='df -h'
alias sysload='uptime'

# WSL2 memory management
alias wsl-compact='echo \"Run in PowerShell: wsl --shutdown && Optimize-VHD -Path \\\$env:LOCALAPPDATA\\\\Packages\\\\*Ubuntu*\\\\LocalState\\\\ext4.vhdx -Mode Full\"'
"

if ! grep -q "Performance and monitoring" ~/.bashrc; then
    echo "$PERF_ALIASES" >> ~/.bashrc
    print_status $GREEN "✅ Performance aliases added"
fi

# Step 6: Create WSL2 status check function
print_status $YELLOW "📊 Creating WSL2 status checker..."

WSL2_STATUS_FUNCTION='
# WSL2 Status Check Function
wsl2-status() {
    echo "=== WSL2 Environment Status ==="
    echo "OS: $(uname -a)"
    echo "Kernel: $(uname -r)"
    echo "Memory: $(free -h | grep Mem:)"
    echo "Disk: $(df -h / | tail -1)"
    echo "Uptime: $(uptime)"
    echo ""
    echo "=== Windows Integration ==="
    which explorer.exe >/dev/null 2>&1 && echo "✅ Windows Explorer integration" || echo "❌ Windows Explorer not available"
    which code >/dev/null 2>&1 && echo "✅ VS Code integration" || echo "❌ VS Code not available"
    which docker >/dev/null 2>&1 && echo "✅ Docker available" || echo "❌ Docker not available"
    echo ""
    echo "=== Enhanced Profile Status ==="
    alias ll >/dev/null 2>&1 && echo "✅ Enhanced aliases loaded" || echo "❌ Enhanced aliases not loaded"
    which starship >/dev/null 2>&1 && echo "✅ Starship prompt available" || echo "❌ Starship not available"
}
'

if ! grep -q "WSL2 Status Check Function" ~/.bashrc; then
    echo "$WSL2_STATUS_FUNCTION" >> ~/.bashrc
    print_status $GREEN "✅ WSL2 status function added"
fi

print_status $CYAN "🎉 WSL2 Optimization Complete!"
print_status $GREEN "========================"
print_status $YELLOW "🚀 Next steps:"
print_status $CYAN "  1. Run: source ~/.bashrc"
print_status $CYAN "  2. Test: wsl2-status"
print_status $CYAN "  3. Try: winpath ."
print_status $CYAN "  4. Test: show-git-aliases"

print_status $GREEN "✨ Your WSL2 environment is now optimized!"
