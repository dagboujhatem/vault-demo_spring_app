
# Terraform IaC

## Created Resources :

- **Vault AppRole Auth Backend Role**: This resource defines a role in Vault to authenticate applications via AppRole.
- **Vault AppRole Policies**: Policies associated with the AppRole to define the permissions for accessing secrets.
- **Vault Secrets Engine**: A secrets engine mounted in Vault to manage and store secrets.
- **Vault Key-Value Pairs**: Key-value secrets stored in the secrets engine.


## Infrastructure as Code (IaC) with Terraform (basic commands)

We use **Terraform** to apply this configuration automatically. Terraform spins up as a Docker container, talks to Vault, applies the `.tf` files, and then exits.

Terraform will output the role_id and secret_id that we need to use in our application. We will use these values in the next step.

We will use the following commands to apply the configuration and extract the role_id and secret_id if you need to do it manually:

```bash
# Terraform version
terraform version

# Terraform init
terraform init

# Terraform fmt
terraform fmt

# Terraform validate
terraform validate

# Terraform plan
terraform plan
# OR
terraform plan -var-file="terraform.tfvars"

# Terraform apply
terraform apply -auto-approve
# OR
terraform apply -auto-approve -var-file="terraform.tfvars"

# Terraform extract role_id and secret_id from terraform output
terraform output -raw role_id
terraform output -raw secret_id

# Terraform destroy 
terraform destroy -auto-approve
# OR
terraform destroy -auto-approve -var-file="terraform.tfvars"

# Terraform State rm (role "role-web" does not exist)
terraform state rm vault_approle_auth_backend_role_secret_id.id
```
For more information, see the [Terraform documentation](https://www.terraform.io/docs/index.html).



