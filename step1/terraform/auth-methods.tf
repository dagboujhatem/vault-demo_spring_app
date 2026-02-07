# 1.  Kubernetes Auth Method
#  step 1 : Enable Kubernetes Auth Method
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

# step 2 : Configure Kubernetes Auth Method (minikube)
# Important pour Minikube: Vault DOIT tourner dans Kubernetes (Pod) pour utiliser ces paths.
resource "vault_kubernetes_auth_backend_config" "this" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default.svc"
  # CA de Minikube (OK depuis macOS)
  kubernetes_ca_cert = file("~/.minikube/ca.crt")
}

# step 3 : Create a Kubernetes Role
resource "vault_kubernetes_auth_backend_role" "this" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "minikube-role"
  bound_service_account_names      = ["sa-tier-a"]
  bound_service_account_namespaces = ["default"]
  token_policies                   = ["default", var.app_name]
  token_ttl                        = 3600
  token_max_ttl                    = 7200
}

# 2.  TLS Certificate Auth Method

# 3. Userpass Auth Method

# 4. GitHub Auth Method

# 5. JWT Auth Method

# 6. OIDC Auth Method

# 7. AWS Auth Method

# 8. Azure Auth Method

# 9. GCP Auth Method

# 10. AliCloud Auth Method

# 11. LDAP Auth Method

# 12. Okta Auth Method

# 13. Radius Auth Method