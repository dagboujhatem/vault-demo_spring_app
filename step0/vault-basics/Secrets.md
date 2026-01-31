# Vault Secrets Engines

Secrets engines are components within Vault that store, generate, or encrypt data. They are flexible and can handle static secrets, dynamic secrets, or encryption services.

## Static Secrets: Key-Value (KV)

The KV secrets engine is used to store arbitrary secrets within the configured physical storage for Vault.

-   **Version 1**: Simple key-value storage.
-   **Version 2**: Supports versioning of secrets, allowing you to roll back to previous versions or recover deleted secrets.

Example path: `secret/data/webapp/config`

### Secret v1 vs Secret v2

KV (Key-Value) secrets engine comes in two versions:



**Important:** KV (v1 or v2) is only for static secrets, not dynamic credentials.

## Dynamic Secrets

Dynamic secrets are generated on-demand and have a limited lifetime. This is one of Vault's most powerful features.

-   **Database**: Vault can generate temporary credentials for databases (SQL, NoSQL). When an application needs to connect, it asks Vault for credentials, and Vault creates a new user with specific permissions.
-   **Cloud**: Generate temporary IAM access keys or tokens for AWS, GCP, and Azure.
-   **PKI**: Generate X.509 certificates on the fly.


![Vault Dynamic Secrets](../../screenshots/6-secret-as-service.png)


### Benefits of Dynamic Secrets
-   **No Shared Credentials**: Every client gets unique credentials.
-   **Automatic Revocation**: Credentials automatically expire (lease expires) or can be revoked immediately if a breach is detected.
-   **Auditability**: Every generated secret is tied to a specific lease and can be tracked.

## Secret Lifecycle

1.  **Lease**: Every secret returned by Vault has a lease associated with it.
2.  **TTL (Time-To-Live)**: The duration for which the secret is valid.
3.  **Renewal**: Some leases can be renewed before they expire to extend their lifetime.
4.  **Revocation**: Once a lease expires (or is explicitly revoked), Vault will automatically delete the credential from the target system (e.g., dropping the database user).


## Bests Practices

- Use **KV v2** for static secrets.
- Use **Dynamic Secrets** for dynamic secrets.
- Use **Token** for manual users in simple environments.
- Use **Userpass** for manual users in simple environments.

For example, in this demo, we will use **KV v2** for static secrets and **Dynamic Secrets** for dynamic secrets.

## References

- [Vault Secrets Engines](https://developer.hashicorp.com/vault/docs/secrets)
- [Vault Secrets Version](https://developer.hashicorp.com/vault/docs/secrets/kv)
