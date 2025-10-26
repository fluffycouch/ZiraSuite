# Free Deployment Options for Zira Suite

Since Railway requires a paid plan for web services, here are the best free alternatives:

## 🆓 Free Platforms That Work

### 1. Render (Recommended - Easiest)
- ✅ **Free tier**: 750 hours/month
- ✅ **Docker support**: Full Docker support
- ✅ **GitHub integration**: Auto-deploy on push
- ⚠️ **Limitation**: Spins down after 15min inactivity

**Setup Steps:**
1. Go to [render.com](https://render.com)
2. Connect your GitHub account
3. Select "Zira Suite" repository
4. Choose "Web Service"
5. Configure:
   - **Name**: `zira-suite`
   - **Root Directory**: `ManagerServer-linux-x64`
   - **Docker File**: `Dockerfile.proxy-only` (for testing)
   - **Region**: Oregon (US West)
6. Add Environment Variables:
   - `SUPABASE_URL`: `https://jowjuudrfgejczwotvws.supabase.co`
   - `SUPABASE_ANON_KEY`: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
7. Click "Create Web Service"

### 2. Fly.io (Best Performance)
- ✅ **Free tier**: 3 shared VMs
- ✅ **Always on**: No spin-down
- ✅ **Global edge**: Fast worldwide
- ⚠️ **Requires verification**: Credit card needed

**Setup Steps:**
```bash
cd ManagerServer-linux-x64
flyctl launch --dockerfile Dockerfile.proxy-only --no-deploy
flyctl secrets set SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co
flyctl secrets set SUPABASE_ANON_KEY=your_anon_key
flyctl deploy --dockerfile Dockerfile.proxy-only
```

### 3. Koyeb (Alternative)
- ✅ **Free tier**: 512MB RAM
- ✅ **GitHub integration**: Auto-deploy
- ✅ **Always on**: No spin-down

### 4. Cyclic (Node.js Focused)
- ✅ **Free tier**: Unlimited
- ✅ **Serverless**: Auto-scaling
- ⚠️ **Node.js only**: Would need to adapt

## 🚀 Quick Start (Render)

**1. Test Proxy-Only Version:**
```
Repository: https://github.com/fluffycouch/ZiraSuite
Root Directory: ManagerServer-linux-x64
Dockerfile: Dockerfile.proxy-only
```

**2. Environment Variables:**
```
SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvd2p1dWRyZmdlamN6d290dndzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NzYxODYsImV4cCI6MjA3NzA1MjE4Nn0.pZQC51ESY_iHCAWrlESn9-K0OZhqgmAQwaKmeKqUTJI
```

**3. Test Endpoints:**
- Health: `https://your-app.onrender.com/health`
- Auth test: `https://your-app.onrender.com/` (should return auth error)

## 📋 Dockerfile Options

| Dockerfile | Purpose | Best For |
|------------|---------|----------|
| `Dockerfile.proxy-only` | Mock backend for testing | Quick testing |
| `Dockerfile.render` | Render-optimized | Production with binary |
| `Dockerfile.cloud` | Generic cloud deployment | Any platform |

## 🔧 Troubleshooting

**Render "No Dockerfile" Error:**
- Make sure "Root Directory" is set to `ManagerServer-linux-x64`
- Specify the exact Dockerfile name (e.g., `Dockerfile.proxy-only`)

**Build Failures:**
- Check the build logs in the platform dashboard
- Verify environment variables are set correctly

**Authentication Issues:**
- Test the `/health` endpoint first (should work without auth)
- Verify your Supabase URL and key are correct

## 🎯 Recommended Approach

1. **Start with Render + proxy-only** for immediate testing
2. **Upgrade to full version** once you have the ManagerServer binary hosted
3. **Consider Fly.io** for production due to better performance

Your Zira Suite will be live and testable within minutes! 🚀