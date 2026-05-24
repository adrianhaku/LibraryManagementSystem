 package com.library.model;

public class Author {
    private int authorId;
    private String name;
    private int birthYear;
    private String nationality;
    
    public Author() {}
    
    public Author(int authorId, String name, int birthYear, String nationality) {
        this.authorId = authorId;
        this.name = name;
        this.birthYear = birthYear;
        this.nationality = nationality;
    }
    
    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getBirthYear() { return birthYear; }
    public void setBirthYear(int birthYear) { this.birthYear = birthYear; }
    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }
    
    @Override
    public String toString() {
        return name;
    }
}