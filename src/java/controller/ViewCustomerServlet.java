package controller;

import dal.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Customer;
import java.util.Collections;

@WebServlet(name = "ViewCustomerServlet", urlPatterns = {"/viewcustomers"})
public class ViewCustomerServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Number of customers per page

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            CustomerDAO customerDAO = new CustomerDAO();
            
            // Get all customers first
            Vector<Customer> allCustomers = customerDAO.getAllCustomers(1, Integer.MAX_VALUE);
            
            // Apply role filter if specified
            String roleFilter = request.getParameter("role");
            if (roleFilter != null && !roleFilter.isEmpty()) {
                Vector<Customer> filteredList = new Vector<>();
                for (Customer c : allCustomers) {
                    if (c.getRole().equalsIgnoreCase(roleFilter)) {
                        filteredList.add(c);
                    }
                }
                allCustomers = filteredList;
            }
            
            // Apply search filter
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                Vector<Customer> searchedList = new Vector<>();
                search = search.toLowerCase();
                for (Customer c : allCustomers) {
                    if (c.getName().toLowerCase().contains(search) || 
                        c.getEmail().toLowerCase().contains(search) ||
                        c.getPhone_number().toLowerCase().contains(search)) {
                        searchedList.add(c);
                    }
                }
                allCustomers = searchedList;
            }
            
            // Apply sorting
            String sortBy = request.getParameter("sortBy");
            if (sortBy != null) {
                switch (sortBy) {
                    case "name":
                        Collections.sort(allCustomers, (c1, c2) -> 
                            c1.getName().compareToIgnoreCase(c2.getName()));
                        break;
                    case "email":
                        Collections.sort(allCustomers, (c1, c2) -> 
                            c1.getEmail().compareToIgnoreCase(c2.getEmail()));
                        break;
                    case "role":
                        Collections.sort(allCustomers, (c1, c2) -> 
                            c1.getRole().compareToIgnoreCase(c2.getRole()));
                        break;
                    case "id":
                        Collections.sort(allCustomers, (c1, c2) -> 
                            Integer.compare(c1.getId(), c2.getId()));
                        break;
                }
            }
            
            // Calculate pagination after filtering
            int totalCustomers = allCustomers.size();
            int totalPages = (int) Math.ceil((double) totalCustomers / PAGE_SIZE);
            
            // Get page number from request
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
                if (page > totalPages && totalPages > 0) page = totalPages;
            } catch (NumberFormatException e) {
                // Keep page as 1 if not specified or invalid
            }
            
            // Apply pagination to filtered and sorted results
            Vector<Customer> pagedCustomers = new Vector<>();
            int startIndex = (page - 1) * PAGE_SIZE;
            int endIndex = Math.min(startIndex + PAGE_SIZE, totalCustomers);
            
            for (int i = startIndex; i < endIndex; i++) {
                pagedCustomers.add(allCustomers.get(i));
            }
            
            // Set attributes for the JSP
            request.setAttribute("customerList", pagedCustomers);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            
            // Forward to JSP
            request.getRequestDispatcher("viewcustomers.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching customers: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ViewCustomer Servlet handles displaying and filtering customers";
    }
} 