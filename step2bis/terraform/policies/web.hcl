# Lire uniquement les credentials Elasticsearch (dynamic secrets)
path "database/creds/${app_name}" {
  capabilities = ["read", "list"]
}