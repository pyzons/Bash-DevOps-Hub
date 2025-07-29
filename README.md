# 🚀 Enhanced PowerShell 7 Profile Setup

A comprehensive PowerShell 7 profile configuration with Oh My Posh integration, advanced Git aliases, and optimized development experience.

## ✨ Features

### 🎨 Visual Enhancements
- **Oh My Posh** integration with custom themes
- **Colorized syntax** highlighting for commands, parameters, and variables
- **Predictive text** with history-based suggestions
- **Beautiful prompt** with Git status integration

### ⚡ Enhanced Completion & Navigation
- **Advanced PSReadLine** configuration
- **Intelligent tab completion** with menu display
- **History-based predictions** and search
- **Smart key bindings** for efficient editing

### 🔧 Git Integration
- **Comprehensive Git aliases** for faster workflow
- **Visual Git status** in prompt
- **Quick Git commands**: `gs`, `ga`, `gc`, `gp`, `glog`, etc.
- **Branch management** shortcuts

### 📁 Productivity Shortcuts
- **Directory navigation**: `ll`, `la`, `..`, `...`
- **Quick workspace access**: `cdws`, `cdprof`
- **Alias overview**: `Show-GitAliases`

## 🛠️ Installation

### Prerequisites
- PowerShell 7.x
- Git
- Oh My Posh (optional but recommended)

### Quick Setup
1. Clone this repository
2. Copy the profile content to your PowerShell profile location
3. Restart PowerShell or run `. $PROFILE`

### Manual Installation
```powershell
# Copy the enhanced profile to your PowerShell profile
Get-Content "enhanced-profile.ps1" | Add-Content $PROFILE

# Reload the profile
. $PROFILE
```

## 📋 Available Git Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Short git command |
| `gs` | `git status` | Check repository status |
| `ga` | `git add` | Add files to staging |
| `gaa` | `git add --all` | Add all files to staging |
| `gc` | `git commit` | Commit changes |
| `gca` | `git commit --amend` | Amend last commit |
| `gp` | `git push` | Push to remote |
| `gl` | `git pull` | Pull from remote |
| `gco` | `git checkout` | Switch branches |
| `gb` | `git branch` | List/manage branches |
| `gm` | `git merge` | Merge branches |
| `gd` | `git diff` | Show differences |
| `glog` | `git log --oneline --graph` | Visual commit history |

## 🎯 Key Features

### PSReadLine Configuration
- **Prediction Source**: History-based intelligent suggestions
- **ListView**: Enhanced completion menu
- **Smart Navigation**: Ctrl+Left/Right for word jumping
- **History Search**: Up/Down arrows for contextual search

### Color Scheme
- **Commands**: Yellow
- **Parameters**: Green
- **Variables**: White
- **Strings**: Blue
- **Comments**: Dark Green
- **Predictions**: Dark Gray

## 📁 Repository Structure

```
├── README.md                           # This file
├── enhanced-profile.ps1                # Main PowerShell profile
├── Install-Profile.ps1                 # Installation script
├── Microsoft.PowerShell_profile.ps1    # Profile template
└── setup-omp.ps1                      # Oh My Posh setup script
```

## 🚀 Usage Examples

```powershell
# Quick Git workflow
gs                    # Check status
ga .                  # Add all files
gc "feat: new feature" # Commit with message
gp                    # Push to remote

# Navigation shortcuts
cdws                  # Go to workspace
ll                    # List files (detailed)
la                    # List all files (including hidden)

# View all Git aliases
Show-GitAliases
```

## 🔧 Customization

### Adding Custom Aliases
```powershell
# Add to your profile
function myalias { your-command $args }
Set-Alias -Name alias -Value your-command
```

### Changing Oh My Posh Theme
```powershell
# Replace the theme in enhanced-profile.ps1
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/your-theme.omp.json" | Invoke-Expression
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the profile configuration
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**Sekhar Valalla**
- Email: pyzons@gmail.com
- GitHub: [@your-username](https://github.com/your-username)

## 🙏 Acknowledgments

- PowerShell team for the amazing shell
- Oh My Posh for beautiful prompts
- PSReadLine for enhanced editing experience
- Git for version control excellence

---

⭐ **Star this repository if it helped improve your PowerShell experience!**
