resource "vault_auth_backend" "approle" {
  type = "approle"
}

# Render Policies per App (for_each)
data "template_file" "web_policies" {
   for_each = toset(var.app_codes)

  template = file(var.policy_path)

  vars = {
    entity_name = each.key
  }
}

# Create Vault Policies per App
resource "vault_policy" "web_policies" { 
  for_each = toset(var.app_codes)
  name   = each.key
  policy = data.template_file.web_policies[each.key].rendered
}

# Create AppRoles per App Code
resource "vault_approle_auth_backend_role" "project_role" { 
  for_each = toset(var.app_codes)
  backend            = vault_auth_backend.approle.path
  role_name          = "role-${each.key}"
  secret_id_num_uses = var.secret_id_num_uses
  secret_id_ttl      = var.secret_id_ttl
  token_num_uses     = var.token_num_uses
  token_ttl          = var.token_ttl
  token_max_ttl      = var.token_max_ttl
  token_policies     = ["default", each.key]
}

# The pipeline should generate this one
resource "vault_approle_auth_backend_role_secret_id" "id" {
  for_each = toset(var.app_codes)
  backend   = vault_auth_backend.approle.path
  role_name = each.key
}

output "approle_secret_ids" {
  description = "AppRole Secret IDs per application"
  value = {
    for app, secret in vault_approle_auth_backend_role_secret_id.id :
    app => secret.secret_id
  }
  sensitive = false
} 