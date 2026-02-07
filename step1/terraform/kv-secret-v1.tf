# 1. Enable the KV v1 secret engine mount
resource "vault_mount" "kvv1" {
  path        = "secrets-v1"
  type        = "kv"
  options     = { version = "1" }
  description = "KV Version 1 secret engine mount"
}

# 2. Create a KV v1 secret
resource "vault_kv_secret" "database_creds" {
  path = "${vault_mount.kvv1.path}/database/creds"
  data_json = jsonencode({
    username = var.database_username
    password = var.database_password
  })
}