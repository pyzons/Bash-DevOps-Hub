# ☁️ Cloud Ubuntu Setup Guide - Bash DevOps Hub Deployment

## 🎯 Objective
Deploy the same enhanced bash experience to your cloud Ubuntu instance for a consistent development environment across all platforms (Local Ubuntu → WSL2 → Cloud Ubuntu).

## 📋 Prerequisites

### Cloud Instance Requirements:
- ✅ Ubuntu 20.04 LTS or Ubuntu 22.04 LTS
- ✅ SSH access configured
- ✅ sudo privileges
- ✅ Internet connectivity
- ✅ Git installed (or ability to install)

### Local Machine Requirements:
- ✅ SSH client configured
- ✅ Your cloud instance IP/hostname
- ✅ SSH key or password access

## 🌐 Phase 1: Cloud Instance Access

### Step 1: Connect to Your Cloud Instance
```bash
# Replace with your actual cloud instance details
ssh user@your-cloud-instance-ip

# Or using SSH key
ssh -i ~/.ssh/your-key.pem user@your-cloud-instance-ip

# Example:
# ssh ubuntu@203.0.113.10
# ssh -i ~/.ssh/aws-key.pem ubuntu@ec2-203-0-113-10.compute-1.amazonaws.com
```

### Step 2: System Information Gathering
```bash
# Check Ubuntu version
cat /etc/os-release

# Check available resources
free -h
df -h
uname -a

# Update system packages
sudo apt update && sudo apt upgrade -y
```

## 🔧 Phase 2: Essential Dependencies Installation

### Step 1: Install Core Packages
```bash
# Install essential development tools
sudo apt install -y \
  curl \
  wget \
  git \
  build-essential \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lsb-release \
  unzip \
  vim \
  htop \
  tree \
  jq

# Verify installations
git --version
curl --version
```

### Step 2: Configure Git
```bash
# Set your Git credentials (use your actual details)
git config --global user.name "pyzons"
git config --global user.email "pyzons@gmail.com"

# Configure Git for better performance
git config --global core.editor "vim"
git config --global init.defaultBranch "main"
git config --global pull.rebase false

# Verify configuration
git config --list
```

## 📦 Phase 3: Bash DevOps Hub Installation

### Step 1: Clone the Repository
```bash
# Create workspace directory
mkdir -p ~/workspace
cd ~/workspace

# Clone the Bash DevOps Hub
git clone https://github.com/pyzons/Bash-DevOps-Hub.git
cd Bash-DevOps-Hub

# Verify repository structure
ls -la
```

### Step 2: Install Enhanced Bash Profile
```bash
# Navigate to installation directory
cd 01-installation/installers

# Make installer executable
chmod +x install-no-hang.sh

# Run the no-hang installer (safest for cloud environments)
./install-no-hang.sh

# Alternative: Enhanced installer with more features
# chmod +x install-enhanced-profile.sh
# ./install-enhanced-profile.sh
```

### Step 3: Activate Profile
```bash
# Source the new profile
source ~/.bashrc

# Test basic functionality
gs  # Should show git status
ll  # Should show detailed listing
```

## 🌟 Phase 4: Starship Prompt Installation

### Step 1: Install Starship
```bash
# Install Starship prompt (works on cloud Ubuntu)
curl -sS https://starship.rs/install.sh | sh

# Add to bashrc (should already be done by installer)
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Reload bash configuration
source ~/.bashrc
```

### Step 2: Configure Starship Theme
```bash
# Create Starship config directory
mkdir -p ~/.config

# Copy the custom configuration (if provided by installer)
# Or create a minimal config
cat > ~/.config/starship.toml << 'EOF'
# Minimal cloud-optimized Starship config
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = false

[git_branch]
symbol = "🌱 "

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"

[cmd_duration]
min_time = 500
format = "⏱️ [$duration](bold yellow)"

[memory_usage]
disabled = false
threshold = 70
format = "🐏 [${ram_pct}]($style) "

[time]
disabled = false
format = "🕐 [$time]($style) "
EOF

# Test the new prompt
source ~/.bashrc
```

