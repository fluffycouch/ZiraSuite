#!/bin/sh
set -e

# Default ports
MANAGER_PORT=${MANAGER_PORT:-8080}
PROXY_PORT=${PORT:-3000}

echo "Starting Zira Suite deployment..."
echo "ManagerServer port: ${MANAGER_PORT}"
echo "Proxy port: ${PROXY_PORT}"

# Start ManagerServer in background
echo "Starting ManagerServer on port ${MANAGER_PORT}..."
./ManagerServer &
MANAGER_PID=$!

# Give ManagerServer a moment to start
sleep 2

# Simple health check - just verify the process is running
echo "Checking if ManagerServer is running..."
if kill -0 $MANAGER_PID 2>/dev/null; then
    echo "ManagerServer is running (PID: $MANAGER_PID)"
else
    echo "Warning: ManagerServer may not have started properly"
fi

# Start the auth proxy
echo "Starting auth proxy on port ${PROXY_PORT}..."
exec node proxy/index.js
