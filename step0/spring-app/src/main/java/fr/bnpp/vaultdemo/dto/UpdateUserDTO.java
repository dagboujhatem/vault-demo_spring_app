package fr.bnpp.vaultdemo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO pour la mise à jour d'un utilisateur existant (mise à jour partielle supportée)")
public class UpdateUserDTO {
    
    @Schema(description = "Nouveau nom d'utilisateur (optionnel)", example = "jane_smith")
    private String username;
    
    @Schema(description = "Nouvelle adresse email (optionnel)", example = "jane.smith@example.com")
    private String email;
}