## 🐳 Phase 5: Docker Integration (Production Ready)

### Step 1: Install Docker
```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt and install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 2: Configure Docker for Cloud
```bash
# Log out and back in for group changes
exit
# Reconnect to your cloud instance

# Test Docker installation
docker --version
docker-compose --version

# Test Docker aliases from the profile
dps  # docker ps
di   # docker images
```

### Step 3: Docker Optimization for Cloud
```bash
# Configure Docker daemon for cloud optimization
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker
sudo systemctl restart docker
```

## ☸️ Phase 6: Kubernetes Tools Installation

### Step 1: Install kubectl
```bash
# Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installation
kubectl version --client
```

### Step 2: Install KIND (Kubernetes in Docker)
```bash
# Download KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Verify installation
kind version
```

### Step 3: Install Helm (Optional)
```bash
# Install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install helm

# Test Kubernetes aliases
k version --client  # kubectl version
kgp                 # kubectl get pods
```

## 🔒 Phase 7: Security & Optimization

### Step 1: SSH Security (If not already configured)
```bash
# Create SSH key for GitHub (if needed)
ssh-keygen -t ed25519 -C "pyzons@gmail.com"

# Display public key to add to GitHub
cat ~/.ssh/id_ed25519.pub

# Test GitHub connection
ssh -T git@github.com
```

### Step 2: System Optimization
```bash
# Configure bash history
echo 'export HISTSIZE=10000' >> ~/.bashrc
echo 'export HISTFILESIZE=10000' >> ~/.bashrc
echo 'export HISTCONTROL=ignoredups:erasedups' >> ~/.bashrc

# Configure timezone (adjust as needed)
sudo timedatectl set-timezone UTC

# Optimize system limits
echo 'ulimit -n 65536' >> ~/.bashrc

# Apply changes
source ~/.bashrc
```

### Step 3: Firewall Configuration (Basic)
```bash
# Enable UFW firewall
sudo ufw enable

# Allow SSH (adjust port if different)
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS if running web services
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Check status
sudo ufw status
```

## 📊 Phase 8: Monitoring & Performance

### Step 1: Install Monitoring Tools
```bash
# Install additional monitoring tools
sudo apt install -y htop iotop nethogs ncdu

# Create useful monitoring aliases
echo 'alias monitor="htop"' >> ~/.bash_aliases
echo 'alias diskspace="ncdu /"' >> ~/.bash_aliases
echo 'alias netmon="sudo nethogs"' >> ~/.bash_aliases

# Reload aliases
source ~/.bashrc
```

### Step 2: Performance Testing
```bash
# Test prompt performance
time (for i in {1..10}; do echo "test"; done)

# Test alias speed
time gs
time ll
time docker --version

# Memory usage check
free -h
```

## 🔄 Phase 9: Backup & Synchronization

### Step 1: Setup Automatic Updates
```bash
# Create update script
cat > ~/update-system.sh << 'EOF'
#!/bin/bash
echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🔄 Updating Bash DevOps Hub..."
cd ~/workspace/Bash-DevOps-Hub
git pull origin main

echo "✅ System updated successfully!"
EOF

chmod +x ~/update-system.sh

# Test the update script
./update-system.sh
```

### Step 2: Profile Backup Strategy
```bash
# Create profile backup
cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d)
cp ~/.bash_aliases ~/.bash_aliases.backup.$(date +%Y%m%d) 2>/dev/null || true

# Create restore script
cat > ~/restore-profile.sh << 'EOF'
#!/bin/bash
echo "🔄 Restoring Bash DevOps Hub profile..."
cd ~/workspace/Bash-DevOps-Hub/01-installation/installers
./install-no-hang.sh
echo "✅ Profile restored successfully!"
EOF

