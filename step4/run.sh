#!/bin/bash
set -e
cd "$(dirname "$0")"

echo ">>> Step 4: Starting Vault-secured Spring Boot Application..."

if [ ! -f ../.secrets ]; then
    echo "Error: .secrets file not found. Please run Step 2 first."
    exit 1
fi

source ../.secrets
export ROLE_ID
export SECRET_ID

cd spring-app
mvn spring-boot:run
