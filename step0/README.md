# Step 0: Starting Point (REST API & Postgres)

In this step, we prepare the ground for our application by starting our base stack. This represents the application *before* any Vault integration.

## Architecture

We use **Docker Compose** to spin up:

- **PostgreSQL**: The database (listening on port 5432).
- **Spring Boot App**: A standard REST API for user management (listening on port 8080).
- **Vault**: The secret management server (listening on port 8200) - Started but not yet used by the app.

## The API

The application provides a standard CRUD for managing users:

- `GET /api/users`: List all users.
- `GET /api/users/{id}`: Get one user.
- `POST /api/users`: Create a user.
- `PUT /api/users/{id}`: Update a user.
- `DELETE /api/users/{id}`: Delete a user.

## Environment Configuration

Database settings are managed via the `.env` file at the root of this folder. You can configure:

- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`

## Run it

Run the following command to start everything:

```bash
./run.sh
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

## Next Step

Now that we have a standard working application, our goal is to migrate its secrets to Vault. Go to [Step 1](../step1/README.md).
