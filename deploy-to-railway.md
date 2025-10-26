# Deploy Zira Suite to Railway (Alternative)

Railway offers $5 free credit monthly and easier account setup.

## Quick Railway Deployment

### Step 1: Install Railway CLI
```powershell
npm install -g @railway/cli
```

### Step 2: Login and Deploy
```powershell
cd ManagerServer-linux-x64
railway login
railway init
railway up
```

### Step 3: Set Environment Variables
```powershell
railway variables set SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co
railway variables set SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvd2p1dWRyZmdlamN6d290dndzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NzYxODYsImV4cCI6MjA3NzA1MjE4Nn0.pZQC51ESY_iHCAWrlESn9-K0OZhqgmAQwaKmeKqUTJI
```

### Benefits:
- ✅ No account verification issues
- ✅ $5 free credit monthly
- ✅ Auto-detects Dockerfile
- ✅ Easy GitHub integration