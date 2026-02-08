/*
package fr.bnpp.vaultdemo.config;

import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import javax.sql.DataSource;

@Configuration
public class DataSourceConfig {

    // RefreshScope allows the datasource to be recreated when credentials change
    @Bean
    @RefreshScope
    public DataSource dataSource(
            @Value("${spring.datasource.url}") String url,
            @Value("${spring.datasource.username}") String username,
            @Value("${spring.datasource.password}") String password) {

        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);

        // Configure pool for credential rotation
        dataSource.setMaxLifetime(1800000);  // 30 minutes
        dataSource.setConnectionTimeout(30000);
        dataSource.setValidationTimeout(5000);

        return dataSource;
    }
}
*/
