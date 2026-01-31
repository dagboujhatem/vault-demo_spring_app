path "secret/data/${entity_name}/*" {
  capabilities = ["read", "list"]
} 

path "secret/metadata/${entity_name}/*" {
  capabilities = ["read", "list"]
}