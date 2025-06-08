/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.BlogDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Blog;
import model.User;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ManageBlogServlet", urlPatterns={"/manageblogs"})
public class ManageBlogServlet extends HttpServlet {
   
    private static final int PAGE_SIZE = 10; // Number of blogs per page
    private final BlogDAO blogDAO;
    private final UserDAO userDAO;

    public ManageBlogServlet() {
        blogDAO = new BlogDAO();
        userDAO = UserDAO.getInstance();
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
        
        try {
            // Get all blogs first (we'll filter and sort them in memory)
            Vector<Blog> allBlogs = blogDAO.getAllBlogs(1, Integer.MAX_VALUE);
            
            // Create a map to store user information
            Map<Integer, String> userNames = new HashMap<>();
            
            // Get all users for the dropdown
            Vector<User> userList = userDAO.getAllUsers();
            request.setAttribute("userList", userList);
            
            // Fetch user information for each blog
            for (Blog blog : allBlogs) {
                try {
                    int userId = blog.getUser_id();
                    // Get user by ID and store their name
                    User user = userDAO.getUserById(userId);
                    if (user != null) {
                        userNames.put(userId, user.getFullname());
                    } else {
                        userNames.put(userId, "Unknown User");
                    }
                } catch (Exception e) {
                    userNames.put(blog.getUser_id(), "Unknown User");
                }
            }
            
            // Store the user names map in request
            request.setAttribute("userNames", userNames);
            
            // Apply search filter if specified
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                Vector<Blog> searchedList = new Vector<>();
                search = search.toLowerCase();
                for (Blog b : allBlogs) {
                    String userName = userNames.get(b.getUser_id());
                    if (b.getTitle().toLowerCase().contains(search) || 
                        b.getContent().toLowerCase().contains(search) ||
                        (userName != null && userName.toLowerCase().contains(search))) {
                        searchedList.add(b);
                    }
                }
                allBlogs = searchedList;
            }
            
            // Apply sorting
            String sortBy = request.getParameter("sortBy");
            if (sortBy != null) {
                switch (sortBy) {
                    case "newest":
                        Collections.sort(allBlogs, (b1, b2) -> {
                            if (b1.getCreated_at() == null || b2.getCreated_at() == null) return 0;
                            return b2.getCreated_at().compareTo(b1.getCreated_at());
                        });
                        break;
                    case "oldest":
                        Collections.sort(allBlogs, (b1, b2) -> {
                            if (b1.getCreated_at() == null || b2.getCreated_at() == null) return 0;
                            return b1.getCreated_at().compareTo(b2.getCreated_at());
                        });
                        break;
                    case "title":
                        Collections.sort(allBlogs, (b1, b2) -> 
                            b1.getTitle().compareToIgnoreCase(b2.getTitle()));
                        break;
                    case "author":
                        Collections.sort(allBlogs, (b1, b2) -> {
                            String name1 = userNames.get(b1.getUser_id());
                            String name2 = userNames.get(b2.getUser_id());
                            return name1.compareToIgnoreCase(name2);
                        });
                        break;
                }
            } else {
                // Default sort by newest
                Collections.sort(allBlogs, (b1, b2) -> {
                    if (b1.getCreated_at() == null || b2.getCreated_at() == null) return 0;
                    return b2.getCreated_at().compareTo(b1.getCreated_at());
                });
            }
            
            // Calculate pagination
            int totalBlogs = allBlogs.size();
            int totalPages = (int) Math.ceil((double) totalBlogs / PAGE_SIZE);
            
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
            Vector<Blog> pagedBlogs = new Vector<>();
            int startIndex = (page - 1) * PAGE_SIZE;
            int endIndex = Math.min(startIndex + PAGE_SIZE, totalBlogs);
            
            for (int i = startIndex; i < endIndex; i++) {
                pagedBlogs.add(allBlogs.get(i));
            }
            
            // Set attributes for the JSP
            request.setAttribute("blogList", pagedBlogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBlogs", totalBlogs);
            
            // Forward to JSP
            request.getRequestDispatcher("ManageBlog.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching blogs: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    } 

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
            if (action == null || action.equals("list")) {
                listBlogs(request, response);
            } else if (action.equals("view")) {
                viewBlog(request, response);
            } else {
                response.sendRedirect("manageblogs");
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Error: " + ex.getMessage());
            request.getRequestDispatcher("ManageBlog.jsp").forward(request, response);
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
            switch (action) {
                case "add":
                    addBlog(request, response);
                    break;
                case "update":
                    updateBlog(request, response);
                    break;
                case "delete":
                    deleteBlog(request, response);
                    break;
                default:
                    response.sendRedirect("manageblogs");
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Error: " + ex.getMessage());
            request.getRequestDispatcher("ManageBlog.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "ManageBlog Servlet handles displaying and managing blogs";
    }

    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    private void viewBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int blogId = Integer.parseInt(request.getParameter("id"));
            Blog blog = blogDAO.getBlogById(blogId);
            
            if (blog != null) {
                // Get user information
                User user = userDAO.getUserById(blog.getUser_id());
                request.setAttribute("blog", blog);
                request.setAttribute("author", user != null ? user.getFullname() : "Unknown User");
                
                // Forward to the manage blog page with the modal open
                request.getRequestDispatcher("ManageBlog.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Blog not found");
                response.sendRedirect(request.getContextPath() + "/manageblogs");
            }
        } catch (Exception ex) {
            request.getSession().setAttribute("error", "Error viewing blog: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/manageblogs");
        }
    }

    private void addBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            // Get user by username
            User user = userDAO.getUserByUsername(username);
            if (user == null) {
                throw new Exception("User not found");
            }
            
            // Create new blog
            Blog blog = new Blog(0, title, content, user.getId(), null, null);
            
            // Save blog
            blogDAO.insertBlog(blog);
            request.getSession().setAttribute("success", "Blog added successfully");
            
            // Redirect back to manage blogs page
            response.sendRedirect(request.getContextPath() + "/manageblogs");
            
        } catch (Exception ex) {
            request.getSession().setAttribute("error", "Error: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/manageblogs");
        }
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int blogId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int userId = Integer.parseInt(request.getParameter("user_id"));
            
            // Create blog object
            Blog blog = new Blog(blogId, title, content, userId, null, null);
            
            // Update blog
            blogDAO.updateBlog(blog);
            request.getSession().setAttribute("success", "Blog updated successfully");
            
            // Redirect back to manage blogs page
            response.sendRedirect(request.getContextPath() + "/manageblogs");
            
        } catch (Exception ex) {
            request.getSession().setAttribute("error", "Error updating blog: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/manageblogs");
        }
    }

    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int blogId = Integer.parseInt(request.getParameter("id"));
            int userId = Integer.parseInt(request.getParameter("user_id"));
            
            // Delete blog
            blogDAO.deleteBlog(blogId, userId);
            request.getSession().setAttribute("success", "Blog deleted successfully");
            
            // Redirect back to manage blogs page
            response.sendRedirect(request.getContextPath() + "/manageblogs");
            
        } catch (Exception ex) {
            request.getSession().setAttribute("error", "Error deleting blog: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/manageblogs");
        }
    }
} 