-- Library Management System - MySQL Schema

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

-- Insert test data
INSERT INTO publishers (name, address) VALUES
('O''Reilly Media', 'Sebastopol, CA'),
('Penguin Random House', 'New York, NY'),
('HarperCollins', 'New York, NY');

INSERT INTO authors (name) VALUES
('Robert C. Martin'),
('Joshua Bloch'),
('Martin Fowler');

INSERT INTO members (full_name, email, phone) VALUES
('John Smith', 'john@email.com', '555-0101'),
('Emma Johnson', 'emma@email.com', '555-0102'),
('Michael Brown', 'michael@email.com', '555-0103');

INSERT INTO books (title, isbn, publisher_id, total_copies, available_copies) VALUES
('Clean Code', '9780132350884', 1, 5, 5),
('Effective Java', '9780134685991', 1, 3, 3),
('Refactoring', '9780201485677', 1, 4, 4);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3);

INSERT INTO loans (book_id, member_id, loan_date, status) VALUES
(1, 1, CURDATE(), 'BORROWED'),
(2, 2, CURDATE(), 'BORROWED');

SELECT 'Setup complete!' as Status;
