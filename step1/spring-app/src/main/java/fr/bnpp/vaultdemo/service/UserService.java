package fr.bnpp.vaultdemo.service;

import fr.bnpp.vaultdemo.dto.CreateUserDTO;
import fr.bnpp.vaultdemo.dto.UpdateUserDTO;
import fr.bnpp.vaultdemo.dto.UserDTO;
import fr.bnpp.vaultdemo.entity.UserEntity;
import fr.bnpp.vaultdemo.mapper.UserMapper;
import fr.bnpp.vaultdemo.repo.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public List<UserDTO> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(userMapper::toDTO)
                .collect(Collectors.toList());
    }

    public Optional<UserDTO> getUserById(Integer id) {
        return userRepository.findById(id)
                .map(userMapper::toDTO);
    }

    public UserDTO createUser(CreateUserDTO createUserDTO) {
        UserEntity entity = userMapper.toEntity(createUserDTO);
        UserEntity savedEntity = userRepository.save(entity);
        return userMapper.toDTO(savedEntity);
    }

    public UserDTO updateUser(Integer id, UpdateUserDTO updateUserDTO) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found for id: " + id));
        
        userMapper.updateEntityFromDTO(updateUserDTO, user);
        
        UserEntity updatedEntity = userRepository.save(user);
        return userMapper.toDTO(updatedEntity);
    }

    public void deleteUser(Integer id) {
        userRepository.deleteById(id);
    }
}
