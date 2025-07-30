# PowerShell 7 Starship Setup - Fully Automated
# Equivalent to WSL2 bash setup but for Windows PowerShell 7
# Minimal prompts, maximum automation

#Requires -Version 7.0

# Suppress progress bars and verbose output
$ProgressPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

# Color functions
function Write-Status {
    param(
        [string]$Message,
        [string]$Color = "Cyan"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

# Main setup function
function Install-StarshipSetup {
    Write-Status "🚀 PowerShell 7 + Starship Setup - Fully Automated" "Cyan"
    Write-Status "=================================================" "Cyan"

    # Step 1: Verify PowerShell 7
    Write-Status "🔍 Checking PowerShell version..." "Yellow"
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Warning "PowerShell 7+ required. Current: $($PSVersionTable.PSVersion)"
        Write-Host "Install PowerShell 7: winget install Microsoft.PowerShell" -ForegroundColor Red
        return
    }
    Write-Success "PowerShell $($PSVersionTable.PSVersion) detected"

    # Step 2: Install Starship (try multiple methods)
    Write-Status "⭐ Installing Starship..." "Yellow"
    
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Write-Info "Starship already installed"
    } else {
        # Try winget first (most reliable)
        try {
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                Write-Host "  Using winget..." -ForegroundColor Gray
                winget install starship --silent --accept-source-agreements --accept-package-agreements | Out-Null
                Write-Success "Starship installed via winget"
            } else {
                throw "winget not available"
            }
        } catch {
            # Fallback to manual download
            try {
                Write-Host "  Using direct download..." -ForegroundColor Gray
                $StarshipUrl = "https://github.com/starship/starship/releases/latest/download/starship-x86_64-pc-windows-msvc.zip"
                $TempPath = "$env:TEMP\starship.zip"
                $InstallPath = "$env:LOCALAPPDATA\starship"
                
                Invoke-WebRequest -Uri $StarshipUrl -OutFile $TempPath -UseBasicParsing
                Expand-Archive -Path $TempPath -DestinationPath $InstallPath -Force
                
                # Add to PATH if not already there
                $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
                if ($CurrentPath -notlike "*$InstallPath*") {
                    [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$InstallPath", "User")
                    $env:PATH = "$env:PATH;$InstallPath"
                }
                
                Remove-Item $TempPath -Force
                Write-Success "Starship installed via direct download"
            } catch {
                Write-Warning "Could not install Starship automatically"
                Write-Host "Manual install: winget install starship" -ForegroundColor Yellow
                return
            }
        }
    }

    # Step 3: Create/Update PowerShell Profile
    Write-Status "📝 Configuring PowerShell profile..." "Yellow"
    
    # Ensure profile directory exists
    $ProfileDir = Split-Path $PROFILE -Parent
    if (-not (Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }

    # Backup existing profile
    if (Test-Path $PROFILE) {
        $BackupPath = "$PROFILE.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $PROFILE $BackupPath
        Write-Success "Profile backed up to: $BackupPath"
    }

    # Create new profile content
    $ProfileContent = @"
# Enhanced PowerShell 7 Profile with Starship
# Auto-generated on $(Get-Date)
# Source: PowerShell 7 Starship Setup Script

# Initialize Starship prompt
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
} else {
    Write-Warning "Starship not found in PATH"
}

# Git aliases (matching bash version)
function gs { git status @args }
function ga { git add @args }
function gc { git commit -m @args }
function gp { git push @args }
function glog { git log --oneline -10 @args }
function gco { git checkout @args }
function gb { git branch @args }
function gd { git diff @args }
function gl { git pull @args }
function gst { git stash @args }
function gsp { git stash pop @args }

# Enhanced directory listing
function ll { Get-ChildItem -Force @args | Format-Table -AutoSize }
function la { Get-ChildItem -Force -Hidden @args }
function lt { Get-ChildItem @args | Sort-Object LastWriteTime -Descending }

# System utilities
function sysinfo { 
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory, CsProcessors
}
function meminfo { Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, @{n='Memory(MB)';e={[math]::Round(`$_.WorkingSet/1MB,2)}} }
function diskinfo { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{n='Size(GB)';e={[math]::Round(`$_.Size/1GB,2)}}, @{n='Free(GB)';e={[math]::Round(`$_.FreeSpace/1GB,2)}} }

# Docker aliases (if Docker Desktop installed)
function d { docker @args }
function dps { docker ps @args }
function di { docker images @args }
function dc { docker-compose @args }
function dcup { docker-compose up -d @args }
function dcdown { docker-compose down @args }

# Kubernetes aliases
function k { kubectl @args }
function kgs { kubectl get svc @args }
function kgp { kubectl get pods @args }
function kgd { kubectl get deployment @args }

# Navigation shortcuts
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ~ { Set-Location `$HOME }
function root { Set-Location C:\ }

# Quick editors
function n { notepad @args }
function c { code @args }

# Network utilities
function myip { (Invoke-WebRequest -Uri "https://ifconfig.me/ip" -UseBasicParsing).Content.Trim() }
function localip { Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi*","Ethernet*" | Select-Object IPAddress, InterfaceAlias }

# PowerShell specific enhancements
function reload { . `$PROFILE }
function edit-profile { code `$PROFILE }
function which { param(`$cmd) Get-Command `$cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source }

# Help functions
function show-git-aliases {
    Write-Host "Git Aliases:" -ForegroundColor Cyan
    Write-Host "  gs    - git status" -ForegroundColor Green
    Write-Host "  ga    - git add" -ForegroundColor Green
    Write-Host "  gc    - git commit -m" -ForegroundColor Green
    Write-Host "  gp    - git push" -ForegroundColor Green
    Write-Host "  glog  - git log --oneline -10" -ForegroundColor Green
    Write-Host "  gco   - git checkout" -ForegroundColor Green
    Write-Host "  gb    - git branch" -ForegroundColor Green
    Write-Host "  gd    - git diff" -ForegroundColor Green
    Write-Host "  gl    - git pull" -ForegroundColor Green
}

function show-docker-aliases {
    Write-Host "Docker Aliases:" -ForegroundColor Cyan
    Write-Host "  d      - docker" -ForegroundColor Green
    Write-Host "  dps    - docker ps" -ForegroundColor Green
    Write-Host "  di     - docker images" -ForegroundColor Green
    Write-Host "  dc     - docker-compose" -ForegroundColor Green
    Write-Host "  dcup   - docker-compose up -d" -ForegroundColor Green
    Write-Host "  dcdown - docker-compose down" -ForegroundColor Green
}

function show-system-aliases {
    Write-Host "System Aliases:" -ForegroundColor Cyan
    Write-Host "  ll       - enhanced directory listing" -ForegroundColor Green
    Write-Host "  sysinfo  - system information" -ForegroundColor Green
    Write-Host "  meminfo  - memory usage" -ForegroundColor Green
    Write-Host "  diskinfo - disk usage" -ForegroundColor Green
    Write-Host "  myip     - public IP address" -ForegroundColor Green
    Write-Host "  localip  - local IP addresses" -ForegroundColor Green
}

function pwsh-status {
    Write-Host "=== PowerShell 7 Environment Status ===" -ForegroundColor Cyan
    Write-Host "PowerShell Version: `$(`$PSVersionTable.PSVersion)" -ForegroundColor Yellow
    Write-Host "Execution Policy: `$(Get-ExecutionPolicy)" -ForegroundColor Yellow
    Write-Host "Profile Location: `$PROFILE" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "=== Installed Tools ===" -ForegroundColor Cyan
    if (Get-Command starship -ErrorAction SilentlyContinue) { Write-Host "✅ Starship available" -ForegroundColor Green } else { Write-Host "❌ Starship not available" -ForegroundColor Red }
    if (Get-Command git -ErrorAction SilentlyContinue) { Write-Host "✅ Git available" -ForegroundColor Green } else { Write-Host "❌ Git not available" -ForegroundColor Red }
    if (Get-Command docker -ErrorAction SilentlyContinue) { Write-Host "✅ Docker available" -ForegroundColor Green } else { Write-Host "❌ Docker not available" -ForegroundColor Red }
    if (Get-Command kubectl -ErrorAction SilentlyContinue) { Write-Host "✅ Kubectl available" -ForegroundColor Green } else { Write-Host "❌ Kubectl not available" -ForegroundColor Red }
    Write-Host ""
    Write-Host "=== Enhanced Profile Status ===" -ForegroundColor Cyan
    Write-Host "✅ Enhanced aliases loaded" -ForegroundColor Green
    Write-Host "✅ Git shortcuts available" -ForegroundColor Green
    Write-Host "✅ System utilities available" -ForegroundColor Green
}

# Welcome message
Write-Host ""
Write-Host "🚀 Enhanced PowerShell 7 Profile Loaded!" -ForegroundColor Green
Write-Host "Type 'pwsh-status' to check your setup" -ForegroundColor Cyan
Write-Host "Type 'show-git-aliases' to see Git shortcuts" -ForegroundColor Cyan
Write-Host ""
"@

    # Write profile content
    $ProfileContent | Out-File -FilePath $PROFILE -Encoding UTF8 -Force
    Write-Success "PowerShell profile created/updated"

    # Step 4: Create Starship configuration
    Write-Status "⚙️  Creating Starship configuration..." "Yellow"
    
    $ConfigDir = "$env:USERPROFILE\.config"
    $StarshipConfig = "$ConfigDir\starship.toml"
    
    if (-not (Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    }

    # Starship config (matching WSL2 version)
    $StarshipConfigContent = @"
# Starship configuration optimized for PowerShell 7
format = """
`$username\
`$hostname\
`$directory\
`$git_branch\
`$git_state\
`$git_status\
`$cmd_duration\
`$line_break\
`$python\
`$character"""

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = "🌱 "

[git_status]
ahead = "⇡`${count}"
diverged = "⇕⇡`${ahead_count}⇣`${behind_count}"
behind = "⇣`${count}"

[hostname]
ssh_only = false
format = "[@`$hostname](bold blue) "
disabled = false

[username]
format = "[`$user](bold yellow)"
disabled = false
show_always = true

[cmd_duration]
min_time = 2_000
format = "took [$duration](bold yellow)"
"@

    $StarshipConfigContent | Out-File -FilePath $StarshipConfig -Encoding UTF8 -Force
    Write-Success "Starship configuration created"

    # Step 5: Set execution policy if needed
    Write-Status "🔒 Checking execution policy..." "Yellow"
    $CurrentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($CurrentPolicy -eq "Restricted" -or $CurrentPolicy -eq "Undefined") {
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Success "Execution policy set to RemoteSigned"
        } catch {
            Write-Warning "Could not set execution policy. You may need to run as Administrator"
        }
    } else {
        Write-Info "Execution policy already appropriate: $CurrentPolicy"
    }

    # Final status
    Write-Status "🎉 Setup Complete!" "Cyan"
    Write-Status "================" "Green"
    Write-Status "🚀 Next steps:" "Yellow"
    Write-Status "  1. Restart PowerShell or run: . `$PROFILE" "Cyan"
    Write-Status "  2. Test: pwsh-status" "Cyan" 
    Write-Status "  3. Try: gs (git status)" "Cyan"
    Write-Status "  4. View shortcuts: show-git-aliases" "Cyan"
    Write-Status "" "White"
    Write-Success "✨ Your PowerShell 7 environment is now optimized with Starship!"
}

# Run the installation
try {
    Install-StarshipSetup
} catch {
    Write-Error "Setup failed: $($_.Exception.Message)"
    Write-Host "You can try running individual commands manually" -ForegroundColor Yellow
}
