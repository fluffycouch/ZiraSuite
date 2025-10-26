FROM node:18-slim

# Install ca-certificates and ICU libraries (for HTTPS requests to Supabase and .NET globalization)
RUN apt-get update && apt-get install -y ca-certificates curl libicu-dev wget && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy assets first
COPY Assets ./Assets

# Download ManagerServer binary during build (since it's not in Git due to size limits)
# Replace this URL with your actual binary location
RUN echo "Downloading ManagerServer binary..." && \
    echo "ERROR: ManagerServer binary download not configured!" && \
    echo "Please update this Dockerfile with the actual download URL" && \
    echo "Example: wget -O ManagerServer 'https://github.com/fluffycouch/ZiraSuite/releases/download/v1.0/ManagerServer'" && \
    exit 1

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
