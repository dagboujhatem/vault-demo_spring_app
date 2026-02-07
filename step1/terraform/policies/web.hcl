# Lire uniquement les credentials PostgreSQL (static secrets)
path "secrets/data/${app_name}/*" {
  capabilities = ["read", "list"]
}

path "secrets/metadata/${app_name}/*" {
  capabilities = ["read", "list"]
}
