FROM node:18-slim

# Install ca-certificates and ICU libraries (for HTTPS requests to Supabase and .NET globalization)
RUN apt-get update && apt-get install -y ca-certificates curl libicu-dev wget && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy assets first
COPY Assets ./Assets

# Copy ManagerServer binary (if it exists locally, otherwise download during build)
COPY ManagerServer ./ManagerServer 2>/dev/null || echo "ManagerServer binary not found - you may need to provide it separately"

# Copy the proxy and package manifest
COPY proxy ./proxy
COPY package.json ./package.json

# Copy entrypoint
COPY entrypoint.sh ./entrypoint.sh

RUN chmod +x ./ManagerServer ./entrypoint.sh

# Install only production dependencies for the proxy
RUN npm ci --only=production || npm install --only=production

ENV PORT=3000
EXPOSE 3000

CMD ["./entrypoint.sh"]
