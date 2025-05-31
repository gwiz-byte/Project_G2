package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import model.Customer;

public class CustomerDAO {

    // Get all customers with pagination
    public Vector<Customer> getAllCustomers(int page, int pageSize) {
         DBContext db = DBContext.getInstance();
        Vector<Customer> listCustomers = new Vector<>();
        String sql = "SELECT * FROM users ORDER BY id LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, pageSize);
            ptm.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Customer c = new Customer(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone_number"),
                    rs.getString("address"),
                    rs.getString("role")
                );
                listCustomers.add(c);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listCustomers;
    }

    // Get customer by ID
    public Customer getCustomerById(int customerId) {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, customerId);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return new Customer(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone_number"),
                    rs.getString("address"),
                    rs.getString("role")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Get customer by email
    public Customer getCustomerByEmail(String email) {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT * FROM users WHERE email = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, email);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return new Customer(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone_number"),
                    rs.getString("address"),
                    rs.getString("role")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Insert new customer
    public boolean insertCustomer(Customer c) {
        DBContext db = DBContext.getInstance();
        String sql = "INSERT INTO users (name, email, password, phone_number, address, role) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, c.getName());
            ptm.setString(2, c.getEmail());
            ptm.setString(3, c.getPassword());
            ptm.setString(4, c.getPhone_number());
            ptm.setString(5, c.getAddress());
            ptm.setString(6, c.getRole());
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Update customer
    public boolean updateCustomer(Customer c) {
        DBContext db = DBContext.getInstance();
        String sql = "UPDATE users SET name = ?, email = ?, phone_number = ?, address = ?, role = ? WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, c.getName());
            ptm.setString(2, c.getEmail());
            ptm.setString(3, c.getPhone_number());
            ptm.setString(4, c.getAddress());
            ptm.setString(5, c.getRole());
            ptm.setInt(6, c.getId());
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Update customer password
    public boolean updatePassword(int customerId, String newPassword) {
        DBContext db = DBContext.getInstance();
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, newPassword);
            ptm.setInt(2, customerId);
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Delete customer
    public boolean deleteCustomer(int customerId) {
        DBContext db = DBContext.getInstance();
        String sql = "DELETE FROM users WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, customerId);
            return ptm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Get total count of customers
    public int getTotalCustomerCount() {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT COUNT(*) as total FROM users";
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

    // Search customers by name or email
    public Vector<Customer> searchCustomers(String searchTerm, int page, int pageSize) {
        DBContext db = DBContext.getInstance();
        Vector<Customer> listCustomers = new Vector<>();
        String sql = "SELECT * FROM users WHERE name LIKE ? OR email LIKE ? LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, "%" + searchTerm + "%");
            ptm.setString(2, "%" + searchTerm + "%");
            ptm.setInt(3, pageSize);
            ptm.setInt(4, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Customer c = new Customer(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone_number"),
                    rs.getString("address"),
                    rs.getString("role")
                );
                listCustomers.add(c);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listCustomers;
    }

    // Check if email exists
    public boolean isEmailExists(String email) {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT COUNT(*) as count FROM users WHERE email = ?";
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

    // Get customers by role
    public Vector<Customer> getCustomersByRole(String role) {
        DBContext db = DBContext.getInstance();
        Vector<Customer> listCustomers = new Vector<>();
        String sql = "SELECT * FROM users WHERE role = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, role);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Customer c = new Customer(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone_number"),
                    rs.getString("address"),
                    rs.getString("role")
                );
                listCustomers.add(c);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listCustomers;
    }

    public static void main(String[] args) {
        CustomerDAO dao = new CustomerDAO();
        
        System.out.println("=== Customer DAO Test Cases ===\n");
        
        // Test 1: Insert a new customer
        System.out.println("Test 1: Inserting a new customer");
        Customer newCustomer = new Customer(0, "Test User", "test@email.com", "password123", 
                                          "1234567890", "123 Test St", "customer");
        boolean inserted = dao.insertCustomer(newCustomer);
        System.out.println("Customer insertion " + (inserted ? "successful" : "failed") + "\n");
        
        // Test 2: Get all customers
        System.out.println("Test 2: Getting all customers (page 1, 5 items per page)");
        Vector<Customer> customers = dao.getAllCustomers(1, 5);
        System.out.println("Total customers in database: " + dao.getTotalCustomerCount());
        for (Customer c : customers) {
            System.out.println("- " + c.getName() + " (" + c.getEmail() + ")");
        }
        System.out.println();
        
        // Test 3: Search customers
        System.out.println("Test 3: Searching for customers with 'test'");
        Vector<Customer> searchResults = dao.searchCustomers("test", 1, 10);
        for (Customer c : searchResults) {
            System.out.println("- Found: " + c.getName() + " (" + c.getEmail() + ")");
        }
        System.out.println();
        
        // Test 4: Get customers by role
        System.out.println("Test 4: Getting customers with role 'customer'");
        Vector<Customer> customerRole = dao.getCustomersByRole("customer");
        System.out.println("Found " + customerRole.size() + " customers with role 'customer'");
        
        System.out.println("\n=== Test Cases Completed ===");
    }
} 