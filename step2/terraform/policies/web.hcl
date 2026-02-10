# Lire uniquement les credentials PostgreSQL (dynamic secrets)
path "database/creds/${app_name}" {
  capabilities = ["read", "list"]
}

# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}