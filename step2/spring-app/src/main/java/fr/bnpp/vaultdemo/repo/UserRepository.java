package fr.bnpp.vaultdemo.repo;

import fr.bnpp.vaultdemo.entity.UserEntity;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Lazy
@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
}
