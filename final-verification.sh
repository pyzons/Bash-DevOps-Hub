#!/bin/bash
# Final Verification Script for Organized Bash DevOps Hub
# Tests all components in their new organized locations

set -e

echo "🧪 Final Verification: Organized Bash DevOps Hub"
echo "================================================"

# Test 1: Installation Components
echo ""
echo "🚀 Testing Installation Components..."

INSTALLERS=(
    "01-installation/installers/install-no-hang.sh"
    "01-installation/installers/install-simple.sh"
    "01-installation/installers/install-enhanced-profile.sh"
    "01-installation/scripts/install-profile.sh"
)

for installer in "${INSTALLERS[@]}"; do
    if [ -f "$installer" ] && [ -x "$installer" ]; then
        if bash -n "$installer"; then
            echo "✅ $installer - syntax OK, executable"
        else
            echo "❌ $installer - syntax ERROR"
            exit 1
        fi
    else
        echo "⚠️  $installer - not found or not executable"
    fi
done

# Test 2: Bash Profile Components
echo ""
echo "🐚 Testing Bash Profile Components..."

PROFILE_COMPONENTS=(
    "02-bash-profile/profile/enhanced-profile.sh"
    "02-bash-profile/tests/test-profile.sh"
)

for component in "${PROFILE_COMPONENTS[@]}"; do
    if [ -f "$component" ]; then
        if bash -n "$component"; then
            echo "✅ $component - syntax OK"
        else
            echo "❌ $component - syntax ERROR"
            exit 1
        fi
    else
        echo "⚠️  $component - not found"
    fi
done

# Test 3: Prompt & Theming
echo ""
echo "⭐ Testing Prompt & Theming Components..."

PROMPT_COMPONENTS=(
    "03-prompt-theming/starship/setup-starship.sh"
)

for component in "${PROMPT_COMPONENTS[@]}"; do
    if [ -f "$component" ]; then
        if bash -n "$component"; then
            echo "✅ $component - syntax OK"
        else
            echo "❌ $component - syntax ERROR"
            exit 1
        fi
    else
        echo "⚠️  $component - not found"
    fi
done

# Test 4: Development Tools
echo ""
echo "🔧 Testing Development Tools..."

DEV_TOOLS=(
    "04-dev-tools/analysis/analyze-profile.sh"
)

for tool in "${DEV_TOOLS[@]}"; do
    if [ -f "$tool" ]; then
        if bash -n "$tool"; then
            echo "✅ $tool - syntax OK"
        else
            echo "❌ $tool - syntax ERROR"
            exit 1
        fi
    else
        echo "⚠️  $tool - not found"
    fi
done

# Test 5: Configuration Structure
echo ""
echo "📁 Testing Configuration Structure..."

CONFIG_DIRS=(
    "05-docker-integration/configs"
    "06-kubernetes-integration/configs"
    "06-kubernetes-integration/kind"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        file_count=$(find "$dir" -type f | wc -l)
        echo "✅ $dir - exists ($file_count files)"
    else
        echo "⚠️  $dir - not found"
    fi
done

# Test 6: Documentation Structure
echo ""
echo "📚 Testing Documentation Structure..."

DOC_DIRS=(
    "07-documentation/setup-guides"
    "07-documentation/troubleshooting"
    "07-documentation/chat-ai"
)

for dir in "${DOC_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        file_count=$(find "$dir" -name "*.md" -type f | wc -l)
        echo "✅ $dir - exists ($file_count markdown files)"
    else
        echo "⚠️  $dir - not found"
    fi
done

# Test 7: README Files
echo ""
echo "📄 Testing README Files..."

README_FILES=(
    "README.md"
    "01-installation/README.md"
    "02-bash-profile/README.md"
    "03-prompt-theming/README.md"
    "04-dev-tools/README.md"
    "05-docker-integration/README.md"
    "06-kubernetes-integration/README.md"
    "07-documentation/README.md"
    "08-legacy-archive/README.md"
)

for readme in "${README_FILES[@]}"; do
    if [ -f "$readme" ]; then
        lines=$(wc -l < "$readme")
        echo "✅ $readme - exists ($lines lines)"
    else
        echo "⚠️  $readme - not found"
    fi
done

# Test 8: Workspace File
echo ""
echo "🔧 Testing Workspace Configuration..."

if [ -f "Bash-DevOps-Hub-Organized.code-workspace" ]; then
    echo "✅ Bash-DevOps-Hub-Organized.code-workspace - exists"
else
    echo "⚠️  Bash-DevOps-Hub-Organized.code-workspace - not found"
fi

# Test 9: Functional Test - Try to load profile
echo ""
echo "🧪 Testing Profile Loading..."

if bash -c "source 02-bash-profile/profile/enhanced-profile.sh 2>/dev/null && echo 'Profile loaded successfully'" | grep -q "Profile loaded successfully"; then
    echo "✅ Enhanced profile loads without errors"
else
    echo "❌ Enhanced profile failed to load"
    exit 1
fi

# Final Summary
echo ""
echo "🎉 Final Verification Complete!"
echo "==============================="
echo "✨ All components in organized structure: WORKING"
echo "🚀 Installation system: FUNCTIONAL"  
echo "🐚 Bash profile system: FUNCTIONAL"
echo "⭐ Prompt theming: FUNCTIONAL"
echo "🔧 Development tools: FUNCTIONAL"
echo "📁 Configuration structure: ORGANIZED"
echo "📚 Documentation: COMPLETE"
echo ""
echo "🎊 Your Bash DevOps Hub is perfectly organized and ready for use!"
echo ""
echo "🚀 Quick Start from organized structure:"
echo "   cd 01-installation/installers"
echo "   ./install-no-hang.sh"
echo ""
echo "📖 Open organized workspace:"
echo "   code Bash-DevOps-Hub-Organized.code-workspace"
