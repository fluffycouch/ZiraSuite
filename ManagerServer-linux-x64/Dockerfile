FROM node:18-slim

# Install ca-certificates and ICU libraries (for HTTPS requests to Supabase and .NET globalization)
RUN apt-get update && apt-get install -y ca-certificates curl libicu-dev wget netcat-openbsd && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy assets first
COPY Assets ./Assets

# Create a mock ManagerServer for testing (since binary is not in Git due to size limits)
# For production, replace this with actual binary download
RUN echo '#!/bin/bash' > ManagerServer && \
    echo 'echo "Mock ManagerServer starting on port ${MANAGER_PORT:-8080}"' >> ManagerServer && \
    echo 'echo "Replace this with actual ManagerServer binary for production"' >> ManagerServer && \
    echo 'while true; do' >> ManagerServer && \
    echo '  echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{\"status\":\"ok\",\"service\":\"mock-manager\"}" | nc -l -p ${MANAGER_PORT:-8080} -q 1 2>/dev/null || sleep 1' >> ManagerServer && \
    echo 'done' >> ManagerServer

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
