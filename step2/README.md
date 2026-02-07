# Step 2: Spring load configuration from Vault (Dynamic Secrets)

This step use Hashicorp Vault dynamic secrets with database. This includes:

1.  Enabling the **AppRole** authentication method.
2.  Creating a **Policy** that allows reading database secrets.
3.  Configuring the **Database Dynamic Secrets Engine** (Postgres).
4.  Creating a **Role** that maps the policy to the application.
5.  Configuring the **Spring Boot** application to use Vault:
    - Use the AppRole authentication method.
    - Use the static secrets (RoleID and SecretID) to login to Vault.
    - Use the database secret engine to get the database credentials (static secrets).

![Spring Vault Dynamic Secrets](screenshots/spring-vault.png)

## How it works

To login to Vault using AppRole authentication method, we need to create a role and provide the RoleID and SecretID to the application. In this step, we will use static secrets (RoleID and SecretID) to login to Vault. 

In the following schema, the Vault admin can create the role and policy, and the application can use the **RoleID** and **SecretID** to login to Vault. Vault returns a token to the application, and the application can use the token to get the database credentials.

![Spring Vault AppRole](screenshots/vault-approle-workflow.avif)


After getting the **token**, the application can send the token to the Vault to get the database credentials from the **dynamic secret engine**.

![Spring Vault Dynamic Secrets](screenshots/spring-vault-dynamic-secrets.png)



### Option 1: without Spring profiles (simple configuration)

In this case, we will have **only one path** to read the secrets from Vault. 

**Example :** if you have this path `secrets/data/AP0001/database`, you can use the following config :

```yaml
spring:
  cloud:
    vault:
      kv:
        backend: secrets
        application-name: AP0001/database
        default-context: ""
 ````

 You can use it simply like this : 

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/test?:5432/${POSTGRES_DB:test}
    username: ${username}
    password: ${password}
```

if you have this database config in vault : 

```json
{
    "username": "user",
    "password": "password"
}
```
### Option 2: use Spring profiles (best practice)



### Debug Spring Cloud Vault communication & variables injection :

to see the secrets loaded by vault, you can use the following URL (only for dev environment): 

```bash
# To see the env variables (injected by Spring Cloud Vault)
http://localhost:8080/actuator/env
# OR (NOTE: values are masked as ***)
http://localhost:8080/actuator/configprops

# Additional configuration to see the secrets loaded by vault
# Actuator endpoints
http://localhost:8080/actuator
# Actuator health 
http://localhost:8080/actuator/health
```

To activate the debug mode, you can add the following property : 

```yaml
# Activate log TRACE
logging:
  level:
    org.springframework.web.client: TRACE
```

or the following environment variable (in K8S): 

```yaml
# Activate log TRACE in K8S environment
env:
  - name: LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_WEB_CLIENT
    value: TRACE
```

## Infrastructure as Code (IaC) with Terraform

We use **Terraform** to apply this configuration automatically. Terraform spins up as a Docker container, talks to Vault, applies the `.tf` files, and then exits.

Terraform will output the role_id and secret_id that we need to use in our application. We will use these values in the next step.

We will use the following commands to apply the configuration and extract the role_id and secret_id if you need to do it manually:

```bash
# Terraform extract role_id and secret_id from terraform output
terraform output -raw role_id
terraform output -raw secret_id
```

For more information, see the [IaC Terraform Vault](./terraform/README.md).

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

Let's verify that we have the credentials. Go to [Step 3](../step3/README.md).
