# Lire uniquement les credentials PostgreSQL (static secrets)
path "secret/data/${app_name}/*" {
  capabilities = ["read", "list"]
}

path "secret/metadata/${app_name}/*" {
  capabilities = ["read", "list"]
}
