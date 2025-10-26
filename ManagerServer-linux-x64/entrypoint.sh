#!/bin/sh
set -e

# Default ports
MANAGER_PORT=${MANAGER_PORT:-8080}
PROXY_PORT=${PORT:-3000}

# Start ManagerServer in background
echo "Starting ManagerServer on port ${MANAGER_PORT}..."
./ManagerServer --urls "http://*:${MANAGER_PORT}" &
MANAGER_PID=$!

# Readiness loop: wait until ManagerServer responds on /health or until timeout
HEALTH_PATH=${HEALTH_PATH:-/health}
TIMEOUT=${READY_TIMEOUT:-30} # seconds
INTERVAL=1
elapsed=0
echo "Waiting up to ${TIMEOUT}s for ManagerServer to become ready (checking ${HEALTH_PATH})..."
while [ ${elapsed} -lt ${TIMEOUT} ]; do
	if curl -s -f "http://127.0.0.1:${MANAGER_PORT}${HEALTH_PATH}" > /dev/null 2>&1; then
		echo "ManagerServer is healthy"
		break
	fi
	sleep ${INTERVAL}
	elapsed=$((elapsed + INTERVAL))
done

if [ ${elapsed} -ge ${TIMEOUT} ]; then
	echo "Warning: ManagerServer did not become healthy within ${TIMEOUT}s. Proceeding to start proxy anyway."
fi

echo "Starting auth proxy on port ${PROXY_PORT}..."
node proxy/index.js

# wait for ManagerServer if it exits
wait ${MANAGER_PID}
