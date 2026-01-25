#!/bin/bash
set -e
# Navigate to step directory
cd "$(dirname "$0")"

echo ">>> Step 0: Starting Infrastructure..."
docker-compose -f ../docker-compose.yml up -d

echo ">>> Step 0: Starting Insecure App (Standard config)..."
cd spring-app
mvn spring-boot:run
