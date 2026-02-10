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

#  Elasticsearch DB
variable "elasticsearch_username" {
  default     = "user"
  description = "Database username"
}

variable "elasticsearch_password" {
  default     = "password"
  description = "Database password"
}

variable "elasticsearch_db" {
  default     = "test"
  description = "Database name"
}

variable "elasticsearch_host" {
  default     = "localhost"
  description = "Database host"
}

variable "elasticsearch_port" {
  default     = 5432
  description = "Database port"
}


# Vault Token Max TTL (in seconds : 86400 = 1 day) 
variable "token_max_ttl" {
  default     = 86400
  description = "Max TTL is like equal to 1 day"
}

# Vault Token Min TTL (in seconds : 3600 = 1 hour) 
variable "db_secret_ttl" {
  default     = 3600
  description = "Min TTL is like equal to 1 hour"
}
