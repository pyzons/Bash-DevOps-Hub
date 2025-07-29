# 🪟 Windows 11 WSL2 Setup Guide - Bash DevOps Hub Recovery

## 🎯 Objective
Set up the same enhanced bash experience from this chat session on your Windows 11 laptop using WSL2, then replicate it on your cloud Ubuntu instance.

## 📋 Prerequisites Checklist

### Windows 11 Requirements:
- ✅ Windows 11 with WSL2 enabled
- ✅ Ubuntu WSL2 distribution installed
- ✅ Windows Terminal (recommended)
- ✅ Git configured with your GitHub credentials

### Verification Commands:
```powershell
# Check WSL2 status
wsl --list --verbose

# Check Ubuntu is running
wsl -d Ubuntu

# Check Windows Terminal
wt --version
```

## 🚀 Phase 1: WSL2 Ubuntu Setup

### Step 1: Access WSL2 Ubuntu
```powershell
# Open Windows Terminal
wt

# Start Ubuntu WSL2
wsl -d Ubuntu
# OR click Ubuntu tab in Windows Terminal
```

### Step 2: Update Ubuntu System
```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y curl wget git build-essential
```

### Step 3: Configure Git (if not already done)
```bash
# Set your Git credentials
git config --global user.name "pyzons"
git config --global user.email "pyzons@gmail.com"

# Verify configuration
git config --list
```

## 🔄 Phase 2: Clone & Install Bash DevOps Hub

### Step 1: Clone the Repository
```bash
# Navigate to home directory
cd ~

# Create a workspace directory
mkdir -p ~/workspace
cd ~/workspace

# Clone the Bash DevOps Hub
git clone https://github.com/pyzons/Bash-DevOps-Hub.git
cd Bash-DevOps-Hub
```

### Step 2: Install the Enhanced Bash Profile
```bash
# Use the guaranteed no-hang installer
cd 01-installation/installers
chmod +x install-no-hang.sh
./install-no-hang.sh
```

### Step 3: Activate the New Profile
```bash
# Reload bash profile
source ~/.bashrc

# OR restart terminal
exit
# Then reopen WSL2 Ubuntu
```

### Step 4: Verify Installation
```bash
# Test Git aliases
gs  # Should show git status

# Test file listing
ll  # Should show detailed file listing

# Test system info
sysinfo  # Should display system information

# View all available aliases
show-git-aliases
show-docker-aliases
show-k8s-aliases
```

## 🌟 Phase 3: Starship Prompt Setup

### Install Starship (if not already installed)
```bash
# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh

# Add to bashrc (should already be done by installer)
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Reload
source ~/.bashrc
```

### Verify Starship Configuration
```bash
# Check Starship config
cat ~/.config/starship.toml

# Test prompt (should show modern prompt with Git info)
cd ~/workspace/Bash-DevOps-Hub
# Prompt should show Git branch and status
```

## 🐳 Phase 4: Docker Integration (Optional)

### Install Docker on WSL2
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker service
sudo service docker start

# Test Docker aliases
dps  # docker ps
di   # docker images
```

## ☸️ Phase 5: Kubernetes Integration (Optional)

### Install kubectl and KIND
```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Test Kubernetes aliases
k version --client  # kubectl version
```

## 🖥️ Phase 6: Windows Terminal Integration

### Configure Windows Terminal for Enhanced Experience
```json
// Add to Windows Terminal settings.json
{
    "profiles": {
        "list": [
            {
                "name": "Bash DevOps Hub",
                "source": "Windows.Terminal.Wsl",
                "distribution": "Ubuntu",
                "startingDirectory": "~/workspace/Bash-DevOps-Hub",
                "colorScheme": "One Half Dark",
                "fontSize": 12,
                "fontFace": "Cascadia Code PL"
            }
        ]
    }
}
```

## 📁 Phase 7: Workspace Setup

### VS Code Integration
```bash
# Install VS Code in WSL2 (if not already done)
# Open repository in VS Code
code ~/workspace/Bash-DevOps-Hub

# Use the organized workspace
code Bash-DevOps-Hub-Organized.code-workspace
```

### Directory Structure Verification
```bash
# Your WSL2 setup should now have:
~/workspace/Bash-DevOps-Hub/
├── 01-installation/
├── 02-bash-profile/
├── 03-prompt-theming/
├── 04-dev-tools/
├── 05-docker-integration/
├── 06-kubernetes-integration/
├── 07-documentation/
├── 08-legacy-archive/
└── 09-chat-recovery/  # This guide!
```

## 🧪 Phase 8: Testing & Verification

### Run Complete Test Suite
```bash
# Navigate to repository
cd ~/workspace/Bash-DevOps-Hub

# Test profile analysis
./04-dev-tools/analysis/analyze-profile.sh

# Test all installations work
./02-bash-profile/tests/test-profile.sh
```

### Performance Test
```bash
# Test prompt speed
time (for i in {1..10}; do echo "test"; done)

# Test alias speed
time gs
time ll
```

## ✨ Phase 9: Customization & Personalization

### Custom Aliases (Optional)
```bash
# Add your custom aliases to ~/.bash_aliases
echo 'alias cdws="cd ~/workspace/Bash-DevOps-Hub"' >> ~/.bash_aliases
echo 'alias update="sudo apt update && sudo apt upgrade"' >> ~/.bash_aliases

# Reload
source ~/.bashrc
```

### Starship Theme Customization
```bash
# Try different Starship presets
starship preset gruvbox-rainbow -o ~/.config/starship.toml
starship preset tokyo-night -o ~/.config/starship.toml
starship preset pastel-powerline -o ~/.config/starship.toml

# Reload to see changes
source ~/.bashrc
```

## 🔧 Troubleshooting

### Common Issues & Solutions

#### 1. Starship Not Loading
```bash
# Check if Starship is in PATH
which starship

# Reinstall if needed
curl -sS https://starship.rs/install.sh | sh

# Ensure it's in bashrc
grep "starship init" ~/.bashrc
```

#### 2. Docker Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
exit
# Reopen WSL2
```

#### 3. Git Aliases Not Working
```bash
# Check if profile is loaded
grep "Enhanced Bash Profile" ~/.bashrc

# Reload profile
source ~/.bashrc

# Test specific alias
type gs
```

#### 4. WSL2 Performance Issues
```powershell
# In PowerShell, restart WSL2
wsl --shutdown
wsl -d Ubuntu
```

## 🎯 Success Verification Checklist

After setup, you should have:
- ✅ **Enhanced bash prompt** with Git status and themes
- ✅ **50+ working aliases** (gs, ga, gc, ll, etc.)
- ✅ **Docker integration** (if installed)
- ✅ **Kubernetes shortcuts** (if installed)
- ✅ **Fast, responsive terminal**
- ✅ **Professional development environment**
- ✅ **All features from the original chat session**

## 🚀 Next: Cloud Ubuntu Instance

Once your WSL2 setup is complete and verified, proceed to the Cloud Ubuntu Setup Guide to replicate this experience on your cloud development instance.

---

**📍 Repository**: https://github.com/pyzons/Bash-DevOps-Hub
**📧 Support**: Create an issue on GitHub if you encounter problems
**⭐ Success?**: Star the repository if this setup worked for you!
