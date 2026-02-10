# 1. Enable database secrets engine
resource "vault_mount" "db" {
  type = "database"
  path = "database"
}

# 2. Create a database connection
# Vault needs one privileged DB account (only used internally).
resource "vault_database_secret_backend_connection" "elasticsearch" {
  backend       = vault_mount.db.path
  name          = "elasticsearch"
  allowed_roles = [var.app_name]
  elasticsearch {
    url      = "https://${var.elasticsearch_host}:${var.elasticsearch_port}"
    username = var.elasticsearch_username
    password = var.elasticsearch_password
  }
}

# 3. Create a database role
# resource "vault_database_secret_backend_role" "role" {
#   backend = vault_mount.db.path
#   name    = var.app_name
#   db_name = vault_database_secret_backend_connection.postgres.name

#   creation_statements = [
#     <<EOF
# CREATE ROLE "{{name}}" WITH
#   LOGIN
#   PASSWORD '{{password}}'
#   VALID UNTIL '{{expiration}}';

# GRANT CONNECT ON DATABASE ${var.postgres_db} TO "{{name}}";
# GRANT USAGE ON SCHEMA public TO "{{name}}";
# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "{{name}}";
# ALTER DEFAULT PRIVILEGES IN SCHEMA public
# GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "{{name}}";
# EOF
#   ]

#   revocation_statements = [
#     "DROP ROLE IF EXISTS \"{{name}}\";"
#   ]

#   default_ttl = var.db_secret_ttl
#   max_ttl     = var.token_max_ttl
# }
