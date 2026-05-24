 package com.library.model;

import java.time.LocalDate;

public class Member {
    private int memberId;
    private String fullName;
    private String email;
    private String phone;
    private LocalDate joinDate;
    private String membershipStatus;
    
    public Member() {}
    
    public Member(int memberId, String fullName, String email, String phone, 
                  LocalDate joinDate, String membershipStatus) {
        this.memberId = memberId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.joinDate = joinDate;
        this.membershipStatus = membershipStatus;
    }
    
    // Getters
    public int getMemberId() { return memberId; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public LocalDate getJoinDate() { return joinDate; }
    public String getMembershipStatus() { return membershipStatus; }
    
    // Setters
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setJoinDate(LocalDate joinDate) { this.joinDate = joinDate; }
    public void setMembershipStatus(String membershipStatus) { this.membershipStatus = membershipStatus; }
    
    @Override
    public String toString() {
        return fullName + " (" + email + ")";
    }
}