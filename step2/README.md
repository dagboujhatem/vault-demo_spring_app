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

### Step-by-Step Breakdown of the Dynamic Secret Retrieval Process

**Step 1: Configure Vault Server**

- Set up the **Vault Server**:
    - Install and initialize HashiCorp Vault.
    - Store the initial root token securely.
    - Enable HTTPS or setup Vault for development mode (not recommended for production).

---

**Step 2: Enable Authentication and Secrets Engines**

- **Enable AppRole Authentication**:
    - Use the following commands to enable AppRole authentication on Vault:

      ```bash
      vault auth enable approle
      ```

- **Enable the Database Secrets Engine**:
    - Configure the database secrets backend (example for PostgreSQL):

      ```bash
      vault secrets enable database
      vault write database/config/my-database \
        plugin_name=postgresql-database-plugin \
        allowed_roles="my-role" \
        connection_url="postgresql://{{username}}:{{password}}@db-host:5432/mydb?sslmode=disable" \
        username="db-admin" \
        password="secure-password"
      ```

---

**Step 3: Create Policies and Roles**

1. **Create Vault Policies**:
    - Define a policy that allows the application to access the database credentials.

    ```hcl
    path "database/creds/my-role" {
      capabilities = ["read"]
    }
    ```

   Apply the policy:

    ```bash
    vault policy write my-policy my-policy.hcl
    ```

2. **Create AppRole Role**:
    - Map the policy to an AppRole:

    ```bash
    vault write auth/approle/role/my-role \
      policies="my-policy" \
      token_ttl=1h \
      token_max_ttl=4h
    ```

   Fetch the RoleID and SecretID:

    ```bash
    vault read auth/approle/role/my-role/role-id
    vault write -f auth/approle/role/my-role/secret-id
    ```

---

**Step 4: Application Obtains a Vault Token**

- The Spring Boot application starts by authenticating to Vault using **AppRole authentication**.
    - The application provides the `RoleID` and `SecretID` to Vault.
    - Vault verifies these static credentials and generates a **token** for the application.
    - This token has a limited Time-To-Live (TTL) and is used for further communication with Vault.

**Step 5: Application Uses the Vault Token to Request Database Credentials**

- After obtaining the token, the application uses this token to make a request to the Vault server.
- Vault dynamically creates **database credentials** (username and password) for the application by connecting to the
  database via the **Database Secrets Engine**.
- The credentials generated:
    - Have their own specified **lease duration** (TTL).
    - Can only be used by the application within their lease period.

**Step 6: Vault Sends Database Credentials to the Application**

- Vault sends back the **dynamically generated credentials** (e.g., username and password) to the application along with
  additional lease information:
    - **Lease TTL**: The amount of time the credentials are valid.
    - **Renewable Status**: Indicates whether the application can renew the lease if needed before it expires.

The application configures its database connection (e.g., JDBC) with these credentials.

---

### Vault’s Role in Managing Lease, TTL, and Renewability

1. **Lease Management**:
    - Vault ensures that the generated credentials are **temporary** and valid only for the defined lease period.
    - Vault stores metadata about these credentials (e.g., TTL, database policy, generated credentials) and monitors
      their leases.

2. **Time-To-Live (TTL)**:
    - Vault assigns a specific TTL to the generated credentials.
    - After this TTL period, the credentials are automatically invalidated in the database.

3. **Renewable Leases**:
    - If enabled, the Vault token or dynamic credentials can be renewed before they expire.
    - **Renewal Process**:
        - The application sends a renewal request to Vault with the token or lease ID.
        - Vault verifies the lease and extends its validity if allowed by the policy.

4. **Automatic Revocation**:
    - When the lease TTL expires or if an application revokes a lease prematurely, Vault automatically invalidates the
      credentials.
    - This ensures enhanced security by preventing unused or stale credentials from being active.

---

### Summary:

- **Step 4**: The application authenticates using AppRole and gets a token.
- **Step 5**: The token is used to request dynamic database credentials.
- **Step 6**: Vault generates and returns credentials with lease and TTL information.
- Vault manages the lifecycle of these credentials using the lease, TTL, and revocation mechanisms while providing
  renewability options for dynamic secrets where needed.

---

## Implementation in Spring 

### Available Options:

1. **Option 1: without Spring profiles (simple configuration)**  
   In this option, a single path (single environment) is used to access secrets in Vault.

2. **Option 2: use Spring profiles (best practice)**  
   This option allows managing multiple environments (dev, test, prod) by accessing different paths in Vault when we need to change the environment.

We have a total of **2 options** available for loading secrets from Vault.

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

In this option, Spring profiles enable using multiple paths in Vault for managing secrets across multiple environments (
e.g., dev, test, prod). By combining Spring profiles with Vault paths, you can seamlessly switch between environments
without modifying core configurations.

#### Example:

If you have the following Vault path structure:

- **Dev environment**: `secrets/data/dev/AP0001/database`
- **Test environment**: `secrets/data/test/AP0001/database`
- **Prod environment**: `secrets/data/prod/AP0001/database`

You can use Spring profiles to load these paths dynamically based on the environment.

#### Configuration Example:

1. **Base Configuration (application.yaml):**

```yaml
spring:
  cloud:
    vault:
      kv:
        backend: secrets
        application-name: AP0001/database
      default-context: ""
```

2. **Dev Profile (application-dev.yaml):**

```yaml
spring:
  cloud:
    vault:
      kv:
        profile-separator: "/"
        profiles: dev
```

3. **Test Profile (application-test.yaml):**

```yaml
spring:
  cloud:
    vault:
      kv:
        profile-separator: "/"
        profiles: test
```

4. **Prod Profile (application-prod.yaml):**

```yaml
spring:
  cloud:
    vault:
      kv:
        profile-separator: "/"
        profiles: prod
```

#### Important Notes:

- By configuring profiles as shown, Spring will load secrets from Vault paths like
  `secrets/data/<profile>/AP0001/database`, where `<profile>` corresponds to the active Spring profile (e.g., `dev`,
  `test`, `prod`).
- The active profile can be set with the `spring.profiles.active` property, such as using the following in the
  `application.properties` file or environment variables:

```properties
spring.profiles.active=dev
```

Alternatively, you can pass this as a JVM argument:

```bash
-Dspring.profiles.active=prod
```

With this setup, switching environments is as simple as setting the appropriate profile, and Vault dynamically loads the
corresponding secrets.

#### Debugging and Validation

To troubleshoot or validate if Vault secrets load correctly, you can enable logging and check the values injected by
Spring Cloud Vault:

1. **Activate Debug Logging:**

```yaml
logging:
  level:
    org.springframework.cloud.vault: TRACE
```

2. **Verify Injected Secrets via Actuator:**

Access the Spring Actuator endpoints:

- **Environment Variables (Secrets):** `http://localhost:8080/actuator/env`
- **Configuration Properties:** `http://localhost:8080/actuator/configprops`

These endpoints will show the secrets retrieved from Vault (values masked as `***` for security).

This approach allows for a scalable and more secure configuration management workflow while supporting multiple
environments.

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

## References:

- [Youtube tutorial - Postgres DB credentials rotation using Spring Cloud Vault](https://www.youtube.com/watch?v=qyBHFVPghFE)
- [Github - source code](https://github.com/visa2learn/spring-cloud-vault-db-cred-rotation)

## Next Step

Let's verify that we have the credentials. Go to [Step 3](../step3/README.md).
