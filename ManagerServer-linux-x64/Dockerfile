FROM node:18-slim

# Install dependencies needed for the application
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    libicu-dev \
    wget \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package.json first for better Docker layer caching
COPY package.json ./package.json

# Install Node.js dependencies
RUN npm ci --only=production || npm install --only=production

# Copy application files
COPY Assets ./Assets
COPY proxy ./proxy
COPY entrypoint.sh ./entrypoint.sh

# Make entrypoint executable
RUN chmod +x ./entrypoint.sh

# Create a simple mock ManagerServer that works reliably in Render
RUN echo '#!/bin/bash' > ManagerServer && \
    echo 'echo "Starting mock ManagerServer on port ${MANAGER_PORT:-8080}"' >> ManagerServer && \
    echo 'echo "This is a placeholder - replace with actual ManagerServer binary for production"' >> ManagerServer && \
    echo 'cd /tmp && python3 -m http.server ${MANAGER_PORT:-8080}' >> ManagerServer && \
    chmod +x ManagerServer

# Set environment variables
ENV PORT=3000
ENV MANAGER_PORT=8080

EXPOSE 3000

CMD ["./entrypoint.sh"]
