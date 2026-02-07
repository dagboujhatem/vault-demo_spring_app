# Lire uniquement les credentials PostgreSQL (dynamic secrets)
path "database/creds/${app_name}" {
  capabilities = ["read", "list"]
}