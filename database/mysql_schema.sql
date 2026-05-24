 -- Library Management System - MySQL Schema (Simplified)

DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Authors table
CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Members table
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Books table
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn CHAR(13) UNIQUE,
    publisher_id INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- Book_Authors table
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'BORROWED',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Fines table
CREATE TABLE fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT UNIQUE NOT NULL,
    amount DECIMAL(5,2),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Insert test data
INSERT INTO publishers (name) VALUES ('O''Reilly Media'), ('Penguin Random House');

INSERT INTO authors (name) VALUES ('Robert C. Martin'), ('Joshua Bloch');

INSERT INTO members (full_name, email) VALUES ('John Smith', 'john@email.com'), ('Emma Johnson', 'emma@email.com');

INSERT INTO books (title, isbn, publisher_id, total_copies, available_copies) VALUES
('Clean Code', '9780132350884', 1, 5, 5),
('Effective Java', '9780134685991', 1, 3, 3);

INSERT INTO book_authors (book_id, author_id) VALUES (1, 1), (2, 2);

INSERT INTO loans (book_id, member_id) VALUES (1, 1), (2, 2);

SELECT COUNT(*) as books_count FROM books;
