# PowerShell-DevOps-Hub Repository Migration Script
# Run this after creating the new GitHub repository

Write-Host "🚀 Starting PowerShell-DevOps-Hub Repository Migration" -ForegroundColor Green
Write-Host ("=" * 60)

# Step 1: Verify current repository status
Write-Host "📋 Step 1: Checking current repository status..." -ForegroundColor Yellow
$uncommittedChanges = git status --porcelain
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Not in a git repository" -ForegroundColor Red
    exit 1
}

# Check for uncommitted changes and offer to commit them
if ($uncommittedChanges) {
    Write-Host "⚠️  Found uncommitted changes:" -ForegroundColor Yellow
    $uncommittedChanges | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    
    $response = Read-Host "Do you want to commit these changes before migration? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host "📝 Adding and committing changes..." -ForegroundColor Yellow
        git add .
        $commitMessage = Read-Host "Enter commit message (or press Enter for default)"
        if ([string]::IsNullOrWhiteSpace($commitMessage)) {
            $commitMessage = "Pre-migration commit: Add remaining files"
        }
        git commit -m $commitMessage
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Failed to commit changes" -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ Changes committed successfully" -ForegroundColor Green
    } else {
        Write-Host "❌ Cannot proceed with uncommitted changes. Please commit or stash them first." -ForegroundColor Red
        exit 1
    }
}

# Step 2: Add new remote (or verify if it already exists)
Write-Host "📋 Step 2: Configuring new repository remote..." -ForegroundColor Yellow
$existingRemotes = git remote
if ($existingRemotes -contains "new-origin") {
    Write-Host "ℹ️  Remote 'new-origin' already exists, skipping..." -ForegroundColor Cyan
} else {
    git remote add new-origin https://github.com/pyzons/PowerShell-DevOps-Hub.git
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ New remote added successfully" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to add new remote" -ForegroundColor Red
        exit 1
    }
}

# Step 3: Push to new repository
Write-Host "📋 Step 3: Pushing all content to new repository..." -ForegroundColor Yellow
git push new-origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully pushed to new repository" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to push to new repository" -ForegroundColor Red
    Write-Host "💡 Make sure you created the repository on GitHub first" -ForegroundColor Cyan
    exit 1
}

# Step 4: Update remote configuration
Write-Host "📋 Step 4: Updating remote configuration..." -ForegroundColor Yellow
$existingOrigin = git remote | Where-Object { $_ -eq "origin" }
if ($existingOrigin) {
    git remote remove origin
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Old origin remote removed" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Warning: Could not remove old origin remote" -ForegroundColor Yellow
    }
}

git remote rename new-origin origin
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Remote configuration updated" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to rename new-origin to origin" -ForegroundColor Red
    Write-Host "💡 You may need to manually run: git remote rename new-origin origin" -ForegroundColor Cyan
}

# Step 5: Verify new setup
Write-Host "📋 Step 5: Verifying new repository setup..." -ForegroundColor Yellow
Write-Host "Current remotes:" -ForegroundColor Cyan
git remote -v

# Step 6: Test connection
Write-Host "📋 Step 6: Testing connection to new repository..." -ForegroundColor Yellow
git ls-remote origin
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Connection to new repository successful!" -ForegroundColor Green
} else {
    Write-Host "❌ Connection test failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 MIGRATION COMPLETE!" -ForegroundColor Green
Write-Host ("=" * 60)
Write-Host "📍 New Repository: https://github.com/pyzons/PowerShell-DevOps-Hub" -ForegroundColor Cyan
Write-Host "📁 Local Path: $(Get-Location)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Close VS Code" -ForegroundColor White
Write-Host "2. Rename directory: c:\app\ws → c:\app\PowerShell-DevOps-Hub" -ForegroundColor White
Write-Host "3. Open: c:\app\PowerShell-DevOps-Hub\PowerShell-DevOps-Hub.code-workspace" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Ready to continue development in your new PowerShell-DevOps-Hub!" -ForegroundColor Green
