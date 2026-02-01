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
