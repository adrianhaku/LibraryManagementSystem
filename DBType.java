 package com.library.db;

public enum DBType {
    POSTGRESQL, MYSQL;
    
    public static DBType fromConfig(String activeDB) {
        if (activeDB.toLowerCase().contains("postgresql")) {
            return POSTGRESQL;
        } else if (activeDB.toLowerCase().contains("mysql")) {
            return MYSQL;
        }
        return POSTGRESQL;
    }
    
    public String getLikeOperator() {
        return this == POSTGRESQL ? "ILIKE" : "LIKE";
    }
}