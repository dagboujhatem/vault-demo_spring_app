package fr.bnpp.vaultdemo.config;

import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
public class EnvDebugConfig {

    @Bean
    ApplicationRunner envDebug(Environment env) {
        return args -> {
            System.out.println("=== ENV DEBUG (before Hikari) ===");
            System.out.println("spring.datasource.url = " +
                    env.getProperty("spring.datasource.url"));
            System.out.println("spring.datasource.username = " +
                    env.getProperty("spring.datasource.username"));
            System.out.println("spring.datasource.password = " +
                    (env.getProperty("spring.datasource.password")));
            System.out.println("================================");
        };
    }
}
