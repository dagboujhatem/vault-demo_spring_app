#!/bin/bash
set -e

# Configuration
VAULT_ADDR=${VAULT_ADDR:-"http://vault:8200"}
VAULT_ROLE_ID=${VAULT_ROLE_ID}
VAULT_SECRET_ID=${VAULT_SECRET_ID}

# Vault KV v2 
VAULT_API_PATH=${VAULT_API_PATH:-"kvv2"}
VAULT_APP_CODE=${VAULT_APP_CODE:-"AP0001"}
VAULT_ENV=${VAULT_ENV:-"dev"}
VAULT_SECRET_NAME=${VAULT_SECRET_NAME:-"database-secret-v2"}

echo "--- Vault Integration ---"
echo "Vault Address: $VAULT_ADDR"
echo "Role ID: $VAULT_ROLE_ID"
echo "Vault API path: $VAULT_API_PATH"
echo "App Code: $VAULT_APP_CODE"
echo "Environment: $VAULT_ENV"

if [ -z "$VAULT_ROLE_ID" ] || [ -z "$VAULT_SECRET_ID" ]; then
    echo "Error: VAULT_ROLE_ID and VAULT_SECRET_ID must be set."
    exit 1
fi

# 1. Login to Vault using AppRole
echo "Logging in to Vault..."
LOGIN_RESPONSE=$(curl -s -X POST -d '{"role_id":"'$VAULT_ROLE_ID'","secret_id":"'$VAULT_SECRET_ID'"}' $VAULT_ADDR/v1/auth/approle/login)
VAULT_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.auth.client_token')

if [ "$VAULT_TOKEN" == "null" ] || [ -z "$VAULT_TOKEN" ]; then
    echo "Error: Failed to authenticate with Vault."
    echo $LOGIN_RESPONSE
    exit 1
fi

echo "Successfully authenticated with Vault."

# 2. Fetch secrets
echo "Fetching secrets from Vault..."
SECRET_PATH="$VAULT_API_PATH/data/$VAULT_APP_CODE/$VAULT_ENV/$VAULT_SECRET_NAME"
SECRET_RESPONSE=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/$SECRET_PATH)

# Check if secret was found
if echo "$SECRET_RESPONSE" | jq -e '.errors' > /dev/null; then
    echo "Error: Failed to fetch secrets from $SECRET_PATH"
    echo "$SECRET_RESPONSE"
    exit 1
fi

# 3. Export secrets as environment variables
# Note: In the Spring app, the datasource configuration uses ${POSTGRES_USER} and ${POSTGRES_PASSWORD}
export POSTGRES_USER=$(echo $SECRET_RESPONSE | jq -r '.data.data.username')
export POSTGRES_PASSWORD=$(echo $SECRET_RESPONSE | jq -r '.data.data.password')

echo "Secrets fetched and exported successfully."
echo "--------------------------"

# 4. Execute the application
exec java -jar app.jar
