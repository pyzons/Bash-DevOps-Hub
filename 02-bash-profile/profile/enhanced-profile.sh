#!/bin/bash
# Enhanced Bash Profile Configuration
# This file contains optimizations for your Bash shell experience

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Enhanced history settings
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
shopt -s histappend
shopt -s cmdhist

# Enhanced bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Enable case-insensitive completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

# Useful aliases for Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias glog='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias gst='git stash'
alias gsp='git stash pop'
alias gpl='git pull'

# Useful aliases for common commands
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias h='history'
alias c='clear'
alias x='exit'

# Function to quickly navigate to common directories
cdws() {
    cd "/home/$(whoami)/wrk/edu/ws/Bash-DevOps-Hub" || echo "Workspace directory not found"
}

cdprof() {
    cd "$(dirname "${BASH_SOURCE[0]}")" || echo "Profile directory not found"
}

# Function to show available Git aliases
show-git-aliases() {
    echo -e "\e[32mAvailable Git Aliases:\e[0m"
    echo -e "\e[33mBasic Git Commands:\e[0m"
    echo -e "\e[37mg      - git\e[0m"
    echo -e "\e[37mgs     - git status\e[0m"
    echo -e "\e[37mga     - git add\e[0m"
    echo -e "\e[37mgc     - git commit\e[0m"
    echo -e "\e[37mgp     - git push\e[0m"
    echo -e "\e[37mgl     - git log --oneline\e[0m"
    echo -e "\e[37mglog   - git log --oneline --graph --decorate --all\e[0m"
    echo -e "\e[37mgd     - git diff\e[0m"
    echo -e "\e[37mgb     - git branch\e[0m"
    echo -e "\e[37mgco    - git checkout\e[0m"
    echo -e "\e[37mgf     - git fetch\e[0m"
    echo -e "\e[37mgm     - git merge\e[0m"
    echo -e "\e[37mgr     - git rebase\e[0m"
    echo -e "\e[37mgst    - git stash\e[0m"
    echo -e "\e[37mgsp    - git stash pop\e[0m"
    echo -e "\e[37mgpl    - git pull\e[0m"
    echo ""
    echo -e "\e[36m💡 Usage Examples:\e[0m"
    echo -e "\e[90mgs              - Show status\e[0m"
    echo -e "\e[90mga .            - Add all files\e[0m"
    echo -e "\e[90mgc -m 'message' - Commit with message\e[0m"
    echo -e "\e[90mgp origin main  - Push to main branch\e[0m"
}

# Docker aliases and functions for faster workflow
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drmi='docker rmi'
alias drun='docker run'
alias dexec='docker exec -it'
alias dlog='docker logs'
alias dlogf='docker logs -f'
alias dstop='docker stop'
alias dstart='docker start'
alias drm='docker rm'
alias dprune='docker system prune'
alias dbuild='docker build'
alias dpull='docker pull'
alias dpush='docker push'

# Docker Compose aliases
alias dc='docker-compose'
alias dcup='docker-compose up'
alias dcupd='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcps='docker-compose ps'
alias dclogs='docker-compose logs'
alias dclogsf='docker-compose logs -f'
alias dcbuild='docker-compose build'
alias dcpull='docker-compose pull'
alias dcrestart='docker-compose restart'

# Advanced Docker functions
show-docker-aliases() {
    echo -e "\e[32mAvailable Docker Aliases:\e[0m"
    echo -e "\e[33mBasic Docker Commands:\e[0m"
    echo -e "\e[37md      - docker\e[0m"
    echo -e "\e[37mdps    - docker ps\e[0m"
    echo -e "\e[37mdpsa   - docker ps -a\e[0m"
    echo -e "\e[37mdi     - docker images\e[0m"
    echo -e "\e[37mdrun   - docker run\e[0m"
    echo -e "\e[37mdexec  - docker exec -it\e[0m"
    echo -e "\e[37mdlog   - docker logs\e[0m"
    echo -e "\e[37mdlogf  - docker logs -f\e[0m"
    echo -e "\e[37mdstop  - docker stop\e[0m"
    echo -e "\e[37mdstart - docker start\e[0m"
    echo -e "\e[37mdrm    - docker rm\e[0m"
    echo -e "\e[37mdrmi   - docker rmi\e[0m"
    echo -e "\e[37mdbuild - docker build\e[0m"
    echo -e "\e[37mdpull  - docker pull\e[0m"
    echo -e "\e[37mdpush  - docker push\e[0m"
    echo -e "\e[37mdprune - docker system prune\e[0m"
    echo ""
    echo -e "\e[33mDocker Compose Commands:\e[0m"
    echo -e "\e[37mdc         - docker-compose\e[0m"
    echo -e "\e[37mdcup       - docker-compose up\e[0m"
    echo -e "\e[37mdcupd      - docker-compose up -d\e[0m"
    echo -e "\e[37mdcdown     - docker-compose down\e[0m"
    echo -e "\e[37mdcps       - docker-compose ps\e[0m"
    echo -e "\e[37mdclogs     - docker-compose logs\e[0m"
    echo -e "\e[37mdclogsf    - docker-compose logs -f\e[0m"
    echo -e "\e[37mdcbuild    - docker-compose build\e[0m"
    echo -e "\e[37mdcpull     - docker-compose pull\e[0m"
    echo -e "\e[37mdcrestart  - docker-compose restart\e[0m"
}

