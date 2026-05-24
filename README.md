 # Library Management System

A desktop application for managing library books, members, loans, and fines.

## Features
- Add, search, and borrow books
- Register library members  
- Track active loans
- Automatic fine calculation ($0.50/day late)
- Works with PostgreSQL and MySQL
- Pure JDBC (no frameworks)

## Technologies
- Java 21, JavaFX, JDBC
- PostgreSQL / MySQL
- Eclipse IDE

## How to Run
1. Create database: `CREATE DATABASE library_db;`
2. Run SQL script from `/database` folder
3. Update `dbconfig.properties` with your password
4. Run `Main.java`

## Author
Adrian Haku
