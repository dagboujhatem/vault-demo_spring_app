# API User - Documentation

## 📚 Technologies utilisées

- **Lombok** : Réduction du code boilerplate avec `@Data`, `@RequiredArgsConstructor`, etc.
- **MapStruct** : Mapping automatique et performant entre Entity et DTOs
- **DTOs** : Séparation claire entre la couche de données et l'API

## 🔒 Sécurité

Le mot de passe n'est **jamais exposé** dans les réponses de l'API grâce à l'utilisation de DTOs.

## 🚀 Endpoints disponibles

### 1. Liste tous les utilisateurs
```http
GET /api/v1/users
```

**Réponse** : `200 OK`
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

### 2. Récupérer un utilisateur par ID
```http
GET /api/v1/users/{id}
```

**Réponse** : `200 OK` ou `404 Not Found`
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com"
}
```

---

### 3. Créer un nouvel utilisateur
```http
POST /api/v1/users
Content-Type: application/json
```

**Body** :
```json
{
  "username": "jane_doe",
  "email": "jane@example.com",
  "password": "securePassword123"
}
```

**Réponse** : `201 Created`
```json
{
  "id": 2,
  "username": "jane_doe",
  "email": "jane@example.com"
}
```

---

### 4. Mettre à jour un utilisateur
```http
PUT /api/v1/users/{id}
Content-Type: application/json
```

**Body** :
```json
{
  "username": "jane_smith",
  "email": "jane.smith@example.com"
}
```

**Notes** :
- Le mot de passe **n'est pas modifiable** via cet endpoint
- Les champs `null` sont ignorés (mise à jour partielle possible)

**Réponse** : `200 OK` ou `404 Not Found`
```json
{
  "id": 2,
  "username": "jane_smith",
  "email": "jane.smith@example.com"
}
```

---

### 5. Supprimer un utilisateur
```http
DELETE /api/v1/users/{id}
```

**Réponse** : `204 No Content`

---

## 📁 Architecture

```
src/main/java/fr/bnpp/vaultdemo/
├── controller/
│   └── UserController.java      # Endpoints REST (utilise DTOs)
├── service/
│   └── UserService.java          # Logique métier (utilise Mapper)
├── entity/
│   └── UserEntity.java           # Entité JPA (avec Lombok)
├── dto/
│   ├── UserDTO.java              # Réponse (sans password)
│   ├── CreateUserDTO.java        # Création (avec password)
│   └── UpdateUserDTO.java        # Mise à jour (sans id ni password)
├── mapper/
│   └── UserMapper.java           # Interface MapStruct
└── repo/
    └── UserRepository.java       # Repository JPA
```

## 🔄 Flux de données

### Création d'un utilisateur :
```
CreateUserDTO → Mapper → UserEntity → DB → UserEntity → Mapper → UserDTO
```

### Mise à jour d'un utilisateur :
```
UpdateUserDTO → Mapper (mise à jour partielle) → UserEntity → DB → UserDTO
```

## ⚡ Avantages de cette architecture

1. **Sécurité** : Le mot de passe n'est jamais exposé dans les réponses
2. **Performance** : MapStruct génère du code au compile-time (pas de réflexion)
3. **Maintenabilité** : Lombok réduit le code boilerplate
4. **Flexibilité** : Les DTOs permettent de contrôler exactement quelles données sont exposées
5. **Type-safety** : Erreurs détectées à la compilation

## 🧪 Test avec curl

### Créer un utilisateur
```bash
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Récupérer tous les utilisateurs
```bash
curl http://localhost:8080/api/v1/users
```

### Mettre à jour un utilisateur
```bash
curl -X PUT http://localhost:8080/api/v1/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "username": "updateduser",
    "email": "updated@example.com"
  }'
```
