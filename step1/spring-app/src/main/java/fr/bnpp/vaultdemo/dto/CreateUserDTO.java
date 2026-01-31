package fr.bnpp.vaultdemo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO pour la création d'un nouvel utilisateur")
public class CreateUserDTO {
    
    @Schema(description = "Nom d'utilisateur (doit être unique)", example = "jane_doe", requiredMode = Schema.RequiredMode.REQUIRED)
    private String username;
    
    @Schema(description = "Adresse email (doit être unique)", example = "jane.doe@example.com", requiredMode = Schema.RequiredMode.REQUIRED)
    private String email;
    
    @Schema(description = "Mot de passe de l'utilisateur (jamais retourné dans les réponses)", example = "SecurePassword123!", requiredMode = Schema.RequiredMode.REQUIRED, accessMode = Schema.AccessMode.WRITE_ONLY)
    private String password;
}
