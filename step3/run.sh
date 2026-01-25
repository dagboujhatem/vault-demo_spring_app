#!/bin/bash
set -e
cd "$(dirname "$0")"

echo ">>> Step 3: Verifying Credentials..."

if [ ! -f ../.secrets ]; then
    echo "Error: .secrets file not found. Please run Step 2 first."
    exit 1
fi

source ../.secrets

echo "Role ID: $ROLE_ID"
echo "Secret ID: ${SECRET_ID:0:5}***** (Hidden)"
echo "Credentials are ready for use."
