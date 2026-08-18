package com.company.irs941.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.TimeZone;

/**
 * Enforces JVM default TimeZone to UTC at the earliest ServletContext initialization phase.
 * Prevents PostgreSQL JDBC driver "FATAL: invalid value for parameter TimeZone" errors.
 */
@WebListener
public class TimezoneInitializerListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.setProperty("user.timezone", "UTC");
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        System.out.println("[TimezoneInitializerListener] Successfully set JVM default TimeZone to UTC");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // No cleanup required
    }
}
