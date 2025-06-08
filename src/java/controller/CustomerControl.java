/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import java.util.Vector;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="Customer_control", urlPatterns={"/Customer_control"})
public class CustomerControl extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("viewcustomers");
            return;
        }

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            String redirectUrl = "viewcustomers";

            switch (action) {
                case "add" -> handleAddCustomer(request, customerDAO);
                    
                case "update" -> handleUpdateCustomer(request, customerDAO);
                    
                case "delete" -> handleDeleteCustomer(request, customerDAO);
                    
                case "updatePassword" -> handleUpdatePassword(request, customerDAO);
                    
                case "search" -> {
                    handleSearchCustomers(request, customerDAO);
                    return; // Return here as we'll forward to a different page
                }
                default -> {
                    request.setAttribute("error", "Invalid action specified");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
            }

            // Preserve the current page and filters in the redirect
            String page = request.getParameter("page");
            String role = request.getParameter("role");
            String search = request.getParameter("search");

            if (page != null) redirectUrl += "?page=" + page;
            if (role != null) redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "role=" + role;
            if (search != null) redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "search=" + search;

            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    } 

    private void handleAddCustomer(HttpServletRequest request, CustomerDAO customerDAO) throws Exception {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone_number = request.getParameter("phone_number");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        // Validate email uniqueness
        if (customerDAO.isEmailExists(email)) {
            throw new Exception("Email already exists");
        }

        // Create new customer
        Customer newCustomer = new Customer(
            0, // ID will be auto-generated
            name,
            email,
            password, // Note: In production, this should be hashed
            phone_number,
            address,
            role
        );

        if (!customerDAO.insertCustomer(newCustomer)) {
            throw new Exception("Failed to add customer");
        }
    }

    private void handleUpdateCustomer(HttpServletRequest request, CustomerDAO customerDAO) throws Exception {
        int customerId = Integer.parseInt(request.getParameter("customer_id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone_number = request.getParameter("phone_number");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        // Get existing customer
        Customer existingCustomer = customerDAO.getCustomerById(customerId);
        if (existingCustomer == null) {
            throw new Exception("Customer not found");
        }

        // Check email uniqueness only if email is changed
        if (!existingCustomer.getEmail().equals(email) && customerDAO.isEmailExists(email)) {
            throw new Exception("Email already exists");
        }

        // Update customer details
        existingCustomer.setName(name);
        existingCustomer.setEmail(email);
        existingCustomer.setPhone_number(phone_number);
        existingCustomer.setAddress(address);
        existingCustomer.setRole(role);

        if (!customerDAO.updateCustomer(existingCustomer)) {
            throw new Exception("Failed to update customer");
        }
    }

    private void handleDeleteCustomer(HttpServletRequest request, CustomerDAO customerDAO) throws Exception {
        int customerId = Integer.parseInt(request.getParameter("customer_id"));
        
        // Verify customer exists
        Customer existingCustomer = customerDAO.getCustomerById(customerId);
        if (existingCustomer == null) {
            throw new Exception("Customer not found");
        }

        // Delete the customer
        if (!customerDAO.deleteCustomer(customerId)) {
            throw new Exception("Failed to delete customer");
        }
    }

    private void handleUpdatePassword(HttpServletRequest request, CustomerDAO customerDAO) throws Exception {
        int customerId = Integer.parseInt(request.getParameter("customer_id"));
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        // Basic password validation
        if (!newPassword.equals(confirmPassword)) {
            throw new Exception("Passwords do not match");
        }

        // Verify customer exists
        Customer existingCustomer = customerDAO.getCustomerById(customerId);
        if (existingCustomer == null) {
            throw new Exception("Customer not found");
        }

        // Update password
        if (!customerDAO.updatePassword(customerId, newPassword)) { // Note: In production, this should be hashed
            throw new Exception("Failed to update password");
        }
    }

    private void handleSearchCustomers(HttpServletRequest request, CustomerDAO customerDAO) throws Exception {
        String searchTerm = request.getParameter("search");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Use default page 1 if not specified
        }
        int pageSize = 10; // You can make this configurable

        Vector<Customer> searchResults = customerDAO.searchCustomers(searchTerm, page, pageSize);
        int totalCustomers = customerDAO.getTotalCustomerCount(); // This should be filtered by search term in production

        request.setAttribute("customers", searchResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", (int) Math.ceil(totalCustomers / (double) pageSize));
        request.setAttribute("searchTerm", searchTerm);
        ServletResponse response = null;

        request.getRequestDispatcher("customers.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Customer Management Controller Servlet";
    }// </editor-fold>

    public static void main(String[] args) {
        // Create DAO instance for testing
        CustomerDAO customerDAO = new CustomerDAO();
        
        try {
            System.out.println("=== Starting Customer Management System Tests ===\n");
            
            // Test Case 1: Add new customer
            System.out.println("Test Case 1: Adding new customer");
            System.out.println("------------------------------");
            Customer newCustomer = new Customer(
                0,
                "Test User",
                "test" + System.currentTimeMillis() + "@example.com", // Ensure unique email
                "password123",
                "1234567890",
                "123 Test Street",
                "customer"
            );
            boolean added = customerDAO.insertCustomer(newCustomer);
            System.out.println("Added new customer: " + (added ? "SUCCESS ✓" : "FAILED ✗"));
            
            // Test Case 2: Search customers
            System.out.println("\nTest Case 2: Searching for customers");
            System.out.println("--------------------------------");
            Vector<Customer> searchResults = customerDAO.searchCustomers("Test", 1, 10);
            System.out.println("Found " + searchResults.size() + " customers");
            searchResults.forEach(customer -> 
                System.out.println("- " + customer.getName() + " (" + customer.getEmail() + ")")
            );
            
            // Test Case 3: Update customer
            System.out.println("\nTest Case 3: Updating customer");
            System.out.println("----------------------------");
            if (!searchResults.isEmpty()) {
                Customer customerToUpdate = searchResults.get(0);
                String originalName = customerToUpdate.getName();
                customerToUpdate.setName("Updated Test User");
                customerToUpdate.setPhone_number("9876543210");
                boolean updated = customerDAO.updateCustomer(customerToUpdate);
                System.out.println("Updating customer '" + originalName + "': " + (updated ? "SUCCESS ✓" : "FAILED ✗"));
                
                // Verify update
                Customer updatedCustomer = customerDAO.getCustomerById(customerToUpdate.getId());
                System.out.println("Updated customer details: " + updatedCustomer.getName() + 
                                 " (Phone: " + updatedCustomer.getPhone_number() + ")");
            }
            
            // Test Case 4: Get customers by role
            System.out.println("\nTest Case 4: Getting customers by role");
            System.out.println("---------------------------------");
            Vector<Customer> customersByRole = customerDAO.getCustomersByRole("customer");
            System.out.println("Found " + customersByRole.size() + " customers with role 'customer'");
            customersByRole.forEach(customer -> 
                System.out.println("- " + customer.getName() + " (Role: " + customer.getRole() + ")")
            );
            
            // Test Case 5: Error handling
            System.out.println("\nTest Case 5: Error handling tests");
            System.out.println("------------------------------");
            
            // Test 5.1: Invalid customer ID
            System.out.println("5.1 Testing invalid customer ID:");
            Customer invalidCustomer = customerDAO.getCustomerById(-1);
            System.out.println("Invalid customer ID test: " + 
                             (invalidCustomer == null ? "SUCCESS ✓" : "FAILED ✗"));
            
            // Test 5.2: Duplicate email
            System.out.println("5.2 Testing duplicate email:");
            try {
                Customer duplicateCustomer = new Customer(
                    0,
                    "Duplicate User",
                    searchResults.get(0).getEmail(), // Using existing email
                    "password123",
                    "1234567890",
                    "123 Test Street",
                    "customer"
                );
                customerDAO.insertCustomer(duplicateCustomer);
                System.out.println("Duplicate email test: FAILED ✗");
            } catch (Exception e) {
                System.out.println("Duplicate email test: SUCCESS ✓");
            }
            
            System.out.println("\n=== Customer Management System Tests Completed ===");
            
        } catch (Exception e) {
            System.out.println("\n❌ ERROR during testing: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
