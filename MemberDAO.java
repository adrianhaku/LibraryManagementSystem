package com.library.dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.library.db.DatabaseConnection;
import com.library.model.Member;

public class MemberDAO {
    
    public List<Member> getAllMembers() throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members ORDER BY full_name";
        
        try (Statement stmt = DatabaseConnection.getConnection().createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setFullName(rs.getString("full_name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                
                Date joinDate = rs.getDate("join_date");
                if (joinDate != null) member.setJoinDate(joinDate.toLocalDate());
                
                member.setMembershipStatus(rs.getString("membership_status"));
                members.add(member);
            }
        }
        return members;
    }
    
    public Member getMemberById(int memberId) throws SQLException {
        String sql = "SELECT * FROM members WHERE member_id = ?";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setFullName(rs.getString("full_name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                
                Date joinDate = rs.getDate("join_date");
                if (joinDate != null) member.setJoinDate(joinDate.toLocalDate());
                
                member.setMembershipStatus(rs.getString("membership_status"));
                return member;
            }
        }
        return null;
    }
    
    public void addMember(Member member) throws SQLException {
        String sql = "INSERT INTO members (full_name, email, phone, join_date, membership_status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, member.getFullName());
            pstmt.setString(2, member.getEmail());
            pstmt.setString(3, member.getPhone());
            pstmt.setDate(4, Date.valueOf(member.getJoinDate()));
            pstmt.setString(5, member.getMembershipStatus());
            pstmt.executeUpdate();
            
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                member.setMemberId(rs.getInt(1));
            }
        }
    }
    
    public void updateMember(Member member) throws SQLException {
        String sql = "UPDATE members SET full_name=?, email=?, phone=?, membership_status=? WHERE member_id=?";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            pstmt.setString(1, member.getFullName());
            pstmt.setString(2, member.getEmail());
            pstmt.setString(3, member.getPhone());
            pstmt.setString(4, member.getMembershipStatus());
            pstmt.setInt(5, member.getMemberId());
            pstmt.executeUpdate();
        }
    }
    
    public void deleteMember(int memberId) throws SQLException {
        String sql = "DELETE FROM members WHERE member_id = ?";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            pstmt.executeUpdate();
        }
    }
    
    public List<Member> searchMembers(String keyword) throws SQLException {
        List<Member> members = new ArrayList<>();
        // Using ILIKE directly for PostgreSQL (case-insensitive search)
        String sql = "SELECT * FROM members WHERE full_name ILIKE ? OR email ILIKE ?";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setFullName(rs.getString("full_name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                
                Date joinDate = rs.getDate("join_date");
                if (joinDate != null) member.setJoinDate(joinDate.toLocalDate());
                
                member.setMembershipStatus(rs.getString("membership_status"));
                members.add(member);
            }
        }
        return members;
    }
    
    public int getActiveLoanCount(int memberId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM loans WHERE member_id = ? AND return_date IS NULL";
        
        try (PreparedStatement pstmt = DatabaseConnection.getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}