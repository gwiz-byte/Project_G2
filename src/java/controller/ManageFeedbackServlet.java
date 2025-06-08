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
import java.time.LocalDateTime;

@WebServlet(name = "ManageFeedbackServlet", urlPatterns = {"/managefeedback"})
public class ManageFeedbackServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Number of feedback items per page
    private final FeedbackDAO feedbackDAO;

    public ManageFeedbackServlet() {
        feedbackDAO = new FeedbackDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if (action != null) {
                switch (action) {
                    case "add":
                        addFeedback(request, response);
                        return;
                    case "update":
                        updateFeedback(request, response);
                        return;
                    case "delete":
                        deleteFeedback(request, response);
                        return;
                }
            }
            
            // Default action: list feedbacks
            listFeedbacks(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/managefeedback");
        }
    }

    private void listFeedbacks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            
            // Check for any messages in session and transfer to request
            String success = (String) request.getSession().getAttribute("success");
            String error = (String) request.getSession().getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                request.getSession().removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                request.getSession().removeAttribute("error");
            }
            
            // Forward to JSP
            request.getRequestDispatcher("managefeedback.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred while fetching feedback: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/managefeedback");
        }
    }

    private void addFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            int userId = Integer.parseInt(request.getParameter("user_id"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");

            // Create new feedback object
            Feedback feedback = new Feedback(0, productId, userId, rating, content, LocalDateTime.now().toString());
            
            // Save feedback
            feedbackDAO.insertFeedback(feedback);
            
            // Set success message
            request.getSession().setAttribute("success", "Feedback added successfully");
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error adding feedback: " + e.getMessage());
        }
        
        // Redirect back to manage feedback page
        response.sendRedirect(request.getContextPath() + "/managefeedback");
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
            int userId = Integer.parseInt(request.getParameter("user_id"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");

            // Get existing feedback
            Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
            if (feedback != null) {
                // Verify user owns this feedback
                if (feedback.getUser_id() != userId) {
                    throw new Exception("Unauthorized to update this feedback");
                }
                
                feedback.setRating(rating);
                feedback.setContent(content);
                
                // Update feedback
                feedbackDAO.updateFeedback(feedback);
                request.getSession().setAttribute("success", "Feedback updated successfully");
            } else {
                request.getSession().setAttribute("error", "Feedback not found");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error updating feedback: " + e.getMessage());
        }
        
        // Redirect back to manage feedback page
        response.sendRedirect(request.getContextPath() + "/managefeedback");
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
            int userId = Integer.parseInt(request.getParameter("user_id"));
            
            // Get existing feedback to verify ownership
            Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
            if (feedback != null) {
                // Verify user owns this feedback
                if (feedback.getUser_id() != userId) {
                    throw new Exception("Unauthorized to delete this feedback");
                }
                
                // Delete feedback
                feedbackDAO.deleteFeedback(feedbackId, userId);
                request.getSession().setAttribute("success", "Feedback deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Feedback not found");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error deleting feedback: " + e.getMessage());
        }
        
        // Redirect back to manage feedback page
        response.sendRedirect(request.getContextPath() + "/managefeedback");
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
        return "ManageFeedback Servlet handles displaying and managing feedback";
    }
} 