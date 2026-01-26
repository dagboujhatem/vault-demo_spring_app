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
# or
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

## Database & Configuration Check

Since **Spring Boot Actuator** is enabled, you can inspect the active configuration (including database settings) at the following URLs:

- **All Configuration Properties**: [http://localhost:8080/actuator/configprops](http://localhost:8080/actuator/configprops)
- **Environment Variables**: [http://localhost:8080/actuator/env](http://localhost:8080/actuator/env)
- **Health Status**: [http://localhost:8080/actuator/health](http://localhost:8080/actuator/health)

In `configprops`, search for `spring.datasource` to see the exact URL, username, and driver currently in use.

## Next Step

Now that we have a standard working application, our goal is to migrate its secrets to Vault. Go to [Step 1](../step1/README.md).
