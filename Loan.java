 package com.library.model;

import java.time.LocalDate;

public class Loan {
    private int loanId;
    private int bookId;
    private String bookTitle;
    private int memberId;
    private String memberName;
    private LocalDate loanDate;
    private LocalDate dueDate;
    private LocalDate returnDate;
    private String status;
    private double fineAmount;
    
    public Loan() {}
    
    // Getters
    public int getLoanId() { return loanId; }
    public int getBookId() { return bookId; }
    public String getBookTitle() { return bookTitle; }
    public int getMemberId() { return memberId; }
    public String getMemberName() { return memberName; }
    public LocalDate getLoanDate() { return loanDate; }
    public LocalDate getDueDate() { return dueDate; }
    public LocalDate getReturnDate() { return returnDate; }
    public String getStatus() { return status; }
    public double getFineAmount() { return fineAmount; }
    
    // Setters
    public void setLoanId(int loanId) { this.loanId = loanId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public void setLoanDate(LocalDate loanDate) { this.loanDate = loanDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }
    public void setReturnDate(LocalDate returnDate) { this.returnDate = returnDate; }
    public void setStatus(String status) { this.status = status; }
    public void setFineAmount(double fineAmount) { this.fineAmount = fineAmount; }
    
    @Override
    public String toString() {
        return "Loan #" + loanId + " - " + bookTitle + " (Due: " + dueDate + ")";
    }
}