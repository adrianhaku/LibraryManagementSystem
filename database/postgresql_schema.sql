-- Library Management System - PostgreSQL Schema

-- Drop tables if exist
DROP TABLE IF EXISTS fines CASCADE;
DROP TABLE IF EXISTS loans CASCADE;
DROP TABLE IF EXISTS book_authors CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS members CASCADE;
DROP TABLE IF EXISTS publishers CASCADE;

-- Publishers table
CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Authors table
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Members table
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Books table
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn CHAR(13) UNIQUE,
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    total_copies INTEGER DEFAULT 1,
    available_copies INTEGER DEFAULT 1
);

-- Book_Authors junction table
CREATE TABLE book_authors (
    book_id INTEGER REFERENCES books(book_id) ON DELETE CASCADE,
    author_id INTEGER REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    member_id INTEGER NOT NULL REFERENCES members(member_id),
    loan_date DATE DEFAULT CURRENT_DATE,
    due_date DATE,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'BORROWED'
);

-- Fines table
CREATE TABLE fines (
    fine_id SERIAL PRIMARY KEY,
    loan_id INTEGER UNIQUE NOT NULL REFERENCES loans(loan_id),
    amount DECIMAL(5,2),
    paid_status BOOLEAN DEFAULT FALSE,
    paid_date DATE
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

-- Verification
SELECT COUNT(*) as books_count FROM books;
