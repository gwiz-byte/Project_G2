package controller;

import dal.FeedbackDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Feedback;
import java.util.Collections;

@WebServlet(name = "ViewFeedbackServlet", urlPatterns = {"/viewfeedback"})
public class ViewFeedbackServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Number of feedback items per page
    private final FeedbackDAO feedbackDAO;

    public ViewFeedbackServlet() {
        feedbackDAO = new FeedbackDAO();
    }

    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get page number from request
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                // Keep page as 1 if not specified or invalid
            }
            
            // Get total count for pagination
            int totalFeedback = feedbackDAO.getTotalFeedbackCount();
            int totalPages = (int) Math.ceil((double) totalFeedback / PAGE_SIZE);
            
            // Get feedback for current page
            Vector<Feedback> feedbackList = feedbackDAO.getAllFeedback(page, PAGE_SIZE);
            
            // Apply rating filter if specified
            String ratingFilter = request.getParameter("rating");
            if (ratingFilter != null && !ratingFilter.isEmpty()) {
                int rating = Integer.parseInt(ratingFilter);
                Vector<Feedback> filteredList = new Vector<>();
                for (Feedback f : feedbackList) {
                    if (f.getRating() == rating) {
                        filteredList.add(f);
                    }
                }
                feedbackList = filteredList;
            }
            
            // Apply search filter
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                Vector<Feedback> searchedList = new Vector<>();
                search = search.toLowerCase();
                for (Feedback f : feedbackList) {
                    if (f.getContent().toLowerCase().contains(search)) {
                        searchedList.add(f);
                    }
                }
                feedbackList = searchedList;
            }
            
            // Apply sorting
            String sortBy = request.getParameter("sortBy");
            if (sortBy != null) {
                switch (sortBy) {
                    case "newest":
                        Collections.sort(feedbackList, (f1, f2) -> 
                            f2.getCreated_at().compareTo(f1.getCreated_at()));
                        break;
                    case "oldest":
                        Collections.sort(feedbackList, (f1, f2) -> 
                            f1.getCreated_at().compareTo(f2.getCreated_at()));
                        break;
                    case "rating":
                        Collections.sort(feedbackList, (f1, f2) -> 
                            Integer.compare(f2.getRating(), f1.getRating()));
                        break;
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalFeedback", totalFeedback);
            
            // Forward to JSP
            request.getRequestDispatcher("viewfeedback.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching feedback: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // View-only servlet doesn't handle POST requests
        response.sendRedirect(request.getContextPath() + "/viewfeedback");
    }

    @Override
    public String getServletInfo() {
        return "ViewFeedback Servlet handles displaying feedback in read-only mode";
    }
} 