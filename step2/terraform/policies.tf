# 1. Create Vault Policy Template
data "template_file" "web_policies" {
  template = file(var.policy_path)
  vars = {
    app_name = var.app_name
  }
}

# 2. Create Vault Policy
resource "vault_policy" "web_policies" {
  name = var.app_name
  policy = data.template_file.web_policies.rendered
}