#!/bin/bash
# Test script for Enhanced Bash Profile
# This script tests all functions and aliases in the enhanced profile

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"  # 0 for success, 1 for failure
    
    TESTS_RUN=$((TESTS_RUN + 1))
    print_color $YELLOW "🧪 Testing: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        result=0
    else
        result=1
    fi
    
    if [ "$result" -eq "$expected_result" ]; then
        print_color $GREEN "  ✅ PASSED"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_color $RED "  ❌ FAILED"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Function to test if alias exists
test_alias() {
    local alias_name="$1"
    local description="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    print_color $YELLOW "🧪 Testing alias: $alias_name ($description)"
    
    if alias "$alias_name" >/dev/null 2>&1; then
        print_color $GREEN "  ✅ PASSED - Alias exists"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_color $RED "  ❌ FAILED - Alias not found"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Function to test if function exists
test_function() {
    local func_name="$1"
    local description="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    print_color $YELLOW "🧪 Testing function: $func_name ($description)"
    
    if declare -F "$func_name" >/dev/null 2>&1; then
        print_color $GREEN "  ✅ PASSED - Function exists"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_color $RED "  ❌ FAILED - Function not found"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

print_color $CYAN "🧪 Enhanced Bash Profile Test Suite"
print_color $CYAN "===================================="

# Check if enhanced profile is loaded
print_color $YELLOW "📋 Checking if enhanced profile is loaded..."

if grep -q "Enhanced Bash Profile Configuration" ~/.bashrc; then
    print_color $GREEN "✅ Enhanced profile found in .bashrc"
else
    print_color $RED "❌ Enhanced profile not found in .bashrc"
    print_color $YELLOW "Please run the install script first: ./scripts/bash/install-profile.sh"
    exit 1
fi

# Source the enhanced profile for testing
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENHANCED_PROFILE="$SCRIPT_DIR/enhanced-profile.sh"

if [ -f "$ENHANCED_PROFILE" ]; then
    print_color $YELLOW "📁 Loading enhanced profile for testing..."
    source "$ENHANCED_PROFILE"
else
    print_color $RED "❌ Enhanced profile script not found: $ENHANCED_PROFILE"
    exit 1
fi

print_color $CYAN "🔍 Testing Git Aliases..."
test_alias "g" "git shortcut"
test_alias "gs" "git status"
test_alias "ga" "git add"
test_alias "gc" "git commit"
test_alias "gp" "git push"
test_alias "gl" "git log --oneline"
test_alias "glog" "git log with graph"
test_alias "gd" "git diff"
test_alias "gb" "git branch"
test_alias "gco" "git checkout"
test_alias "gf" "git fetch"
test_alias "gm" "git merge"
test_alias "gr" "git rebase"
test_alias "gst" "git stash"
test_alias "gsp" "git stash pop"
test_alias "gpl" "git pull"

print_color $CYAN "🔍 Testing File System Aliases..."
test_alias "ll" "detailed list"
test_alias "la" "list all files"
test_alias "l" "simple list"
test_alias ".." "go up one directory"
test_alias "..." "go up two directories"
test_alias "...." "go up three directories"
test_alias "h" "history"
test_alias "c" "clear"
test_alias "x" "exit"

print_color $CYAN "🔍 Testing Docker Aliases..."
test_alias "d" "docker"
test_alias "dps" "docker ps"
test_alias "dpsa" "docker ps -a"
test_alias "di" "docker images"
test_alias "drun" "docker run"
test_alias "dexec" "docker exec -it"
test_alias "dlog" "docker logs"
test_alias "dlogf" "docker logs -f"
test_alias "dstop" "docker stop"
test_alias "dstart" "docker start"
test_alias "drm" "docker rm"
test_alias "drmi" "docker rmi"
test_alias "dbuild" "docker build"
test_alias "dpull" "docker pull"
test_alias "dpush" "docker push"
test_alias "dprune" "docker system prune"

print_color $CYAN "🔍 Testing Docker Compose Aliases..."
test_alias "dc" "docker-compose"
test_alias "dcup" "docker-compose up"
test_alias "dcupd" "docker-compose up -d"
test_alias "dcdown" "docker-compose down"
test_alias "dcps" "docker-compose ps"
test_alias "dclogs" "docker-compose logs"
test_alias "dclogsf" "docker-compose logs -f"
test_alias "dcbuild" "docker-compose build"
test_alias "dcpull" "docker-compose pull"
test_alias "dcrestart" "docker-compose restart"

print_color $CYAN "🔍 Testing Kubernetes Aliases..."
test_alias "k" "kubectl"
test_alias "kgs" "kubectl get services"
test_alias "kgp" "kubectl get pods"
test_alias "kgd" "kubectl get deployments"
test_alias "kgn" "kubectl get nodes"
test_alias "kd" "kubectl describe"
test_alias "kl" "kubectl logs"
test_alias "ke" "kubectl exec -it"
test_alias "ka" "kubectl apply -f"
test_alias "kdel" "kubectl delete"

print_color $CYAN "🔍 Testing Custom Functions..."
test_function "show-git-aliases" "show Git aliases function"
test_function "show-docker-aliases" "show Docker aliases function"
test_function "show-k8s-aliases" "show Kubernetes aliases function"
test_function "cdws" "change to workspace directory"
test_function "cdprof" "change to profile directory"
test_function "mkcd" "make and change directory"
test_function "extract" "extract various archives"
test_function "sysinfo" "system information"

print_color $CYAN "🔍 Testing Environment Variables..."
run_test "HISTSIZE is set" "[ \"\$HISTSIZE\" = \"10000\" ]" 0
run_test "HISTFILESIZE is set" "[ \"\$HISTFILESIZE\" = \"20000\" ]" 0
run_test "HISTCONTROL is set" "[ \"\$HISTCONTROL\" = \"ignoredups:erasedups\" ]" 0

print_color $CYAN "🔍 Testing Bash Options..."
run_test "histappend is enabled" "shopt -q histappend" 0
run_test "cmdhist is enabled" "shopt -q cmdhist" 0

print_color $CYAN "🔍 Testing Command Availability..."
run_test "git is available" "command -v git" 0

# Test optional commands
if command -v docker >/dev/null 2>&1; then
    print_color $GREEN "✅ Docker is available"
    run_test "docker command works" "docker --version" 0
else
    print_color $YELLOW "⚠️  Docker not installed (optional)"
fi

if command -v kubectl >/dev/null 2>&1; then
    print_color $GREEN "✅ kubectl is available"
    run_test "kubectl command works" "kubectl version --client" 0
else
    print_color $YELLOW "⚠️  kubectl not installed (optional)"
fi

if command -v starship >/dev/null 2>&1; then
    print_color $GREEN "✅ Starship is available"
    run_test "starship command works" "starship --version" 0
else
    print_color $YELLOW "⚠️  Starship not installed (optional but recommended)"
fi

# Test some functions actually work
print_color $CYAN "🔍 Testing Function Execution..."

# Test show-git-aliases function
print_color $YELLOW "🧪 Testing show-git-aliases output..."
if show-git-aliases | grep -q "Available Git Aliases"; then
    print_color $GREEN "  ✅ PASSED - Function produces expected output"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    print_color $RED "  ❌ FAILED - Function output unexpected"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test sysinfo function
print_color $YELLOW "🧪 Testing sysinfo output..."
if sysinfo | grep -q "System Information"; then
    print_color $GREEN "  ✅ PASSED - Function produces expected output"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    print_color $RED "  ❌ FAILED - Function output unexpected"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test extract function with a simple case
print_color $YELLOW "🧪 Testing extract function help..."
if extract 2>&1 | grep -q "is not a valid file"; then
    print_color $GREEN "  ✅ PASSED - Function shows expected error message"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    print_color $RED "  ❌ FAILED - Function error message unexpected"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Summary
print_color $CYAN "📊 Test Results Summary"
print_color $CYAN "======================="
print_color $YELLOW "Tests Run: $TESTS_RUN"
print_color $GREEN "Tests Passed: $TESTS_PASSED"
if [ $TESTS_FAILED -gt 0 ]; then
    print_color $RED "Tests Failed: $TESTS_FAILED"
else
    print_color $GREEN "Tests Failed: $TESTS_FAILED"
fi

# Calculate percentage
if [ $TESTS_RUN -gt 0 ]; then
    PERCENTAGE=$((TESTS_PASSED * 100 / TESTS_RUN))
    print_color $CYAN "Success Rate: ${PERCENTAGE}%"
fi

# Final result
if [ $TESTS_FAILED -eq 0 ]; then
    print_color $GREEN "🎉 All tests passed! Enhanced bash profile is working correctly."
    exit 0
else
    print_color $RED "❌ Some tests failed. Please check the enhanced bash profile configuration."
    exit 1
fi
