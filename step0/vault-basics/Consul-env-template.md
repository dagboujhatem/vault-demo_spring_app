# Consul-Template and EnvConsul

**Consul-Template** and **EnvConsul** are powerful tools from HashiCorp that allow applications to consume Vault secrets transparently, often without requiring any changes to the application's source code.

## 1. EnvConsul

`envconsul` provides a convenient way to launch a subprocess with environment variables populated from Vault.

### How it Works
1.  Connects to Vault and authenticates.
2.  Fetches the specified secrets.
3.  Maps the secret data to environment variables.
4.  Starts the application process with these variables.

### Key Features
-   **Zero Code Changes**: Your application just reads standard environment variables.
-   **Live Updates**: If a secret changes in Vault, `envconsul` can automatically restart your application with the new values.
-   **Security**: Secrets only exist in the memory of the environment, not on disk.

```bash
# Example usage:
envconsul -secret="secret/data/myapp" java -jar myapp.jar
```

---

## 2. Consul-Template

`consul-template` is a more flexible tool that renders configuration files from templates by populating them with Vault secrets.

### How it Works
1.  Monitors Vault for changes to specific paths.
2.  Renders a local template file (using HCL/Go template syntax).
3.  Writes the rendered file to disk (or shared memory).
4.  Optionally runs a command (like `SIGHUP` or a service restart) to notify the application of the change.

### Key Features
-   **Complex Formatting**: Can generate `.properties`, `.yaml`, `.xml`, or any other format your application expects.
-   **Lease Management**: Automatically handles the renewal of dynamic secret leases inside the template.
-   **Sidecar Pattern**: Often used as a sidecar in Kubernetes or a background daemon on VMs.

```hcl
# Example Template (myapp.conf.ctmpl):
{{ with secret "secret/data/db" }}
db_user = "{{ .Data.data.username }}"
db_pass = "{{ .Data.data.password }}"
{{ end }}
```

## Best Practices

-   **Use Shared Memory**: When writing secrets to disk with `consul-template`, use a `tmpfs` or `memory` volume to ensure secrets aren't persisted to physical storage.
-   **Graceful Restarts**: Ensure your application can handle restarts or configuration reloads gracefully without dropping active connections.
-   **Limit Permissions**: The Vault token used by these tools should only have `read` access to the paths defined in the templates or environment filters.

## References
- [EnvConsul GitHub](https://github.com/hashicorp/envconsul)
- [Consul-Template GitHub](https://github.com/hashicorp/consul-template)
- [Vault Agent Templating](https://developer.hashicorp.com/vault/docs/agent/template) (Vault Agent now includes Consul-Template functionality directly)
