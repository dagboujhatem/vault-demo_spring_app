#  Only the Auth method here in main 

# 1. Enable the AppRole authentication method
resource "vault_auth_backend" "approle" {
  type = "approle"
}


# 2. Create a role for the application
resource "vault_approle_auth_backend_role" "web_app" {
  backend          = vault_auth_backend.approle.path
  role_name        = var.app_name
  token_policies   = [vault_policy.web_policies.name]
  token_ttl        = 20
  token_max_ttl    = 60
  token_no_default_policy = true
  token_type       = "service"
}

# 3. The pipeline should generate this one
resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.web_app.role_name
}

# 4. Output the Role ID and Secret ID
# see output.tf

