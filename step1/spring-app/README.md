# User API - Documentation

## 📚 Technologies Used

- **Lombok**: Boilerplate code reduction using `@Data`, `@RequiredArgsConstructor`, etc.
- **MapStruct**: Automatic and high-performance mapping between Entity and DTOs.
- **DTOs**: Clear separation between the data layer and the API.
- **Swagger/OpenAPI 3**: Interactive API documentation with springdoc-openapi.

## 📖 Interactive Documentation (Swagger UI)

Once the application is started, access the interactive Swagger documentation:

- **Swagger UI**: [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **OpenAPI JSON**: [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs)
- **OpenAPI YAML**: [http://localhost:8080/v3/api-docs.yaml](http://localhost:8080/v3/api-docs.yaml)

**Swagger UI Features**:
- 🔍 Interactive exploration of all endpoints.
- 🧪 Test APIs directly from the browser.
- 📝 Detailed request/response schemas.
- 💡 Data examples for each endpoint.
- 🎯 Documented HTTP response codes.

## 🔒 Security

The password is **never exposed** in API responses thanks to the use of DTOs.

## 🚀 Available Endpoints

### 1. List All Users
```http
GET /api/v1/users
```

**Response**: `200 OK`
```json
[
  {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com"
  }
]
```

---

### 2. Get User by ID
```http
GET /api/v1/users/{id}
```

**Response**: `200 OK` or `404 Not Found`
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com"
}
```

---

### 3. Create a New User
```http
POST /api/v1/users
Content-Type: application/json
```

**Body**:
```json
{
  "username": "jane_doe",
  "email": "jane@example.com",
  "password": "securePassword123"
}
```

**Response**: `201 Created`
```json
{
  "id": 2,
  "username": "jane_doe",
  "email": "jane@example.com"
}
```

---

### 4. Update a User
```http
PUT /api/v1/users/{id}
Content-Type: application/json
```

**Body**:
```json
{
  "username": "jane_smith",
  "email": "jane.smith@example.com"
}
```

**Notes**:
- The password **cannot be modified** via this endpoint.
- `null` fields are ignored (partial update supported).

**Response**: `200 OK` or `404 Not Found`
```json
{
  "id": 2,
  "username": "jane_smith",
  "email": "jane.smith@example.com"
}
```

---

### 5. Delete a User
```http
DELETE /api/v1/users/{id}
```

**Response**: `204 No Content`

---

## 📁 Architecture

```
src/main/java/fr/bnpp/vaultdemo/
├── config/
│   └── OpenAPIConfig.java        # Swagger/OpenAPI configuration
├── controller/
│   └── UserController.java       # REST Endpoints (uses DTOs)
├── service/
│   └── UserService.java           # Business logic (uses Mapper)
├── entity/
│   └── UserEntity.java            # JPA Entity (with Lombok)
├── dto/
│   ├── UserDTO.java               # Response (without password)
│   ├── CreateUserDTO.java         # Creation (with password)
│   └── UpdateUserDTO.java         # Update (without id or password)
├── mapper/
│   └── UserMapper.java            # MapStruct interface
└── repo/
    └── UserRepository.java        # JPA Repository
```

## 🔄 Data Flow

### User Creation:
```
CreateUserDTO → Mapper → UserEntity → DB → UserEntity → Mapper → UserDTO
```

### User Update:
```
UpdateUserDTO → Mapper (partial update) → UserEntity → DB → UserDTO
```

## ⚡ Architecture Benefits

1. **Security**: Password is never exposed in responses.
2. **Performance**: MapStruct generates code at compile-time (no reflection).
3. **Maintainability**: Lombok reduces boilerplate code.
4. **Flexibility**: DTOs allow precise control over exposed data.
5. **Type-safety**: Errors detected at compilation.

## 🧪 Testing with curl

### Create a User
```bash
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Get All Users
```bash
curl http://localhost:8080/api/v1/users
```

### Update a User
```bash
curl -X PUT http://localhost:8080/api/v1/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "username": "updateduser",
    "email": "updated@example.com"
  }'
```

## Dockerization Strategies for Spring Boot Applications 

This document describes two common Dockerization approaches for Spring Boot applications:

1. Dockerization with an `entrypoint.sh` script
2. Dockerization without an entrypoint script (direct JVM execution)

Both approaches use multi-stage builds to produce small, production-ready images.

## Dockerization with `entrypoint.sh`

This approach uses a shell script as the container entrypoint.
It is typically used when:
- Secrets must be fetched at startup (Vault, AWS Secrets Manager, etc.)
- Environment variables need to be transformed
- Dynamic configuration is required before starting the JVM

### Examples: 

Example of `dockerfile`:
```dockerfile
# =========================
# Build stage
# =========================
FROM maven:3.8.5-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests

# =========================
# Run stage
# =========================
FROM eclipse-temurin:17-jre
WORKDIR /app

# Tools for runtime configuration (Vault, debugging)
RUN apt-get update \
 && apt-get install -y curl jq \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/*.jar app.jar
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
```

Example of `entrypoint.sh`:

```sh
#!/bin/sh
set -e

export SPRING_APPLICATION_NAME=${SPRING_APPLICATION_NAME:-application}
export SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE:-default}

exec java $JAVA_OPTS -jar app.jar
```

This is a basic example but you can see this [dockerfile](./dockerfile) and [entrypoint.sh]('./entrypoint.sh') in the same directory.

---

**Pros**
- Full control over startup logic
- Easy integration with Vault or secret providers
- Allows dynamic configuration before JVM start

**Cons**
- Extra moving part (script to maintain)
- Harder to debug
- PID 1 is the shell, not the JVM (signal handling issues if not handled properly)

## Dockerization without entrypoint.sh (Recommended)

This approach relies entirely on:

- Spring Boot configuration resolution
- Environment variables
- JVM arguments

It is simpler, cleaner, and cloud-native.

Recommended for:

- Kubernetes
- ECS / Fargate
- Modern DevOps pipelines

### Examples: 

Example of `Dockerfile (without entrypoint)`:
```dockerfile
# =========================
# Build stage
# =========================
FROM maven:3.8.5-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests

# =========================
# Run stage
# =========================
FROM eclipse-temurin:17-jre
WORKDIR /app

RUN apt-get update \
 && apt-get install -y curl jq \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

This is a basic example but you can see this [dockerfile.v2](./dockerfile.v2) in the same directory.

### ENTRYPOINT Options 

The application is packaged as a Docker image using a direct JVM entrypoint:

```dockerfile 
# Option 1️⃣ — Simple ENTRYPOINT (No JVM tuning)
ENTRYPOINT ["java", "-jar", "app.jar"]
# Option 2️⃣ — ENTRYPOINT with JAVA_OPTS (JVM tuning support)
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

**Option 1️⃣** — Simple ENTRYPOINT (No JVM tuning)

Use this when JVM options are fixed at build time or not needed.

**Pros**
* JVM runs as PID 1 (proper signal handling)
* Simpler and safer
* Best for Kubernetes / ECS

**Cons**
* Cannot inject JVM options dynamically

**Option 2️⃣** — ENTRYPOINT with JAVA_OPTS (JVM tuning support)

Use this when JVM options must be configurable at runtime.

**Pros**
* Supports runtime JVM tuning
* Works with Docker, Docker Compose, Kubernetes
* Flexible memory and GC configuration

**Cons**
* Shell becomes PID 1 (slightly worse signal handling)
* Small overhead (usually acceptable)


### Runtime Configuration for Docker, Docker Compose & Kubernetes

This document explains how to configure a Spring Boot application at runtime when running in:

- Docker
- Docker Compose
- Kubernetes

#### Runtime Configuration with Docker
Using Environment Variables :

```shell 
docker run \
  -p 8080:8080 \
  -e SPRING_APPLICATION_NAME=my-service \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e LOGGING_LEVEL_ROOT=INFO \
  -e JAVA_OPTS="-Xms256m -Xmx512m" \
  my-image:tag
```

Using Spring Command-Line Arguments : 
```shell 
docker run my-spring-app:latest \
  --spring.application.name=my-service \
  --spring.profiles.active=prod
```

#### Runtime Configuration with Docker Compose

Example `docker-compose.yml`

```yaml 
version: "3.9"

services:
  app:
    image: my-spring-app:latest
    container_name: my-spring-app

    ports:
      - "8080:8080"

    environment:
      SPRING_APPLICATION_NAME: my-service
      SPRING_PROFILES_ACTIVE: prod
      LOGGING_LEVEL_ROOT: INFO

      # JVM options
      JAVA_OPTS: "-Xms256m -Xmx512m"

    restart: unless-stopped
```

#### Runtime Configuration with Kubernetes

1. Using Environment Variables

```yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-spring-app
spec:
  replicas: 2
  template:
    spec:
      containers:
        - name: app
          image: my-spring-app:latest
          ports:
            - containerPort: 8080
          env:
            - name: SPRING_APPLICATION_NAME
              value: my-service
            - name: SPRING_PROFILES_ACTIVE
              value: prod
            - name: LOGGING_LEVEL_ROOT
              value: INFO
```

2. Using ConfigMaps / Secrets (Recommended)

This approach externalizes configuration from the container image and follows Kubernetes best practices.

- **ConfigMaps** → non-sensitive configuration
- **Secrets** → sensitive configuration (passwords, tokens, keys)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  SPRING_APPLICATION_NAME: my-service
  SPRING_PROFILES_ACTIVE: prod
  LOGGING_LEVEL_ROOT: INFO
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
stringData:
  SPRING_DATASOURCE_PASSWORD: secret123
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-spring-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-spring-app
  template:
    metadata:
      labels:
        app: my-spring-app
    spec:
      containers:
        - name: app
          image: my-spring-app:latest
          ports:
            - containerPort: 8080
          # JVM configuration
          env:
            - name: JAVA_OPTS
              value: "-Xms256m -Xmx512m"
          # Injecting a Single Variable from ConfigMap (Optional)
            - name: SPRING_PROFILES_ACTIVE
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: SPRING_PROFILES_ACTIVE
          # Injecting a Single Variable from Secret (Optional)
            - name: SPRING_DATASOURCE_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: SPRING_DATASOURCE_PASSWORD
          # Inject all variables from the ConfigMap / Secret
          envFrom:
            - configMapRef:
                name: app-config
            - secretRef:
                name: app-secrets       
```

----

**Pros**

- Simpler and more maintainable
- JVM runs as PID 1 (proper signal handling)
- Easy override with docker run / Kubernetes command
- Works naturally with Spring Cloud Config and Vault

**Cons**

- Less flexibility for complex startup logic
- Not suitable if heavy pre-start scripting is required


## Best Practices

1. Use environment variables

Spring Boot automatically maps:

```text
SPRING_APPLICATION_NAME → spring.application.name
```

2. Memory optimization for containers.

```text
-XX:InitialRAMPercentage=50.0
-XX:MaxRAMPercentage=70.0
-XX:MinRAMPercentage=50.0
```

3. Run as non-root (recommended)

In `dockerfile`, we can added : 

```dockerfile
RUN useradd -r -u 1001 appuser
```

In `docker-compose.yml`, we can added : 

```yaml
  user: "1001:1001"
```
  
In Kubernetes and/or OpenShift, we can also use a SecurityContext to run the container as a non-root user:

```yaml
securityContext:
  runAsUser: 1001
  runAsGroup: 1001
  fsGroup: 1001
```

## Memory optimization for Spring containers

Running Spring Boot inside containers requires explicit JVM tuning, otherwise the JVM may:

* Misinterpret available memory
* Trigger OOMKilled
* Waste resources or cause GC pressure

This guide shows recommended approaches for Docker and Kubernetes.

### 1. The Golden Rule (Java 11+ / Java 17)

Always set container-aware JVM options to ensure the JVM respects the container's memory and CPU limitations. These
options are enabled by default in Java 11+:

- `-XX:+UseContainerSupport` (enabled by default in Java 11+)
- `-XX:MaxRAMPercentage=75.0` (uses 75% of container's memory)

### 2. Recommended JVM Options (Best Practice)

Configure additional JVM options for optimal performance in containers:

```text
-XX:+UseG1GC
-XX:InitialRAMPercentage=50.0
-XX:MaxRAMPercentage=75.0
-XX:MinRAMPercentage=50.0
-XX:+AlwaysPreTouch
```

### 3. Kubernetes Resource Configuration (Mandatory)

Set resource limits and requests in Kubernetes to prevent overcommitting container resources:

```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "500m"
  limits:
    memory: "1024Mi"
    cpu: "1000m"
```

Ensure that the memory limits align with JVM tuning parameters to avoid unexpected behavior.

### 4. Avoid These Anti-Patterns 🚫

- Do not rely on default JVM behavior for memory allocation.
- Avoid setting fixed heap sizes (`-Xmx`) without adjusting for container memory limits.
- Do not use aggressive GC tunings unless necessary; use G1GC with default settings for most cases.

### 5. When JAVA_OPTS Is Still Useful

Use `JAVA_OPTS` during runtime to inject additional JVM parameters dynamically. Example:

```shell
export JAVA_OPTS="-Dspring.profiles.active=prod -XX:+HeapDumpOnOutOfMemoryError -Xms256m -Xmx512m"
```

### 6. Spring Boot–Specific Memory Tips

- Enable lazy initialization to reduce startup memory usage:
  ```yaml
  spring.main.lazy-initialization: true
  ```
- Configure actuator endpoints to monitor memory usage:
  ```yaml
  management.endpoints.web.exposure.include: health, metrics
  ```
- Use Spring Boot's built-in statistics for GC and heap monitoring.

### 7. Native Memory Tracking (Optional)

Enable JVM's Native Memory Tracking (NMT) to debug memory usage:

```text
-XX:NativeMemoryTracking=summary
-XX:+PrintNMTStatistics
```

### 8. Minimal Recommended Setup (Production)

```shell
-Xms256m -Xmx512m
-XX:+UseG1GC
-XX:MaxRAMPercentage=75.0
-Dspring.profiles.active=prod
```

### 9. Quick Checklist ✅

- [ ] Use `-XX:MaxRAMPercentage` instead of fixed `-Xmx`.
- [ ] Ensure Kubernetes resource limits match JVM memory settings.
- [ ] Monitor memory usage using Spring Actuator or external tools like Prometheus + Grafana.
- [ ] Test application scaling under real-world load scenarios.

### 10. Actuator endpoints for Memory optimization

Use Spring Boot Actuator to expose key metrics:

- `GET /actuator/metrics/jvm.memory.used`: Displays used JVM memory.
- `GET /actuator/metrics/jvm.memory.max`: Shows maximum JVM memory.
- `GET /actuator/metrics/process.uptime`: Shows the uptime of the application.
- Configure custom monitoring tools to consume these endpoints for in-depth analysis.