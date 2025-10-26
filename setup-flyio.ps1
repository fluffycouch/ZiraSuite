# Zira Suite - Fly.io Deployment Setup Script

Write-Host "🚀 Setting up Zira Suite deployment to Fly.io..." -ForegroundColor Green

# Check if flyctl is installed
try {
    $flyVersion = flyctl version
    Write-Host "✅ Fly CLI found: $flyVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Fly CLI not found. Installing..." -ForegroundColor Red
    Write-Host "Run: iwr https://fly.io/install.ps1 -useb | iex" -ForegroundColor Yellow
    exit 1
}

# Check if logged in
try {
    flyctl auth whoami | Out-Null
    Write-Host "✅ Already logged in to Fly.io" -ForegroundColor Green
} catch {
    Write-Host "🔐 Please login to Fly.io..." -ForegroundColor Yellow
    flyctl auth login
}

# Navigate to ManagerServer directory
Set-Location "ManagerServer-linux-x64"

Write-Host "📋 Fly.io configuration ready!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: flyctl launch --no-deploy" -ForegroundColor White
Write-Host "2. Set secrets:" -ForegroundColor White
Write-Host "   flyctl secrets set SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co" -ForegroundColor Gray
Write-Host "   flyctl secrets set SUPABASE_ANON_KEY=your_anon_key" -ForegroundColor Gray
Write-Host "3. Deploy: flyctl deploy" -ForegroundColor White
Write-Host ""
Write-Host "Your app will be available at: https://zira-suite.fly.dev" -ForegroundColor Green