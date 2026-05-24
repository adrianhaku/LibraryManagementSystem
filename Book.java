 package com.library.model;

public class Book {
    private int bookId;
    private String title;
    private String isbn;
    private int publicationYear;
    private int publisherId;
    private String publisherName;
    private int totalCopies;
    private int availableCopies;
    
    public Book() {}
    
    public Book(int bookId, String title, String isbn, int publicationYear, 
                int publisherId, int totalCopies, int availableCopies) {
        this.bookId = bookId;
        this.title = title;
        this.isbn = isbn;
        this.publicationYear = publicationYear;
        this.publisherId = publisherId;
        this.totalCopies = totalCopies;
        this.availableCopies = availableCopies;
    }
    
    // Getters
    public int getBookId() { return bookId; }
    public String getTitle() { return title; }
    public String getIsbn() { return isbn; }
    public int getPublicationYear() { return publicationYear; }
    public int getPublisherId() { return publisherId; }
    public String getPublisherName() { return publisherName; }
    public int getTotalCopies() { return totalCopies; }
    public int getAvailableCopies() { return availableCopies; }
    
    // Setters
    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setTitle(String title) { this.title = title; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public void setPublicationYear(int publicationYear) { this.publicationYear = publicationYear; }
    public void setPublisherId(int publisherId) { this.publisherId = publisherId; }
    public void setPublisherName(String publisherName) { this.publisherName = publisherName; }
    public void setTotalCopies(int totalCopies) { this.totalCopies = totalCopies; }
    public void setAvailableCopies(int availableCopies) { this.availableCopies = availableCopies; }
    
    @Override
    public String toString() {
        return title + " (Available: " + availableCopies + "/" + totalCopies + ")";
    }
}