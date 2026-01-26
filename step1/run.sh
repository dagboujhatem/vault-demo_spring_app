#!/bin/bash
set -e
# Navigate to step directory
cd "$(dirname "$0")"

echo ">>> Starting App ..."
docker-compose -f ./docker-compose.yml up -d

echo ">>> App started successfully."

