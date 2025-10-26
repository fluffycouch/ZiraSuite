# Handling Large Binaries for Cloud Deployment

## The Problem
GitHub has a 100MB file size limit, but our ManagerServer binary (116MB) and Node.js binary (116MB) exceed this limit.

## Free Deployment Solutions

### Option 1: Test with Proxy-Only Version (Quickest)

For immediate testing without the ManagerServer binary:

```bash
# Deploy proxy-only version to test authentication
# Uses Dockerfile.proxy-only with a mock backend
```

**Render Setup:**
1. Connect GitHub repository
2. Set root directory: `ManagerServer-linux-x64`
3. Set Docker file: `Dockerfile.proxy-only`
4. Add environment variables:
   - `SUPABASE_URL`: `https://jowjuudrfgejczwotvws.supabase.co`
   - `SUPABASE_ANON_KEY`: `your_anon_key`

### Option 2: Use Cloud Build with Binary Download

Use `Dockerfile.cloud` which downloads binaries during the build process:

1. **Host your ManagerServer binary** somewhere accessible:
   - GitHub Releases (for public repos)
   - Cloud storage (AWS S3, Google Cloud Storage, etc.)
   - Your own server

2. **Update Dockerfile.cloud** with the download URL:
   ```dockerfile
   RUN wget -O ManagerServer "https://github.com/your-username/zira-suite/releases/download/v1.0/ManagerServer" && chmod +x ManagerServer
   ```

3. **Deploy using the cloud Dockerfile**:
   ```bash
   # For Fly.io
   flyctl deploy --dockerfile Dockerfile.cloud
   
   # For Railway
   railway up --dockerfile Dockerfile.cloud
   ```

### Option 2: GitHub Releases

1. **Create a GitHub Release**:
   - Go to your repository → Releases → Create new release
   - Upload your ManagerServer binary as a release asset
   - Note the download URL

2. **Update deployment to download from releases**:
   ```dockerfile
   RUN wget -O ManagerServer "https://github.com/your-username/zira-suite/releases/download/v1.0/ManagerServer"
   ```

### Option 3: Build from Source (If Available)

If you have the source code for ManagerServer:

```dockerfile
# Add to Dockerfile.cloud
COPY src ./src
RUN dotnet publish -c Release -o . src/ManagerServer.csproj
```

### Option 4: Platform-Specific Solutions

#### Fly.io
```bash
# Build with larger disk space
flyctl deploy --build-arg BUILDKIT_INLINE_CACHE=1
```

#### Railway
- Railway automatically handles larger builds
- Use the cloud Dockerfile

#### Render
- Supports larger builds in paid plans
- Use build commands to download binaries

## Current Repository Status

✅ **What's in Git**:
- Complete application code
- Docker configuration
- Deployment scripts
- Documentation

❌ **What's excluded** (too large for GitHub):
- ManagerServer binary (116MB)
- Node.js binary for Playwright (116MB)

## Quick Setup for Cloud Deployment

1. **Upload ManagerServer binary** to GitHub Releases or cloud storage
2. **Update Dockerfile.cloud** with the download URL
3. **Deploy using the cloud Dockerfile**

## Example Commands

```bash
# Create GitHub release with binary
gh release create v1.0 ManagerServer-linux-x64/ManagerServer --title "Zira Suite v1.0"

# Deploy to Fly.io with cloud Dockerfile
flyctl deploy --dockerfile Dockerfile.cloud

# Deploy to Railway
railway up --dockerfile Dockerfile.cloud
```

## Testing Locally

To test the cloud build locally:

```bash
cd ManagerServer-linux-x64
docker build -f Dockerfile.cloud -t zira-suite-cloud .
docker run -p 3000:3000 -e SUPABASE_URL=your_url -e SUPABASE_ANON_KEY=your_key zira-suite-cloud
```

Your Zira Suite is ready for cloud deployment! 🚀