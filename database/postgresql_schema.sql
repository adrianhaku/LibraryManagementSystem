 -- Library Management System - MySQL Schema
-- Complete version with all tables

DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- Authors table
CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    birth_year INT,
    nationality VARCHAR(50)
);

-- Members table
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE DEFAULT (CURRENT_DATE),
    membership_status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Books table
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn CHAR(13) UNIQUE,
    publication_year INT,
    publisher_id INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- Book_Authors junction table
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Loans table
CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'BORROWED',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Fines table
CREATE TABLE fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT UNIQUE NOT NULL,
    amount DECIMAL(5,2),
    paid_status BOOLEAN DEFAULT FALSE,
    paid_date DATE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    manager_id INT,
    location_id INT
);

-- Employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(20),
    salary DECIMAL(10,2),
    manager_id INT,
    department_id INT
);

-- Jobs table
CREATE TABLE jobs (
    job_id VARCHAR(20) PRIMARY KEY,
    job_title VARCHAR(50),
    min_salary INT,
    max_salary INT
);

-- Job History table
CREATE TABLE job_history (
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(20),
    department_id INT
);

-- Locations table
CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    street_address VARCHAR(100),
    postal_code VARCHAR(20),
    city VARCHAR(50),
    state_province VARCHAR(50),
    country_id CHAR(2)
);

-- Job Grades table
CREATE TABLE job_grades (
    grade_level VARCHAR(2) PRIMARY KEY,
    lowest_salary INT NOT NULL,
    highest_salary INT NOT NULL
);

-- Insert test data - Publishers (5 records)
INSERT INTO publishers (publisher_id, name, address, phone, email) VALUES
(1, 'Penguin Random House', '1745 Broadway, New York, NY 10019', '212-782-9000', 'contact@penguinrandomhouse.com'),
(2, 'HarperCollins', '195 Broadway, New York, NY 10007', '212-207-7000', 'info@harpercollins.com'),
(3, 'O''Reilly Media', '1005 Gravenstein Highway North, Sebastopol, CA 95472', '707-827-7000', 'info@oreilly.com'),
(4, 'Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020', '212-698-7000', 'publicity@simonandschuster.com'),
(5, 'Wiley', '111 River Street, Hoboken, NJ 07030', '201-748-6000', 'customer@wiley.com');

-- Insert test data - Authors (6 records)
INSERT INTO authors (author_id, name, birth_year, nationality) VALUES
(1, 'Robert C. Martin', 1952, 'American'),
(2, 'Joshua Bloch', 1961, 'American'),
(3, 'Martin Fowler', 1963, 'British'),
(4, 'Erich Gamma', 1961, 'Swiss'),
(5, 'Kent Beck', 1961, 'American'),
(6, 'Eric Evans', 1962, 'American');

-- Insert test data - Members (5 records)
INSERT INTO members (member_id, full_name, email, phone, join_date, membership_status) VALUES
(1, 'John Smith', 'john.smith@email.com', '555-0101', '2023-01-15', 'ACTIVE'),
(2, 'Emma Johnson', 'emma.j@email.com', '555-0102', '2023-02-20', 'ACTIVE'),
(3, 'Michael Brown', 'michael.brown@email.com', '555-0103', '2023-03-10', 'ACTIVE'),
(4, 'Sarah Davis', 'sarah.davis@email.com', '555-0104', '2023-04-05', 'ACTIVE'),
(5, 'James Wilson', 'james.w@email.com', '555-0105', '2023-05-12', 'ACTIVE');

-- Insert test data - Books (8 records)
INSERT INTO books (book_id, title, isbn, publication_year, publisher_id, total_copies, available_copies) VALUES
(1, 'Clean Code: A Handbook of Agile Software Craftsmanship', '9780132350884', 2008, 3, 5, 5),
(2, 'Effective Java', '9780134685991', 2017, 3, 3, 3),
(3, 'Refactoring: Improving the Design of Existing Code', '9780201485677', 1999, 3, 4, 4),
(4, 'Design Patterns: Elements of Reusable Object-Oriented Software', '9780201633610', 1994, 1, 3, 3),
(5, 'Test-Driven Development: By Example', '9780321146533', 2002, 3, 2, 2),
(6, 'Domain-Driven Design: Tackling Complexity in the Heart of Software', '9780321125217', 2003, 1, 3, 3),
(7, 'The Pragmatic Programmer', '9780201616224', 1999, 3, 4, 4),
(8, 'Introduction to Algorithms', '9780262033848', 2009, 4, 2, 2);

-- Insert test data - Book_Authors (8 records)
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 1), (7, 3);

