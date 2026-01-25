# Step 4: Run Application

In this final step, we run the Spring Boot application and see Vault in action!

## What happens ?

1.  **Authentication**: The application uses the `ROLE_ID` and `SECRET_ID` (from the `.secrets` file) to authenticate with Vault.
2.  **Secret Retrieval**: Once authenticated, the Spring Cloud Vault connector automatically fetches temporary database credentials from the Vault Database Secret Engine.
3.  **Connection**: The application connects to MySQL using these dynamic credentials.

## Run it

Run the following command to start the application:

```bash
./run.sh
```

## Check it

Once the application is started, you can verify that it is working by accessing the endpoints (e.g., via `curl` or a browser if you have a web controller).

## Conclusion

Congratulations! You have successfully migrated an application from hardcoded secrets to dynamic, managed secrets using HashiCorp Vault.

### Benefits:
- **No secrets in code**: Even the AppRole credentials are provided via the environment.
- **Dynamic credentials**: The database password used by the app is temporary and managed by Vault.
- **Auditability**: Every secret access is logged in Vault.
