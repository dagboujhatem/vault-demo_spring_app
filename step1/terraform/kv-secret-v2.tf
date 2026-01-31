resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

# Generate a map of all app/env combinations
locals {
  app_env_combinations = flatten([
    for app in var.app_codes : [
      for env in var.envs : {
        app_code = app
        env      = env
      }
    ]
  ])
}

# Create a secret for each combination
resource "vault_kv_secret_v2" "app_secret" {
  for_each = { for combo in local.app_env_combinations : "${combo.app_code}-${combo.env}" => combo }

  mount = vault_mount.kvv2.path
  name  = "${each.value.app_code}/${each.value.env}/${var.secret_name}"

  cas   = 1
  delete_all_versions = true

  data_json = jsonencode({
    username = var.username
    password = var.password
  })
}