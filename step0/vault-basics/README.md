# Vault Basics

This directory contains documentation on the fundamental concepts of HashiCorp Vault. Understanding these three pillars is essential for managing secrets and access control effectively.

## Core Concepts

Vault's security model is built on three main components that work together to secure your infrastructure:

1.  **[Secrets Engines](./Secrets.md)**: How Vault stores, generates, and manages sensitive data (static and dynamic).
2.  **[Policies](./Policies.md)**: How Vault defines and enforces what an authenticated identity is allowed to do.
3.  **[Authentication Methods](./Auth-methods.md)**: How users and applications prove their identity to Vault.
4.  **[Leases](./Lease.md)**: How Vault manages the lifecycle and expiration of secrets and tokens.
5.  **[Leases in Kubernetes](./Lease-in-k8s.md)**: How Vault Agent automates lease management in K8s environments.
6.  **[Vault Agent](./Vault-agent.md)**: Deployment modes (InitContainer, Sidecar) and CSI provider best practices.
7.  **[Consul-Template and EnvConsul](./Consul-env-template.md)**: Transparent secret injection for legacy or non-cloud-native apps.
8.  **[Encryption as a Service](./Encryption-as-service.md)**: Offloading cryptography to Vault using the Transit engine.
9.  **[PKI as a Service](./PKI-as-service.md)**: Generating dynamic X.509 certificates on the fly.
10. **[Cert-Manager with Vault](./CertManager-using-pki.md)**: Automating certificate management in Kubernetes.
11. **[HashiCorp Vault and Venafi](./Venafi.md)**: Enterprise-grade machine identity management and policy enforcement.


## How they interact

The typical workflow in Vault follows these steps:

```mermaid
graph LR
    A[Client] -->|Log in| B(Auth Method)
    B -->|Issue Token| C(Token + Policies)
    C -->|Request Access| D(Secrets Engine)
    D -->|Check Permissions| E{Policy Engine}
    E -->|Allowed| F[Secret/Key]
    E -->|Denied| G[403 Forbidden]
```

1.  A client authenticates via an **Auth Method**.
2.  Vault validates the identity and issues a **Token** with specific **Policies** attached.
3.  The client uses the Token to access a **Secrets Engine**.
4.  Vault's **Policy Engine** verifies if the Token has the required capabilities for the requested path.
5.  If authorized, Vault provides the secret or dynamic credential.

---


![Vault Auth Token](../../screenshots/1-4-auth-token.avif)


## References

For more detailed information, please refer to the individual documentation files linked above.

- [Vault Authentication Methods](https://developer.hashicorp.com/vault/docs/auth)
- [Vault Policies](https://developer.hashicorp.com/vault/docs/concepts/policy)
- [Vault Secrets Engines](https://developer.hashicorp.com/vault/docs/secrets)
