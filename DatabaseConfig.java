 package com.library.config;

import java.io.InputStream;
import java.util.Properties;

public class DatabaseConfig {
    private static Properties props = new Properties();
    
    static {
        try {
            InputStream input = DatabaseConfig.class.getClassLoader()
                .getResourceAsStream("dbconfig.properties");
            if (input == null) {
                System.err.println("dbconfig.properties not found!");
            } else {
                props.load(input);
                System.out.println("Loaded config. Active DB: " + getActiveDB());
                input.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static String getActiveDB() {
        return props.getProperty("active.db", "postgresql");
    }
    
    public static String getDriver() {
        return props.getProperty(getActiveDB() + ".driver");
    }
    
    public static String getUrl() {
        return props.getProperty(getActiveDB() + ".url");
    }
    
    public static String getUser() {
        return props.getProperty(getActiveDB() + ".user");
    }
    
    public static String getPassword() {
        return props.getProperty(getActiveDB() + ".password");
    }
}