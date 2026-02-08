package fr.bnpp.vaultdemo.mapper;

import fr.bnpp.vaultdemo.dto.CreateUserDTO;
import fr.bnpp.vaultdemo.dto.UpdateUserDTO;
import fr.bnpp.vaultdemo.dto.UserDTO;
import fr.bnpp.vaultdemo.entity.UserEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
public interface UserMapper {
    
    /**
     * Convertit une entité UserEntity en DTO UserDTO
     * @param entity l'entité à convertir
     * @return le DTO converti
     */
    UserDTO toDTO(UserEntity entity);
    
    /**
     * Convertit un CreateUserDTO en entité UserEntity
     * @param createDTO le DTO de création
     * @return l'entité créée
     */
    @Mapping(target = "id", ignore = true)
    UserEntity toEntity(CreateUserDTO createDTO);
    
    /**
     * Met à jour une entité existante avec les données d'un UpdateUserDTO
     * @param updateDTO le DTO contenant les nouvelles valeurs
     * @param entity l'entité à mettre à jour
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    void updateEntityFromDTO(UpdateUserDTO updateDTO, @MappingTarget UserEntity entity);
}