chmod +x ~/restore-profile.sh
```

## ✅ Phase 10: Verification & Testing

### Step 1: Complete Function Test
```bash
# Test all major components
echo "Testing Git aliases..."
gs
ga --help
gc --help

echo "Testing file operations..."
ll
la
lt

echo "Testing system info..."
sysinfo

echo "Testing Docker (if installed)..."
docker --version
dps

echo "Testing Kubernetes (if installed)..."
kubectl version --client
```

### Step 2: Performance Verification
```bash
# Run profile analysis
cd ~/workspace/Bash-DevOps-Hub
./04-dev-tools/analysis/analyze-profile.sh

# Run test suite
./02-bash-profile/tests/test-profile.sh
```

### Step 3: Create Verification Report
```bash
# Generate system report
cat > ~/cloud-setup-report.txt << 'EOF'
=== Cloud Ubuntu Bash DevOps Hub Setup Report ===
Date: $(date)
Hostname: $(hostname)
OS: $(cat /etc/os-release | grep PRETTY_NAME)
Uptime: $(uptime)

=== Installed Components ===
Bash: $(bash --version | head -1)
Git: $(git --version)
Docker: $(docker --version 2>/dev/null || echo "Not installed")
kubectl: $(kubectl version --client --short 2>/dev/null || echo "Not installed")
Starship: $(starship --version 2>/dev/null || echo "Not installed")

=== Repository Status ===
$(cd ~/workspace/Bash-DevOps-Hub && git status --porcelain && echo "Repository clean" || echo "Repository has changes")

=== Profile Status ===
Bash Profile: $(grep -q "Enhanced Bash Profile" ~/.bashrc && echo "✅ Loaded" || echo "❌ Not loaded")
Aliases Count: $(alias | wc -l)
Functions Count: $(declare -F | wc -l)

=== Resource Usage ===
$(free -h)
$(df -h /)

=== Network Status ===
$(ip addr show | grep "inet " | head -5)

Setup completed successfully! 🎉
EOF

# Display the report
cat ~/cloud-setup-report.txt
```

## 🎯 Success Checklist

Your cloud Ubuntu instance should now have:
- ✅ **Enhanced bash profile** with all aliases and functions
- ✅ **Starship prompt** with Git integration
- ✅ **Docker integration** (if installed)
- ✅ **Kubernetes tools** (if installed)
- ✅ **Security optimizations**
- ✅ **Performance monitoring tools**
- ✅ **Backup and restore capabilities**
- ✅ **Consistent experience** across all platforms

## 🚀 Next Steps

### Development Workflow
```bash
# Start your development session
cd ~/workspace/Bash-DevOps-Hub

# Check system status
sysinfo

# Update repository
git pull origin main

# Begin coding with enhanced aliases and tools
```

### Maintenance Tasks
```bash
# Weekly system update
./update-system.sh

# Monthly profile backup
cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d)

# Check system health
htop
df -h
```

## 🆘 Troubleshooting Cloud-Specific Issues

### Issue 1: Slow Network Performance
```bash
# Test network speed
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -

# Optimize network settings
echo 'net.core.rmem_max = 16777216' | sudo tee -a /etc/sysctl.conf
echo 'net.core.wmem_max = 16777216' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Issue 2: Limited Resources
```bash
# Monitor resources
htop
iotop
df -h

# Optimize for low resources
export STARSHIP_CONFIG=~/.config/starship-minimal.toml
```

### Issue 3: SSH Connection Issues
```bash
# Check SSH service
sudo systemctl status ssh

# Restart SSH if needed
sudo systemctl restart ssh

# Check SSH logs
sudo tail -f /var/log/auth.log
```

---

**🌟 Cloud Deployment Complete!**

You now have a fully functional, enhanced bash development environment on your cloud Ubuntu instance that matches your local and WSL2 setups.

**📍 Repository**: https://github.com/pyzons/Bash-DevOps-Hub  
**📧 Support**: Create an issue on GitHub for cloud-specific problems  
**⭐ Success?**: Star the repository if this cloud setup worked perfectly!
