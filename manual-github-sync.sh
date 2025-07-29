#!/bin/bash
# Manual GitHub Repository Sync Script
# For when GitHub CLI is not available

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

print_status() {
    printf "${1}${2}${NC}\n"
}

print_status $CYAN "📋 Manual GitHub Repository Setup"
print_status $CYAN "================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_status $RED "❌ Not in a git repository"
    print_status $YELLOW "💡 Run: git init"
    exit 1
fi

# Check current git status
print_status $YELLOW "🔍 Checking repository status..."

if [ -n "$(git status --porcelain)" ]; then
    print_status $YELLOW "⚠️  Found uncommitted changes:"
    git status --porcelain | head -10
    echo
    print_status $YELLOW "📝 Committing all changes..."
    git add .
    git commit -m "feat: reorganize repository into sub-projects with enhanced bash profile"
    print_status $GREEN "✅ Changes committed"
fi

# Provide step-by-step instructions
print_status $BLUE "📋 Manual Setup Instructions:"
print_status $BLUE "============================="

print_status $YELLOW "Step 1: Create GitHub Repository"
print_status $WHITE "1. Open: https://github.com/new"
print_status $WHITE "2. Repository name: Bash-DevOps-Hub"
print_status $WHITE "3. Description: A comprehensive, well-organized Bash development environment"
print_status $WHITE "4. Set to: Public"
print_status $WHITE "5. Do NOT initialize with README, .gitignore, or license"
print_status $WHITE "6. Click 'Create repository'"

echo
read -p "Press Enter after creating the GitHub repository..."

print_status $YELLOW "Step 2: Get Your GitHub Username"
read -p "Enter your GitHub username: " github_username

if [ -z "$github_username" ]; then
    print_status $RED "❌ GitHub username is required"
    exit 1
fi

REPO_URL="https://github.com/$github_username/Bash-DevOps-Hub.git"

print_status $YELLOW "Step 3: Configure Git Remote"
print_status $CYAN "Repository URL: $REPO_URL"

# Check if origin remote already exists
if git remote get-url origin >/dev/null 2>&1; then
    print_status $YELLOW "⚠️  Origin remote already exists. Updating..."
    git remote set-url origin "$REPO_URL"
else
    print_status $YELLOW "📡 Adding origin remote..."
    git remote add origin "$REPO_URL"
fi

print_status $GREEN "✅ Remote configured"

print_status $YELLOW "Step 4: Push to GitHub"
print_status $CYAN "Pushing to: $REPO_URL"

# Ensure we're on main branch
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    print_status $YELLOW "🌿 Switching to main branch..."
    git checkout -b main 2>/dev/null || git checkout main
fi

# Push to GitHub
if git push -u origin main; then
    print_status $GREEN "✅ Successfully pushed to GitHub!"
else
    print_status $RED "❌ Failed to push to GitHub"
    print_status $YELLOW "💡 Make sure you:"
    print_status $WHITE "  • Created the repository on GitHub"
    print_status $WHITE "  • Used the correct username"
    print_status $WHITE "  • Have proper authentication set up"
    exit 1
fi

# Verify the connection
print_status $YELLOW "🔍 Verifying connection..."

if git ls-remote origin >/dev/null 2>&1; then
    print_status $GREEN "✅ Repository successfully connected to GitHub"
else
    print_status $YELLOW "⚠️  Could not verify connection, but push appeared successful"
fi

# Final summary
print_status $GREEN "🎉 Manual GitHub Setup Complete!"
print_status $GREEN "================================"

print_status $YELLOW "✨ Repository Information:"
print_status $WHITE "  📁 Local Path: $(pwd)"
print_status $WHITE "  🌐 GitHub URL: https://github.com/$github_username/Bash-DevOps-Hub"
print_status $WHITE "  📡 Remote: $REPO_URL"
print_status $WHITE "  🌿 Branch: main"

print_status $YELLOW "🚀 Next Steps:"
print_status $WHITE "  1. Visit: https://github.com/$github_username/Bash-DevOps-Hub"
print_status $WHITE "  2. Verify all files are present"
print_status $WHITE "  3. Add topics and description on GitHub"
print_status $WHITE "  4. Consider adding a LICENSE file"

print_status $YELLOW "🔧 Future Git Commands:"
print_status $WHITE "  • git add . && git commit -m 'your message'"
print_status $WHITE "  • git push"
print_status $WHITE "  • git pull"

print_status $GREEN "🎊 Your Bash DevOps Hub is now live on GitHub!"
