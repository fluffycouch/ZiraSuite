# Deploy Zira Suite to Render (Free Alternative)

Render offers a free tier perfect for testing your container.

## Render Deployment Steps

### Step 1: Connect GitHub
1. Go to [render.com](https://render.com)
2. Sign up with GitHub
3. Connect your "Zira Suite" repository

### Step 2: Create Web Service
1. Click "New +" → "Web Service"
2. Select your repository
3. Configure:
   - **Name**: zira-suite
   - **Region**: Oregon (US West)
   - **Branch**: main
   - **Root Directory**: ManagerServer-linux-x64
   - **Runtime**: Docker
   - **Build Command**: (leave empty)
   - **Start Command**: (leave empty - uses Dockerfile)

### Step 3: Set Environment Variables
Add these in the Environment section:
```
SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvd2p1dWRyZmdlamN6d290dndzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NzYxODYsImV4cCI6MjA3NzA1MjE4Nn0.pZQC51ESY_iHCAWrlESn9-K0OZhqgmAQwaKmeKqUTJI
PORT=3000
```

### Step 4: Deploy
Click "Create Web Service" - it will auto-deploy!

### Benefits:
- ✅ Completely free tier
- ✅ No credit card required
- ✅ Auto-deploys from GitHub
- ✅ Custom domains on free tier
- ⚠️ Spins down after 15min inactivity (free tier)