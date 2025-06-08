/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.util.Vector;
import model.Products;
import dal.ProductDAO;
import model.Category;
import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

/**
 *
 * @author nghia
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/productservlet"})
public class ProductServlet extends HttpServlet {

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
        String service = request.getParameter("service");
        ProductDAO dao = new ProductDAO();
        CategoryDAO cdao = new CategoryDAO();
        Vector<Products> plist;
        ArrayList<Category> clist = cdao.getAllCategories();
        Vector<String> brands = dao.getAllBrands();

        if (service != null) {
            switch (service) {
                case "viewProduct":
                    String sortBy = request.getParameter("sortBy");
                    String order = request.getParameter("order");

                    if (sortBy == null || order == null || order.equals("none")) {
                        plist = dao.getAllProductWithCategoryName();
                    } else {
                        plist = dao.getSortedProduct(sortBy, order);
                    }

                    request.setAttribute("product", plist);
                    request.setAttribute("brand", brands);
                    request.setAttribute("category", clist);
                    request.getRequestDispatcher("viewProduct.jsp").forward(request, response);
                    break;
                case "insertProduct":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String name = request.getParameter("name");
                        String brand = request.getParameter("brand");
                        int categoryID = Integer.parseInt(request.getParameter("category_id"));
                        double price = Double.parseDouble(request.getParameter("price"));
                        int stock = Integer.parseInt(request.getParameter("stock"));
                        String imageUrl = request.getParameter("image_url");
                        String description = request.getParameter("description");
                        String specDescription = request.getParameter("spec_description");
                        String status = request.getParameter("status");

                        // Assuming your constructor matches the order and types of your new fields
                        Products newProduct = new Products(
                                0, // id (auto-increment or generated elsewhere)
                                name,
                                brand,
                                categoryID,
                                price,
                                stock,
                                imageUrl,
                                description,
                                specDescription,
                                status
                        );
                        dao.insertProduct(newProduct);
                        response.sendRedirect("productservlet?service=viewProduct");
                    } else {
                        request.getRequestDispatcher("insertProduct.jsp").forward(request, response);
                    }
                    break;
                case "updateProduct":
                    if (request.getParameter("id") != null && request.getParameter("name") == null) {
                        int productID = Integer.parseInt(request.getParameter("id"));

                        ProductDAO pdao = new ProductDAO();
                        Products product = pdao.getProductById(productID);

                        request.setAttribute("product", product);
                        request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                    } else {
                        // Update product data from form submission
                        int id = Integer.parseInt(request.getParameter("id"));
                        String name = request.getParameter("name");
                        String brand = request.getParameter("brand");
                        int category_id = Integer.parseInt(request.getParameter("category_id"));
                        double price = Double.parseDouble(request.getParameter("price"));
                        int stock = Integer.parseInt(request.getParameter("stock"));
                        String image_url = request.getParameter("image_url");
                        String description = request.getParameter("description");
                        String spec_description = request.getParameter("spec_description");
                        String status = request.getParameter("status");

                        Products updatedProduct = new Products(id, name, brand, category_id, price, stock, image_url, description, spec_description, status);
                        dao.updateProduct(updatedProduct);

                        response.sendRedirect("productservlet?service=viewProduct");
                    }
                    break;
                case "searchProduct":
                    String keyword = request.getParameter("keyword");
                    Vector<Products> result;
                    Vector<Products> productList;
                    if (keyword == null || keyword.trim().isEmpty()) {
                        // Return all products if keyword is empty
                        result = dao.getAllProduct();
                    } else {
                        // Otherwise, perform search
                        result = dao.searchProduct(keyword.trim());
                    }
                    request.setAttribute("brand", brands);
                    request.setAttribute("category", clist);
                    request.setAttribute("product", result);
                    request.getRequestDispatcher("viewProduct.jsp").forward(request, response);
                    break;
                case "filterByBrand":
                    String brand = request.getParameter("brand");
                    Vector<Products> blist = dao.getProductByBrand(brand);

                    request.setAttribute("product", blist);            // Đặt danh sách sản phẩm
                    request.setAttribute("brand", brands);             // Danh sách brand để đổ dropdown
                    request.setAttribute("category", clist);
                    request.getRequestDispatcher("viewProduct.jsp").forward(request, response);
                    break;

                case "filterByCategory":
                    String categoryIdRaw = request.getParameter("category_id");
                    int categoryId = Integer.parseInt(categoryIdRaw);
                    Vector<Products> categoryList = dao.getProductByCategory(categoryId);

                    request.setAttribute("product", categoryList);      // Đặt danh sách sản phẩm
                    request.setAttribute("brand", brands);              // Danh sách brand để đổ dropdown
                    request.setAttribute("category", clist);            // Danh sách category để đổ dropdown
                    request.getRequestDispatcher("viewProduct.jsp").forward(request, response);
                    break;
                case "productDetail":
                    int productID = Integer.parseInt(request.getParameter("id"));

                    ProductDAO ppdao = new ProductDAO();
                    Products product = ppdao.getProductById(productID);

                    // Đẩy dữ liệu lên request để hiển thị trong JSP
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                    break;
                default:
                    service = "viewProduct";
                    break;
            }
        } else {
            response.sendRedirect("productservlet?service=viewProduct");
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
        return "Short description";
    }// </editor-fold>
}
