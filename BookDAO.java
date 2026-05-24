 package com.library.dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.library.db.DatabaseConnection;
import com.library.model.Book;
import com.library.model.Loan;

public class BookDAO {
    
    public List<Book> getAllBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, p.name as publisher_name FROM books b " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.publisher_id " +
                     "ORDER BY b.title";
        
        try (Statement stmt = DatabaseConnection.getConnection().createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setPublisherId(rs.getInt("publisher_id"));
                book.setPublisherName(rs.getString("publisher_name"));
                book.setTotalCopies(rs.getInt("total_copies"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                books.add(book);
            }
        }
        return books;
    }
    
    public Book getBookById(int bookId) throws SQLException {
        String sql = "SELECT b.*, p.name as publisher_name FROM books b " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.publisher_id " +
                     "WHERE b.book_id = ?";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, bookId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setPublisherId(rs.getInt("publisher_id"));
                book.setPublisherName(rs.getString("publisher_name"));
                book.setTotalCopies(rs.getInt("total_copies"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                return book;
            }
        }
        return null;
    }
    
    public List<Book> searchBooks(String keyword) throws SQLException {
        List<Book> books = new ArrayList<>();
        // Using ILIKE directly for PostgreSQL (case-insensitive search)
        String sql = "SELECT DISTINCT b.*, p.name as publisher_name FROM books b " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.publisher_id " +
                     "LEFT JOIN book_authors ba ON b.book_id = ba.book_id " +
                     "LEFT JOIN authors a ON ba.author_id = a.author_id " +
                     "WHERE b.title ILIKE ? OR a.name ILIKE ? OR p.name ILIKE ? " +
                     "ORDER BY b.title";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setPublisherId(rs.getInt("publisher_id"));
                book.setPublisherName(rs.getString("publisher_name"));
                book.setTotalCopies(rs.getInt("total_copies"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                books.add(book);
            }
        }
        return books;
    }
    
    public boolean borrowBook(int bookId, int memberId) throws SQLException {
        // Check if member has active loans (max 5)
        String checkMemberSql = "SELECT COUNT(*) FROM loans WHERE member_id = ? AND return_date IS NULL";
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(checkMemberSql)) {
            pstmt.setInt(1, memberId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) >= 5) {
                throw new SQLException("Member already has 5 active loans");
            }
        }
        
        // Check if book is available
        String checkBookSql = "SELECT available_copies FROM books WHERE book_id = ?";
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(checkBookSql)) {
            pstmt.setInt(1, bookId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt("available_copies") <= 0) {
                return false;
            }
        }
        
        // Create loan record
        String sql = "INSERT INTO loans (book_id, member_id, loan_date, status) VALUES (?, ?, CURRENT_DATE, 'BORROWED')";
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, bookId);
            pstmt.setInt(2, memberId);
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }
    
    public double returnBook(int loanId) throws SQLException {
        String getLoanSql = "SELECT book_id, loan_date FROM loans WHERE loan_id = ? AND return_date IS NULL";
        int bookId = -1;
        LocalDate loanDate = null;
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(getLoanSql)) {
            pstmt.setInt(1, loanId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                bookId = rs.getInt("book_id");
                loanDate = rs.getDate("loan_date").toLocalDate();
            } else {
                throw new SQLException("Loan not found or already returned");
            }
        }
        
        LocalDate dueDate = loanDate.plusDays(14);
        LocalDate returnDate = LocalDate.now();
        double fine = 0;
        if (returnDate.isAfter(dueDate)) {
            long daysLate = java.time.temporal.ChronoUnit.DAYS.between(dueDate, returnDate);
            fine = daysLate * 0.50;
        }
        
        String updateSql = "UPDATE loans SET return_date = ?, status = 'RETURNED' WHERE loan_id = ?";
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(updateSql)) {
            pstmt.setDate(1, Date.valueOf(returnDate));
            pstmt.setInt(2, loanId);
            pstmt.executeUpdate();
        }
        
        // Update available copies in books table
        String updateBookSql = "UPDATE books SET available_copies = available_copies + 1 WHERE book_id = ?";
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(updateBookSql)) {
            pstmt.setInt(1, bookId);
            pstmt.executeUpdate();
        }
        
        if (fine > 0) {
            String fineSql = "INSERT INTO fines (loan_id, amount, paid_status) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(fineSql)) {
                pstmt.setInt(1, loanId);
                pstmt.setDouble(2, fine);
                pstmt.setBoolean(3, false);
                pstmt.executeUpdate();
            }
        }
        
        return fine;
    }
    
    public List<Loan> getActiveLoans() throws SQLException {
        List<Loan> loans = new ArrayList<>();
        String sql = "SELECT l.*, b.title as book_title, m.full_name as member_name " +
                     "FROM loans l " +
                     "JOIN books b ON l.book_id = b.book_id " +
                     "JOIN members m ON l.member_id = m.member_id " +
                     "WHERE l.return_date IS NULL " +
                     "ORDER BY l.loan_date DESC";
        
        try (Statement stmt = DatabaseConnection.getConnection().createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Loan loan = new Loan();
                loan.setLoanId(rs.getInt("loan_id"));
                loan.setBookId(rs.getInt("book_id"));
                loan.setBookTitle(rs.getString("book_title"));
                loan.setMemberId(rs.getInt("member_id"));
                loan.setMemberName(rs.getString("member_name"));
                
                Date loanDate = rs.getDate("loan_date");
                if (loanDate != null) loan.setLoanDate(loanDate.toLocalDate());
                
                Date dueDate = rs.getDate("due_date");
                if (dueDate != null) loan.setDueDate(dueDate.toLocalDate());
                
                loan.setStatus(rs.getString("status"));
                loans.add(loan);
            }
        }
        return loans;
    }
}