# Step 1: Configuration

In this step, we configure Vault to work with our application. This includes:

1.  Enabling the **AppRole** authentication method.
2.  Creating a **Policy** that allows reading database secrets.
3.  Configuring the **Database Secret Engine** (MySQL).
4.  Creating a **Role** that maps the policy to the application.

## How it works

We use **Terraform** to apply this configuration automatically. Terraform spins up as a Docker container, talks to Vault, applies the `.tf` files, and then exits.

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
