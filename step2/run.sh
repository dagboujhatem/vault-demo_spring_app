#!/bin/bash
set -e
cd "$(dirname "$0")"

echo ">>> Step 2: Extracting AppRole Credentials..."

ROLE_ID=$(docker run --rm -v $(pwd)/../terraform:/app/ -w /app/ hashicorp/terraform:light output -raw approle_role_id)
SECRET_ID=$(docker run --rm -v $(pwd)/../terraform:/app/ -w /app/ hashicorp/terraform:light output -raw approle_secret_id)

if [ -z "$ROLE_ID" ] || [ -z "$SECRET_ID" ]; then
    echo "Error: Failed to retrieve Role ID or Secret ID. Check Terraform logs."
    docker-compose -f ../docker-compose.yml logs terraform
    exit 1
fi

# Save to .secrets file at project root
echo "ROLE_ID=$ROLE_ID" > ../.secrets
echo "SECRET_ID=$SECRET_ID" >> ../.secrets
chmod 600 ../.secrets

echo "Credentials extracted and saved to .secrets file (root of project)."
