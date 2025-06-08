/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.BlogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;
import java.util.Vector;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="Blog_control", urlPatterns={"/CES/Blog_control"})
public class BlogControl extends HttpServlet {
    private BlogDAO blogDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        blogDAO = new BlogDAO();
    }
    
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Blog_control</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Blog_control at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        String action = request.getParameter("action");
        
        try {
            switch(action == null ? "list" : action) {
                case "list":
                    listBlogs(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewBlog(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
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
        String action = request.getParameter("action");
        
        try {
            switch(action == null ? "add" : action) {
                case "add":
                    addBlog(request, response);
                    break;
                case "edit":
                    updateBlog(request, response);
                    break;
                case "delete":
                    deleteBlog(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            // Keep default page value
        }
        
        Vector<Blog> blogs = blogDAO.getAllBlogs(page, pageSize);
        int totalBlogs = blogDAO.getTotalBlogCount();
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
        
        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/WEB-INF/views/blog/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/blog/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Blog blog = blogDAO.getBlogById(id);
            
            if (blog != null) {
                request.setAttribute("blog", blog);
                request.getRequestDispatcher("/WEB-INF/views/blog/form.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void viewBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Blog blog = blogDAO.getBlogById(id);
            
            if (blog != null) {
                request.setAttribute("blog", blog);
                request.getRequestDispatcher("/WEB-INF/views/blog/view.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void addBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String userIdStr = request.getParameter("user_id");
        
        // Validate input
        StringBuilder errors = new StringBuilder();
        if (title == null || title.trim().isEmpty()) errors.append("Title is required. ");
        if (content == null || content.trim().isEmpty()) errors.append("Content is required. ");
        if (userIdStr == null || userIdStr.trim().isEmpty()) errors.append("User ID is required. ");
        
        if (errors.length() > 0) {
            request.getSession().setAttribute("error", errors.toString());
            response.sendRedirect(request.getContextPath() + "/viewblogs");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            Blog blog = new Blog(0, title.trim(), content.trim(), userId, null, null);
            blogDAO.insertBlog(blog);
            
            request.getSession().setAttribute("success", "Blog created successfully!");
            response.sendRedirect(request.getContextPath() + "/viewblogs");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID format.");
            response.sendRedirect(request.getContextPath() + "/viewblogs");
        }
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String userIdStr = request.getParameter("user_id");
        
        // Validate input
        StringBuilder errors = new StringBuilder();
        if (idStr == null || idStr.trim().isEmpty()) errors.append("Blog ID is required. ");
        if (title == null || title.trim().isEmpty()) errors.append("Title is required. ");
        if (content == null || content.trim().isEmpty()) errors.append("Content is required. ");
        if (userIdStr == null || userIdStr.trim().isEmpty()) errors.append("User ID is required. ");
        
        if (errors.length() > 0) {
            request.getSession().setAttribute("error", errors.toString());
            response.sendRedirect(request.getContextPath() + "/viewblogs");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            int userId = Integer.parseInt(userIdStr);
            Blog blog = new Blog(id, title.trim(), content.trim(), userId, null, null);
            blogDAO.updateBlog(blog);
            
            request.getSession().setAttribute("success", "Blog updated successfully!");
            response.sendRedirect(request.getContextPath() + "/viewblogs");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid ID format.");
            response.sendRedirect(request.getContextPath() + "/viewblogs");
        }
    }

    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int userId = Integer.parseInt(request.getParameter("user_id"));
            
            blogDAO.deleteBlog(id, userId);
            request.getSession().setAttribute("success", "Blog deleted successfully!");
            response.sendRedirect(request.getContextPath() + "/viewblogs");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid ID format.");
            response.sendRedirect(request.getContextPath() + "/viewblogs");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Blog Management Servlet";
    }// </editor-fold>

}
