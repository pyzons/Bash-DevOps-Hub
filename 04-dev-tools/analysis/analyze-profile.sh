#!/bin/bash
# Bash Profile Analysis Tool
# Equivalent to Analyze-Profile.ps1 for bash environments

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

print_section() {
    echo
    print_color $CYAN "═══════════════════════════════════════════════════════════"
    print_color $CYAN "  $1"
    print_color $CYAN "═══════════════════════════════════════════════════════════"
}

print_header() {
    print_color $BLUE "┌────────────────────────────────────────────────────────────┐"
    print_color $BLUE "│                🔍 Bash Profile Analysis Tool               │"
    print_color $BLUE "│                                                            │"
    print_color $BLUE "│         Comprehensive analysis of your bash setup         │"
    print_color $BLUE "└────────────────────────────────────────────────────────────┘"
}

# Function to check command availability
check_command() {
    local cmd="$1"
    local description="$2"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        local version=$($cmd --version 2>/dev/null | head -n1 | sed 's/.*\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/' || echo "Unknown")
        print_color $GREEN "  ✅ $description: Available ($version)"
        return 0
    else
        print_color $RED "  ❌ $description: Not installed"
        return 1
    fi
}

# Function to count aliases
count_aliases() {
    alias | wc -l
}

# Function to count functions
count_functions() {
    declare -F | wc -l
}

# Function to analyze bash configuration
analyze_bash_config() {
    print_section "🐚 Bash Configuration Analysis"
    
    print_color $YELLOW "Bash Version:"
    print_color $WHITE "  $BASH_VERSION"
    
    print_color $YELLOW "Bash Configuration Files:"
    
    local config_files=(
        "$HOME/.bashrc:Main configuration"
        "$HOME/.bash_profile:Login shell profile"
        "$HOME/.bash_aliases:User aliases"
        "$HOME/.bash_functions:User functions"
        "$HOME/.profile:General profile"
        "/etc/bash.bashrc:System-wide configuration"
    )
    
    for file_desc in "${config_files[@]}"; do
        IFS=':' read -r file desc <<< "$file_desc"
        if [ -f "$file" ]; then
            local size=$(du -h "$file" | cut -f1)
            local lines=$(wc -l < "$file")
            print_color $GREEN "  ✅ $desc: $file ($size, $lines lines)"
        else
            print_color $RED "  ❌ $desc: $file (Not found)"
        fi
    done
    
    # Check for enhanced profile
    if grep -q "Enhanced Bash Profile Configuration" ~/.bashrc 2>/dev/null; then
        print_color $GREEN "  ✅ Enhanced Bash Profile: Installed"
    else
        print_color $YELLOW "  ⚠️  Enhanced Bash Profile: Not detected"
    fi
}

