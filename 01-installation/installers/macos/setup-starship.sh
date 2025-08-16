#!/bin/zsh
# Starship Prompt Setup Script for Enhanced Zsh Profile (macOS)
# Installs and configures Starship for Zsh on macOS

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

print_color $CYAN "⭐ Starship Prompt Setup for Enhanced Zsh Profile (macOS)"
print_color $CYAN "======================================================="

# Check if Starship is already installed
if command -v starship &> /dev/null; then
    print_color $GREEN "✅ Starship is already installed!"
    STARSHIP_VERSION=$(starship --version | awk '{print $2}')
    print_color $YELLOW "Current version: $STARSHIP_VERSION"
else
    print_color $YELLOW "📦 Installing Starship via Homebrew..."
    if ! command -v brew &> /dev/null; then
        print_color $RED "❌ Homebrew is required but not installed."
        print_color $YELLOW "Please install Homebrew first:"
        print_color $YELLOW "  /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    brew install starship
    print_color $GREEN "✅ Starship installed!"
fi

# Add Starship init to .zshrc if not present
ZSHRC="$HOME/.zshrc"
if ! grep -q 'eval "$(starship init zsh)"' "$ZSHRC"; then
    echo '\neval "$(starship init zsh)"' >> "$ZSHRC"
    print_color $GREEN "✅ Starship initialization added to .zshrc"
else
    print_color $YELLOW "Starship initialization already present in .zshrc"
fi

print_color $GREEN "🎉 Starship setup complete! Open a new terminal to see your prompt."
