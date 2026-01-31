# Step 1: Configuration

In this step, we configure Vault to work with our application. This includes:

1.  Enabling the **AppRole** authentication method.
2.  Creating a **Policy** that allows reading database secrets.
3.  Configuring the **Database Secret Engine** (Postgres).
4.  Creating a **Role** that maps the policy to the application.

## How it works

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
terraform output -raw approle_role_id
terraform output -raw approle_secret_id

# Terraform destroy 
terraform destroy -auto-approve
# OR
terraform destroy -auto-approve -var-file="terraform.tfvars"
```
For more information, see the [Terraform documentation](https://www.terraform.io/docs/index.html).

## Run it

Run the following command to wait for Terraform to complete the configuration:

```bash
./run.sh
```

This script waits until the Terraform container successfully exits.

## Access pgadmin: 

You can access pgadmin from your browser using the following credentials:

- **Email**: [PGADMIN_DEFAULT_EMAIL]
- **Password**: [PGADMIN_DEFAULT_PASSWORD]

and access pgadmin using this URL : 

[http://localhost:5050/browser/](http://localhost:5050/browser/)

## Next Step

Once configured, we need to get the credentials (RoleID and SecretID) to login. Go to [Step 2](../step2/README.md).
