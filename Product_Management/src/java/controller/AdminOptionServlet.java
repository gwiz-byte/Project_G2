/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import models.Products;

/**
 *
 * @author nghia
 */
@WebServlet(name = "AdminOptionServlet", urlPatterns = {"/adminoptions"})
public class AdminOptionServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");
        ProductDAO pdao = new ProductDAO();
        CustomerDAO udao = new CustomerDAO();
        OrderDAO odao = new OrderDAO();

        if (service != null) {
            switch (service) {
                case "listProduct":
                    Vector<Products> plist = pdao.getAllProduct();
                    request.setAttribute("data", plist);
                    request.getRequestDispatcher("JSP/productList.jsp").forward(request, response);
                    break;
                case "updateProduct":
                    if (request.getParameter("productID") != null && request.getParameter("name") == null) {
                        int productID = Integer.parseInt(request.getParameter("productID"));

                        ProductDAO dao = new ProductDAO();
                        Products product = dao.getProductById(productID);

                        request.setAttribute("product", product);
                        request.getRequestDispatcher("JSP/updateProduct.jsp").forward(request, response);
                    } else {
                        int id = Integer.parseInt(request.getParameter("productID"));
                        String name = request.getParameter("name");
                        String brand = request.getParameter("brand");
                        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
                        double price = Double.parseDouble(request.getParameter("price"));
                        String connectionType = request.getParameter("connectionType");
                        String batteryType = request.getParameter("batteryType");
                        int stock = Integer.parseInt(request.getParameter("stock"));
                        String description = request.getParameter("description");
                        String imageUrl = request.getParameter("imageUrl");
                        String statusStr = request.getParameter("status");
                        boolean status = "Active".equalsIgnoreCase(statusStr);

                        Products updatedProduct = new Products(id, name, brand, categoryID, price, connectionType, batteryType, stock, description, imageUrl, status);
                        pdao.updateProduct(updatedProduct);

                        response.sendRedirect("adminoptions?service=listProduct");
                    }
                    break;
                
                case "insertProduct":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String name = request.getParameter("name");
                        String brand = request.getParameter("brand");
                        int categoryID = Integer.parseInt(request.getParameter("category_id"));
                        double price = Double.parseDouble(request.getParameter("price"));
                        String connectionType = request.getParameter("connection_type");
                        String batteryType = request.getParameter("battery_type");
                        int stock = Integer.parseInt(request.getParameter("stock"));
                        String description = request.getParameter("description");
                        String imageUrl = request.getParameter("image_url");
                        boolean status = true;

                        Products newProduct = new Products(0, name, brand, categoryID, price, connectionType, batteryType, stock, description, imageUrl, status);
                        pdao.insertProduct(newProduct);
                        response.sendRedirect("adminoptions?service=listProduct");
                    } else {
                        request.getRequestDispatcher("JSP/insertProduct.jsp").forward(request, response);
                    }
                    break;
                case "deleteProduct":
                    if (request.getParameter("productID") != null) {
                        int productID = Integer.parseInt(request.getParameter("productID"));
                        pdao.deleteProduct(productID);

                        response.sendRedirect("adminoptions?service=listProduct");

                    }
                    break;
                default:
                    service = "listProduct";
                    break;
            }
        } else {
            response.sendRedirect("adminoptions?service=listProduct");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        return "Short description";
    }// </editor-fold>

}
