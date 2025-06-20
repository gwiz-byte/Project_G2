package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import model.Account;

public class AccountDAO {

    // Get all accounts with pagination
    public Vector<Account> getAllAccounts(int page, int pageSize) {
         DBContext db = DBContext.getInstance();
        Vector<Account> listAccounts = new Vector<>();
        String sql = "SELECT * FROM User ORDER BY user_id LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, pageSize);
            ptm.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Account a = new Account(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role")
                );
                listAccounts.add(a);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listAccounts;
    }

    // Get account by ID
    public Account getAccountById(int accountId) {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT * FROM User WHERE user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, accountId);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Get account by email
    public Account getAccountByEmail(String email) {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT * FROM User WHERE email = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, email);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Insert new account
    public boolean insertAccount(Account a) {
        DBContext db = DBContext.getInstance();
        String sql = "INSERT INTO User (username, email, password, role) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, a.getUsername());
            ptm.setString(2, a.getEmail());
            ptm.setString(3, a.getPassword());
            ptm.setString(4, a.getRole());
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Update account
    public boolean updateAccount(Account a) {
        DBContext db = DBContext.getInstance();
        String sql = "UPDATE User SET username = ?, email = ?, password = ?, role = ? WHERE user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, a.getUsername());
            ptm.setString(2, a.getEmail());
            ptm.setString(3, a.getPassword());
            ptm.setString(4, a.getRole());
            ptm.setInt(5, a.getId());
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Update account password
    public boolean updatePassword(int accountId, String newPassword) {
        DBContext db = DBContext.getInstance();
        String sql = "UPDATE User SET password = ? WHERE user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, newPassword);
            ptm.setInt(2, accountId);
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Delete account
    public boolean deleteAccount(int accountId) {
        DBContext db = DBContext.getInstance();
        String sql = "DELETE FROM User WHERE user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, accountId);
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Get total count of accounts
    public int getTotalAccountCount() {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT COUNT(*) as total FROM User";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Search accounts by name or email
    public Vector<Account> searchAccounts(String searchTerm, int page, int pageSize) {
        DBContext db = DBContext.getInstance();
        Vector<Account> listAccounts = new Vector<>();
        String sql = "SELECT * FROM User WHERE username LIKE ? OR email LIKE ? LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, "%" + searchTerm + "%");
            ptm.setString(2, "%" + searchTerm + "%");
            ptm.setInt(3, pageSize);
            ptm.setInt(4, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Account a = new Account(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role")
                );
                listAccounts.add(a);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listAccounts;
    }

    // Check if email exists
    public boolean isEmailExists(String email) {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT COUNT(*) as count FROM User WHERE email = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, email);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Get accounts by role
    public Vector<Account> getAccountsByRole(String role) {
        DBContext db = DBContext.getInstance();
        Vector<Account> listAccounts = new Vector<>();
        String sql = "SELECT * FROM User WHERE role = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, role);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Account a = new Account(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role")
                );
                listAccounts.add(a);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listAccounts;
    }

    public static void main(String[] args) {
        AccountDAO dao = new AccountDAO();
        
        System.out.println("=== Account DAO Test Cases ===\n");
        
        // Test 1: Insert a new account
        System.out.println("Test 1: Inserting a new account");
        Account newAccount = new Account(0, "Test User", "test@email.com", "password123", "customer");
        boolean inserted = dao.insertAccount(newAccount);
        System.out.println("Account insertion " + (inserted ? "successful" : "failed") + "\n");
        
        // Test 2: Get all accounts
        System.out.println("Test 2: Getting all accounts (page 1, 5 items per page)");
        Vector<Account> accounts = dao.getAllAccounts(1, 5);
        System.out.println("Total accounts in database: " + dao.getTotalAccountCount());
        for (Account a : accounts) {
            System.out.println("- " + a.getUsername() + " (" + a.getEmail() + ")");
        }
        System.out.println();
        
        // Test 3: Search accounts
        System.out.println("Test 3: Searching for accounts with 'test'");
        Vector<Account> searchResults = dao.searchAccounts("test", 1, 10);
        for (Account a : searchResults) {
            System.out.println("- Found: " + a.getUsername() + " (" + a.getEmail() + ")");
        }
        System.out.println();
        
        // Test 4: Get accounts by role
        System.out.println("Test 4: Getting accounts with role 'customer'");
        Vector<Account> customerRole = dao.getAccountsByRole("customer");
        System.out.println("Found " + customerRole.size() + " accounts with role 'customer'");
        
        System.out.println("\n=== Test Cases Completed ===");
    }
} 