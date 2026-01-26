# Step 0: Infrastructure

In this step, we prepare the ground for our application by starting the necessary services.

## Architecture

We use **Docker Compose** to spin up:

- **Vault**: The secret management server (listening on port 8200).
- **MySQL**: The database (listening on port 3306).

## Run it

Run the following command to start the infrastructure:

```bash
./run.sh
```

This script wraps `docker-compose up -d` to launch the containers in the background.

If you want recreate the spring app, you can use this command : 

`docker-compose up -d --build --force-recreate`

## Check it

You can verify that the containers are running:

```bash
docker ps
```

You should see `vault` and `mysql` containers up and running.

## Next Step

Once the infrastructure is ready, we need to configure Vault. Go to [Step 1](../step1/README.md).
