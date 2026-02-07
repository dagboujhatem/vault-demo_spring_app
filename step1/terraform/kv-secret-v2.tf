# 1. Enable the KV v2 secret engine mount
resource "vault_mount" "kvv2" {
  path        = "secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

# 2. Create a KV v2 secret
resource "vault_kv_secret_v2" "database_creds" {
  mount = vault_mount.kvv2.path
  name  = "${var.app_name}/database/creds"
  data_json = jsonencode({
    username = var.database_username
    password = var.database_password
  })
}