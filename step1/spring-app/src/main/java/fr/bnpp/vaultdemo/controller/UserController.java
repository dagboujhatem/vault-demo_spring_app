package fr.bnpp.vaultdemo.controller;

import fr.bnpp.vaultdemo.dto.CreateUserDTO;
import fr.bnpp.vaultdemo.dto.UpdateUserDTO;
import fr.bnpp.vaultdemo.dto.UserDTO;
import fr.bnpp.vaultdemo.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "User Management", description = "API pour la gestion des utilisateurs")
public class UserController {

    private final UserService userService;

    @GetMapping
    @Operation(
            summary = "Récupérer tous les utilisateurs",
            description = "Retourne la liste complète de tous les utilisateurs enregistrés (sans les mots de passe)"
    )
    @ApiResponse(
            responseCode = "200",
            description = "Liste des utilisateurs récupérée avec succès",
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserDTO.class))
    )
    public List<UserDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    @Operation(
            summary = "Récupérer un utilisateur par ID",
            description = "Retourne les détails d'un utilisateur spécifique par son identifiant"
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "Utilisateur trouvé",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserDTO.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "Utilisateur non trouvé",
                    content = @Content
            )
    })
    public ResponseEntity<UserDTO> getUserById(
            @Parameter(description = "ID de l'utilisateur à récupérer", required = true)
            @PathVariable Integer id
    ) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(
            summary = "Créer un nouvel utilisateur",
            description = "Crée un nouvel utilisateur avec username, email et password. Le password ne sera jamais retourné dans les réponses."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "201",
                    description = "Utilisateur créé avec succès",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserDTO.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "Requête invalide",
                    content = @Content
            )
    })
    public UserDTO createUser(
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    description = "Données de l'utilisateur à créer",
                    required = true,
                    content = @Content(schema = @Schema(implementation = CreateUserDTO.class))
            )
            @RequestBody CreateUserDTO createUserDTO
    ) {
        return userService.createUser(createUserDTO);
    }

    @PutMapping("/{id}")
    @Operation(
            summary = "Mettre à jour un utilisateur",
            description = "Met à jour les informations d'un utilisateur existant (username et/ou email). Le password ne peut pas être modifié via cet endpoint."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "Utilisateur mis à jour avec succès",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserDTO.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "Utilisateur non trouvé",
                    content = @Content
            )
    })
    public ResponseEntity<UserDTO> updateUser(
            @Parameter(description = "ID de l'utilisateur à mettre à jour", required = true)
            @PathVariable Integer id,
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    description = "Nouvelles données de l'utilisateur",
                    required = true,
                    content = @Content(schema = @Schema(implementation = UpdateUserDTO.class))
            )
            @RequestBody UpdateUserDTO updateUserDTO
    ) {
        try {
            return ResponseEntity.ok(userService.updateUser(id, updateUserDTO));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(
            summary = "Supprimer un utilisateur",
            description = "Supprime définitivement un utilisateur par son identifiant"
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "204",
                    description = "Utilisateur supprimé avec succès",
                    content = @Content
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "Utilisateur non trouvé",
                    content = @Content
            )
    })
    public void deleteUser(
            @Parameter(description = "ID de l'utilisateur à supprimer", required = true)
            @PathVariable Integer id
    ) {
        userService.deleteUser(id);
    }
}