-- Insert test data - Loans (5+ records)
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, 1, '2024-01-10', '2024-01-24', '2024-01-20', 'RETURNED'),
(2, 2, 2, '2024-01-15', '2024-01-29', '2024-01-28', 'RETURNED'),
(3, 3, 3, '2024-01-20', '2024-02-03', NULL, 'BORROWED'),
(4, 4, 4, '2024-01-22', '2024-02-05', NULL, 'BORROWED'),
(5, 5, 5, '2024-01-05', '2024-01-19', '2024-01-25', 'RETURNED'),
(6, 1, 5, '2026-05-13', '2026-05-27', '2026-05-13', 'RETURNED'),
(7, 4, 1, '2026-05-24', '2026-06-07', NULL, 'BORROWED');

-- Insert test data - Fines
INSERT INTO fines (fine_id, loan_id, amount, paid_status, paid_date) VALUES
(1, 5, 3.00, TRUE, '2024-01-26'),
(2, 4, 419.50, FALSE, NULL);

-- Insert HR/Company data - Departments
INSERT INTO departments (department_id, department_name, manager_id, location_id) VALUES
(10, 'Administration', 200, 1700),
(20, 'Marketing', 201, 1800),
(50, 'Shipping', 124, 1500),
(60, 'IT', 103, 1400),
(80, 'Sales', 149, 2500),
(90, 'Executive', 100, 1700),
(110, 'Accounting', 205, 1700),
(100, 'Finance', 108, 1700);

-- Insert HR data - Employees
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, salary, manager_id, department_id) VALUES
(100, 'Steven', 'King', 'steven.king@company.com', '2003-06-17', 'AD_PRES', 24000, NULL, 90),
(101, 'Neena', 'Kochhar', 'neena.kochhar@company.com', '2005-09-21', 'AD_VP', 17000, 100, 90),
(102, 'Lex', 'De Haan', 'lex.dehaan@company.com', '2001-01-13', 'AD_VP', 17000, 100, 90),
(103, 'Alexander', 'Hunold', 'alexander.hunold@company.com', '2006-01-03', 'IT_PROG', 9000, 102, 60),
(104, 'Bruce', 'Ernst', 'bruce.ernst@company.com', '2007-05-21', 'IT_PROG', 6000, 103, 60),
(105, 'David', 'Austin', 'david.austin@company.com', '2005-06-25', 'IT_PROG', 4800, 103, 60),
(106, 'Valli', 'Pataballa', 'valli.pataballa@company.com', '2006-02-05', 'IT_PROG', 4800, 103, 60),
(107, 'Diana', 'Lorentz', 'diana.lorentz@company.com', '2007-02-07', 'IT_PROG', 4200, 103, 60),
(108, 'Nancy', 'Greenberg', 'nancy.greenberg@company.com', '2002-08-17', 'FI_MGR', 12000, 101, 110),
(109, 'Daniel', 'Faviet', 'daniel.faviet@company.com', '2002-08-16', 'FI_ACCOUNT', 9000, 108, 110);

-- Insert HR data - Jobs
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES
('AD_PRES', 'President', 20080, 40000),
('AD_VP', 'Administration Vice President', 15000, 30000),
('IT_PROG', 'Programmer', 4000, 10000),
('FI_MGR', 'Finance Manager', 8200, 16000),
('FI_ACCOUNT', 'Accountant', 4200, 9000),
('AC_MGR', 'Accounting Manager', 8200, 16000),
('AC_ACCOUNT', 'Public Accountant', 4200, 9000);

-- Insert HR data - Job History
INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id) VALUES
(101, '1997-09-21', '2001-10-27', 'AC_ACCOUNT', 110),
(101, '2001-10-28', '2005-03-15', 'AC_MGR', 110),
(102, '2001-01-13', '2006-07-24', 'IT_PROG', 60),
(103, '1999-03-03', '2004-02-22', 'MK_REP', 20);

-- Insert HR data - Locations
INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id) VALUES
(1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
(1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
(1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
(1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
(2500, 'Magdalene Centre', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');

-- Insert HR data - Job Grades
INSERT INTO job_grades (grade_level, lowest_salary, highest_salary) VALUES
('A', 1000, 2999),
('B', 3000, 5999),
('C', 6000, 9999),
('D', 10000, 14999),
('E', 15000, 24999),
('F', 25000, 40000);

-- Verification queries
SELECT 'publishers' as table_name, COUNT(*) FROM publishers
UNION ALL
SELECT 'authors', COUNT(*) FROM authors
UNION ALL
SELECT 'members', COUNT(*) FROM members
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'book_authors', COUNT(*) FROM book_authors
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'fines', COUNT(*) FROM fines;
