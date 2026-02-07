#!/bin/bash
set -e
# Navigate to step directory
cd "$(dirname "$0")"

# Start vault container
docker-compose -f ./docker-compose.yml up -d vault
# --------------------------------------------------
# Wait for Vault to be UP
# --------------------------------------------------
echo "🔐 Waiting for Vault to be UP..."
VAULT_URL="http://localhost:8200/v1/sys/health"
MAX_RETRIES=10
SLEEP_TIME=5

retry=0
until curl -s "$VAULT_URL" | grep -q '"initialized":true'; do
  retry=$((retry + 1))
  if [ "$retry" -ge "$MAX_RETRIES" ]; then
    echo "❌ Vault did not become ready in time"
    exit 1
  fi
  echo "⏳ Vault not ready yet... retry $retry/$MAX_RETRIES"
  sleep "$SLEEP_TIME"
done

echo "✅ Vault is UP!"
echo ""

# Apply the terraform IaC 
cd ./terraform
terraform apply -auto-approve -var-file="terraform.tfvars"

# Get the role_id and secret_id from terraform output
VAULT_ROLE_ID=$(terraform output -raw role_id)
VAULT_SECRET_ID=$(terraform output -raw secret_id)

# Export the role_id and secret_id as environment variables
export VAULT_ROLE_ID
export VAULT_SECRET_ID

echo "VAULT_ROLE_ID: $VAULT_ROLE_ID"
echo "VAULT_SECRET_ID: $VAULT_SECRET_ID"

cd ..

echo ">>> Starting App ..."
docker-compose -f ./docker-compose.yml up -d $(docker-compose config --services | grep -v vault)

echo ">>> App started successfully."
echo "============================================================="
echo ">>> You can access the app at http://localhost:8080"
echo ">>> You can access the database at http://localhost:5432"
echo ">>> You can access the vault at http://localhost:8200"
echo "============================================================="

echo ">>> Test some APIs with curl commands"
echo ""
echo ">>> Test the app: curl http://localhost:8080/actuator/health"
echo ">>> Test the database: curl http://localhost:5432/actuator/health"
echo ">>> Test the vault: curl http://localhost:8200/v1/sys/health"
echo ""

chmod +x test.sh
./test.sh