package com.company.irs941.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
@ComponentScan(basePackages = "com.company.irs941")
@PropertySource(value = {
        "classpath:db.properties",
        "classpath:irs-mef.properties",
        "classpath:authorize.properties",
        "classpath:google.properties",
        // External Linux Configuration (production / staging)
        "file:/etc/efile941/db.properties",
        "file:/etc/efile941/irs-mef.properties",
        "file:/etc/efile941/authorize.properties",
        "file:/etc/efile941/google.properties",
        // External Windows Configuration (local development)
        "file:C:/efile941/config/db.properties",
        "file:C:/efile941/config/irs-mef.properties",
        "file:C:/efile941/config/authorize.properties",
        "file:C:/efile941/config/google.properties"
}, ignoreResourceNotFound = true)
public class AppConfig {

    static {
        // Set JVM default TimeZone to UTC to prevent PostgreSQL driver FATAL invalid TimeZone error during connection startup
        java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("UTC"));
    }

    @Value("${db.driver:org.postgresql.Driver}")
    private String driverClassName;

    @Value("${db.url:jdbc:postgresql://localhost:5432/efile941_db?options=-c%20timezone=UTC}")
    private String dbUrl;

    @Value("${db.username:postgres}")
    private String dbUsername;

    @Value("${db.password:root}")
    private String dbPassword;

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(driverClassName);
        dataSource.setUrl(dbUrl);
        dataSource.setUsername(dbUsername);
        dataSource.setPassword(dbPassword);
        return dataSource;
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean
    public NamedParameterJdbcTemplate namedParameterJdbcTemplate(DataSource dataSource) {
        return new NamedParameterJdbcTemplate(dataSource);
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}