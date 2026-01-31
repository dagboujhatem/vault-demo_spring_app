# Step 0: Starting Point (Spring boot application with REST API & Postgres database)

In this step, we prepare the ground for our Spring boot application by starting our base stack. This represents the application *before* any Vault integration.

## Architecture

We use **Docker Compose** to spin up:

- **PostgreSQL**: The database (listening on port 5432).
- **Spring Boot App**: A standard REST API for user management (listening on port 8080).
- **Vault**: The secret management server (listening on port 8200) - Started but not yet used by the app.

## The API

The application provides a standard CRUD for managing users:

- `GET /api/v1/users`: List all users.
- `GET /api/v1/users/{id}`: Get one user.
- `POST /api/v1/users`: Create a user.
- `PUT /api/v1/users/{id}`: Update a user.
- `DELETE /api/v1/users/{id}`: Delete a user.

## API Documentation Interactive (Swagger UI)

Once the application is started, access the interactive Swagger documentation:

- **Swagger UI** : [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **OpenAPI JSON** : [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs)
- **OpenAPI YAML** : [http://localhost:8080/v3/api-docs.yaml](http://localhost:8080/v3/api-docs.yaml)

## Environment Configuration

Database settings are managed via the `.env` file at the root of this folder. You can configure:

- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`

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

## Database & Configuration Check

This our starting point Spring application with secret divulgation.

You can find the Spring application code in the folder `spring-app/`. Where there is only one file [application.yaml](./spring-app/src/main/resources/application.yaml). Inside this file, in **line 10 & 11**, you can find the database user and password in cleartext.

Our goal is to secure this Spring application with [Hashicorp Vault](https://www.vaultproject.io/).

## Next Step

Now that we have a standard working application, our goal is to migrate its secrets to Vault. Go to [Step 1](../step1/README.md).
