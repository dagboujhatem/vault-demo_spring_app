# Step 1: Spring load configuration from Vault (Static Secrets)

In this step, we configure Vault to work with our application. This includes:

1.  Enabling the **AppRole** authentication method.
2.  Creating a **Policy** that allows reading database secrets.
3.  Configuring the **Database Secret Engine** (Postgres).
4.  Creating a **Role** that maps the policy to the application.
5.  Configuring the **Spring Boot** application to use Vault:
    - Use the AppRole authentication method.
    - Use the static secrets (RoleID and SecretID) to login to Vault.
    - Use the database secret engine to get the database credentials (static secrets).

![Spring Vault Static Secrets](screenshots/spring-vault.png)

## How it works

To login to Vault using AppRole authentication method, we need to create a role and provide the RoleID and SecretID to the application. In this step, we will use static secrets (RoleID and SecretID) to login to Vault. 

In the following schema, the Vault admin can create the role and policy, and the application can use the **RoleID** and **SecretID** to login to Vault. Vault returns a token to the application, and the application can use the token to get the database credentials.

![Spring Vault AppRole](screenshots/vault-approle-workflow.avif)


After getting the **token**, the application can send the token to the Vault to get the database credentials from the **static secret engine**.

![Spring Vault Static Secrets](screenshots/spring-vault-static-secrets.png)

## Infrastructure as Code (IaC) with Terraform

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

## Run it

Run the following command to start everything:

```bash
# Run application & tests
./run.sh 
# Or run only the application
docker-compose -f ./docker-compose.yml up -d
```

If you need to rebuild the Spring app (e.g., after a code change), use:

```bash
docker-compose up -d --build --force-recreate
```

## Check it

You can verify that the containers are running:

```bash
docker ps
```

You should see `spring-app`, `postgres`, and `vault` containers up and running.

After running, you can test the application using this command 

```bash
# Run only the application test
./test.sh
```

This script waits until the Terraform container successfully exits.

## Access pgadmin: 

You can access pgadmin from your browser using the following credentials:

- **Email**: [PGADMIN_DEFAULT_EMAIL]
- **Password**: [PGADMIN_DEFAULT_PASSWORD]

and access pgadmin using this URL : 

[http://localhost:5050/browser/](http://localhost:5050/browser/)

## Cleanup

Do the following commands:

```bash
$ docker-compose down
$ rm terraform/terraform.tfstate
```

## Next Step

Once configured, we need to get the credentials (RoleID and SecretID) to login. Go to [Step 2](../step2/README.md).