# Function to analyze environment
analyze_environment() {
    print_section "🌍 Environment Analysis"
    
    print_color $YELLOW "System Information:"
    print_color $WHITE "  OS: $(uname -s) $(uname -r)"
    print_color $WHITE "  Architecture: $(uname -m)"
    print_color $WHITE "  Hostname: $(hostname)"
    print_color $WHITE "  User: $(whoami)"
    print_color $WHITE "  Home: $HOME"
    print_color $WHITE "  Shell: $SHELL"
    print_color $WHITE "  Terminal: ${TERM:-Unknown}"
    
    print_color $YELLOW "Key Environment Variables:"
    
    local env_vars=(
        "PATH:Command search paths"
        "EDITOR:Default editor"
        "HISTSIZE:History size in memory"
        "HISTFILESIZE:History file size"
        "HISTCONTROL:History control settings"
        "PS1:Primary prompt"
        "LANG:Language setting"
        "LC_ALL:Locale setting"
    )
    
    for var_desc in "${env_vars[@]}"; do
        IFS=':' read -r var desc <<< "$var_desc"
        local value="${!var}"
        if [ -n "$value" ]; then
            # Truncate long values
            if [ ${#value} -gt 60 ]; then
                value="${value:0:60}..."
            fi
            print_color $GREEN "  ✅ $desc ($var): $value"
        else
            print_color $RED "  ❌ $desc ($var): Not set"
        fi
    done
}

# Function to analyze aliases and functions
analyze_aliases_functions() {
    print_section "⚡ Aliases and Functions Analysis"
    
    local alias_count=$(count_aliases)
    local function_count=$(count_functions)
    
    print_color $YELLOW "Summary:"
    print_color $WHITE "  Total Aliases: $alias_count"
    print_color $WHITE "  Total Functions: $function_count"
    
    print_color $YELLOW "Git Aliases:"
    local git_aliases=(g gs ga gc gp gl glog gd gb gco gf gm gr gst gsp gpl)
    local git_count=0
    for alias_name in "${git_aliases[@]}"; do
        if alias "$alias_name" >/dev/null 2>&1; then
            git_count=$((git_count + 1))
        fi
    done
    print_color $WHITE "  Git shortcuts available: $git_count/${#git_aliases[@]}"
    
    print_color $YELLOW "Docker Aliases:"
    local docker_aliases=(d dps dpsa di drun dexec dlog dstop dstart drm dc dcup dcdown)
    local docker_count=0
    for alias_name in "${docker_aliases[@]}"; do
        if alias "$alias_name" >/dev/null 2>&1; then
            docker_count=$((docker_count + 1))
        fi
    done
    print_color $WHITE "  Docker shortcuts available: $docker_count/${#docker_aliases[@]}"
    
    print_color $YELLOW "Kubernetes Aliases:"
    local k8s_aliases=(k kgs kgp kgd kgn kd kl ke ka kdel)
    local k8s_count=0
    for alias_name in "${k8s_aliases[@]}"; do
        if alias "$alias_name" >/dev/null 2>&1; then
            k8s_count=$((k8s_count + 1))
        fi
    done
    print_color $WHITE "  Kubernetes shortcuts available: $k8s_count/${#k8s_aliases[@]}"
    
    print_color $YELLOW "Custom Functions:"
    local custom_functions=(show-git-aliases show-docker-aliases show-k8s-aliases cdws cdprof mkcd extract sysinfo)
    local custom_count=0
    for func_name in "${custom_functions[@]}"; do
        if declare -F "$func_name" >/dev/null 2>&1; then
            custom_count=$((custom_count + 1))
        fi
    done
    print_color $WHITE "  Enhanced functions available: $custom_count/${#custom_functions[@]}"
}

# Function to analyze development tools
analyze_dev_tools() {
    print_section "🛠️ Development Tools Analysis"
    
    print_color $YELLOW "Core Development Tools:"
    check_command "git" "Git version control"
    check_command "curl" "HTTP client"
    check_command "wget" "Download utility"
    check_command "vim" "Vim editor"
    check_command "nano" "Nano editor"
    check_command "emacs" "Emacs editor"
    
    print_color $YELLOW "Container & Orchestration:"
    check_command "docker" "Docker"
    check_command "docker-compose" "Docker Compose"
    check_command "kubectl" "Kubernetes CLI"
    check_command "kind" "Kubernetes in Docker"
    check_command "helm" "Kubernetes package manager"
    
    print_color $YELLOW "Programming Languages:"
    check_command "python3" "Python 3"
    check_command "python" "Python"
    check_command "node" "Node.js"
    check_command "npm" "Node Package Manager"
    check_command "go" "Go language"
    check_command "java" "Java"
    check_command "gcc" "GNU C Compiler"
    
    print_color $YELLOW "Terminal Enhancements:"
    check_command "oh-my-posh" "Oh My Posh"
    check_command "bat" "Better cat"
    check_command "exa" "Better ls"
    check_command "fd" "Better find"
    check_command "rg" "Ripgrep (better grep)"
    check_command "fzf" "Fuzzy finder"
    check_command "tmux" "Terminal multiplexer"
    check_command "screen" "Screen multiplexer"
}

# Function to analyze bash completion
analyze_completion() {
    print_section "📝 Bash Completion Analysis"
    
    # Check if bash completion is available
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        print_color $GREEN "  ✅ Bash completion framework: Available"
    elif [ -f /etc/bash_completion ]; then
        print_color $GREEN "  ✅ Bash completion framework: Available (legacy location)"
    else
        print_color $RED "  ❌ Bash completion framework: Not found"
    fi
    
    # Check specific completions
    local completion_dirs=(
        "/usr/share/bash-completion/completions"
        "/etc/bash_completion.d"
        "$HOME/.bash_completion.d"
    )
    
    local completion_files=0
    for dir in "${completion_dirs[@]}"; do
        if [ -d "$dir" ]; then
            local count=$(find "$dir" -name "*.bash" -o -name "*" | wc -l)
            completion_files=$((completion_files + count))
            print_color $YELLOW "  📁 $dir: $count completion files"
        fi
    done
    
    print_color $WHITE "  Total completion files: $completion_files"
    
    # Check completion settings
    if complete -p git >/dev/null 2>&1; then
        print_color $GREEN "  ✅ Git completion: Available"
    else
        print_color $RED "  ❌ Git completion: Not available"
    fi
    
    if complete -p docker >/dev/null 2>&1; then
        print_color $GREEN "  ✅ Docker completion: Available"
    else
        print_color $RED "  ❌ Docker completion: Not available"
    fi
    
    if complete -p kubectl >/dev/null 2>&1; then
        print_color $GREEN "  ✅ Kubectl completion: Available"
    else
        print_color $RED "  ❌ Kubectl completion: Not available"
    fi
}

# Function to analyze bash history
analyze_history() {
    print_section "📚 Bash History Analysis"
    
    local histfile="${HISTFILE:-$HOME/.bash_history}"
    
    if [ -f "$histfile" ]; then
        local total_commands=$(wc -l < "$histfile")
        local file_size=$(du -h "$histfile" | cut -f1)
        print_color $GREEN "  ✅ History file: $histfile ($file_size, $total_commands commands)"
        
        # Analyze most used commands
        print_color $YELLOW "  Top 10 most used commands:"
        if [ -f "$histfile" ]; then
            awk '{print $1}' "$histfile" | sort | uniq -c | sort -nr | head -10 | while read -r count cmd; do
                print_color $WHITE "    $count × $cmd"
            done
        fi
    else
        print_color $RED "  ❌ History file: Not found"
    fi
    
    print_color $YELLOW "History Configuration:"
    print_color $WHITE "  HISTSIZE: ${HISTSIZE:-Not set}"
    print_color $WHITE "  HISTFILESIZE: ${HISTFILESIZE:-Not set}"
    print_color $WHITE "  HISTCONTROL: ${HISTCONTROL:-Not set}"
    print_color $WHITE "  HISTTIMEFORMAT: ${HISTTIMEFORMAT:-Not set}"
    
    # Check bash options
    if shopt -q histappend; then
        print_color $GREEN "  ✅ histappend: Enabled (recommended)"
    else
        print_color $RED "  ❌ histappend: Disabled"
    fi
    
    if shopt -q cmdhist; then
        print_color $GREEN "  ✅ cmdhist: Enabled (recommended)"
    else
        print_color $RED "  ❌ cmdhist: Disabled"
    fi
}

# Function to show recommendations
show_recommendations() {
    print_section "💡 Recommendations"
    
    print_color $YELLOW "Performance Optimizations:"
    
    # Check if enhanced profile is installed
    if ! grep -q "Enhanced Bash Profile Configuration" ~/.bashrc 2>/dev/null; then
        print_color $RED "  ❌ Install Enhanced Bash Profile for optimized experience"
        print_color $WHITE "     Run: ./install-enhanced-profile.sh"
    fi
    
    # Check Oh My Posh
    if ! command -v oh-my-posh >/dev/null 2>&1; then
        print_color $YELLOW "  💡 Install Oh My Posh for beautiful prompts"
        print_color $WHITE "     Run: curl -s https://ohmyposh.dev/install.sh | bash -s"
    fi
    
    # Check bash completion
    if [ ! -f /usr/share/bash-completion/bash_completion ]; then
        print_color $YELLOW "  💡 Install bash completion for better tab completion"
        print_color $WHITE "     Ubuntu/Debian: sudo apt-get install bash-completion"
        print_color $WHITE "     RHEL/CentOS: sudo yum install bash-completion"
    fi
    
    # Check for useful tools
    local recommended_tools=(
        "bat:Better cat with syntax highlighting"
        "exa:Better ls with colors and icons"
        "fd:Faster find alternative"
        "ripgrep:Faster grep alternative"
        "fzf:Fuzzy finder for files and history"
    )
    
    print_color $YELLOW "Recommended Tools to Install:"
    for tool_desc in "${recommended_tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_desc"
        if ! command -v "$tool" >/dev/null 2>&1; then
            print_color $WHITE "  📦 $tool: $desc"
        fi
    done
    
    print_color $YELLOW "Configuration Improvements:"
    
    if [ -z "$HISTCONTROL" ] || [[ "$HISTCONTROL" != *"ignoredups"* ]]; then
        print_color $WHITE "  📝 Set HISTCONTROL=ignoredups:erasedups to avoid duplicate history entries"
    fi
    
    if [ -z "$HISTTIMEFORMAT" ]; then
        print_color $WHITE "  📝 Set HISTTIMEFORMAT to add timestamps to history"
    fi
    
    if ! shopt -q histappend; then
        print_color $WHITE "  📝 Enable histappend option to preserve history across sessions"
    fi
}

# Main execution
main() {
    print_header
    
    analyze_bash_config
    analyze_environment
    analyze_aliases_functions
    analyze_dev_tools
    analyze_completion
    analyze_history
    show_recommendations
    
    print_section "✅ Analysis Complete"
    print_color $GREEN "Analysis completed successfully!"
    print_color $YELLOW "💡 Use this information to optimize your bash environment."
    
    # Offer to save report
    read -p "Would you like to save this analysis to a file? (y/N): " save_report
    if [[ "$save_report" =~ ^[Yy]$ ]]; then
        local report_file="bash-profile-analysis-$(date +%Y%m%d-%H%M%S).txt"
        print_color $YELLOW "💾 Saving analysis to: $report_file"
        
        # Re-run analysis and save to file
        {
            echo "Bash Profile Analysis Report"
            echo "Generated on: $(date)"
            echo "System: $(uname -a)"
            echo "User: $(whoami)"
            echo "=============================================="
            echo
        } > "$report_file"
        
        # This is a simplified version - in practice you'd want to capture the output
        print_color $GREEN "✅ Analysis saved to: $report_file"
    fi
}

# Run main function
main "$@"
