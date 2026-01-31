package fr.bnpp.vaultdemo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO représentant un utilisateur (sans le mot de passe pour des raisons de sécurité)")
public class UserDTO {
    
    @Schema(description = "Identifiant unique de l'utilisateur", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer id;
    
    @Schema(description = "Nom d'utilisateur", example = "john_doe", requiredMode = Schema.RequiredMode.REQUIRED)
    private String username;
    
    @Schema(description = "Adresse email de l'utilisateur", example = "john.doe@example.com", requiredMode = Schema.RequiredMode.REQUIRED)
    private String email;
}
