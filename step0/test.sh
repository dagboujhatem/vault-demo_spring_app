echo ">>> Waiting for Spring Boot application to be UP (Actuator)..."


APP_URL="http://localhost:8080"
ACTUATOR_URL="$APP_URL/actuator/health"
VAULT_URL="http://localhost:8200/v1/sys/health"
MAX_RETRIES=10
SLEEP_TIME=5

# --------------------------------------------------
# Wait for Spring Boot application to be UP
# --------------------------------------------------
retry=0
until curl -s "$ACTUATOR_URL" | grep -q '"status":"UP"'; do
  retry=$((retry + 1))
  if [ "$retry" -ge "$MAX_RETRIES" ]; then
    echo "❌ Application did not become ready in time"
    exit 1
  fi
  echo "⏳ App not ready yet... retry $retry/$MAX_RETRIES"
  sleep "$SLEEP_TIME"
done

echo "✅ Application is UP!"
echo ""

# --------------------------------------------------
# Actuator checks
# --------------------------------------------------
echo ">>> Test Actuator health"
curl -s "$ACTUATOR_URL" | jq .
echo ""

echo ">>> Test Database health via Actuator"
curl -s "$APP_URL/actuator/health/db" | jq .
echo ""

echo ">>> Test Vault health"
curl -s "$VAULT_URL" | jq .
echo ""
echo "✅ All containers are UP! (Spring Boot, Postgres, Vault)"
echo ""
# --------------------------------------------------
# API TESTS
# --------------------------------------------------
echo ">>> Test API: create user"
CREATE_RESPONSE=$(curl -s -X POST "$APP_URL/api/v1/users" \
  -H "Content-Type: application/json" \
  -d '{"username":"John Doe","email":"john.doe@example.com","password":"123456"}')

echo "$CREATE_RESPONSE" | jq .
USER_ID=$(echo "$CREATE_RESPONSE" | jq -r '.id')
echo "🆔 Created user ID: $USER_ID"
echo ""

echo ">>> Test API: get all users"
curl -s "$APP_URL/api/v1/users" | jq .
echo ""

echo ">>> Test API: get user by id"
curl -s "$APP_URL/api/v1/users/$USER_ID" | jq .
echo ""

echo ">>> Test API: update user by id"
curl -s -X PUT "$APP_URL/api/v1/users/$USER_ID" \
  -H "Content-Type: application/json" \
  -d '{"username":"Hatem DAGHBOUJ","email":"dagboujhatem@gmail.com"}' | jq .
echo ""

echo ">>> Test API: get updated user"
curl -s "$APP_URL/api/v1/users/$USER_ID" | jq .
echo ""

echo ">>> Test API: delete user by id"
curl -s -X DELETE "$APP_URL/api/v1/users/$USER_ID"
echo "✅ User deleted"
echo ""

# --------------------------------------------------
# NEGATIVE TESTS
# --------------------------------------------------
echo ">>> Test API: get deleted user (should fail)"
curl -s -i "$APP_URL/api/v1/users/$USER_ID"
echo ""

echo ">>> Test API: create user with invalid payload (should fail)"
curl -s -i -X POST "$APP_URL/api/v1/users" \
  -H "Content-Type: application/json" \
  -d '{"username":""}'
echo ""

echo "============================================================="
echo "✅ All tests executed"
echo "============================================================="
