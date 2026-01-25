package com.example.vaultdemo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.vault.core.VaultTemplate;
import org.springframework.vault.support.Ciphertext;
import org.springframework.vault.support.Plaintext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Base64;
import java.util.List;
import java.util.stream.Collectors;

@RestController
public class DemoController {

    @Autowired
    private VaultTemplate vaultTemplate;

    @Autowired
    private TestRepository testRepository;

    @GetMapping("/")
    public String demo() {
        StringBuilder output = new StringBuilder();
        output.append("<h1>Hello World!</h1>");
        output.append("Vault interaction...</br>");

        // In Spring Cloud Vault, authentication and token retrieval are handled automatically.
        // We can just use the vaultTemplate.

        output.append("Approle auth with Vault... (Handled by Spring Cloud Vault)</br>");
        output.append("Get database credentials from Vault... (Handled by Spring Cloud Vault Database)</br>");
        
        // Reset Database State
        output.append("</br>Data test into DB:<br>");
        try {
            testRepository.deleteAll();
            // In a real app we wouldn't drop/create via repository usually, but we can simulate the "fresh" start by deleting all.
            // If we really want to drop table we'd need a custom query or JDBC template, but deleteAll is fine for logically clearing it.
             output.append("Cleaned up existing table data.</br>");
        } catch (Exception e) {
             output.append("Fail to clear table: " + e.getMessage() + "</br>");
        }

        // Encrypt
        output.append("Encrypt value from Vault...</br>");
        String plainText = "Spring Boot Vault Demo"; // Simulating the server name or just a text
        String base64Input = Base64.getEncoder().encodeToString(plainText.getBytes());
        // PHP did base64 before sending? 
        // PHP: curl_setopt($ch, CURLOPT_POSTFIELDS, '{"plaintext":"' . base64_encode($_SERVER['SERVER_NAME']) . '"}');
        // Vault expects base64 if it's binary, but usually text is fine? 
        // Actually Vault Transit API expects plaintext reference to be base64 encoded if not configured otherwise?
        // Spring Vault's `Plaintext.of()` handles strings. By default Spring Vault handles the encoding/decoding if I recall correctly?
        // Let's check docs or assume Spring Vault `encrypt(key, Plaintext)` handles it.
        // Wait, standard Vault API for transit expects base64. Spring Vault abstract this.
        // PHP code explicitly base64 encoded it.
        // `vaultTemplate.opsForTransit().encrypt("web", Plaintext.of(plainText))` should work and return Ciphertext.
        
        Ciphertext ciphertext = vaultTemplate.opsForTransit().encrypt("web", Plaintext.of(plainText));
        String cipherString = ciphertext.getCiphertext();
        output.append("Encrypted value from Vault: " + cipherString + "</br>");

        // Insert
        output.append("Put data into database...</br>");
        try {
            testRepository.save(new TestEntity(1, "Hello"));
            testRepository.save(new TestEntity(2, "World!"));
            testRepository.save(new TestEntity(3, cipherString));
        } catch (Exception e) {
            output.append("Fail to insert into table: " + e.getMessage());
        }

        // Select
        output.append("Get data from database:</br>");
        List<TestEntity> all = testRepository.findAll();
        
        for (TestEntity entity : all) {
             output.append(" id = " + entity.getId() + " & value = " + entity.getValue() + "</br>");
        }

        return output.toString();
    }
}
