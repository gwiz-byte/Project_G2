/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.FeedbackDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Feedback;
import java.time.LocalDateTime;
import java.util.Vector;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="feedback_control", urlPatterns={"/feedback_control"})
public class FeedbackControl extends HttpServlet {
   
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
            response.sendRedirect("viewfeedback");
            return;
        }

        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            String redirectUrl = "viewfeedback";

            switch (action) {
                case "add" -> handleAddFeedback(request, feedbackDAO);
                    
                case "update" -> handleUpdateFeedback(request, feedbackDAO);
                    
                case "delete" -> handleDeleteFeedback(request, feedbackDAO);
                    
                default -> {
                    request.setAttribute("error", "Invalid action specified");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
            }

            // Preserve the current page and filters in the redirect
            String page = request.getParameter("page");
            String sortBy = request.getParameter("sortBy");
            String rating = request.getParameter("rating");
            String search = request.getParameter("search");

            if (page != null) redirectUrl += "?page=" + page;
            if (sortBy != null) redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "sortBy=" + sortBy;
            if (rating != null) redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "rating=" + rating;
            if (search != null) redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "search=" + search;

            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    } 

    private void handleAddFeedback(HttpServletRequest request, FeedbackDAO feedbackDAO) throws Exception {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int userId = Integer.parseInt(request.getParameter("user_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String content = request.getParameter("content");

        Feedback newFeedback = new Feedback(
            0, // ID will be auto-generated
            productId,
            userId,
            rating,
            content,
            LocalDateTime.now().toString()
        );

        feedbackDAO.insertFeedback(newFeedback);
    }

    private void handleUpdateFeedback(HttpServletRequest request, FeedbackDAO feedbackDAO) throws Exception {
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
        int userId = Integer.parseInt(request.getParameter("user_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String content = request.getParameter("content");

        // Get existing feedback to verify ownership
        Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);
        if (existingFeedback == null) {
            throw new Exception("Feedback not found");
        }

        // Verify user owns this feedback
        if (existingFeedback.getUser_id() != userId) {
            throw new Exception("Unauthorized to update this feedback");
        }

        // Update the feedback
        existingFeedback.setRating(rating);
        existingFeedback.setContent(content);
        feedbackDAO.updateFeedback(existingFeedback);
    }

    private void handleDeleteFeedback(HttpServletRequest request, FeedbackDAO feedbackDAO) throws Exception {
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
        
        // Get existing feedback to verify it exists
        Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);
        if (existingFeedback == null) {
            throw new Exception("Feedback not found");
        }

        // Delete the feedback
        feedbackDAO.deleteFeedback(feedbackId, existingFeedback.getUser_id());
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
        return "Feedback Controller Servlet";
    }// </editor-fold>

    public static void main(String[] args) {
        // Create DAO instance for testing
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        
        try {
            // Test Case 1: Add new feedback
            System.out.println("Test Case 1: Adding new feedback");
            Feedback newFeedback = new Feedback(
                0,  // ID will be auto-generated
                1,  // product_id
                2,  // user_id
                5,  // rating
                "This is a test feedback for product 1",
                LocalDateTime.now().toString()
            );
            feedbackDAO.insertFeedback(newFeedback);
            System.out.println("Added new feedback successfully");
            
            // Test Case 2: Get feedback by product
            System.out.println("\nTest Case 2: Getting feedback for product 1");
            Vector<Feedback> productFeedbacks = feedbackDAO.getFeedbackByProduct(1);
            System.out.println("Feedback count for product 1: " + productFeedbacks.size());
            for (Feedback f : productFeedbacks) {
                System.out.println(f.toString());
            }
            
            // Test Case 3: Get feedback by user
            System.out.println("\nTest Case 3: Getting feedback for user 2");
            Vector<Feedback> userFeedbacks = feedbackDAO.getFeedbackByUser(2);
            System.out.println("Feedback count for user 2: " + userFeedbacks.size());
            for (Feedback f : userFeedbacks) {
                System.out.println(f.toString());
            }
            
            // Test Case 4: Update feedback
            System.out.println("\nTest Case 4: Updating feedback");
            if (!productFeedbacks.isEmpty()) {
                Feedback feedbackToUpdate = productFeedbacks.get(0);
                feedbackToUpdate.setRating(4);
                feedbackToUpdate.setContent("Updated feedback content for testing");
                feedbackDAO.updateFeedback(feedbackToUpdate);
                System.out.println("Updated feedback successfully");
                
                // Verify update
                Feedback updatedFeedback = feedbackDAO.getFeedbackById(feedbackToUpdate.getId());
                System.out.println("Updated feedback: " + updatedFeedback.toString());
            }
            
            // Test Case 5: Get average rating
            System.out.println("\nTest Case 5: Getting average rating for product 1");
            double avgRating = feedbackDAO.getAverageRating(1);
            System.out.println("Average rating for product 1: " + avgRating);
            
            // Test Case 6: Error handling test
            System.out.println("\nTest Case 6: Error handling - Invalid feedback ID");
            Feedback invalidFeedback = feedbackDAO.getFeedbackById(-1);
            if (invalidFeedback == null) {
                System.out.println("Successfully handled invalid feedback ID");
            }
            
        } catch (Exception e) {
            System.out.println("Error during testing: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
