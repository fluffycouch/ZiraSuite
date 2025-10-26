# Deploy Zira Suite to Fly.io

## Prerequisites
- ✅ Docker container tested locally (working!)
- ✅ GitHub repository: "Zira Suite"
- ✅ Fly.io account with 30-day free trial

## Step 1: Install Fly CLI

```powershell
# Install Fly CLI using PowerShell
iwr https://fly.io/install.ps1 -useb | iex

# Or using Chocolatey
choco install flyctl

# Verify installation
flyctl version
```

## Step 2: Login to Fly.io

```powershell
flyctl auth login
```

## Step 3: Initialize Fly App

Navigate to your ManagerServer directory and initialize:

```powershell
cd ManagerServer-linux-x64
flyctl launch --no-deploy
```

This will:
- Detect your Dockerfile automatically
- Create a `fly.toml` configuration file
- Set up the app (but not deploy yet)

## Step 4: Configure fly.toml

The generated `fly.toml` will need these settings:

```toml
app = "zira-suite"
primary_region = "iad"  # or your preferred region

[build]

[env]
  PORT = "3000"

[http_service]
  internal_port = 3000
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 512

[checks]
  [checks.health]
    grace_period = "30s"
    interval = "15s"
    method = "get"
    path = "/health"
    port = 3000
    timeout = "10s"
```

## Step 5: Set Environment Variables

```powershell
# Set your Supabase credentials as secrets
flyctl secrets set SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co
flyctl secrets set SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvd2p1dWRyZmdlamN6d290dndzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NzYxODYsImV4cCI6MjA3NzA1MjE4Nn0.pZQC51ESY_iHCAWrlESn9-K0OZhqgmAQwaKmeKqUTJI

# Optional: Set JWT verification for better performance
flyctl secrets set SUPABASE_JWKS_URL=https://jowjuudrfgejczwotvws.supabase.co/auth/v1/.well-known/jwks.json
```

## Step 6: Deploy

```powershell
flyctl deploy
```

## Step 7: Test Deployment

```powershell
# Get your app URL
flyctl info

# Test health endpoint
curl https://zira-suite.fly.dev/health

# Check logs
flyctl logs
```

## GitHub Integration (Optional)

To deploy automatically from GitHub:

1. **Create GitHub Action** (`.github/workflows/fly.yml`):

```yaml
name: Deploy to Fly.io
on:
  push:
    branches: [main]
    paths: ['ManagerServer-linux-x64/**']

jobs:
  deploy:
    name: Deploy app
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only --dockerfile ManagerServer-linux-x64/Dockerfile
        working-directory: ManagerServer-linux-x64
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

2. **Add Fly API Token to GitHub Secrets**:
   - Get token: `flyctl auth token`
   - Add to GitHub repo secrets as `FLY_API_TOKEN`

## Fly.io Benefits

- ✅ **30-day free trial** - Perfect for testing
- ✅ **Global edge deployment** - Fast worldwide
- ✅ **Auto-scaling** - Scales to zero when not used
- ✅ **Built-in SSL** - HTTPS automatically
- ✅ **Health checks** - Uses your `/health` endpoint
- ✅ **Easy rollbacks** - `flyctl rollback`

## Cost After Trial

- **Hobby Plan**: ~$2-5/month for small apps
- **Scales to zero**: Only pay when running
- **Much cheaper** than traditional hosting

## Troubleshooting

```powershell
# Check app status
flyctl status

# View logs
flyctl logs

# SSH into container (if needed)
flyctl ssh console

# Scale resources if needed
flyctl scale memory 1024  # 1GB RAM
```

Your Zira Suite will be available at: `https://zira-suite.fly.dev`