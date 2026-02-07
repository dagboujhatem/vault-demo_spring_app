#!/bin/bash
set -e
# Navigate to step directory
cd "$(dirname "$0")"
cd ./terraform
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
#docker-compose -f ./docker-compose.yml up -d

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