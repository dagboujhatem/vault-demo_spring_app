# Vault Authentication Methods

Authentication in HashiCorp Vault is the process by which users or machines provide their identity. Vault supports multiple authentication methods to cater to different environments and use cases.

## How it Works

1.  **Selection**: A user or application selects an authentication method (e.g., GitHub, AppRole, Kubernetes).
2.  **Login**: The client provides credentials to Vault through that method.
3.  **Verification**: Vault verifies the credentials with the backend (e.g., checking GitHub team membership).
4.  **Token Issuance**: If successful, Vault issues a **Token** associated with specific **Policies**.

## Common Authentication Methods

-   **Token**: The core authentication method. Every other method ultimately results in a token. Tokens can be created directly by administrators or automated systems.
-   **Userpass**: Username and password based authentication, managed directly within Vault. Useful for manual users in simple environments.
-   **AppRole**: Designed for machine-to-machine authentication. Applications use a RoleID and SecretID (similar to username/password) to get a token.
-   **GitHub**: Allows users to authenticate using their GitHub credentials. Policies can be mapped to GitHub teams or organizations.
-   **Kubernetes**: Allows applications running in Kubernetes pods to authenticate using their service account tokens.
-   **Cloud-specific (AWS, GCP, Azure)**: Uses cloud identity services (e.g., IAM roles) to authenticate instances and services.

## Important Concepts

-   **Mounting**: Auth methods must be "enabled" or "mounted" at a specific path (e.g., `auth/github/`).
-   **Entities and Groups**: Vault uses an Identity Store (Identity Secrets Engine) to map multiple auth methods to a single unique identifier (Entity), allowing unified policy management.
-   **Lease and TTL**: Every token has a Time-To-Live (TTL). When it expires, the token is no longer valid unless renewed.
