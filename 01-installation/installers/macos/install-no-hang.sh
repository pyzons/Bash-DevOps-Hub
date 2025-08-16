#!/bin/zsh
# Non-Hanging Zsh Profile Installer for macOS
# Zero interactive prompts, designed for Zsh on macOS

set -e
exec < /dev/null

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    printf "${1}${2}${NC}\n"
}

print_status $CYAN "🚀 Enhanced Zsh Profile - Non-Hanging Installer (macOS)"
print_status $CYAN "====================================================="

# Step 1: Basic checks (no hanging)
print_status $YELLOW "🔍 Checking system..."

if [ -z "$ZSH_VERSION" ]; then
    print_status $RED "❌ Must run with zsh"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    print_status $RED "❌ Git required"
    exit 1
fi

print_status $GREEN "✅ System check passed"

# Step 2: Backup existing zshrc (no prompts)
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    BACKUP="$ZSHRC.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$ZSHRC" "$BACKUP" 2>/dev/null || true
    print_status $GREEN "✅ Backup created: $BACKUP"
fi

# Step 3: Get script location
SCRIPT_DIR="$(cd "$(dirname "${0}")" && pwd)"
# ...existing code...
