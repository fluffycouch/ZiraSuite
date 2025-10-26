#!/bin/bash
# Test script to verify the Docker setup works locally

echo "🧪 Testing Zira Suite Docker Setup"
echo "=================================="

# Build the Docker image
echo "📦 Building Docker image..."
docker build -t zira-suite-test .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed!"
    exit 1
fi

echo "✅ Docker build successful!"

# Run the container
echo "🚀 Starting container..."
docker run -d \
    --name zira-suite-test \
    -p 3000:3000 \
    -p 8080:8080 \
    -e SUPABASE_URL=https://jowjuudrfgejczwotvws.supabase.co \
    -e SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impvd2p1dWRyZmdlamN6d290dndzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NzYxODYsImV4cCI6MjA3NzA1MjE4Nn0.pZQC51ESY_iHCAWrlESn9-K0OZhqgmAQwaKmeKqUTJI \
    -e PORT=3000 \
    -e MANAGER_PORT=8080 \
    zira-suite-test

if [ $? -ne 0 ]; then
    echo "❌ Failed to start container!"
    exit 1
fi

echo "✅ Container started!"

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Test health endpoint
echo "🔍 Testing health endpoint..."
curl -f http://localhost:3000/health

if [ $? -eq 0 ]; then
    echo "✅ Health endpoint working!"
else
    echo "❌ Health endpoint failed!"
fi

# Test protected endpoint (should fail without auth)
echo "🔍 Testing protected endpoint (should fail)..."
curl -f http://localhost:3000/ 2>/dev/null

if [ $? -ne 0 ]; then
    echo "✅ Protected endpoint correctly requires authentication!"
else
    echo "❌ Protected endpoint should require authentication!"
fi

# Cleanup
echo "🧹 Cleaning up..."
docker stop zira-suite-test
docker rm zira-suite-test

echo "🎉 Test completed! Your setup should work on Render."
