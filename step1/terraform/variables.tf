# Application name
variable "app_name" {
  default     = "AP00001"
  description = "Application name"
}

# Vault Address
variable "vault_address" {
  default     = "http://localhost:8200"
  description = "Vault address"
}

# Vault Token
variable "vault_token" {
  type      = string
  default   = "root"
  sensitive = true
}

# Vault Policy Path
variable "policy_path" {
  default     = "policies/web.hcl"
  description = "Path to the policy file"
}


# Database credentials
variable "database_username" {
  type      = string
  default   = "root"
  sensitive = true
}

variable "database_password" {
  type      = string
  default   = "root"
  sensitive = true
}