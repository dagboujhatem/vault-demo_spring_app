# Step 2: Extract Credentials

In this step, we retrieve the necessary credentials for our Application to authenticate with Vault.

## The Credentials

We need two pieces of information for **AppRole** authentication:

1.  **Role ID**: The permanent identifier for our application's role.
2.  **Secret ID**: A one-time (or renewable) password generated for this specific instance.

## Run it

Run the following command to extract these values from the Terraform output:

```bash
./run.sh
```

## What happens?

The script:
1.  Reads the `terraform output` from the Terraform container.
2.  Saves the `ROLE_ID` and `SECRET_ID` into a protected file named `.secrets` at the root of the project.

**Security Note**: In a real production environment, the wrapped Secret ID might be delivered via a trusted orchestrator (like Kubernetes) or a CI/CD pipeline, not written to a local file.

## Next Step

Let's verify that we have the credentials. Go to [Step 3](../step3/README.md).
