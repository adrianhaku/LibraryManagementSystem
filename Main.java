 package com.library;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.library.dao.BookDAO;
import com.library.dao.MemberDAO;
import com.library.db.DatabaseConnection;
import com.library.model.Book;
import com.library.model.Loan;
import com.library.model.Member;

import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Dialog;
import javafx.scene.control.Label;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.Region;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Main extends Application {
    
    private BookDAO bookDAO = new BookDAO();
    private MemberDAO memberDAO = new MemberDAO();
    
    // Book Table
    private TableView<Book> bookTable = new TableView<>();
    private ObservableList<Book> bookList = FXCollections.observableArrayList();
    
    // Member Table
    private TableView<Member> memberTable = new TableView<>();
    private ObservableList<Member> memberList = FXCollections.observableArrayList();
    
    // Loan Table
    private TableView<Loan> loanTable = new TableView<>();
    private ObservableList<Loan> loanList = FXCollections.observableArrayList();
    
    // Status Bar Labels
    private Label statusLabel = new Label("Ready");
    private Label bookCountLabel = new Label();
    private Label memberCountLabel = new Label();
    private Label loanCountLabel = new Label();
    
    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("📚 Library Management System");
        
        // Load CSS
        Scene scene = new Scene(createMainLayout(), 1200, 800);
        scene.getStylesheets().add(getClass().getResource("/style.css").toExternalForm());
        
        primaryStage.setScene(scene);
        primaryStage.show();
        
        // Load data
        loadBooksData();
        loadMembersData();
        loadLoansData();
        updateStatusBar();
        testDatabaseConnection();
    }
    
    private BorderPane createMainLayout() {
        BorderPane mainLayout = new BorderPane();
        
        // Header
        mainLayout.setTop(createHeader());
        
        // Center - Tab Pane
        mainLayout.setCenter(createTabPane());
        
        // Footer - Status Bar
        mainLayout.setBottom(createStatusBar());
        
        return mainLayout;
    }
    
    private VBox createHeader() {
        VBox header = new VBox();
        header.setStyle("-fx-background-color: linear-gradient(to right, #1976D2, #64B5F6);");
        header.setPadding(new Insets(20, 30, 20, 30));
        
        Label titleLabel = new Label("📖 Library Management System");
        titleLabel.setStyle("-fx-text-fill: white; -fx-font-size: 28px; -fx-font-weight: bold;");
        
        Label subtitleLabel = new Label("Manage Books, Members, and Loans Efficiently");
        subtitleLabel.setStyle("-fx-text-fill: rgba(255,255,255,0.9); -fx-font-size: 14px;");
        
        HBox statsBox = new HBox(30);
        statsBox.setAlignment(Pos.CENTER_RIGHT);
        statsBox.setStyle("-fx-padding: 10 0 0 0;");
        
        bookCountLabel.setStyle("-fx-text-fill: white; -fx-font-size: 12px;");
        memberCountLabel.setStyle("-fx-text-fill: white; -fx-font-size: 12px;");
        loanCountLabel.setStyle("-fx-text-fill: white; -fx-font-size: 12px;");
        
        statsBox.getChildren().addAll(bookCountLabel, memberCountLabel, loanCountLabel);
        
        VBox titleBox = new VBox(5);
        titleBox.getChildren().addAll(titleLabel, subtitleLabel);
        
        HBox headerContent = new HBox();
        headerContent.setAlignment(Pos.CENTER_LEFT);
        HBox.setHgrow(titleBox, Priority.ALWAYS);
        headerContent.getChildren().addAll(titleBox, statsBox);
        
        header.getChildren().add(headerContent);
        return header;
    }
    
    private TabPane createTabPane() {
        TabPane tabPane = new TabPane();
        tabPane.setTabClosingPolicy(TabPane.TabClosingPolicy.UNAVAILABLE);
        tabPane.setPadding(new Insets(10));
        
        Tab booksTab = new Tab("📚 Books", createBooksPanel());
        Tab membersTab = new Tab("👥 Members", createMembersPanel());
        Tab loansTab = new Tab("📋 Active Loans", createLoansPanel());
        Tab returnsTab = new Tab("🔄 Returns", createReturnsPanel());
        
        booksTab.setClosable(false);
        membersTab.setClosable(false);
        loansTab.setClosable(false);
        returnsTab.setClosable(false);
        
        tabPane.getTabs().addAll(booksTab, membersTab, loansTab, returnsTab);
        
        return tabPane;
    }
    
    private VBox createStatusBar() {
        HBox statusBar = new HBox(20);
        statusBar.setStyle("-fx-background-color: #e0e0e0; -fx-padding: 8 15 8 15;");
        statusBar.setAlignment(Pos.CENTER_LEFT);
        
        Label statusIcon = new Label("🟢");
        statusLabel.setStyle("-fx-font-size: 12px; -fx-text-fill: #666;");
        
        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);
        
        Label versionLabel = new Label("Version 2.0 | PostgreSQL");
        versionLabel.setStyle("-fx-font-size: 11px; -fx-text-fill: #999;");
        
        statusBar.getChildren().addAll(statusIcon, statusLabel, spacer, versionLabel);
        
        VBox statusBox = new VBox();
        statusBox.getChildren().add(statusBar);
        return statusBox;
    }
    
    private VBox createBooksPanel() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new Insets(20));
        vbox.setStyle("-fx-background-color: #f5f5f5;");
        
        // Search section with card design
        VBox searchCard = new VBox(10);
        searchCard.getStyleClass().add("card");
        searchCard.setPadding(new Insets(15));
        
        HBox searchBox = new HBox(10);
        TextField searchField = new TextField();
        searchField.setPromptText("🔍 Search by title, author, or publisher...");
        searchField.setPrefWidth(400);
        
        Button searchButton = new Button("🔍 Search");
        Button refreshButton = new Button("🔄 Refresh");
        Button borrowButton = new Button("📖 Borrow Selected");
        borrowButton.getStyleClass().add("button-success");
        
        searchBox.getChildren().addAll(searchField, searchButton, refreshButton, borrowButton);
        
        Label statsLabel = new Label("📊 Book Collection");
        statsLabel.getStyleClass().add("label-subtitle");
        
        searchCard.getChildren().addAll(statsLabel, searchBox);
        
        // Setup book table
        setupBookTable();
        
        // Search action
        searchButton.setOnAction(e -> {
            try {
                String keyword = searchField.getText();
                if (keyword != null && !keyword.trim().isEmpty()) {
                    List<Book> books = bookDAO.searchBooks(keyword);
                    bookList.clear();
                    bookList.addAll(books);
                    statusLabel.setText("Found " + books.size() + " book(s) matching '" + keyword + "'");
                } else {
                    loadBooksData();
                }
            } catch (SQLException ex) {
                showError("Search failed: " + ex.getMessage());
            }
        });
        
        // Refresh action
        refreshButton.setOnAction(e -> loadBooksData());
        
        // Borrow action
        borrowButton.setOnAction(e -> showBorrowDialog());
        
        vbox.getChildren().addAll(searchCard, bookTable);
        return vbox;
    }
    
    private void setupBookTable() {
        bookTable.setPlaceholder(new Label("📭 No books found. Click Refresh to load data."));
        
        TableColumn<Book, Integer> idCol = new TableColumn<>("ID");
        idCol.setCellValueFactory(new PropertyValueFactory<>("bookId"));
        idCol.setPrefWidth(50);
        idCol.setStyle("-fx-alignment: CENTER;");
        
        TableColumn<Book, String> titleCol = new TableColumn<>("📖 Title");
        titleCol.setCellValueFactory(new PropertyValueFactory<>("title"));
        titleCol.setPrefWidth(400);
        
        TableColumn<Book, String> isbnCol = new TableColumn<>("ISBN");
        isbnCol.setCellValueFactory(new PropertyValueFactory<>("isbn"));
        isbnCol.setPrefWidth(130);
        
        TableColumn<Book, String> publisherCol = new TableColumn<>("🏢 Publisher");
        publisherCol.setCellValueFactory(new PropertyValueFactory<>("publisherName"));
        publisherCol.setPrefWidth(150);
        
        TableColumn<Book, Integer> copiesCol = new TableColumn<>("📊 Available");
        copiesCol.setCellValueFactory(new PropertyValueFactory<>("availableCopies"));
        copiesCol.setPrefWidth(80);
        copiesCol.setStyle("-fx-alignment: CENTER;");
        
        TableColumn<Book, Integer> totalCol = new TableColumn<>("📚 Total");
        totalCol.setCellValueFactory(new PropertyValueFactory<>("totalCopies"));
        totalCol.setPrefWidth(80);
        totalCol.setStyle("-fx-alignment: CENTER;");
        
        bookTable.getColumns().addAll(idCol, titleCol, isbnCol, publisherCol, copiesCol, totalCol);
        bookTable.setItems(bookList);
    }
    
    private void loadBooksData() {
        try {
            List<Book> books = bookDAO.getAllBooks();
            bookList.clear();
            bookList.addAll(books);
            bookCountLabel.setText("📚 Books: " + books.size());
            statusLabel.setText("Loaded " + books.size() + " books");
            System.out.println("Loaded " + books.size() + " books");
        } catch (SQLException e) {
            showError("Failed to load books: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void showBorrowDialog() {
        Book selectedBook = bookTable.getSelectionModel().getSelectedItem();
        if (selectedBook == null) {
            showError("Please select a book to borrow");
            return;
        }
        
        if (selectedBook.getAvailableCopies() <= 0) {
            showError("This book is not available for borrowing");
            return;
        }
        
        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Borrow Book");
        dialog.setHeaderText("📖 Borrow: " + selectedBook.getTitle());
        
        GridPane grid = new GridPane();
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(20));
        
        ComboBox<Member> memberCombo = new ComboBox<>();
        memberCombo.setItems(memberList);
        memberCombo.setPromptText("Select Member");
        memberCombo.setPrefWidth(250);
        
        grid.add(new Label("👤 Select Member:"), 0, 0);
        grid.add(memberCombo, 1, 0);
        
        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        
        dialog.showAndWait().ifPresent(response -> {
            if (response == ButtonType.OK && memberCombo.getValue() != null) {
                try {
                    Member member = memberCombo.getValue();
                    boolean success = bookDAO.borrowBook(selectedBook.getBookId(), member.getMemberId());
                    if (success) {
                        showInfo("✅ Book borrowed successfully by " + member.getFullName());
                        loadBooksData();
                        loadLoansData();
                        updateStatusBar();
                        statusLabel.setText("Book borrowed: " + selectedBook.getTitle());
                    } else {
                        showError("Failed to borrow book. It may not be available.");
                    }
                } catch (SQLException e) {
                    showError("Error borrowing book: " + e.getMessage());
                }
            }
        });
    }
    
    private VBox createMembersPanel() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new Insets(20));
        vbox.setStyle("-fx-background-color: #f5f5f5;");
        
        VBox searchCard = new VBox(10);
        searchCard.getStyleClass().add("card");
        searchCard.setPadding(new Insets(15));
        
        HBox searchBox = new HBox(10);
        TextField searchField = new TextField();
        searchField.setPromptText("🔍 Search members by name or email...");
        searchField.setPrefWidth(300);
        
        Button searchButton = new Button("🔍 Search");
        Button refreshButton = new Button("🔄 Refresh");
        Button addMemberButton = new Button("➕ Add Member");
        addMemberButton.getStyleClass().add("button-success");
        
        searchBox.getChildren().addAll(searchField, searchButton, refreshButton, addMemberButton);
        
        Label statsLabel = new Label("👥 Library Members");
        statsLabel.getStyleClass().add("label-subtitle");
        
        searchCard.getChildren().addAll(statsLabel, searchBox);
        
        setupMemberTable();
        
        searchButton.setOnAction(e -> {
            try {
                String keyword = searchField.getText();
                if (keyword != null && !keyword.trim().isEmpty()) {
                    List<Member> members = memberDAO.searchMembers(keyword);
                    memberList.clear();
                    memberList.addAll(members);
                    statusLabel.setText("Found " + members.size() + " member(s) matching '" + keyword + "'");
                } else {
                    loadMembersData();
                }
            } catch (SQLException ex) {
                showError("Search failed: " + ex.getMessage());
            }
        });
        
        refreshButton.setOnAction(e -> loadMembersData());
        addMemberButton.setOnAction(e -> showAddMemberDialog());
        
        vbox.getChildren().addAll(searchCard, memberTable);
        return vbox;
    }
    
    private void setupMemberTable() {
        memberTable.setPlaceholder(new Label("👥 No members found. Click Add Member to add one."));
        
        TableColumn<Member, Integer> idCol = new TableColumn<>("ID");
        idCol.setCellValueFactory(new PropertyValueFactory<>("memberId"));
        idCol.setPrefWidth(50);
        
        TableColumn<Member, String> nameCol = new TableColumn<>("👤 Name");
        nameCol.setCellValueFactory(new PropertyValueFactory<>("fullName"));
        nameCol.setPrefWidth(200);
        
        TableColumn<Member, String> emailCol = new TableColumn<>("📧 Email");
        emailCol.setCellValueFactory(new PropertyValueFactory<>("email"));
        emailCol.setPrefWidth(200);
        
        TableColumn<Member, String> phoneCol = new TableColumn<>("📞 Phone");
        phoneCol.setCellValueFactory(new PropertyValueFactory<>("phone"));
        phoneCol.setPrefWidth(120);
        
        TableColumn<Member, String> statusCol = new TableColumn<>("📌 Status");
        statusCol.setCellValueFactory(new PropertyValueFactory<>("membershipStatus"));
        statusCol.setPrefWidth(100);
        
        TableColumn<Member, String> dateCol = new TableColumn<>("📅 Join Date");
        dateCol.setCellValueFactory(new PropertyValueFactory<>("joinDate"));
        dateCol.setPrefWidth(100);
        
        memberTable.getColumns().addAll(idCol, nameCol, emailCol, phoneCol, statusCol, dateCol);
        memberTable.setItems(memberList);
    }
    
    private void loadMembersData() {
        try {
            List<Member> members = memberDAO.getAllMembers();
            memberList.clear();
            memberList.addAll(members);
            memberCountLabel.setText("👥 Members: " + members.size());
            statusLabel.setText("Loaded " + members.size() + " members");
            System.out.println("Loaded " + members.size() + " members");
        } catch (SQLException e) {
            showError("Failed to load members: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void showAddMemberDialog() {
        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Add New Member");
        dialog.setHeaderText("➕ Enter member details");
        
        GridPane grid = new GridPane();
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(20));
        
        TextField nameField = new TextField();
        nameField.setPromptText("Full Name");
        TextField emailField = new TextField();
        emailField.setPromptText("Email Address");
        TextField phoneField = new TextField();
        phoneField.setPromptText("Phone Number");
        
        grid.add(new Label("👤 Full Name:"), 0, 0);
        grid.add(nameField, 1, 0);
        grid.add(new Label("📧 Email:"), 0, 1);
        grid.add(emailField, 1, 1);
        grid.add(new Label("📞 Phone:"), 0, 2);
        grid.add(phoneField, 1, 2);
        
        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        
        dialog.showAndWait().ifPresent(response -> {
            if (response == ButtonType.OK) {
                try {
                    Member member = new Member();
                    member.setFullName(nameField.getText());
                    member.setEmail(emailField.getText());
                    member.setPhone(phoneField.getText());
                    member.setJoinDate(LocalDate.now());
                    member.setMembershipStatus("ACTIVE");
                    
                    memberDAO.addMember(member);
                    showInfo("✅ Member added successfully!");
                    loadMembersData();
                    updateStatusBar();
                    statusLabel.setText("New member added: " + member.getFullName());
                } catch (SQLException e) {
                    showError("Failed to add member: " + e.getMessage());
                }
            }
        });
    }
    
    private VBox createLoansPanel() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new Insets(20));
        vbox.setStyle("-fx-background-color: #f5f5f5;");
        
        VBox infoCard = new VBox(10);
        infoCard.getStyleClass().add("card");
        infoCard.setPadding(new Insets(15));
        
        Label titleLabel = new Label("📋 Currently Active Loans");
        titleLabel.setStyle("-fx-font-size: 18px; -fx-font-weight: bold; -fx-text-fill: #1976D2;");
        
        infoCard.getChildren().add(titleLabel);
        
        setupLoanTable();
        
        Button refreshButton = new Button("🔄 Refresh");
        refreshButton.setOnAction(e -> loadLoansData());
        
        vbox.getChildren().addAll(infoCard, loanTable, refreshButton);
        return vbox;
    }
    
    private void setupLoanTable() {
        loanTable.setPlaceholder(new Label("📭 No active loans at the moment."));
        
        TableColumn<Loan, Integer> idCol = new TableColumn<>("Loan ID");
        idCol.setCellValueFactory(new PropertyValueFactory<>("loanId"));
        idCol.setPrefWidth(70);
        
        TableColumn<Loan, String> bookCol = new TableColumn<>("📖 Book");
        bookCol.setCellValueFactory(new PropertyValueFactory<>("bookTitle"));
        bookCol.setPrefWidth(350);
        
        TableColumn<Loan, String> memberCol = new TableColumn<>("👤 Member");
        memberCol.setCellValueFactory(new PropertyValueFactory<>("memberName"));
        memberCol.setPrefWidth(200);
        
        TableColumn<Loan, LocalDate> loanDateCol = new TableColumn<>("📅 Loan Date");
        loanDateCol.setCellValueFactory(new PropertyValueFactory<>("loanDate"));
        loanDateCol.setPrefWidth(120);
        
        TableColumn<Loan, LocalDate> dueDateCol = new TableColumn<>("⏰ Due Date");
        dueDateCol.setCellValueFactory(new PropertyValueFactory<>("dueDate"));
        dueDateCol.setPrefWidth(120);
        
        TableColumn<Loan, String> statusCol = new TableColumn<>("📌 Status");
        statusCol.setCellValueFactory(new PropertyValueFactory<>("status"));
        statusCol.setPrefWidth(100);
        
        loanTable.getColumns().addAll(idCol, bookCol, memberCol, loanDateCol, dueDateCol, statusCol);
        loanTable.setItems(loanList);
    }
    
    private void loadLoansData() {
        try {
            List<Loan> loans = bookDAO.getActiveLoans();
            loanList.clear();
            loanList.addAll(loans);
            loanCountLabel.setText("📋 Loans: " + loans.size());
            statusLabel.setText("Loaded " + loans.size() + " active loans");
            System.out.println("Loaded " + loans.size() + " active loans");
        } catch (SQLException e) {
            showError("Failed to load loans: " + e.getMessage());
        }
    }
    
    private VBox createReturnsPanel() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new Insets(20));
        vbox.setStyle("-fx-background-color: #f5f5f5;");
        
        VBox returnCard = new VBox(15);
        returnCard.getStyleClass().add("card");
        returnCard.setPadding(new Insets(25));
        returnCard.setAlignment(Pos.CENTER);
        
        Label titleLabel = new Label("🔄 Return a Book");
        titleLabel.setStyle("-fx-font-size: 20px; -fx-font-weight: bold; -fx-text-fill: #1976D2;");
        
        ComboBox<Loan> loanCombo = new ComboBox<>();
        loanCombo.setPromptText("Select an active loan to return");
        loanCombo.setPrefWidth(500);
        
        HBox buttonBox = new HBox(15);
        buttonBox.setAlignment(Pos.CENTER);
        
        Button refreshButton = new Button("🔄 Refresh Loans");
        Button returnButton = new Button("✅ Return Selected Book");
        returnButton.getStyleClass().add("button-success");
        returnButton.setStyle("-fx-font-size: 14px; -fx-padding: 10 20 10 20;");
        
        buttonBox.getChildren().addAll(refreshButton, returnButton);
        
        Label fineLabel = new Label();
        fineLabel.setStyle("-fx-font-size: 14px; -fx-text-fill: #FF5722; -fx-font-weight: bold;");
        
        refreshButton.setOnAction(e -> loadReturnLoans(loanCombo));
        returnButton.setOnAction(e -> returnBook(loanCombo, fineLabel));
        
        loadReturnLoans(loanCombo);
        
        returnCard.getChildren().addAll(titleLabel, loanCombo, buttonBox, fineLabel);
        vbox.getChildren().add(returnCard);
        return vbox;
    }
    
    private void loadReturnLoans(ComboBox<Loan> loanCombo) {
        try {
            List<Loan> loans = bookDAO.getActiveLoans();
            loanCombo.getItems().clear();
            loanCombo.getItems().addAll(loans);
            statusLabel.setText("Loaded " + loans.size() + " loans ready for return");
        } catch (SQLException e) {
            showError("Failed to load loans: " + e.getMessage());
        }
    }
    
    private void returnBook(ComboBox<Loan> loanCombo, Label fineLabel) {
        Loan selectedLoan = loanCombo.getValue();
        if (selectedLoan == null) {
            showError("Please select a loan to return");
            return;
        }
        
        try {
            double fine = bookDAO.returnBook(selectedLoan.getLoanId());
            if (fine > 0) {
                fineLabel.setText("⚠️ Late return! Fine amount: $" + String.format("%.2f", fine));
                showInfo("Book returned with fine: $" + String.format("%.2f", fine));
                statusLabel.setText("Book returned with fine: $" + String.format("%.2f", fine));
            } else {
                fineLabel.setText("✅ Book returned on time. No fine.");
                showInfo("Book returned successfully!");
                statusLabel.setText("Book returned successfully");
            }
            loadReturnLoans(loanCombo);
            loanCombo.setValue(null);
            loadBooksData();
            loadLoansData();
            updateStatusBar();
        } catch (SQLException e) {
            showError("Failed to return book: " + e.getMessage());
        }
    }
    
    private void updateStatusBar() {
        bookCountLabel.setText("📚 Books: " + bookList.size());
        memberCountLabel.setText("👥 Members: " + memberList.size());
        loanCountLabel.setText("📋 Loans: " + loanList.size());
    }
    
    private void testDatabaseConnection() {
        if (DatabaseConnection.testConnection()) {
            statusLabel.setText("✅ Connected to PostgreSQL database");
            System.out.println("✓ Database connection successful!");
        } else {
            statusLabel.setText("❌ Database connection failed!");
            showError("Cannot connect to database. Check your connection settings.");
        }
    }
    
    private void showError(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Error");
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
    
    private void showInfo(String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Information");
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
    
    public static void main(String[] args) {
        launch(args);
    }
}