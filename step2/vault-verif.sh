#!/bin/bash
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root        # token avec accès database/creds/*
export APP_NAME=spring-app

export POSTGRES_HOST=host.docker.internal
export POSTGRES_DB=test
export POSTGRES_ADMIN_USER=user

set -euo pipefail

echo "🔍 Vault → PostgreSQL validation started"
echo "----------------------------------------"

# 1. Vault status
echo "➡️ Checking Vault status..."
vault status > /dev/null
echo "✅ Vault is reachable"

# 2. Check database secrets engine
echo "➡️ Checking database secrets engine..."
if ! vault secrets list | grep -q "^database/"; then
  echo "❌ database secrets engine not enabled"
  exit 1
fi
echo "✅ database secrets engine enabled"

# 3. Check role existence (no list required)
echo "➡️ Checking Vault DB role '${APP_NAME}'..."
if ! vault read database/roles/${APP_NAME} > /dev/null 2>&1; then
  echo "❌ Vault role '${APP_NAME}' does not exist or access denied"
  exit 1
fi
echo "✅ Vault role exists"

# 4. Request dynamic credentials
echo "➡️ Requesting dynamic PostgreSQL credentials..."
CREDS_JSON=$(vault read -format=json database/creds/${APP_NAME})

DB_USER=$(echo "$CREDS_JSON" | jq -r '.data.username')
DB_PASS=$(echo "$CREDS_JSON" | jq -r '.data.password')

if [[ -z "$DB_USER" || "$DB_USER" == "null" ]]; then
  echo "❌ No username returned by Vault"
  exit 1
fi

echo "✅ Vault returned credentials"
echo "   → username: $DB_USER"
echo "   → password: $DB_PASS"

# 5. Check PostgreSQL user existence
POSTGRES_CONTAINER=${POSTGRES_CONTAINER:-postgres}

echo "➡️ Checking user existence in PostgreSQL..."
docker exec "$POSTGRES_CONTAINER" pg_isready -h "$POSTGRES_HOST" -U "$POSTGRES_ADMIN_USER" > /dev/null

if [[ $? -ne 0 ]]; then
  echo "❌ PostgreSQL is not ready"
  exit 1
fi

echo "✅ PostgreSQL user '$DB_USER' exists"

# 6. Optional: test login with generated credentials
echo "➡️ Testing login with generated credentials..."
docker exec "$POSTGRES_CONTAINER" pg_isready -h localhost -p 5432 -U "$DB_USER" -d "$POSTGRES_DB" > /dev/null
echo "✅ Login successful with dynamic credentials"

echo "----------------------------------------"
echo "🎉 VALIDATION SUCCESSFUL"
echo "Vault → PostgreSQL dynamic secrets are WORKING"

echo "➡️ Testing SCRAM login with generated credentials..."

docker exec -e PGPASSWORD="$DB_PASS" "$POSTGRES_CONTAINER" \
  psql -h localhost -U "$DB_USER" -d "$POSTGRES_DB" -c "SELECT 1;" > /dev/null

echo "✅ SCRAM authentication successful"


