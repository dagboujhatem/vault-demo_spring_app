package fr.bnpp.vaultdemo.repo;

import fr.bnpp.vaultdemo.entity.UserEntity;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends ElasticsearchRepository<UserEntity, Integer> {
}
