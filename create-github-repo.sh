#!/bin/bash
# GitHub Repository Creation and Sync Script
# Creates a new GitHub repository and syncs all local changes

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    printf "${1}${2}${NC}\n"
}

print_status $CYAN "🚀 GitHub Repository Creation & Sync"
print_status $CYAN "===================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_status $RED "❌ Not in a git repository"
    print_status $YELLOW "💡 Run: git init"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh >/dev/null 2>&1; then
    print_status $RED "❌ GitHub CLI (gh) is not installed"
    print_status $YELLOW "💡 Install it from: https://cli.github.com/"
    print_status $YELLOW "💡 Or use manual method below"
    
    # Provide manual alternative
    print_status $BLUE "📋 Manual Alternative:"
    print_status $WHITE "1. Go to https://github.com/new"
    print_status $WHITE "2. Create repository: Bash-DevOps-Hub"
    print_status $WHITE "3. Run: git remote add origin https://github.com/YOUR_USERNAME/Bash-DevOps-Hub.git"
    print_status $WHITE "4. Run: git push -u origin main"
    exit 1
fi

# Check if user is logged in to GitHub CLI
if ! gh auth status >/dev/null 2>&1; then
    print_status $RED "❌ Not logged in to GitHub CLI"
    print_status $YELLOW "💡 Run: gh auth login"
    exit 1
fi

# Get current repository status
print_status $YELLOW "🔍 Checking repository status..."

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    print_status $YELLOW "⚠️  Found uncommitted changes:"
    git status --porcelain | head -10
    echo
    read -p "Commit all changes before sync? (Y/n): " commit_changes
    
    if [[ ! "$commit_changes" =~ ^[Nn]$ ]]; then
        print_status $YELLOW "📝 Staging all changes..."
        git add .
        
        read -p "Enter commit message (or press Enter for default): " commit_msg
        if [ -z "$commit_msg" ]; then
            commit_msg="feat: reorganize repository into sub-projects with enhanced bash profile"
        fi
        
        git commit -m "$commit_msg"
        print_status $GREEN "✅ Changes committed"
    else
        print_status $RED "❌ Cannot sync with uncommitted changes"
        exit 1
    fi
fi

# Repository configuration
REPO_NAME="Bash-DevOps-Hub"
REPO_DESCRIPTION="A comprehensive, well-organized Bash development environment with Git, Docker, and Kubernetes integration"

print_status $YELLOW "📋 Repository Configuration:"
print_status $CYAN "  Name: $REPO_NAME"
print_status $CYAN "  Description: $REPO_DESCRIPTION"
print_status $CYAN "  Visibility: Public"

echo
read -p "Proceed with creating GitHub repository? (Y/n): " proceed
if [[ "$proceed" =~ ^[Nn]$ ]]; then
    print_status $YELLOW "❌ Operation cancelled"
    exit 0
fi

# Create GitHub repository
print_status $YELLOW "🚀 Creating GitHub repository..."

if gh repo create "$REPO_NAME" \
    --description "$REPO_DESCRIPTION" \
    --public \
    --source=. \
    --remote=origin \
    --push; then
    
    print_status $GREEN "✅ GitHub repository created successfully!"
    
    # Get the repository URL
    REPO_URL=$(gh repo view --json url --jq .url)
    print_status $GREEN "📍 Repository URL: $REPO_URL"
    
else
    print_status $RED "❌ Failed to create GitHub repository"
    print_status $YELLOW "💡 Repository might already exist or there was an authentication issue"
    exit 1
fi

# Verify the push was successful
print_status $YELLOW "🔍 Verifying sync..."

if git ls-remote origin >/dev/null 2>&1; then
    print_status $GREEN "✅ Repository successfully synced to GitHub"
    
    # Show repository information
    print_status $CYAN "📊 Repository Information:"
    gh repo view --json name,description,url,defaultBranch,pushedAt | jq -r '
        "  📁 Name: " + .name,
        "  📝 Description: " + .description,
        "  🌐 URL: " + .url,
        "  🌿 Default Branch: " + .defaultBranch,
        "  📅 Last Push: " + .pushedAt
    '
    
else
    print_status $RED "❌ Failed to verify repository sync"
    exit 1
fi

# Show final status and next steps
print_status $GREEN "🎉 GitHub Repository Setup Complete!"
print_status $GREEN "===================================="

print_status $YELLOW "✨ What was accomplished:"
print_status $WHITE "  • Created new GitHub repository: $REPO_NAME"
print_status $WHITE "  • Committed all local changes"
print_status $WHITE "  • Pushed organized repository structure to GitHub"
print_status $WHITE "  • Set up origin remote for future pushes"

print_status $YELLOW "🚀 Next Steps:"
print_status $WHITE "  1. Visit: $REPO_URL"
print_status $WHITE "  2. Add repository description and topics on GitHub"
print_status $WHITE "  3. Consider adding a LICENSE file"
print_status $WHITE "  4. Set up GitHub Pages if desired"

print_status $YELLOW "🔧 Future Git Workflow:"
print_status $WHITE "  • Make changes: git add . && git commit -m 'your message'"
print_status $WHITE "  • Push changes: git push"
print_status $WHITE "  • Pull updates: git pull"

print_status $GREEN "🎊 Your Bash DevOps Hub is now live on GitHub!"
