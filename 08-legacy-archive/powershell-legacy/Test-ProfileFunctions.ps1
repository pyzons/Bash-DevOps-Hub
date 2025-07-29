# Test PowerShell 7 Profile Functions
Write-Host "🧪 Testing PowerShell 7 Profile Functions" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "📍 Profile Location:" -ForegroundColor Yellow
Write-Host $PROFILE -ForegroundColor White

Write-Host ""
Write-Host "🔍 Testing Show-GitAliases function..." -ForegroundColor Yellow
try {
    if (Get-Command Show-GitAliases -ErrorAction SilentlyContinue) {
        Write-Host "✅ Show-GitAliases function found" -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 Running Show-GitAliases:" -ForegroundColor Cyan
        Show-GitAliases
    } else {
        Write-Host "❌ Show-GitAliases function not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error running Show-GitAliases: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔍 Testing basic Git aliases..." -ForegroundColor Yellow
$gitAliases = @('g', 'gs', 'ga', 'gc', 'gp', 'gl', 'gd', 'gb', 'gco')
foreach ($alias in $gitAliases) {
    if (Get-Command $alias -ErrorAction SilentlyContinue) {
        Write-Host "✅ $alias" -ForegroundColor Green -NoNewline
        Write-Host " - " -NoNewline
        Write-Host (Get-Command $alias).Definition -ForegroundColor Gray
    } else {
        Write-Host "❌ $alias - Not found" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🔍 Testing other functions..." -ForegroundColor Yellow
$functions = @('Show-DockerAliases', 'Show-KubernetesAliases', 'K8s-QuickStart', 'Check-DockerReady')
foreach ($func in $functions) {
    if (Get-Command $func -ErrorAction SilentlyContinue) {
        Write-Host "✅ $func" -ForegroundColor Green
    } else {
        Write-Host "❌ $func - Not found" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎯 Test completed!" -ForegroundColor Green
