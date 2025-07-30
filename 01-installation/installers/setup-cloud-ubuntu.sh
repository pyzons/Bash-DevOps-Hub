#!/bin/bash
# Cloud Ubuntu Setup Script for Bash DevOps Hub
# Deploy identical environment to cloud Ubuntu instance

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

print_status $CYAN "☁️  Cloud Ubuntu Setup for Bash DevOps Hub"
print_status $CYAN "=========================================="

# Step 1: System Updates
print_status $YELLOW "📦 Updating system packages..."
sudo apt update -y >/dev/null 2>&1
sudo apt upgrade -y >/dev/null 2>&1
print_status $GREEN "✅ System updated"

# Step 2: Install essential packages
print_status $YELLOW "🔧 Installing essential packages..."
sudo apt install -y curl wget git build-essential unzip tree htop >/dev/null 2>&1
print_status $GREEN "✅ Essential packages installed"

# Step 3: Clone repository (if not already present)
if [ ! -d "Bash-DevOps-Hub" ]; then
    print_status $YELLOW "📥 Cloning Bash DevOps Hub repository..."
    git clone https://github.com/pyzons/Bash-DevOps-Hub.git
    cd Bash-DevOps-Hub
    print_status $GREEN "✅ Repository cloned"
else
    print_status $CYAN "ℹ️  Repository already exists"
    cd Bash-DevOps-Hub
    git pull origin main >/dev/null 2>&1 || print_status $YELLOW "⚠️  Could not update repository"
fi

# Step 4: Install enhanced profile
print_status $YELLOW "🚀 Installing enhanced bash profile..."
cd 01-installation/installers
chmod +x install-no-hang.sh
./install-no-hang.sh >/dev/null 2>&1
print_status $GREEN "✅ Enhanced profile installed"

# Step 5: Cloud-specific optimizations
print_status $YELLOW "☁️  Adding cloud-specific optimizations..."

CLOUD_ALIASES="
# Cloud Ubuntu specific aliases
alias sshkeys='ls -la ~/.ssh/'
alias pubkey='cat ~/.ssh/id_rsa.pub 2>/dev/null || echo \"No SSH key found\"'
alias genkey='ssh-keygen -t rsa -b 4096 -C \"\$(whoami)@\$(hostname)\"'
alias cloudip='curl -s ifconfig.me && echo'
alias internalip='hostname -I | awk \"{print \$1}\"'

# Server management
alias ports='netstat -tuln'
alias processes='ps aux | head -20'
alias diskusage='du -sh * | sort -hr'

# Git shortcuts for cloud development
alias gitsetup='echo \"Run: git config --global user.name \\\"Your Name\\\" && git config --global user.email \\\"your.email@example.com\\\"\"'
"

# Add cloud aliases if not present
if ! grep -q "Cloud Ubuntu specific aliases" ~/.bashrc; then
    echo "$CLOUD_ALIASES" >> ~/.bashrc
    print_status $GREEN "✅ Cloud aliases added"
else
    print_status $CYAN "ℹ️  Cloud aliases already present"
fi

# Step 6: Docker installation (optional)
print_status $YELLOW "🐳 Setting up Docker (optional)..."
if ! command -v docker >/dev/null 2>&1; then
    print_status $YELLOW "📦 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh >/dev/null 2>&1
    sudo sh get-docker.sh >/dev/null 2>&1
    sudo usermod -aG docker $USER
    rm get-docker.sh
    print_status $GREEN "✅ Docker installed (restart session to use)"
else
    print_status $CYAN "ℹ️  Docker already installed"
fi

# Step 7: Create cloud status checker
CLOUD_STATUS_FUNCTION='
# Cloud Ubuntu Status Checker
cloud-status() {
    echo "=== Cloud Ubuntu Environment Status ==="
    echo "Hostname: $(hostname)"
    echo "Public IP: $(curl -s ifconfig.me 2>/dev/null || echo \"Not available\")"
    echo "Internal IP: $(hostname -I | awk \"{print \$1}\")"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime)"
    echo "Memory: $(free -h | grep Mem:)"
    echo "Disk: $(df -h / | tail -1)"
    echo ""
    echo "=== Services Status ==="
    systemctl is-active ssh >/dev/null 2>&1 && echo "✅ SSH service active" || echo "❌ SSH service inactive"
    which docker >/dev/null 2>&1 && echo "✅ Docker available" || echo "❌ Docker not available"
    which git >/dev/null 2>&1 && echo "✅ Git available" || echo "❌ Git not available"
    which starship >/dev/null 2>&1 && echo "✅ Starship available" || echo "❌ Starship not available"
    echo ""
    echo "=== Enhanced Profile Status ==="
    alias ll >/dev/null 2>&1 && echo "✅ Enhanced aliases loaded" || echo "❌ Enhanced aliases not loaded"
}
'

if ! grep -q "Cloud Ubuntu Status Checker" ~/.bashrc; then
    echo "$CLOUD_STATUS_FUNCTION" >> ~/.bashrc
    print_status $GREEN "✅ Cloud status function added"
fi

print_status $CYAN "🎉 Cloud Ubuntu Setup Complete!"
print_status $GREEN "============================"
print_status $YELLOW "🚀 Next steps:"
print_status $CYAN "  1. Run: source ~/.bashrc"
print_status $CYAN "  2. Test: cloud-status"
print_status $CYAN "  3. Configure: gitsetup"
print_status $CYAN "  4. Optional: logout/login to use Docker"

print_status $GREEN "☁️  Your cloud environment is ready!"
