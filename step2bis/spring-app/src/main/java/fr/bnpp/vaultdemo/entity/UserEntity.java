package fr.bnpp.vaultdemo.entity;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(indexName = "users")
public class UserEntity {

    @Id
    private Integer id;
    @Field(type = FieldType.Text)
    private String username;
    @Field(type = FieldType.Text)
    private String email;
    @Field(type = FieldType.Text)
    private String password;
}
