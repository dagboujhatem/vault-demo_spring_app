variable "policy_path" {
  description = "The path of the template policy"
}

# OPTIONS
variable "secret_id_num_uses" {
  default     = 0
  description = "The number of secret-id usage"
}

variable "secret_id_ttl" {
  default     = 600
  description = "TTL is like equal to 10 minutes"
}

variable "token_num_uses" {
  default     = 0
  description = "The number of token usage"
}

variable "token_ttl" {
  default     = 60
  description = "TTL is like equal to 1 minute"
}

variable "token_max_ttl" {
  default     = 600
  description = "Max TTL is like equal to 10 minute"
}

# KV V1

# KV V2
variable "app_codes" {
  type = list(string)
  description = "List of application codes, e.g., [AP0001, AP0002]"
}

variable "envs" {
  type = list(string)
  description = "List of environments, e.g., [dev, int, qua, pprod, prod]"
}

variable "username" {
  type        = string
  default     = "user"
  description = "Username for the secret"
}

variable "password" {
  type        = string  
  default     = "password"
  description = "Password for the secret"
}

variable "secret_name" {
  type        = string
  default     = "database-secret-v2"
  description = "Name of the secret"
}