# Kubernetes aliases
alias k='kubectl'
alias kgs='kubectl get services'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias ka='kubectl apply -f'
alias kdel='kubectl delete'

# Show Kubernetes aliases
show-k8s-aliases() {
    echo -e "\e[32mAvailable Kubernetes Aliases:\e[0m"
    echo -e "\e[33mBasic kubectl Commands:\e[0m"
    echo -e "\e[37mk      - kubectl\e[0m"
    echo -e "\e[37mkgs    - kubectl get services\e[0m"
    echo -e "\e[37mkgp    - kubectl get pods\e[0m"
    echo -e "\e[37mkgd    - kubectl get deployments\e[0m"
    echo -e "\e[37mkgn    - kubectl get nodes\e[0m"
    echo -e "\e[37mkd     - kubectl describe\e[0m"
    echo -e "\e[37mkl     - kubectl logs\e[0m"
    echo -e "\e[37mke     - kubectl exec -it\e[0m"
    echo -e "\e[37mka     - kubectl apply -f\e[0m"
    echo -e "\e[37mkdel   - kubectl delete\e[0m"
}

# Utility functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract function for various archives
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# System information
sysinfo() {
    echo -e "\e[32mSystem Information:\e[0m"
    echo -e "\e[33mHostname:\e[0m $(hostname)"
    echo -e "\e[33mUptime:\e[0m $(uptime -p)"
    echo -e "\e[33mKernel:\e[0m $(uname -r)"
    echo -e "\e[33mOS:\e[0m $(lsb_release -d | cut -f2)"
    echo -e "\e[33mCPU:\e[0m $(lscpu | grep 'Model name' | cut -f 2 -d ':' | awk '{print $1 $2 $3 $4 $5 $6}')"
    echo -e "\e[33mMemory:\e[0m $(free -h | grep '^Mem:' | awk '{print $3"/"$2}')"
    echo -e "\e[33mDisk Usage:\e[0m $(df -h / | awk 'NR==2{printf "%s/%s (%s)", $3,$2,$5}')"
}

# Initialize Starship prompt if available (modern, fast, customizable)
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # Fallback to enhanced bash prompt with Git integration
    # Load git-prompt if available
    if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
        source /usr/share/git-core/contrib/completion/git-prompt.sh
    elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
        source /usr/lib/git-core/git-sh-prompt
    elif [ -f /etc/bash_completion.d/git-prompt ]; then
        source /etc/bash_completion.d/git-prompt
    fi
    
    # Configure git prompt options
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto"
    export GIT_PS1_SHOWCOLORHINTS=1
    
    # Enhanced bash prompt function
    __bash_prompt() {
        local EXIT="$?"
        
        # Colors
        local RED='\[\033[0;31m\]'
        local GREEN='\[\033[0;32m\]'
        local YELLOW='\[\033[1;33m\]'
        local BLUE='\[\033[0;34m\]'
        local PURPLE='\[\033[0;35m\]'
        local CYAN='\[\033[0;36m\]'
        local WHITE='\[\033[1;37m\]'
        local RESET='\[\033[0m\]'
        
        # Build prompt
        PS1=""
        
        # User@host
        PS1+="${GREEN}\u@\h${RESET}"
        
        # Current directory
        PS1+=":${BLUE}\w${RESET}"
        
        # Git branch (if in git repo)
        if command -v __git_ps1 &> /dev/null; then
            PS1+="${YELLOW}$(__git_ps1 " (%s)")${RESET}"
        fi
        
        # Exit status (if non-zero)
        if [ $EXIT != 0 ]; then
            PS1+=" ${RED}✗${RESET}"
        else
            PS1+=" ${GREEN}✓${RESET}"
        fi
        
        # Docker context (if available)
        if command -v docker &> /dev/null && [ -n "$DOCKER_CONTEXT" ] && [ "$DOCKER_CONTEXT" != "default" ]; then
            PS1+=" ${PURPLE}🐳${DOCKER_CONTEXT}${RESET}"
        fi
        
        # Kubernetes context (if available)
        if command -v kubectl &> /dev/null; then
            local k8s_context=$(kubectl config current-context 2>/dev/null)
            if [ -n "$k8s_context" ] && [ "$k8s_context" != "docker-desktop" ]; then
                PS1+=" ${CYAN}⎈${k8s_context}${RESET}"
            fi
        fi
        
        # Prompt symbol
        PS1+="\n${WHITE}❯${RESET} "
    }
    
    # Set prompt command
    PROMPT_COMMAND=__bash_prompt
fi

# Show welcome message
echo -e "\e[36m🚀 Enhanced Bash Profile Loaded!\e[0m"
echo -e "\e[32mType 'show-git-aliases' to see Git shortcuts\e[0m"
echo -e "\e[32mType 'show-docker-aliases' to see Docker shortcuts\e[0m"
echo -e "\e[32mType 'show-k8s-aliases' to see Kubernetes shortcuts\e[0m"
echo -e "\e[32mType 'sysinfo' to see system information\e[0m"
if command -v starship &> /dev/null; then
    echo -e "\e[35m✨ Starship prompt is active\e[0m"
else
    echo -e "\e[33m💡 Install Starship for an even better prompt: curl -sS https://starship.rs/install.sh | sh\e[0m"
fi
