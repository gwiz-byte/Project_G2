/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.util.Vector;
import model.Products;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author nghia
 */
@WebServlet(name = "HomePageServlet", urlPatterns = {"/homepageservlet"})
public class HomePageServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            ProductDAO dao = new ProductDAO();
            Vector<Products> plist = dao.getAllProduct();
            
            // Add debug information
            System.out.println("Number of products loaded: " + (plist != null ? plist.size() : 0));
            if (plist != null && !plist.isEmpty()) {
                System.out.println("First product: " + plist.get(0).getName());
            } else {
                System.out.println("No products found in database");
            }
            
            request.setAttribute("product", plist);
            request.getRequestDispatcher("homePage.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in HomePageServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message for the JSP
            request.setAttribute("errorMessage", "An error occurred while loading products. Please try again later.");
            request.getRequestDispatcher("homePage.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Homepage Servlet";
    }// </editor-fold>

}
